#include <sourcemod>
#include <sdktools>

#pragma semicolon 1

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name = "Godmode",
	author = "ImPossibLe`",
	description = "Godmode",
	version = PLUGIN_VERSION
}

new Handle:g_PluginTagi = INVALID_HANDLE;

public OnPluginStart()
{
	
	RegAdminCmd("sm_god", Command_God, ADMFLAG_GENERIC, "Kullanım: sm_god [hedef] <0/1>");
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");

}

public Action:Command_God(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if (args < 2)
	{
		ReplyToCommand(client, "Kullanım: sm_god [hedef] <0/1>");
		return Plugin_Handled;	
	}	
	decl String:pattern[96],String:buffer[96],String:god[32];
	GetCmdArg(1,pattern,sizeof(pattern));
	GetCmdArg(2,god,sizeof(god));
	new gd = StringToInt(god);
	if(gd < 0 || gd > 1)
	{
		PrintToChat(client, " \x07Geçersiz değer girdiniz \x06(%d)", gd);
		return Plugin_Handled;
	}
	new targets[64],bool:ml = false;

	new count = ProcessTargetString(pattern,client,targets,sizeof(targets),COMMAND_FILTER_ALIVE,buffer,sizeof(buffer),ml);

	if (count <= 0) PrintToChat(client, " \x07Hedef Bulunamadı.");
	else for (new i = 0; i < count; i++)
	{
		SetEntProp(targets[i], Prop_Data, "m_takedamage", gd?0:2, 1);
		if(count == 1)
		{
			if(gd)
			{
				PrintToChatAll(" \x02[%s] \x10%N \x01adlı oyuncuya \x10%N \x01tarafından \x06Godmode verildi.", sPluginTagi, targets[i], client);
			}
			if(!gd)
			{
				PrintToChatAll(" \x02[%s] \x10%N \x01adlı oyuncudan \x10%N \x01tarafından \x07Godmode alındı.", sPluginTagi, targets[i], client);
			}
		}
	}
	if(gd)
	{
		if(StrEqual(pattern, "@all", false))
		{
			PrintToChatAll(" \x02[%s] \x01Tüm Oyunculara \x10%N \x01tarafından \x06Godmode verildi.", sPluginTagi, client);
		}
		else if(StrEqual(pattern, "@ct", false))
		{
			PrintToChatAll(" \x02[%s] \x01CT'lere \x10%N \x01tarafından \x06Godmode verildi.", sPluginTagi, client);
		}
		if(StrEqual(pattern, "@t", false))
		{
			PrintToChatAll(" \x02[%s] \x01T'lere \x10%N \x01tarafından \x06Godmode verildi.", sPluginTagi, client);
		}
		if(StrEqual(pattern, "@alive", false))
		{
			PrintToChatAll(" \x02[%s] \x01Tüm yaşayan oyunculara \x10%N \x01tarafından \x06Godmode verildi.", sPluginTagi, client);
		}
	}
	else
	{
		if(StrEqual(pattern, "@all", false))
		{
			PrintToChatAll(" \x02[%s] \x01Tüm Oyunculardan \x10%N \x01tarafından \x07Godmode alındı.", sPluginTagi, client);
		}
		else if(StrEqual(pattern, "@ct", false))
		{
			PrintToChatAll(" \x02[%s] \x01CT'lerden \x10%N \x01tarafından \x07Godmode alındı.", sPluginTagi, client);
		}
		if(StrEqual(pattern, "@t", false))
		{
			PrintToChatAll(" \x02[%s] \x01T'lerden \x10%N \x01tarafından \x07Godmode alındı.", sPluginTagi, client);
		}
		if(StrEqual(pattern, "@alive", false))
		{
			PrintToChatAll(" \x02[%s] \x01Tüm yaşayan oyunculardan \x10%N \x01tarafından \x07Godmode alındı.", sPluginTagi, client);
		}
	}
	return Plugin_Handled;
}