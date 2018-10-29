#pragma semicolon 1
#include <sourcemod>

public Plugin:myinfo =
{
	name        = "Mesut abimizin rengi",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

public OnPluginStart() 
{
	CreateTimer(0.33, SurekliTimer, _, TIMER_REPEAT);
}

public Action SurekliTimer(Handle timer)
{
	new i;
	for(i=1;i<=MaxClients;i++)
	{
		if(!IsClientConnected(i)) continue;
		if(!IsClientInGame(i)) continue;
		if(GetClientTeam(i) <= 1) continue;
		if(IsPlayerAlive(i))
		{
			decl String:authid[32];
			GetClientAuthString(i, authid, sizeof(authid));
			if(StrEqual(authid, "STEAM_1:1:150784409", false)) // UÐUR ÖZEL GLOBAL
			{
				if(IsPlayerAlive(i))
				{
					//if(GetRandomInt(0,1))
					{
						new r,g,b;
						r = GetRandomInt(0, 255);
						g = GetRandomInt(0, 255);
						b = GetRandomInt(0, 255);
						//new r = 0,g = 50,b = 180;
						
						SetEntityRenderColor(i, r, g, b, 255);
					}
					/*else
					{
						new r = 0,g = 30,b = 70;
						
						SetEntityRenderColor(i, r, g, b, 255);
					}*/
				}
			 }
		}
	}
}