#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.0"
new Handle:g_cVar_TS3IP = INVALID_HANDLE;
new Handle:g_cVar_ReklamSuresi = INVALID_HANDLE;
bool mesajYazildi;


public Plugin:myinfo =
{
	name        = "Server Ve TS3 IP Reklamı",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

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
	
	AutoExecConfig(true, "server_ve_ts_reklami");
	g_cVar_TS3IP				=	CreateConVar("drk_reklam_ts3ip", "", "TS3 IP Adresinizi drk_reklam_ts3ip değerine giriniz.");
	g_cVar_ReklamSuresi	=	CreateConVar("drk_reklam_bekleme", "30", "Reklamlar arasındaki bekleme süresi");
	RegConsoleCmd("sm_ts", IpReklam);
	RegConsoleCmd("sm_ts3", IpReklam);
	RegConsoleCmd("sm_ip", IpReklam);
	
	CreateTimer(15.0, sifirla, _,TIMER_REPEAT);
	CreateTimer(8.0, TimerAyarla);
}

public Action:TimerAyarla(Handle:timer)
{
	CreateTimer(GetConVarFloat(g_cVar_ReklamSuresi), reklam, _,TIMER_REPEAT);
}

public Action:sifirla(Handle:timer)
{
	mesajYazildi = false;
}

public Action:IpReklam( client, args )
{
	int ips[4];
	new String:serverip[32];
	int ip = GetConVarInt(FindConVar("hostip"));
	ips[0] = (ip >> 24) & 0x000000FF;
	ips[1] = (ip >> 16) & 0x000000FF;
	ips[2] = (ip >> 8) & 0x000000FF;
	ips[3] = ip & 0x000000FF;
	
	Format(serverip, sizeof(serverip), "%d.%d.%d.%d", ips[0], ips[1], ips[2], ips[3]);
	
	PrintToChat(client, " \x02IP Adresimiz: \x04%s", serverip);
	
	new String:ts3ip[256];
	GetConVarString(g_cVar_TS3IP, ts3ip, sizeof(ts3ip));
	if(!StrEqual(ts3ip, "", false))
		PrintToChat(client, " \x06TS3 Adresimiz: \x0C%s", ts3ip);
		
	return Plugin_Continue;
}

public Action:reklam(Handle:timer)
{
	if(!mesajYazildi)
	{
		mesajYazildi = true;
		int ips[4];
		new String:serverip[32];
		int ip = GetConVarInt(FindConVar("hostip"));
		ips[0] = (ip >> 24) & 0x000000FF;
		ips[1] = (ip >> 16) & 0x000000FF;
		ips[2] = (ip >> 8) & 0x000000FF;
		ips[3] = ip & 0x000000FF;
		
		Format(serverip, sizeof(serverip), "%d.%d.%d.%d", ips[0], ips[1], ips[2], ips[3]);
		
		PrintToChatAll(" \x02IP Adresimiz: \x04%s", serverip);
		
		new String:ts3ip[256];
		GetConVarString(g_cVar_TS3IP, ts3ip, sizeof(ts3ip));
		if(!StrEqual(ts3ip, "", false))
			PrintToChatAll(" \x06TS3 Adresimiz: \x0C%s", ts3ip);
	}
	
	return Plugin_Continue;
}