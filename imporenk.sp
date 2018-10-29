#pragma semicolon 1
#include <sourcemod>

public Plugin:myinfo =
{
	name        = "ImPossibLe abimizin rengi",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

public OnPluginStart() 
{
	CreateTimer(0.25, SurekliTimer, _, TIMER_REPEAT);
}

public Action SurekliTimer(Handle timer)
{
	new i;
	for(i=1;i<=MaxClients;i++)
	{
		decl String:authid[32];
		GetClientAuthString(i, authid, sizeof(authid));
		if(StrEqual(authid, "STEAM_1:1:104585403", false)) // UÐUR ÖZEL GLOBAL
		{
			if(!IsClientConnected(i)) continue;
			if(!IsClientInGame(i)) continue;
			if(GetClientTeam(i) <= 1) continue;
			if(IsPlayerAlive(i))
			{
				new r,g,b;
				r = GetRandomInt(0, 255);
				g = GetRandomInt(0, 255);
				b = GetRandomInt(0, 255);
				SetEntityRenderColor(i, r, g, b, 255);
			}
		}
	}
}