#include <sourcemod>
#include <sdktools_functions>
#include <colors>
#pragma semicolon 1

public Plugin:myinfo = 
{
	name = "DrK # TESTTT",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "1.0"
}

Handle:mp_forcecamera;

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
	
	Format(serverip, sizeof(serverip), "%d.%d.%d.%d:%d", ips[0], ips[1], ips[2], ips[3],port);
	if(StrEqual(serverip, "95.173.166.51:27015") == false)
	{
		LogError("Bu plugin ImPossibLe` tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	
	mp_forcecamera = FindConVar("mp_forcecamera");
	RegAdminCmd("sm_testtt", TESTTT, ADMFLAG_KICK, "Oyuncunun takimini degistirir");
	
}

public Action:TESTTT(client, args)
{
	SendConVarValue(client, mp_forcecamera, "0");
	return Plugin_Handled;
}