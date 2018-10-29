#include <sourcemod>
#include <cstrike>

public Plugin myinfo =
{
    name = "specmode",
    author = "Hattrick HKS",
    description = "Admin Spectator Mode",
    version = "1.0",
    url = "http://hattrick.go.ro/"
};

#define REQUIRED_FLAG ADMFLAG_BAN

enum SpecMode
{
    SpecMode_None = 0,

    SpecMode_1ST_Person = 4,
    SpecMode_3RD_Person,

    SpecMode_Free_Look
};

public void OnPluginStart()
{
    RegConsoleCmd("spec_mode", OnSpecMode);
}

public Action OnSpecMode(int iId, int iArgs)
{
    static int iMode = view_as<int>(SpecMode_None);

    if (iId >= 1 && iId <= MaxClients && IsClientInGame(iId) && \
            !IsFakeClient(iId) && !IsClientSourceTV(iId) && \
                F_IsAdmin(iId) && F_CanSwitchSpecMode(iId, iMode))
    {
        switch (iMode)
        {
            case view_as<int>(SpecMode_1ST_Person):
            {
                SetEntProp(iId, Prop_Send, "m_iObserverMode", view_as<int>(SpecMode_3RD_Person));
            }

            case view_as<int>(SpecMode_3RD_Person):
            {
                SetEntProp(iId, Prop_Send, "m_iObserverMode", view_as<int>(SpecMode_Free_Look));
            }

            case view_as<int>(SpecMode_Free_Look):
            {
                SetEntProp(iId, Prop_Send, "m_iObserverMode", view_as<int>(SpecMode_1ST_Person));
            }
        }

        return Plugin_Stop;
    }

    return Plugin_Continue;
}

bool F_IsAdmin(int iId)
{
    static int iFlags = 0;

    iFlags = GetUserFlagBits(iId);

    if (iFlags & ADMFLAG_ROOT)
    {
        return true;
    }

    if (iFlags & REQUIRED_FLAG)
    {
        return true;
    }

    return false;
}

bool F_CanSwitchSpecMode(int iId, int& iMode)
{
    static int iTeam = CS_TEAM_NONE;
    static int iSpecMode = view_as<int>(SpecMode_None);

    iMode = iSpecMode;

    if (IsPlayerAlive(iId))
    {
        return false;
    }

    iTeam = GetClientTeam(iId);

    if (iTeam != CS_TEAM_T && iTeam != CS_TEAM_CT)
    {
        return false;
    }

    iSpecMode = GetEntProp(iId, Prop_Send, "m_iObserverMode");

    iMode = iSpecMode;

    if (iSpecMode == view_as<int>(SpecMode_None))
    {
        return false;
    }

    return true;
}  