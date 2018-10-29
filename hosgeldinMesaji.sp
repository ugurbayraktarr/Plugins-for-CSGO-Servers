#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Hoşgeldiniz Mesajı",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

new Handle:g_Hosgeldin_Mesaji1 = INVALID_HANDLE;
new Handle:g_Hosgeldin_Mesaji2 = INVALID_HANDLE;

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
	
	AutoExecConfig(true, "hosgeldin_mesajlari");
	
	g_Hosgeldin_Mesaji1	=	CreateConVar("drk_hosgeldin_mesajlari1", "<font color='#FF0000'>Sunucumuza Hosgeldiniz.</font>", "Hoşgeldin mesajı (Önce Gelen)");
	g_Hosgeldin_Mesaji2	=	CreateConVar("drk_hosgeldin_mesajlari2", "<font color='#00FF00'>iyi oyunlar dileriz.</font>", "Hoşgeldin mesajı (Sonra Gelen)");
}


public OnClientPutInServer(client)
{
	CreateTimer(10.0, LoadStuff1, client);
	CreateTimer(12.5, LoadStuff2, client);
}

public Action LoadStuff1(Handle timer, int client)
{
	if(IsClientInGame(client))
	{
		new String:sMesaj1[256];
		GetConVarString(g_Hosgeldin_Mesaji1, sMesaj1, sizeof(sMesaj1));
		PrintCenterText(client, "%s", sMesaj1);
	}
	else
	{
		CreateTimer(10.0, LoadStuff1, client);
		CreateTimer(12.5, LoadStuff2, client);
	}
}

public Action LoadStuff2(Handle timer, int client)
{
	if(IsClientInGame(client))
	{
		new String:sMesaj2[256];
		GetConVarString(g_Hosgeldin_Mesaji2, sMesaj2, sizeof(sMesaj2));
		PrintCenterText(client, "%s", sMesaj2);
	}
}