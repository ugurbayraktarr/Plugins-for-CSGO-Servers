#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Ts Reklam",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

public OnPluginStart() 
{
	HookEvent("round_start", Event_RoundStart);
}

public Action Event_RoundStart(Handle event, char[] name, bool dontBroadcast)
{
	CreateTimer(20.0, TSReklam);
	CreateTimer(70.0, TSReklam);
}

public Action TSReklam(Handle timer)
{
	PrintToChatAll(" ");
	PrintToChatAll(" \x04TS3 adresimiz, \x02ts.drk-gaming.net");
	PrintToChatAll(" ");
}