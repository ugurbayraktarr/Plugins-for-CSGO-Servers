#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <colors>

public Plugin:myinfo =
{
	name        = "Yeni IP",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

public OnPluginStart() 
{
	HookEvent("player_spawn", OnPlayerSpawn);
	CreateTimer(5.0, Timer, _, TIMER_REPEAT);
}

public Action:OnPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new userid = GetEventInt(event, "userid");
	ServerCommand("sm_freeze #%d -1", userid);
}

public Action Timer(Handle timer)
{
	PrintToChatAll(" ");
	PrintToChatAll(" \x02 Lütfen Alttaki IP Adresimize gelir misiniz?");
	PrintToChatAll(" \x04 185.122.202.36");
	PrintToChatAll(" ");
}