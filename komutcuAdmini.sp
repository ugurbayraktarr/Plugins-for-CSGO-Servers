#pragma semicolon 1

#include <sourcemod>
#include <cstrike>

public Plugin:myinfo = 
{
	name = "Komutçu Admini Sistemi",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "1.0"
}

static int iKomutcuAdmini = -1;
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
	
	RegAdminCmd("sm_ka", KomutcuAdmini, ADMFLAG_GENERIC, "Komutçu Admini");
	RegAdminCmd("sm_kk", KomutcuAdminiKaldir, ADMFLAG_GENERIC, "Komutçu Admini Kaldırma");
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");

	HookEvent("player_spawn", OnPlayerSpawn);
}

public OnMapStart()
{
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	
	if(!((StrContains(mapName, "jb_", false) != -1) || (StrContains(mapName, "jail_", false)!= -1)))
	{
		SetFailState("Bu plugin sadece jail maplarında çalışmaktadır.");
	}
	if(iKomutcuAdmini > 0)
		SetEntityRenderColor(iKomutcuAdmini, 255, 255, 255, 255);
	iKomutcuAdmini = -1;
}

public OnClientDisconnect(client)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	if(client == iKomutcuAdmini)
	{
		PrintToChatAll(" \x04[%s] \x02Komutçu admini oyundan çıktı!", sPluginTagi);
		SetEntityRenderColor(iKomutcuAdmini, 255, 255, 255, 255);
		iKomutcuAdmini = -1;
	}
}

public Action:OnPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(client == iKomutcuAdmini)
	{
		SetEntityRenderColor(iKomutcuAdmini, 0, 255, 255, 255);
	}
	
}

public Action:KomutcuAdmini(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(iKomutcuAdmini > 0)
	{
		PrintToChat(client, " \x04[%s] \x02Şuan bir komutçu admini var. \x10!kk \x02yazarak \x0C%N \x02kişisinden komutçu adminliğini kaldırabilirsiniz.", sPluginTagi, iKomutcuAdmini);
	}
	else
	{
		PrintToChatAll(" \x04[%s] \x10%N \x02 komutçu admini oldu!", sPluginTagi, client);
		iKomutcuAdmini = client;
		SetEntityRenderColor(iKomutcuAdmini, 0, 255, 255, 255);
	}
	
}

public Action:KomutcuAdminiKaldir(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(iKomutcuAdmini > 0)
	{
		if(client != iKomutcuAdmini)
			PrintToChatAll(" \x04[%s] \x10%N \x04, \x0C%N \x02kişisinden komutçu adminliğini kaldırdı.", sPluginTagi, client, iKomutcuAdmini);
		else
			PrintToChatAll(" \x04[%s] \x10%N \x04, \x0Ckendinden \x02 komutçu adminliğini kaldırdı.", sPluginTagi, client);
		SetEntityRenderColor(iKomutcuAdmini, 255, 255, 255, 255);
		iKomutcuAdmini = -1;
	}
	else
	{
		PrintToChat(client, " \x04[%s] \x02Şuan bir komutçu admini bulunmuyor.", sPluginTagi);
	}
}