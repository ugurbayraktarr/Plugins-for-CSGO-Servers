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

new Handle:g_PluginTagi = INVALID_HANDLE;

new iSonHareket[MAXPLAYERS+1];

public OnPluginStart() 
{
	//RegAdminCmd("sm_afktest", AfkTest, ADMFLAG_GENERIC);
	HookEvent("round_start", Event_Round_Start);
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
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
	new i, zaman = GetTime() + 10;
	for(i=1;i<=MaxClients;i++)
		iSonHareket[i] = zaman;
	CreateTimer(30.0, AfkKontrol);
}


public Action AfkKontrol(Handle timer)
{
	new i;
	for(i=1;i<=MaxClients; i++)
	{
		if(IsClientConnected(i) && IsClientInGame(i) && IsPlayerAlive(i))
		{
			if(iSonHareket[i] + 20 <= GetTime())
			{
				new String:sPluginTagi[64];
				GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
				
				ForcePlayerSuicide(i);
				PrintToChatAll(" \x02[%s] \x10%N \x04AFK olduğu için öldürüldü!", sPluginTagi, i);
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

