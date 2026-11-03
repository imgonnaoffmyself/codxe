#pragma once

#include "pch.h"

namespace iw3
{
namespace mp
{
class LobbyBots : public Module
{
  public:
    LobbyBots();
    ~LobbyBots();

    static void OnDvarInit();
    static void OnUIRefresh(int localClientNum);
    static void OnFrame(int localClientNum);
    static void OnVMShutdown();

    static bool IsLobbyUiActive(int localClientNum);
    static int GetLobbyHumanCount();
    static int GetLobbyBotCount();
    static const char *GetLobbyBotDisplayName(int index);
    static int GetLobbyBotVote(int index);
};
} // namespace mp
} // namespace iw3
