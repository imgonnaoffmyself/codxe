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
};
} // namespace mp
} // namespace iw3
