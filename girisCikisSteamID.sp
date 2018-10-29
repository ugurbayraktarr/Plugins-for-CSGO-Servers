#pragma semicolon 1
#include <sourcemod>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Giriş & Çıkış SteamID Gösterici",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
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
	if(StrEqual(serverip, "185.193.165") == false && ips[3] != 166)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	HookEvent("round_start", Event_RoundStart);
}

public void Event_RoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	new i;
	for(i=1; i<=MaxClients; i++)
	{
		if(!IsClientConnected(i)) continue;
		if(!IsClientInGame(i)) continue;
		if(IsClientInGame(i))
		{
			decl String:authid[32];
			GetClientAuthString(i, authid, sizeof(authid));
			GetClientAuthString(i, steamID[i], sizeof(steamID));
			GetClientName(i, nickler[i], sizeof(nickler));
		}
	}
}

public OnClientPutInServer(client)
{
	decl String:authid[32];
	GetClientAuthString(client, authid, sizeof(authid));

	PrintToChatAll(" \x10%N \x01[\x03%s\x01] \x06oyuna girdi.", client, authid);
	
	GetClientAuthString(client, steamID[client], sizeof(steamID));
	GetClientName(client, nickler[client], sizeof(nickler));
}

public OnClientDisconnect(client)
{
	decl String:gName[MAX_NAME_LENGTH+1];
	decl String:gAuth[21];
	
	GetClientName( client, gName, MAX_NAME_LENGTH );
	GetClientAuthString( client, gAuth, sizeof( gAuth ) );
	
	if(StrContains(gAuth, "STEAM_", false) != -1)
	{
		PrintToChatAll(" \x10%s \x01[\x03%s\x01] \x0Foyundan çıktı.\x01", gName, gAuth);
	}
	else
	{
		if(client > 0 && client < MaxClients)
		{
			PrintToChatAll(" \x10%s \x01[\x03%s\x01] \x0Foyundan çıktı.", nickler[client], steamID[client]);
		}
	}
	

}