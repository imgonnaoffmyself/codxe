#include "pch.h"
#include "gsc_fields.h"

const unsigned int CLIENT_FIELD_MASK = 0xC000;

namespace iw3
{
namespace mp
{

void ClientScr_SetEntityFlags(gclient_s *pSelf, const client_fields_s *pField)
{
    gentity_s *ent = &g_entities[pSelf - g_clients];
    ent->flags = Scr_GetInt(0);
}

void ClientScr_GetEntityFlags(gclient_s *pSelf, const client_fields_s *field)
{
    const gentity_s *ent = &g_entities[pSelf - g_clients];
    Scr_AddInt(ent->flags);
}

void ClientScr_GetForwardMove(gclient_s *pSelf, const client_fields_s *field)
{
    const client_t *cl = &svsHeader->clients[pSelf - g_clients];
    Scr_AddInt(cl->lastUsercmd.rightmove);
}

void ClientScr_GetRightMove(gclient_s *pSelf, const client_fields_s *field)
{
    const client_t *cl = &svsHeader->clients[pSelf - g_clients];
    Scr_AddInt(cl->lastUsercmd.forwardmove);
}

void ClientScr_GetBotStatus(gclient_s *pSelf, const client_fields_s *pField)
{
    assert(pSelf != NULL);

    const client_t *cl = &svsHeader->clients[pSelf - g_clients];

    Scr_AddInt(cl->header.netchan.remoteAddress.type == NA_BOT);
}

void ClientScr_SetName(gclient_s *pSelf, const client_fields_s *pField)
{
    const char *name = Scr_GetString(0);
    strncpy(pSelf->sess.cs.name, name, sizeof(pSelf->sess.cs.name) - 1);
    pSelf->sess.cs.name[sizeof(pSelf->sess.cs.name) - 1] = '\0';
    strncpy(pSelf->sess.newnetname, name, sizeof(pSelf->sess.newnetname) - 1);
    pSelf->sess.newnetname[sizeof(pSelf->sess.newnetname) - 1] = '\0';

    int clientNum = pSelf - g_clients;
    if (clientNum >= 0 && clientNum < 18)
    {
        strncpy(svsHeader->clients[clientNum].name, name, sizeof(svsHeader->clients[clientNum].name) - 1);
        svsHeader->clients[clientNum].name[sizeof(svsHeader->clients[clientNum].name) - 1] = '\0';
        Info_SetValueForKey(svsHeader->clients[clientNum].userinfo, "name", name);
        ClientUserinfoChanged(clientNum);
    }
}

void ClientScr_GetClanAbbrev(gclient_s *pSelf, const client_fields_s *field)
{
    Scr_AddString(pSelf->sess.cs.clanAbbrev);
}

void ClientScr_SetClanAbbrev(gclient_s *pSelf, const client_fields_s *pField)
{
    const char *tag = Scr_GetString(0);
    strncpy(pSelf->sess.cs.clanAbbrev, tag, sizeof(pSelf->sess.cs.clanAbbrev) - 1);
    pSelf->sess.cs.clanAbbrev[sizeof(pSelf->sess.cs.clanAbbrev) - 1] = '\0';

    int clientNum = pSelf - g_clients;
    if (clientNum >= 0 && clientNum < 18)
    {
        Info_SetValueForKey(svsHeader->clients[clientNum].userinfo, "clanAbbrev", tag);
        Info_SetValueForKey(svsHeader->clients[clientNum].userinfo, "clantag", tag);
        ClientUserinfoChanged(clientNum);
    }
}

client_fields_s client_fields_extended[] = {
    // Original fields
    {"name", 0, F_LSTRING, ClientScr_SetName, ClientScr_GetName},
    {"sessionteam", 0, F_STRING, ClientScr_SetSessionTeam, ClientScr_GetSessionTeam},
    {"sessionstate", 0, F_STRING, ClientScr_SetSessionState, ClientScr_GetSessionState},
    {"maxhealth", 12284, F_INT, ClientScr_SetMaxHealth, nullptr},
    {"score", 12156, F_INT, ClientScr_SetScore, nullptr},
    {"deaths", 12160, F_INT, nullptr, nullptr},
    {"statusicon", 0, F_STRING, ClientScr_SetStatusIcon, ClientScr_GetStatusIcon},
    {"headicon", 0, F_STRING, ClientScr_SetHeadIcon, ClientScr_GetHeadIcon},
    {"headiconteam", 0, F_STRING, ClientScr_SetHeadIconTeam, ClientScr_GetHeadIconTeam},
    {"kills", 12164, F_INT, nullptr, nullptr},
    {"assists", 12168, F_INT, nullptr, nullptr},
    {"hasradar", 12712, F_INT, nullptr, nullptr},
    {"spectatorclient", 12140, F_INT, ClientScr_SetSpectatorClient, nullptr},
    {"killcamentity", 12144, F_INT, ClientScr_SetKillCamEntity, nullptr},
    {"archivetime", 12152, F_FLOAT, ClientScr_SetArchiveTime, ClientScr_GetArchiveTime},
    {"psoffsettime", 12448, F_INT, ClientScr_SetPSOffsetTime, ClientScr_GetPSOffsetTime},
    {"pers", 12172, F_OBJECT, ClientScr_ReadOnly, nullptr},

    // Custom fields
    {"noclip", 12456, F_INT, nullptr, nullptr},
    {"ufo", 12460, F_INT, nullptr, nullptr},
    {"entityflags", NULL, F_INT, ClientScr_SetEntityFlags, ClientScr_GetEntityFlags},
    {"forwardmove", NULL, F_INT, ClientScr_ReadOnly, ClientScr_GetForwardMove},
    {"rightmove", NULL, F_INT, ClientScr_ReadOnly, ClientScr_GetRightMove},
    {"isbot", 0, F_INT, ClientScr_ReadOnly, ClientScr_GetBotStatus},
    {"clanabbrev", NULL, F_STRING, ClientScr_SetClanAbbrev, ClientScr_GetClanAbbrev},
    {"clantag", NULL, F_STRING, ClientScr_SetClanAbbrev, ClientScr_GetClanAbbrev},

    {nullptr, 0, F_INT, nullptr, nullptr}};

Detour GScr_AddFieldsForClient_Detour;

void GScr_AddFieldsForClient_Hook()
{
    auto client_field = client_fields_extended;
    while (client_field->name != nullptr)
    {
        int field_index = client_field - client_fields_extended;
        Scr_AddClassField(0, client_field->name, (unsigned short)(field_index) | CLIENT_FIELD_MASK);
        client_field++;
    }
}

Detour Scr_SetEntityField_Detour;

int Scr_SetEntityField_Hook(int entnum, int offset)
{
    auto entity = &g_entities[entnum];

    // Client field case
    if ((offset & CLIENT_FIELD_MASK) == CLIENT_FIELD_MASK)
    {
        if (!entity->client)
        {
            return 0;
        }

        // Using our extended client fields
        const client_fields_s *field = &client_fields_extended[offset & 0xFFFF3FFF];

        // Check if there's a setter function
        if (field->setter)
        {
            field->setter(entity->client, field);
            return 1;
        }

        Scr_SetGenericField((unsigned char *)entity->client, field->type, field->ofs);
        return 1;
    }
    else
    {
        // Entity field case
        const ent_field_t *field = &entity_fields[offset];

        if (field->callback)
        {
            field->callback(entity, field->ofs);
            return 1;
        }

        Scr_SetGenericField(reinterpret_cast<unsigned __int8 *>(entity), field->type, field->ofs);
        return 1;
    }
}

Detour Scr_GetEntityField_Detour;

void Scr_GetEntityField_Hook(int entnum, int offset)
{
    auto entity = &g_entities[entnum];

    if ((offset & CLIENT_FIELD_MASK) == CLIENT_FIELD_MASK)
    {
        if (!entity->client)
        {
            return;
        }

        const client_fields_s *field = &client_fields_extended[offset & 0xFFFF3FFF];

        if (field->getter)
        {
            field->getter(entity->client, field);
            return;
        }

        Scr_GetGenericField(reinterpret_cast<unsigned __int8 *>(entity->client), field->type, field->ofs);
    }
    else
    {
        const ent_field_t *field = &entity_fields[offset];
        Scr_GetGenericField(reinterpret_cast<unsigned __int8 *>(entity), field->type, field->ofs);
    }
}

GSCFields::GSCFields()
{
    GScr_AddFieldsForClient_Detour = Detour(GScr_AddFieldsForClient, GScr_AddFieldsForClient_Hook);
    GScr_AddFieldsForClient_Detour.Install();

    Scr_GetEntityField_Detour = Detour(Scr_GetEntityField, Scr_GetEntityField_Hook);
    Scr_GetEntityField_Detour.Install();

    Scr_SetEntityField_Detour = Detour(Scr_SetEntityField, Scr_SetEntityField_Hook);
    Scr_SetEntityField_Detour.Install();
}

GSCFields::~GSCFields()
{
    GScr_AddFieldsForClient_Detour.Remove();
    Scr_GetEntityField_Detour.Remove();
    Scr_SetEntityField_Detour.Remove();
}
} // namespace mp
} // namespace iw3
