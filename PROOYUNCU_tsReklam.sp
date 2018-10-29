#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "PROOYUNCU ~ Ts Reklam",
	author      = "ImPossibLe`",
	description = "PROOYUNCU",
	version     = PLUGIN_VERSION,
};

public OnPluginStart() 
{
	HookEvent("round_start", Event_RoundStart);
}

public Action Event_RoundStart(Handle event, char[] name, bool dontBroadcast)
{
	CreateTimer(10.0, TSReklam);
	CreateTimer(30.0, TSReklam);
	CreateTimer(60.0, TSReklam);
}

public Action TSReklam(Handle timer)
{
	PrintToChatAll(" ");
	PrintToChatAll(" \x0CTS3 adresimiz, \x04ts.prooyuncu.com");
	PrintToChatAll(" \x0CSteam grubumuza katılmayı unutmayın.");
	PrintToChatAll(" \x02!grup \x0Cyazarak steam grubumuza ulaşabilirsiniz.");
	PrintToChatAll(" ");
}