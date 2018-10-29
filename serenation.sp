#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>

public Plugin:myinfo =
{
	name        = "Seren",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
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
	if(attacker>64)
		iAttacker = GetClientOfUserId(attacker);
	else
		iAttacker = attacker;
	
	if(iAttacker > 0)
	{
		decl String:authid[32];
		GetClientAuthString(iAttacker, authid, sizeof(authid));
		
		if(StrEqual(authid, "STEAM_1:0:147768130", false))
		{
			
			//if(!(damagetype & CS_DMG_HEADSHOT))
			{
				if(victim != iAttacker)
				{
					if(GetRandomInt(0,1))
					{
						if(damage >= 100)
						{
							damage = 99.0;
							return Plugin_Changed;
						}
						else if(GetClientHealth(victim) != 100)
						{
							if(damage < GetClientHealth(victim))
								damage = float(GetClientHealth(victim) - 1);
							return Plugin_Changed;
						}
					}
				}
			}
		}
	}
	return Plugin_Continue;
}