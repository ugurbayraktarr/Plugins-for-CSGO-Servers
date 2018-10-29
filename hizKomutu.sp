#pragma semicolon 1
#include <sourcemod>
#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name = "Hız Komutu",
	author = "ImPossibLe`",
	description = "Hız Komutu",
	version = PLUGIN_VERSION,
};

new Handle:g_PluginTagi = INVALID_HANDLE;

#define MAX_NAME 96
#define MAX_ID 32


public OnPluginStart()
{
	int ips[4];
	char serverip[32];
	int ip = GetConVarInt(FindConVar("hostip"));
	ips[0] = (ip >> 24) & 0x000000FF;
	ips[1] = (ip >> 16) & 0x000000FF;
	ips[2] = (ip >> 8) & 0x000000FF;
	ips[3] = ip & 0x000000FF;
	
	Format(serverip, sizeof(serverip), "%d.%d.%d", ips[0], ips[1], ips[2]);
	if(StrEqual(serverip, "185.193.165") == false && ips[3] != 166)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");

	
	RegAdminCmd("sm_hiz",		Command_Speed,		ADMFLAG_GENERIC,		"Hız Ayarlama Komutu");
}

public Action:Command_Speed(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if (args < 2)
	{
		PrintToChat(client, " \x02[%s] \x04Kullanım: !hiz <hedef> <katlayici>", sPluginTagi);
		return Plugin_Handled;	
	}	
	decl String:pattern[MAX_NAME],String:buffer[MAX_NAME],String:mul[MAX_ID];
	GetCmdArg(1,pattern,sizeof(pattern));
	GetCmdArg(2,mul,sizeof(mul));
	new Float:mult = StringToFloat(mul);
	new targets[MAXPLAYERS+1],bool:ml = false;

	new count = ProcessTargetString(pattern,client,targets,sizeof(targets),COMMAND_FILTER_ALIVE,buffer,sizeof(buffer),ml);

	if (count <= 0) PrintToChat(client, "Hedef Bulunamadı.");
	else for (new i = 0; i < count; i++)
	{
		new t = targets[i];
		SetEntPropFloat(t, Prop_Data, "m_flLaggedMovementValue", mult);
		
		LogAction(client,t,"\"%L\" adlı oyuncu \"%L\" adlı oyuncuya %.1f kat hız verdi.",client,t,mult);
		PrintToChatAll(" \x02[%s] \x04%N \x10isimli admin \x04%N \x10adlı oyuncuya \x02%.1f kat \x10hız verdi.", sPluginTagi, client, t, mult);
	}
	return Plugin_Handled;
}