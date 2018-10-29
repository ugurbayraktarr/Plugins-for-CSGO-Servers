#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.3"

public Plugin:myinfo =
{
	name        = "Saldırı Koruması",
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
	
	CreateTimer(5.0, Sifirla, _, TIMER_REPEAT);
	AddCommandListener(Commands_CommandListener);
}

static int sayac;
bool mesajYazildi = false;

public Action Sifirla(Handle timer)
{
	sayac = 0;
	mesajYazildi = false;
}

public Action:Commands_CommandListener(client, const String:command[], argc)
{
	if(StrEqual(command, "status", false))
	{
		sayac++;
		if(sayac > 5)
		{
			if(!mesajYazildi)
				MesajYaz();
			return Plugin_Stop;
		}
	}
	if(StrEqual(command, "ping", false))
	{
		sayac++;
		if(sayac > 5)
		{
			if(!mesajYazildi)
				MesajYaz();
			return Plugin_Stop;
		}
	}
	return Plugin_Continue;
}

void MesajYaz()
{
	for(new i=1; i<MaxClients; i++)
	{
		if(IsClientConnected(i))
		{
			if(IsClientInGame(i))
			{
				PrintToConsole(i, "[DrK # GaminG] Birkaç saniye sonra tekrar deneyin.");
				PrintToConsole(i, "[DrK # GaminG] Birkaç saniye sonra tekrar deneyin.");
				PrintToConsole(i, "[DrK # GaminG] Birkaç saniye sonra tekrar deneyin.");
				PrintToConsole(i, "[DrK # GaminG] Birkaç saniye sonra tekrar deneyin.");
				PrintToConsole(i, "[DrK # GaminG] Birkaç saniye sonra tekrar deneyin.");
				mesajYazildi = true;
			}
		}
	}
	PrintToChatAll(" \x02[DrK # GaminG] \x04Bir saldırı denemesi başarıyla engellendi.");
}