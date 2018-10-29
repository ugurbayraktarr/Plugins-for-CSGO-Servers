#include <sourcemod>
//#include <colors>
#include <cstrike>
#include <sdktools>
#pragma semicolon 1
#define SARKISAYISI 7

public Plugin:myinfo = 
{
	name = "20 Kişinin altında Dust2",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "4.0"
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
	
	HookEvent("round_end", Event_RoundEnd);
}

public Action Event_RoundEnd(Handle event, char[] name, bool dontBroadcast)
{
	new kisiSay = 0;
	for(new i = 1; i<=MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			if(IsClientConnected(i) && GetClientTeam(i) > 1)
			{
				kisiSay++;
			}
		}
	}
	
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	if(!StrEqual(mapName, "de_dust2", false))
	{
		if(kisiSay < 20)
		{
			PrintToChatAll(" \x02[NoFL Pro Public] \x10Yeterli sayıda oyuncu olmadığı için\x04 Dust2 \x10açılıyor.");
			ServerCommand("sm_map de_dust2");
		}
	}
		
	if(GetTeamScore(2) == 16 || GetTeamScore(3) == 16)
	{
		if((((GetTime() + 10800) % 86400) >= 5400) && ((GetTime() + 10800) % 86400) <= 43200)
		{
			PrintToChatAll(" \x02[NoFL Pro Public] \x10Şuan saat 1:30-12:00 arasında olduğundan \x04 Dust2 \x10açılıyor.");
			ServerCommand("sm_map de_dust2");
		}
	}
	return Plugin_Continue;
}