#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.0"


public Plugin:myinfo =
{
	name        = "Takım Skor",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

public OnPluginStart() 
{
	RegAdminCmd("sm_tskor", test, ADMFLAG_GENERIC);
	RegAdminCmd("sm_ctskor", test2, ADMFLAG_GENERIC);
}
public Action:test(client, args)
{
	decl String:sKomut[32];
	GetCmdArg(1, sKomut, sizeof(sKomut));
	if(args == 1)
	{
		new skor = StringToInt(sKomut);
		CS_SetTeamScore(2, skor);
	}
	return Plugin_Continue;
}
public Action:test2(client, args)
{
	decl String:sKomut[32];
	GetCmdArg(1, sKomut, sizeof(sKomut));
	if(args == 1)
	{
		new skor = StringToInt(sKomut);
		CS_SetTeamScore(3, skor);
	}
	return Plugin_Continue;
}