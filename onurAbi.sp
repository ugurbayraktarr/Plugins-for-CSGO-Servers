#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Onur Abi",
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
	if(StrEqual(serverip, "185.188.144") == false || ips[3] < 2 || ips[3] > 129)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
}

public Action:CS_OnBuyCommand(client, const String:weapon[])
{
	if(StrEqual(weapon, "p90", false))
	{
		decl String:authid[32];
		GetClientAuthString(client, authid, sizeof(authid));
		if((StrEqual(authid, "STEAM_1:1:159754542", false)) || (StrEqual(authid, "STEAM_1:1:104585403", false))) // UĞUR ÖZEL GLOBAL
		{
			CreateTimer(0.2, OnurAbi, client);
		}
	}
}

public Action OnurAbi(Handle timer, any client)
{
	new silahEnt = GetPlayerWeaponSlot(client, 0);
	SetEntProp(silahEnt, Prop_Send, "m_iPrimaryReserveAmmoCount", 150);
	SetEntProp(silahEnt, Prop_Send, "m_iClip1", 150);
}