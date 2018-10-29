#pragma semicolon 1
#include <sourcemod>
#include <cstrike>
#include <sdktools>

public Plugin:myinfo =
{
	name        = "Kendini Öldürme",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

new Handle:g_PluginTagi = INVALID_HANDLE;

public OnPluginStart()
{
	RegConsoleCmd("sm_kill", Kill);
	RegConsoleCmd("sm_k", Kill);
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
}

public Action Kill(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
    if (IsClientInGame(client) && IsPlayerAlive(client)) 
	{
		ForcePlayerSuicide(client);
		PrintToChatAll(" \x02[%s] \x10%N \x07adlı oyuncu intihar etti.", sPluginTagi, client);
	}
}