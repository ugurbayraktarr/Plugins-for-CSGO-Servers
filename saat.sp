#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Saat Gösterici",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

new Handle:g_PluginTagi = INVALID_HANDLE;

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
	if(StrEqual(serverip, "185.188.144") == false || ips[3] < 2 || ips[3] > 129)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");

	RegConsoleCmd("sm_saat", saat);	
}

public Action:saat(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	new String:buffer[64];
	FormatTime(buffer, sizeof(buffer), "\x04%H:%M:%S \x02, \x06%d.%m.%Y", GetTime()); 
	new String:gun[64];
	FormatTime(gun, sizeof(gun), "%A", GetTime());
	if(StrEqual(gun, "Monday", false))
		gun = "Pazartesi";
	else if(StrEqual(gun, "Tuesday", false))
		gun = "Salı";
	else if(StrEqual(gun, "Wednesday", false))
		gun = "Çarşamba";
	else if(StrEqual(gun, "Thursday", false))
		gun = "Perşembe";
	else if(StrEqual(gun, "Friday", false))
		gun = "Cuma";
	else if(StrEqual(gun, "Saturday", false))
		gun = "Cumartesi";
	else if(StrEqual(gun, "Sunday", false))
		gun = "Pazar";
	
	PrintToChat(client, " \x02[%s] %s \x02, \x10%s", sPluginTagi, buffer, gun);
}