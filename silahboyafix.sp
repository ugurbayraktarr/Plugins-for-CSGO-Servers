#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.3"

public Plugin:myinfo =
{
	name        = "Silah Boyama Firewall Fix",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

public OnPluginStart() 
{
	CreateTimer(3.0, IslemYap, _, TIMER_REPEAT);
}

public Action:IslemYap(Handle:timer)
{
	ServerCommand("sm plugins load gelismis_silah_boyama");
	//ServerCommand("say TEST");
}