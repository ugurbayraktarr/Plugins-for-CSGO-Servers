#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.1"

new Handle:g_PluginTagi = INVALID_HANDLE;

public Plugin:myinfo =
{
	name        = "Map değişme",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};


public OnPluginStart() 
{
	RegAdminCmd("sm_mapp", Command_DrkMap, ADMFLAG_GENERIC);
	RegAdminCmd("sm_drkmap", Command_DrkMap, ADMFLAG_GENERIC);
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
}

public Action:Command_DrkMap(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	decl String:mapismi[32];
	GetCmdArgString(mapismi, sizeof(mapismi));
	if(args != 1)
	{
		PrintToChat(client, " \x02[%s] \x04Hatalı giriş yaptınız. Kullanım: \x03!mapp mapismi", sPluginTagi);
	}
	else
	{
		if(IsMapValid(mapismi))
		{
			ServerCommand("sm_nextmap %s", mapismi);
			ServerCommand("mp_timelimit 0");
			ServerCommand("mp_maxrounds 0");
		}
		else
			PrintToChat(client, " \x02[%s] \x04Girmiş olduğunuz map bulunamadı: \x10%s", sPluginTagi, mapismi);
	}
}