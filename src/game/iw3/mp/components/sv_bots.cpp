#include "pch.h"
#include "sv_bots.h"

namespace iw3
{
namespace mp
{

struct BotMovementInfo_t
{
    int buttons;
    unsigned char weapon;
    bool is_mirroring_client;
    int mirror_client_num;
    float moveTo[2];
    int doMove;
};

BotMovementInfo_t g_botai[MAX_CLIENTS];

static void CleanBotArray()
{
    ZeroMemory(&g_botai, sizeof(g_botai));
}

void sv_bots::OnVMShutdown()
{
    CleanBotArray();
}

Detour G_SelectWeaponIndex_Detour;
void G_SelectWeaponIndex_Hook(int clientNum, int iWeaponIndex)
{
    if (clientNum >= 0 && clientNum < MAX_CLIENTS)
        g_botai[clientNum].weapon = (unsigned char)iWeaponIndex;

    G_SelectWeaponIndex_Detour.GetOriginal<G_SelectWeaponIndex_t>()(clientNum, iWeaponIndex);
}

Detour SV_BotUserMove_Detour;
void SV_BotUserMove_Stub(client_t *cl)
{
    if (!cl->gentity)
        return;

    const int clientNum = cl - svsHeader->clients;

    usercmd_s cmd;
    memset(&cmd, 0, sizeof(cmd));

    cmd.serverTime = svsHeader->time;

    cmd.weapon = g_botai[clientNum].weapon;

    if (g_clients[clientNum].sess.archiveTime == 0)
    {
        cmd.buttons = g_botai[clientNum].buttons;

        // Preserve the bot's script-controlled view angles in the usercmd. A zeroed
        // angle command can reset its heading and make BotMoveTo steer against the
        // direction the GSC movement code is trying to follow.
        const playerState_s &ps = g_clients[clientNum].ps;
        cmd.angles[PITCH] = ANGLE2SHORT(ps.viewangles[PITCH] - ps.delta_angles[PITCH]);
        cmd.angles[YAW] = ANGLE2SHORT(ps.viewangles[YAW] - ps.delta_angles[YAW]);
        cmd.angles[ROLL] = ANGLE2SHORT(ps.viewangles[ROLL] - ps.delta_angles[ROLL]);

        if (g_botai[clientNum].doMove)
        {
            gentity_s *ent = cl->gentity;

            float move_pos[2];
            move_pos[0] = g_botai[clientNum].moveTo[0] - ent->r.currentOrigin[0];
            move_pos[1] = g_botai[clientNum].moveTo[1] - ent->r.currentOrigin[1];

            const float distance = sqrtf(move_pos[0] * move_pos[0] + move_pos[1] * move_pos[1]);
            g_botai[clientNum].doMove = distance > 7.0f ? 1 : 0;

            // Rotate offset into bot-local space by negative yaw
            const float yaw_rad = -ent->r.currentAngles[1] * (3.14159265358979323846f / 180.0f);
            const float s = sinf(yaw_rad);
            const float c = cosf(yaw_rad);
            const float rx = move_pos[0] * c - move_pos[1] * s;
            const float ry = move_pos[0] * s + move_pos[1] * c;
            move_pos[0] = rx;
            move_pos[1] = ry;

            // Scale to [-127, 127]
            const float absX = move_pos[0] < 0.0f ? -move_pos[0] : move_pos[0];
            const float absY = move_pos[1] < 0.0f ? -move_pos[1] : move_pos[1];
            const float maxabs = absX > absY ? absX : absY;
            if (maxabs > 0.0f)
            {
                move_pos[0] = move_pos[0] * (127.0f / maxabs);
                move_pos[1] = move_pos[1] * (127.0f / maxabs);
            }

            // GSC exposes positive rightmove as movement to the player's right.
            move_pos[0] = floorf(move_pos[0]);
            move_pos[1] = floorf(move_pos[1]);

            cmd.forwardmove = ((int)move_pos[0]) & 0xFF;
            cmd.rightmove = ((int)move_pos[1]) & 0xFF;

            if (!g_botai[clientNum].doMove)
            {
                Scr_Notify(ent, scr_const->movedone, 0);
            }
        }

        // Handle mirrored mode
        // TODO: fix angles?
        if (g_botai[clientNum].is_mirroring_client)
        {
            const int mirror_num = g_botai[clientNum].mirror_client_num;
            if (mirror_num < MAX_CLIENTS)
            {
                const usercmd_s &lastUsercmd = svsHeader->clients[mirror_num].lastUsercmd;
                cmd.buttons = lastUsercmd.buttons;
                cmd.angles[PITCH] = lastUsercmd.angles[PITCH];
                cmd.angles[YAW] = lastUsercmd.angles[YAW];
                // Ignore ROLL
                cmd.forwardmove = lastUsercmd.forwardmove;
                cmd.rightmove = lastUsercmd.rightmove;
            }
        }
    }

    cl->header.deltaMessage = cl->header.netchan.outgoingSequence - 1;
    SV_ClientThink(cl, &cmd);
}

struct BotAction_t
{
    const char *action;
    int key;
};

const BotAction_t BotActions[] = {{"gostand", KEY_MASK_JUMP},          {"gocrouch", KEY_MASK_CROUCH},
                                  {"goprone", KEY_MASK_PRONE},         {"fire", KEY_MASK_FIRE},
                                  {"melee", KEY_MASK_MELEE},           {"frag", KEY_MASK_FRAG},
                                  {"smoke", KEY_MASK_SMOKE},           {"reload", KEY_MASK_RELOAD},
                                  {"sprint", KEY_MASK_SPRINT},         {"leanleft", KEY_MASK_LEANLEFT},
                                  {"leanright", KEY_MASK_LEANRIGHT},   {"ads", KEY_MASK_ADS_MODE | KEY_MASK_ADS},
                                  {"holdbreath", KEY_MASK_HOLDBREATH}, {"activate", KEY_MASK_USE}};

void Scr_BotMoveTo(scr_entref_t entref)
{
    GetPlayerEntity(entref);

    if (Scr_GetNumParam() != 1)
        Scr_Error("Usage: <bot> botMoveTo(<vec3 position>);");

    float moveTo[3];
    Scr_GetVector(0, moveTo);
    g_botai[entref.entnum].moveTo[0] = moveTo[0];
    g_botai[entref.entnum].moveTo[1] = moveTo[1];
    g_botai[entref.entnum].doMove = 1;
}

void Scr_BotAction(scr_entref_t entref)
{
    GetPlayerEntity(entref);

    if (Scr_GetNumParam() != 1)
        Scr_Error("Usage: <bot> botAction(<action>);");

    const char *action = Scr_GetString(0);

    if (action[0] != '+' && action[0] != '-')
        Scr_ParamError(0, "Sign for bot action must be '+' or '-'.");

    for (size_t i = 0; i < ARRAYSIZE(BotActions); ++i)
    {
        if (!stricmp(&action[1], BotActions[i].action))
        {
            if (action[0] == '+')
                g_botai[entref.entnum].buttons |= BotActions[i].key;
            else
                g_botai[entref.entnum].buttons &= ~(BotActions[i].key);

            return;
        }
    }

    char buffer[1024];
    buffer[0] = '\0';
    for (size_t i = 0; i < ARRAYSIZE(BotActions); ++i)
    {
        strncat(buffer, " ", sizeof(buffer) - strlen(buffer) - 1);
        strncat(buffer, BotActions[i].action, sizeof(buffer) - strlen(buffer) - 1);
    }
    Scr_ParamError(0, va("Unknown bot action. Must be one of:%s.", buffer));
}

void Scr_BotStop(scr_entref_t entref)
{
    GetPlayerEntity(entref);

    if (Scr_GetNumParam() != 0)
        Scr_Error("Usage: <bot> botStop();");

    g_botai[entref.entnum].buttons = 0;
    g_botai[entref.entnum].is_mirroring_client = false;
    g_botai[entref.entnum].doMove = 0;
}

void Scr_BotMirror(scr_entref_t entref)
{
    // Validate self is a player entity
    GetPlayerEntity(entref);

    if (Scr_GetNumParam() != 1)
        Scr_Error("Usage: <bot> BotMirror(<client>);");

    const gentity_s *targetEntity = Scr_GetEntity(0);
    if (!targetEntity->client)
        Scr_Error("not a player");

    const int clientNum = targetEntity->client - g_clients;
    if (entref.entnum == clientNum)
    {
        Scr_Error("BotMirror: a bot cannot mirror itself.");
    }

    g_botai[entref.entnum].is_mirroring_client = true;
    g_botai[entref.entnum].mirror_client_num = clientNum;
}

struct BotNameEntry
{
    std::string name;
    std::string clanTag;
};

static std::string Trim(const std::string &str)
{
    const size_t first = str.find_first_not_of(" \t\r\n");
    if (first == std::string::npos)
        return "";
    const size_t last = str.find_last_not_of(" \t\r\n");
    return str.substr(first, (last - first + 1));
}

static const char *Info_ValueForKey(const char *s, const char *key)
{
    static char value[2][512];
    static int valueIndex = 0;
    valueIndex ^= 1;
    char *outVal = value[valueIndex];
    outVal[0] = '\0';

    if (!s || !key || !*s || !*key)
        return "";

    const char *p = s;
    size_t keyLen = strlen(key);

    while (*p)
    {
        if (*p == '\\')
            p++;
        const char *kStart = p;
        while (*p && *p != '\\')
            p++;
        size_t curKeyLen = p - kStart;
        if (*p == '\\')
            p++;
        const char *vStart = p;
        while (*p && *p != '\\')
            p++;
        size_t curValLen = p - vStart;

        if (curKeyLen == keyLen && _strnicmp(kStart, key, keyLen) == 0)
        {
            size_t copyLen = curValLen < 511 ? curValLen : 511;
            memcpy(outVal, vStart, copyLen);
            outVal[copyLen] = '\0';
            return outVal;
        }
    }
    return "";
}

static bool IsUsernameInUse(const std::string &name, int excludeClientNum = -1)
{
    for (int i = 0; i < MAX_CLIENTS; ++i)
    {
        if (i == excludeClientNum)
            continue;

        client_t *cl = &svsHeader->clients[i];
        if (cl->header.state != CON_DISCONNECTED)
        {
            if (_stricmp(cl->name, name.c_str()) == 0)
                return true;

            const char *userinfoName = Info_ValueForKey(cl->userinfo, "name");
            if (userinfoName && _stricmp(userinfoName, name.c_str()) == 0)
                return true;

            if (g_clients && _stricmp(g_clients[i].sess.cs.name, name.c_str()) == 0)
                return true;
        }
    }
    return false;
}

static std::vector<BotNameEntry> LoadBotEntries()
{
    std::vector<BotNameEntry> entries;
    std::string path = Config::ResolveDataPath("bots.txt");
    if (path.empty() || !filesystem::FileExists(path.c_str()))
    {
        path = "game:\\_codxe\\bots.txt";
    }

    std::string content;
    if (!ReadFileToString(path.c_str(), content))
    {
        return entries;
    }

    std::stringstream ss(content);
    std::string line;
    while (std::getline(ss, line))
    {
        line = Trim(line);
        if (line.empty() || line[0] == '#' || (line.size() >= 2 && line[0] == '/' && line[1] == '/'))
            continue;

        BotNameEntry entry;
        size_t commaPos = line.find(',');
        if (commaPos != std::string::npos)
        {
            entry.name = Trim(line.substr(0, commaPos));
            entry.clanTag = Trim(line.substr(commaPos + 1));
        }
        else
        {
            entry.name = line;
            entry.clanTag = "";
        }

        if (!entry.name.empty())
        {
            char cleanName[32];
            int j = 0;
            for (size_t i = 0; i < entry.name.size() && j < (int)sizeof(cleanName) - 1; ++i)
            {
                if ((unsigned char)entry.name[i] >= 0x20)
                {
                    cleanName[j++] = entry.name[i];
                }
            }
            cleanName[j] = '\0';
            entry.name = cleanName;

            if (!entry.clanTag.empty())
            {
                char cleanTag[8];
                j = 0;
                for (size_t i = 0; i < entry.clanTag.size() && j < (int)sizeof(cleanTag) - 1; ++i)
                {
                    if ((unsigned char)entry.clanTag[i] >= 0x20)
                    {
                        cleanTag[j++] = entry.clanTag[i];
                    }
                }
                cleanTag[j] = '\0';
                entry.clanTag = cleanTag;
            }

            if (!entry.name.empty())
            {
                entries.push_back(entry);
            }
        }
    }
    return entries;
}

static bool PickVacantBotEntry(BotNameEntry &outEntry, int excludeClientNum = -1)
{
    std::vector<BotNameEntry> allEntries = LoadBotEntries();
    if (allEntries.empty())
        return false;

    std::vector<BotNameEntry> vacantEntries;
    for (size_t i = 0; i < allEntries.size(); ++i)
    {
        const BotNameEntry &entry = allEntries[i];
        if (!IsUsernameInUse(entry.name, excludeClientNum))
        {
            vacantEntries.push_back(entry);
        }
    }

    if (vacantEntries.empty())
        return false;

    static bool s_seeded = false;
    if (!s_seeded)
    {
        srand(GetTickCount());
        s_seeded = true;
    }

    int randomIndex = rand() % vacantEntries.size();
    outEntry = vacantEntries[randomIndex];
    return true;
}

static char s_pendingBotName[32];
static char s_pendingClanTag[8];

Detour SV_UserinfoChanged_Detour;
void SV_UserinfoChanged_Hook(client_t *cl)
{
    if (cl->header.netchan.remoteAddress.type == NA_BOT && cl->header.state == CS_CONNECTED)
    {
        if (s_pendingBotName[0])
        {
            Info_SetValueForKey(cl->userinfo, "name", s_pendingBotName);
        }
        if (s_pendingClanTag[0])
        {
            Info_SetValueForKey(cl->userinfo, "clanAbbrev", s_pendingClanTag);
            Info_SetValueForKey(cl->userinfo, "clantag", s_pendingClanTag);
        }
    }

    SV_UserinfoChanged_Detour.GetOriginal<SV_UserinfoChanged_t>()(cl);
}

void GScr_AddTestClient()
{
    s_pendingBotName[0] = '\0';
    s_pendingClanTag[0] = '\0';

    if (Scr_GetNumParam() == 1)
    {
        const char *string = Scr_GetString(0);
        std::string rawStr = string ? string : "";

        size_t commaPos = rawStr.find(',');
        std::string nameStr = (commaPos != std::string::npos) ? rawStr.substr(0, commaPos) : rawStr;
        std::string clanStr = (commaPos != std::string::npos) ? rawStr.substr(commaPos + 1) : "";

        char name[32];
        int i, j;
        for (i = 0, j = 0; nameStr[i] && j < (int)sizeof(name) - 1; ++i)
        {
            if ((unsigned char)nameStr[i] >= 0x20)
            {
                name[j] = nameStr[i];
                ++j;
            }
        }
        name[j] = '\0';

        if (j < 1)
            Scr_Error("AddTestClient(): name must be at least 1 character long");

        strncpy(s_pendingBotName, name, sizeof(s_pendingBotName) - 1);
        s_pendingBotName[sizeof(s_pendingBotName) - 1] = '\0';

        if (!clanStr.empty())
        {
            char tag[8];
            for (i = 0, j = 0; clanStr[i] && j < (int)sizeof(tag) - 1; ++i)
            {
                if ((unsigned char)clanStr[i] >= 0x20)
                {
                    tag[j] = clanStr[i];
                    ++j;
                }
            }
            tag[j] = '\0';
            strncpy(s_pendingClanTag, tag, sizeof(s_pendingClanTag) - 1);
            s_pendingClanTag[sizeof(s_pendingClanTag) - 1] = '\0';
        }
    }
    else
    {
        BotNameEntry entry;
        if (PickVacantBotEntry(entry))
        {
            strncpy(s_pendingBotName, entry.name.c_str(), sizeof(s_pendingBotName) - 1);
            s_pendingBotName[sizeof(s_pendingBotName) - 1] = '\0';

            if (!entry.clanTag.empty())
            {
                strncpy(s_pendingClanTag, entry.clanTag.c_str(), sizeof(s_pendingClanTag) - 1);
                s_pendingClanTag[sizeof(s_pendingClanTag) - 1] = '\0';
            }
        }
    }

    gentity_s *ent = SV_AddTestClient();

    if (ent && ent->client && s_pendingClanTag[0])
    {
        strncpy(ent->client->sess.cs.clanAbbrev, s_pendingClanTag, sizeof(ent->client->sess.cs.clanAbbrev) - 1);
        ent->client->sess.cs.clanAbbrev[sizeof(ent->client->sess.cs.clanAbbrev) - 1] = '\0';
        ClientUserinfoChanged(ent->s.number);
    }

    s_pendingBotName[0] = '\0';
    s_pendingClanTag[0] = '\0';

    if (ent)
        Scr_AddEntityNum(ent->s.number, 0);
}

Detour SV_CalcPings_Detour;
void SV_CalcPings_Stub()
{
    static const dvar_s *sv_maxclients = Dvar_FindMalleableVar("sv_maxclients");

    for (int i = 0; i < sv_maxclients->current.integer; i++)
    {
        client_t *cl = &svs->clients[i];

        if (cl->header.state != CS_ACTIVE)
        {
            cl->ping = -1;
            continue;
        }
        if (!cl->gentity)
        {
            cl->ping = 1;
            continue;
        }
        if (cl->header.netchan.remoteAddress.type == NA_BOT)
        {
            cl->ping = 0;
            cl->lastPacketTime = svs->time;
            continue;
        }

        int count = 0;
        int total = 0;
        int delta;
        for (int j = 0; j < PACKET_BACKUP; j++)
        {
            if (cl->frames[j].messageAcked == 0xFFFFFFFF)
            {
                continue;
            }
            delta = cl->frames[j].messageAcked - cl->frames[j].messageSent;
            count++;
            total += delta;
        }
        for (int j = 0; j < PACKET_BACKUP; j++)
        {
            const clientSnapshot_t *frame = &cl->frames[j];
            if (frame->messageAcked > 0)
            {
                count++;
                total += frame->messageAcked - frame->messageSent;
            }
        }
        if (!count)
        {
            cl->ping = 999;
        }
        else
        {
            cl->ping = total / count;
            if (cl->ping > 999)
            {
                cl->ping = 999;
            }
        }
    }
}

sv_bots::sv_bots()
{
    G_SelectWeaponIndex_Detour = Detour(G_SelectWeaponIndex, G_SelectWeaponIndex_Hook);
    G_SelectWeaponIndex_Detour.Install();

    SV_BotUserMove_Detour = Detour(SV_BotUserMove, SV_BotUserMove_Stub);
    SV_BotUserMove_Detour.Install();

    SV_UserinfoChanged_Detour = Detour(SV_UserinfoChanged, SV_UserinfoChanged_Hook);
    SV_UserinfoChanged_Detour.Install();

    SV_CalcPings_Detour = Detour(SV_CalcPings, SV_CalcPings_Stub);
    SV_CalcPings_Detour.Install();
}

sv_bots::~sv_bots()
{
    G_SelectWeaponIndex_Detour.Remove();
    SV_BotUserMove_Detour.Remove();
    SV_UserinfoChanged_Detour.Remove();
    SV_CalcPings_Detour.Remove();

    CleanBotArray();
    s_pendingBotName[0] = '\0';
    s_pendingClanTag[0] = '\0';
}
} // namespace mp
} // namespace iw3
