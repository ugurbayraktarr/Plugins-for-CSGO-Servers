#pragma semicolon 1
#include <sourcemod>
#include <sdktools>

public Plugin:myinfo =
{
	name        = "Zaman testi",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};
public OnPluginStart() 
{
	RegConsoleCmd( "sm_zamantest", Test);
}


public Action:Test( client, args )
{
	
	PrintToChat(client, "%d", (GetTime() + 10800) % 86400);
	return Plugin_Handled;
}