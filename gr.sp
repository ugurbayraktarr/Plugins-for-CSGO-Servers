#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.0"


public Plugin:myinfo =
{
	name        = "Yazı",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

public OnPluginStart() 
{
	RegAdminCmd("sm_gr1", test1, ADMFLAG_GENERIC);
	RegAdminCmd("sm_gr2", test2, ADMFLAG_GENERIC);
}
public Action:test1(client, args)
{	
	decl String:text[192];
	GetCmdArgString(text, sizeof(text));
	
	FakeClientCommand(client, "%s", text);
	return Plugin_Continue;
}

public Action:test2(client, args)
{	
	decl String:text[192];
	GetCmdArgString(text, sizeof(text));
	
	FakeClientCommandEx(client, "%s", text);
	return Plugin_Continue;
}
