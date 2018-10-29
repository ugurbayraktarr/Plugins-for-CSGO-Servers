#include <sourcemod>
#include <colors>
#include <cstrike>
#include <sdktools>

#pragma semicolon 1

new Handle:g_cVar_OluMesaj = INVALID_HANDLE;

public Plugin:myinfo = 
{
	name = "Ölülere Mesaj Gösterme Sistemi",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "1.0"
}

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
	
	AutoExecConfig(true, "olulere_mesaj");
	
	
	g_cVar_OluMesaj			=	CreateConVar("drk_olulere_mesaj", "", "Olulere gondermek istediginiz mesaji giriniz");
	
	CreateTimer(10.0, IzleyenKaldir);
	CreateTimer(0.5, SurekliTimer, _, TIMER_REPEAT);
}

public OnMapStart()
{
	CreateTimer(10.0, IzleyenKaldir);
}

public Action:IzleyenKaldir(Handle:timer)
{
	ServerCommand("sm plugins unload izleyenSayisi_nofl");
	ServerCommand("sm plugins unload izleyenSayisi");
}

public Action:SurekliTimer(Handle timer)
{
	new String:sMesaj[512];
	GetConVarString(g_cVar_OluMesaj, sMesaj, sizeof(sMesaj));
	for(new i=1; i<=MaxClients; i++)
	{
		if(IsClientConnected(i))
		{
			if(IsClientInGame(i))
			{
				if(!IsPlayerAlive(i))
				{
					PrintHintText(i, "%s", sMesaj);
				}
			}
		}
	}
}