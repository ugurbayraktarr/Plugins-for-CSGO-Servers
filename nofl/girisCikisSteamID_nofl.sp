#pragma semicolon 1
#include <sourcemod>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Giriş & Çıkış SteamID Gösterici",
	author      = "ImPossibLe`",
	description = "NoFL",
	version     = PLUGIN_VERSION,
};

char steamID[MAXPLAYERS+1][24];
char nickler[MAXPLAYERS+1][100];

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
	if(StrEqual(serverip, "185.122.202") == false || ips[3] < 2 || ips[3] > 101)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
}

public OnClientPutInServer(client)
{
	decl String:authid[32];
	GetClientAuthString(client, authid, sizeof(authid));

	PrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x0C%N \x01oyuna girdi.", client);
	
	GetClientAuthString(client, steamID[client], sizeof(steamID));
	GetClientName(client, nickler[client], sizeof(nickler));
}

public OnClientDisconnect(client)
{	
	if(client > 0 && client < MaxClients)
	{
		PrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x0C%s \x01oyundan ayrıldı.", nickler[client]);
	}
}