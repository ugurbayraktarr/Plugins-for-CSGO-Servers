#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

public Plugin:myinfo =
{
	name        = "Afk Oyunculara Slay Atma Sistemi",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

new iSonHareket[MAXPLAYERS+1];

public OnPluginStart() 
{
	RegAdminCmd("sm_afktest", AfkTest, ADMFLAG_GENERIC);
	HookEvent("round_start", Event_Round_Start);
}
public Action:AfkTest(client, args)
{	
	new i;
	for(i=1;i<=MaxClients; i++)
	{
		if(IsClientConnected(i) && IsClientInGame(i) && IsPlayerAlive(i))
		{
			PrintToChat(client, "%N'nin son hareketi: %d", i, iSonHareket[i]);
		}
	}
	return Plugin_Continue;
}

public Action:Event_Round_Start(Handle:event, const String:name[], bool:dontBroadcast) 
{
	new i, zaman = GetTime() + 15;
	for(i=1;i<=MaxClients;i++)
		iSonHareket[i] = zaman;
	CreateTimer(60.0, AfkKontrol);
}


public Action AfkKontrol(Handle timer)
{
	new i;
	for(i=1;i<=MaxClients; i++)
	{
		if(IsClientConnected(i) && IsClientInGame(i) && IsPlayerAlive(i))
		{
			if(iSonHareket[i] + 35 < GetTime())
			{
				ForcePlayerSuicide(i);
				PrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x10%N \x04AFK olduğu için öldürüldü!", i);
			}
		}
	}
}

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)
{
	if((buttons & IN_FORWARD) || (buttons & IN_JUMP) || (buttons & IN_MOVELEFT) || (buttons & IN_BACK) || (buttons & IN_MOVERIGHT) || (buttons & IN_DUCK) || (buttons & IN_SPEED) || (buttons & IN_USE) || (buttons & IN_ATTACK) || (buttons & IN_ATTACK2))
	{
		if(GetTime() > iSonHareket[client])
			iSonHareket[client] = GetTime() + 1;
	}
}

