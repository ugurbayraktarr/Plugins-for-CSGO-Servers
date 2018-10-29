#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.0"


public Plugin:myinfo =
{
	name        = "TEST",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

public OnPluginStart() 
{
	RegAdminCmd("sm_testtest", test, ADMFLAG_GENERIC);
	RegAdminCmd("sm_testtest2", test2, ADMFLAG_GENERIC);
}
public Action:test(client, args)
{
	GivePlayerItem(client, "weapon_healthshot");
	PrintToChat(client, "TEST");
	GivePlayerItem(client, "weapon_tagrenade");
	PrintToChat(client, "TEST2");
	
	return Plugin_Handled;
}

public Action:test2(client, args)
{
	new i;
	for(i=1;i<=MaxClients;i++)
	{
		if(!IsClientInGame(i)) continue;
		if(!IsPlayerAlive(i)) continue;
		GivePlayerItem(i, "weapon_healthshot");
		GivePlayerItem(i, "weapon_tagrenade");
	}
	
	return Plugin_Handled;
}