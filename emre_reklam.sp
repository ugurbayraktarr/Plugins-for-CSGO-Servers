#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Reklam",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

public OnPluginStart() 
{
	RegConsoleCmd("sm_ip", IpGoster);	
	RegConsoleCmd("sm_ts", TsGoster);	
	RegConsoleCmd("sm_ts3", TsGoster);	
}

public Action:IpGoster(client, args)
{
	PrintToChatAll(" \x02IP Adresimiz: \x04csgo.noflplay.com");
}

public Action:TsGoster(client, args)
{
	PrintToChatAll(" \x02TS3 Adresimiz: \x04ts3.noflplay.com");
}