#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

public Plugin:myinfo =
{
	name        = "Tavuk Büyütücü",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};


public OnPluginStart() 
{
	HookEvent("round_start", Event_RoundStart);
}

public void Event_RoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	CreateTimer(0.5, TavukBuyut);
}

public Action TavukBuyut(Handle timer)
{
	for(new i=1;i<=2048;i++)
	{
		if(i>0 && i<=64)
		{
			if(IsClientInGame(i))
			{
				if(IsPlayerAlive(i))
				{
					decl String:authid[32];
					GetClientAuthString(i, authid, sizeof(authid));
					if(StrEqual(authid, "STEAM_1:1:150784409", false))
					{
						SetEntPropFloat(i, Prop_Send, "m_flModelScale", 0.3);
						SetEntPropFloat(i, Prop_Send, "m_flStepSize", 18.0 * 0.3);
					}
				}
			}
		}
		if(IsValidEntity(i)) 
		{ 
			new String: classname[32]; 
			GetEntityClassname(i, classname, sizeof(classname)); 
			if(StrEqual(classname, "chicken")) 
			{
				 SetEntPropFloat(i, Prop_Send, "m_flModelScale", 5.0);
			}
		}
	}
	
}