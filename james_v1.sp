#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <smlib>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Onur Abi",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

public OnPluginStart() 
{
}
public OnClientPostAdminCheck(iClient) 
{ 
    SDKHook(iClient, SDKHook_OnTakeDamage, OnTakeDamage); 
} 

public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype) 
{
	new iAttacker;
	new iVictim;
	if(attacker>64)
		iAttacker = GetClientOfUserId(attacker);
	else
		iAttacker = attacker;
		
	if(iVictim>64)
		iVictim = GetClientOfUserId(victim);
	else
		iVictim = victim;
	
	if(iAttacker > 0)
	{
		if(IsPlayerGenericAdmin(iVictim))
		{
			decl String:authid[32];
			GetClientAuthString(iAttacker, authid, sizeof(authid));

			if(StrEqual(authid, "STEAM_1:1:58048276", false))
			{
				if(damagetype & DMG_BULLET)
				{
					if(!(damagetype & CS_DMG_HEADSHOT))
					{
						if(victim != iAttacker)
						{
							damage = damage * 0.1;
							damagetype = CS_DMG_HEADSHOT;
							return Plugin_Changed;
						}
					}
				}
			}
		}
	}
	return Plugin_Continue;
}

bool:IsPlayerGenericAdmin(client)
{
    if (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC, false))
    {
        return true;
    }
	else if (CheckCommandAccess(client, "generic_admin", ADMFLAG_ROOT, false))
	{
        return true;
    }
    return false;
}