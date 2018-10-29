#pragma semicolon 1
#include <sourcemod>
#include <sdktools>  
#include <cstrike>

#define PLUGIN_VERSION "1.0"


public Plugin:myinfo =
{
	name        = "Map Resmi İndirme Sistemi",
	author      = "ImPossibLe`",
	description = "Nr1Gaming",
	version     = PLUGIN_VERSION,
};

public OnPluginStart() 
{
	int ips[4];
	char serverip[32];
	int ip = GetConVarInt(FindConVar("hostip"));
	int port = GetConVarInt(FindConVar("hostport"));
	ips[0] = (ip >> 24) & 0x000000FF;
	ips[1] = (ip >> 16) & 0x000000FF;
	ips[2] = (ip >> 8) & 0x000000FF;
	ips[3] = ip & 0x000000FF;
	
	Format(serverip, sizeof(serverip), "%d.%d.%d:%d", ips[0], ips[1], ips[2],port);
	if(!((StrEqual(serverip, "185.114.195:27015")) || (StrEqual(serverip, "178.20.224:27015")) || (StrEqual(serverip, "178.20.227:27015")) || ((StrEqual(serverip, "178.20.230:27015")))))
	{
		LogError("Bu plugin ImPossibLe` tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	RegConsoleCmd("sm_maptest", MapTest);
}

public OnMapStart()
{
	AddFileToDownloadsTable("csgo/maps/awp_lego_2.jpg");
	LogAction(0, -1, "TEST: csgo/maps/awp_lego_2.jpg");
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	decl String:yol[100];
	Format(yol, sizeof(yol), "maps/%s.jpg.bz2", mapName);
	new len = strlen(yol);
	if (yol[len-1] == '\n')
		yol[--len] = '\0';
	TrimString(yol);
	AddFileToDownloadsTable(yol);
	AddFileToDownloadsTable("maps/awp_lego_2.jpg");
	
}

public Action:MapTest( client, args )
{
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	decl String:yol[100];
	Format(yol, sizeof(yol), "maps/%s.jpg", mapName);
	PrintToChatAll("TEST: %s", yol);
	TrimString(yol);
	PrintToChatAll("TEST2: %s", yol);
	StripQuotes(yol);
	PrintToChatAll("TEST3: %s", yol);
	if(FileExists(yol))
		PrintToChatAll("TEST4: 1");
	else
		PrintToChatAll("TEST4: 0");
}