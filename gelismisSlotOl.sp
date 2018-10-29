#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <smlib>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Slot Ol",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

new String:adminlikDosyasi[PLATFORM_MAX_PATH];
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
	
	RegConsoleCmd("sm_slotol", SlotOl);	
}

public Action:SlotOl(client, args)
{
	new String:authid[32];
	new String:line[256];
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	GetClientAuthString(client, authid, sizeof(authid));
	
	BuildPath(Path_SM,adminlikDosyasi,sizeof(adminlikDosyasi),"configs/admins_simple.ini");
	if(FileExists(adminlikDosyasi))
	{
		new Handle:adminDosyaHandle = OpenFile(adminlikDosyasi, "r");
		new i = 0;
		while (ReadFileLine(adminDosyaHandle, line, sizeof(line)))
		{
			TrimString(line);
			i++;
			
			if (StrContains(line, authid) != -1)
			{
				PrintToChat(client, " \x02[%s] \x06Şuan bir yetkiniz olduğu için \x0E!slotol \x06komutunu kullanamazsınız.", sPluginTagi);
				if (IsEndOfFile(adminDosyaHandle))
				{
					CloseHandle(adminDosyaHandle);
					break;
				}
				return Plugin_Handled;
			}
		}
		CloseHandle(adminDosyaHandle);
	}
	
	new Handle:SlotYazHandle = OpenFile(adminlikDosyasi, "a+");
	new String:slotYazLine[256];
	Format(slotYazLine, sizeof(slotYazLine), "\"%s\" \"1:a\" // %N", authid, client);
	WriteFileLine(SlotYazHandle, slotYazLine);
	PrintToChat(client, " \x02-------------------------------");
	PrintToChat(client, " \x02[%s] \x04İşlem başarılı!", sPluginTagi);
	PrintToChat(client, " \x02\x10Slot yetkiniz verildi!", sPluginTagi);
	PrintToChat(client, " \x02-------------------------------");
	ServerCommand("sm_reloadadmins");
	ServerCommand("sm_reloadcc");
	CloseHandle(SlotYazHandle);
	return Plugin_Continue;
}