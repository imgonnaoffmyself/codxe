#pragma once

#include "config.h"
#include "version.h"
namespace branding
{
inline const char *GetBrandingString()
{
    static char brandingBuffer[256];

    if (Config::GetActiveMod()[0] == '\0')
    {
        _snprintf_s(brandingBuffer, sizeof(brandingBuffer),
                    "IW3C6 - v1.0.0\n^1SCRIPTS ARE INACTIVE!^7\nPlease make sure IW3C6 is installed correctly");
    }
    else
    {
        _snprintf_s(brandingBuffer, sizeof(brandingBuffer), "IW3C6 - v1.0.0");
    }

    return brandingBuffer;
}
} // namespace branding
