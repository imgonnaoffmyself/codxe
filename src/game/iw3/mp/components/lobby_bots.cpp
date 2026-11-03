#include "pch.h"
#include "lobby_bots.h"
#include "ui_feeder.h"

#include <cstdlib>

namespace iw3
{
namespace mp
{
namespace
{
struct LobbyBot
{
    std::string name;
    std::string displayName;
    int vetoVote;
};

const char *const LOBBY_BOTS_ENABLED_DVAR = "codxe_lobbybots_enabled";
const char *const LOBBY_BOTS_TARGET_DVAR = "codxe_lobbybots_target";
const DWORD LOBBY_BOT_LEAVE_CHECK_MS = 2000;
const DWORD POST_MATCH_LOBBY_GRACE_MS = 60000;

std::vector<LobbyBot> s_lobbyBots;
std::vector<std::string> s_botNamePool;
std::string s_vetoStatusBase;
std::string s_vetoStatusLastWritten;
dvar_s *s_lobbyBotsEnabled = nullptr;
dvar_s *s_lobbyBotsTarget = nullptr;
DWORD s_nextArrivalTime = 0;
DWORD s_nextLeaveCheckTime = 0;
DWORD s_lastStateUpdateTime = 0;
DWORD s_postMatchGraceDeadline = 0;
int s_lobbyPlayerCount = 1;
int s_previousLobbyPlayerCount = 1;
int s_lobbyMaxPlayers = MAX_CLIENTS;
bool s_lobbySimulationActive = false;
bool s_matchActive = false;
bool s_vetoActive = false;
bool s_randomSeeded = false;

void UpdateBotDisplayName(LobbyBot &bot)
{
    if (bot.vetoVote < 0)
    {
        bot.displayName = bot.name;
        return;
    }

    char displayName[64];
    _snprintf_s(displayName, ARRAYSIZE(displayName), _TRUNCATE, "%s ^7[%s]", bot.name.c_str(),
                bot.vetoVote ? "SKIP" : "KEEP");
    bot.displayName = displayName;
}

bool GetDvarBoolSafe(const char *name)
{
    const dvar_s *dvar = Dvar_FindMalleableVar(name);
    return dvar && dvar->current.enabled;
}

int GetDvarIntSafe(const char *name, int defaultValue)
{
    const dvar_s *dvar = Dvar_FindMalleableVar(name);
    return dvar ? dvar->current.integer : defaultValue;
}

const char *GetDvarStringSafe(const char *name)
{
    const dvar_s *dvar = Dvar_FindMalleableVar(name);
    return dvar && dvar->current.string ? dvar->current.string : "";
}

int ParseFirstInteger(const char *text, int fallback)
{
    if (!text)
        return fallback;

    while (*text && (*text < '0' || *text > '9'))
        ++text;

    if (!*text)
        return fallback;

    return std::atoi(text);
}

void SetIntDvar(dvar_s *dvar, int value)
{
    if (!dvar)
        return;

    char text[16];
    _snprintf_s(text, ARRAYSIZE(text), _TRUNCATE, "%d", value);
    Dvar_SetStringFromSource(dvar, text, DVAR_SOURCE_INTERNAL);
}

void SetBoolDvar(dvar_s *dvar, bool value)
{
    if (!dvar)
        return;

    Dvar_SetStringFromSource(dvar, value ? "1" : "0", DVAR_SOURCE_INTERNAL);
}

void RestoreLocalVetoStatus()
{
    if (s_vetoStatusLastWritten.empty())
        return;

    dvar_s *dvar = Dvar_FindMalleableVar("party_vetoStatus");
    if (dvar && dvar->current.string && !(dvar->flags & DVAR_CODINFO) &&
        s_vetoStatusLastWritten == dvar->current.string)
    {
        Dvar_SetStringFromSource(dvar, s_vetoStatusBase.c_str(), DVAR_SOURCE_INTERNAL);
    }

    s_vetoStatusBase.clear();
    s_vetoStatusLastWritten.clear();
}

void UpdateLocalVetoStatus()
{
    dvar_s *dvar = Dvar_FindMalleableVar("party_vetoStatus");
    if (!dvar || !dvar->current.string || (dvar->flags & DVAR_CODINFO))
        return;

    if (!GetDvarBoolSafe("party_vetoButtonVisible") || !s_vetoActive)
    {
        RestoreLocalVetoStatus();
        return;
    }

    const std::string current = dvar->current.string;
    if (s_vetoStatusLastWritten.empty() || current != s_vetoStatusLastWritten)
        s_vetoStatusBase = current;

    int skipVotes = 0;
    int keepVotes = 0;
    for (size_t i = 0; i < s_lobbyBots.size(); ++i)
    {
        if (s_lobbyBots[i].vetoVote == 1)
            ++skipVotes;
        else if (s_lobbyBots[i].vetoVote == 0)
            ++keepVotes;
    }

    char display[256];
    _snprintf_s(display, ARRAYSIZE(display), _TRUNCATE, "%s  (local simulated bots: %d skip, %d keep)",
                s_vetoStatusBase.c_str(), skipVotes, keepVotes);
    if (current != display)
    {
        Dvar_SetStringFromSource(dvar, display, DVAR_SOURCE_INTERNAL);
        s_vetoStatusLastWritten = display;
    }
}

bool IsPublicGameHostDvars()
{
    // onlinegameandhost alone includes party contexts; exclude the console's private-party roles explicitly.
    return GetDvarBoolSafe("onlinegame") && GetDvarBoolSafe("onlinegameandhost") &&
           !GetDvarBoolSafe("xblive_privatematch") && !GetDvarBoolSafe("xblive_hostingprivateparty") &&
           !GetDvarBoolSafe("xblive_privatepartyclient");
}

bool IsPublicHostContext(int localClientNum)
{
    if (localClientNum < 0 || localClientNum >= 4 || !uiInfoArray[localClientNum])
        return false;

    return IsPublicGameHostDvars() && uiInfoArray[localClientNum]->currentMenuType == UIMENU_GAMELOBBY;
}

bool IsServerRunning()
{
    return GetDvarBoolSafe("sv_running");
}

void LoadBotNames()
{
    if (!s_botNamePool.empty())
        return;

    const std::string path = Config::ResolveDataPath("bots.txt");
    if (!path.empty())
    {
        std::istringstream stream(filesystem::ReadFileToString(path));
        std::string line;
        while (std::getline(stream, line))
        {
            const size_t comma = line.find(',');
            if (comma != std::string::npos)
                line.erase(comma);

            while (!line.empty() && (line.back() == '\r' || line.back() == ' ' || line.back() == '\t'))
                line.pop_back();
            const size_t first = line.find_first_not_of(" \t");
            if (first != std::string::npos)
                line.erase(0, first);

            if (line.empty() || line[0] == '#')
                continue;

            if (line.size() > 31)
                line.resize(31);
            s_botNamePool.push_back(line);
        }
    }
}

std::string NextBotName()
{
    LoadBotNames();

    for (size_t attempt = 0; attempt < s_botNamePool.size(); ++attempt)
    {
        const std::string &candidate = s_botNamePool[static_cast<size_t>(rand()) % s_botNamePool.size()];
        bool alreadyUsed = false;
        for (size_t i = 0; i < s_lobbyBots.size(); ++i)
        {
            if (I_stricmp(candidate.c_str(), s_lobbyBots[i].name.c_str()) == 0)
            {
                alreadyUsed = true;
                break;
            }
        }
        if (!alreadyUsed)
            return candidate;
    }

    char fallback[32];
    _snprintf_s(fallback, ARRAYSIZE(fallback), _TRUNCATE, "CodXe Bot %02u",
                static_cast<unsigned int>(s_lobbyBots.size() + 1));
    return fallback;
}

float RandomFloat(float minValue, float maxValue)
{
    const float unit = static_cast<float>(rand()) / static_cast<float>(RAND_MAX);
    return minValue + (maxValue - minValue) * unit;
}

DWORD GetArrivalDelayMs()
{
    const int population = s_lobbyPlayerCount + static_cast<int>(s_lobbyBots.size());
    const float progress = (std::min)(1.0f, (std::max)(0.0f, (population - 1) / 7.0f));
    const float minDelay = 5.0f + (0.33f - 5.0f) * progress;
    const float maxDelay = 30.0f + (2.5f - 30.0f) * progress;
    return static_cast<DWORD>(RandomFloat(minDelay, maxDelay) * 1000.0f);
}

int GetAvailableBotSlots()
{
    return (std::max)(0, (std::min)(MAX_CLIENTS, s_lobbyMaxPlayers) - s_lobbyPlayerCount);
}

void UpdateLobbyCounts()
{
    s_lobbyPlayerCount = (std::max)(1, ParseFirstInteger(GetDvarStringSafe("party_lobbyPlayerCount"), 1));
    s_lobbyMaxPlayers = GetDvarIntSafe("party_maxplayers", MAX_CLIENTS);
    if (s_lobbyMaxPlayers <= 0)
        s_lobbyMaxPlayers = MAX_CLIENTS;
    s_lobbyMaxPlayers = (std::min)(s_lobbyMaxPlayers, MAX_CLIENTS);
}

void SetTargetBotCount()
{
    SetIntDvar(s_lobbyBotsTarget, static_cast<int>(s_lobbyBots.size()));
}

void ResetLobbyState()
{
    const bool hadState = s_lobbySimulationActive || s_matchActive || s_postMatchGraceDeadline != 0 ||
                          !s_lobbyBots.empty() || !s_vetoStatusLastWritten.empty() ||
                          GetDvarBoolSafe(LOBBY_BOTS_ENABLED_DVAR) || GetDvarIntSafe(LOBBY_BOTS_TARGET_DVAR, 0) != 0;
    if (!hadState)
        return;

    RestoreLocalVetoStatus();
    s_lobbyBots.clear();
    UIFeeder::ResetLobbyBotFeeder();
    s_lobbySimulationActive = false;
    s_matchActive = false;
    s_vetoActive = false;
    s_nextArrivalTime = 0;
    s_nextLeaveCheckTime = 0;
    s_postMatchGraceDeadline = 0;
    s_previousLobbyPlayerCount = 1;
    SetTargetBotCount();
    SetBoolDvar(s_lobbyBotsEnabled, false);
}

void BeginLobbyState(DWORD now)
{
    if (!s_randomSeeded)
    {
        srand(GetTickCount());
        s_randomSeeded = true;
    }

    s_lobbyBots.clear();
    s_lobbySimulationActive = true;
    s_matchActive = false;
    s_vetoActive = false;
    s_postMatchGraceDeadline = 0;
    RestoreLocalVetoStatus();
    UpdateLobbyCounts();
    s_previousLobbyPlayerCount = s_lobbyPlayerCount;
    s_nextLeaveCheckTime = now + LOBBY_BOT_LEAVE_CHECK_MS;
    s_nextArrivalTime = now + GetArrivalDelayMs();
    SetTargetBotCount();
    SetBoolDvar(s_lobbyBotsEnabled, true);
}

void SetBotVoteState(bool active)
{
    if (!active)
    {
        for (size_t i = 0; i < s_lobbyBots.size(); ++i)
        {
            s_lobbyBots[i].vetoVote = -1;
            UpdateBotDisplayName(s_lobbyBots[i]);
        }
        s_vetoActive = false;
        return;
    }

    if (!s_vetoActive)
    {
        for (size_t i = 0; i < s_lobbyBots.size(); ++i)
        {
            s_lobbyBots[i].vetoVote = rand() & 1;
            UpdateBotDisplayName(s_lobbyBots[i]);
        }
        s_vetoActive = true;
    }
}

void AddLobbyBot()
{
    LobbyBot bot;
    bot.name = NextBotName();
    bot.vetoVote = s_vetoActive ? (rand() & 1) : -1;
    UpdateBotDisplayName(bot);
    s_lobbyBots.push_back(bot);
}

void RemoveLobbyBots(int count)
{
    while (count-- > 0 && !s_lobbyBots.empty())
        s_lobbyBots.erase(s_lobbyBots.begin() + (rand() % s_lobbyBots.size()));
}

void UpdateLobbySimulation(DWORD now)
{
    UpdateLobbyCounts();
    if (s_lobbyPlayerCount != s_previousLobbyPlayerCount)
    {
        s_previousLobbyPlayerCount = s_lobbyPlayerCount;
        s_nextArrivalTime = now + GetArrivalDelayMs();
    }
    SetBoolDvar(s_lobbyBotsEnabled, true);

    if (s_matchActive)
        s_matchActive = false;

    SetBotVoteState(GetDvarBoolSafe("party_vetoButtonVisible"));

    const int availableSlots = GetAvailableBotSlots();
    if (static_cast<int>(s_lobbyBots.size()) > availableSlots)
    {
        RemoveLobbyBots(static_cast<int>(s_lobbyBots.size()) - availableSlots);
        s_nextArrivalTime = now + GetArrivalDelayMs();
    }

    if (static_cast<LONG>(now - s_nextLeaveCheckTime) >= 0)
    {
        s_nextLeaveCheckTime = now + LOBBY_BOT_LEAVE_CHECK_MS;
        if (!s_lobbyBots.empty() && (rand() % 10) == 0)
        {
            RemoveLobbyBots(1 + (rand() & 1));
            s_nextArrivalTime = now + GetArrivalDelayMs();
        }
    }

    if (static_cast<LONG>(now - s_nextArrivalTime) >= 0 && static_cast<int>(s_lobbyBots.size()) < availableSlots)
    {
        AddLobbyBot();
        s_nextArrivalTime = now + GetArrivalDelayMs();
    }

    SetTargetBotCount();
    UpdateLocalVetoStatus();
}

void UpdateForCurrentState(DWORD now, int localClientNum)
{
    if (static_cast<LONG>(now - s_lastStateUpdateTime) < 100)
        return;
    s_lastStateUpdateTime = now;

    if (IsServerRunning())
    {
        if (s_lobbySimulationActive && !s_matchActive)
        {
            if (!IsPublicGameHostDvars())
            {
                ResetLobbyState();
                return;
            }

            RestoreLocalVetoStatus();
            s_matchActive = true;
            s_postMatchGraceDeadline = 0;
            SetTargetBotCount();
        }
        return;
    }

    if (!IsPublicHostContext(localClientNum))
    {
        if (s_lobbySimulationActive && s_matchActive)
        {
            s_matchActive = false;
            s_postMatchGraceDeadline = now + POST_MATCH_LOBBY_GRACE_MS;
            return;
        }

        if (s_postMatchGraceDeadline && static_cast<LONG>(now - s_postMatchGraceDeadline) < 0)
            return;

        ResetLobbyState();
        return;
    }

    s_postMatchGraceDeadline = 0;
    if (!s_lobbySimulationActive)
        BeginLobbyState(now);

    UpdateLobbySimulation(now);
}
} // namespace

LobbyBots::LobbyBots()
{
}

LobbyBots::~LobbyBots()
{
}

void LobbyBots::OnDvarInit()
{
    s_lobbyBotsEnabled = Dvar_RegisterBool(LOBBY_BOTS_ENABLED_DVAR, false, DVAR_FLAG_NONE,
                                           "Enable CoD Xe's host-local public lobby bot prototype");
    s_lobbyBotsTarget = Dvar_RegisterInt(LOBBY_BOTS_TARGET_DVAR, 0, 0, MAX_CLIENTS - 1, DVAR_FLAG_NONE,
                                         "Number of host-local lobby bots to spawn when the match starts");
}

void LobbyBots::OnUIRefresh(int localClientNum)
{
    if (localClientNum != 0)
        return;

    UpdateForCurrentState(GetTickCount(), localClientNum);
}

void LobbyBots::OnFrame(int localClientNum)
{
    if (localClientNum == 0)
        UpdateForCurrentState(GetTickCount(), localClientNum);
}

void LobbyBots::OnVMShutdown()
{
    if (!s_lobbySimulationActive || !s_matchActive || !svsHeader || !svsHeader->clients)
        return;

    std::vector<LobbyBot> actualRoster;
    for (int i = 0; i < MAX_CLIENTS && actualRoster.size() < MAX_CLIENTS; ++i)
    {
        const client_t &client = svsHeader->clients[i];
        if (client.header.netchan.remoteAddress.type != NA_BOT || client.header.state == CS_FREE ||
            client.header.state == CS_ZOMBIE)
        {
            continue;
        }

        LobbyBot bot;
        bot.name = client.name[0] ? client.name : "CodXe Bot";
        bot.vetoVote = -1;
        UpdateBotDisplayName(bot);
        actualRoster.push_back(bot);
    }

    s_lobbyBots.swap(actualRoster);
    SetTargetBotCount();
}

bool LobbyBots::IsLobbyUiActive(int localClientNum)
{
    return s_lobbySimulationActive && !s_matchActive && !IsServerRunning() && IsPublicHostContext(localClientNum);
}

int LobbyBots::GetLobbyHumanCount()
{
    return s_lobbyPlayerCount;
}

int LobbyBots::GetLobbyBotCount()
{
    return static_cast<int>(s_lobbyBots.size());
}

const char *LobbyBots::GetLobbyBotDisplayName(int index)
{
    if (index < 0 || index >= static_cast<int>(s_lobbyBots.size()))
        return "";

    return s_lobbyBots[static_cast<size_t>(index)].displayName.c_str();
}

int LobbyBots::GetLobbyBotVote(int index)
{
    if (index < 0 || index >= static_cast<int>(s_lobbyBots.size()))
        return -1;
    return s_lobbyBots[static_cast<size_t>(index)].vetoVote;
}
} // namespace mp
} // namespace iw3
