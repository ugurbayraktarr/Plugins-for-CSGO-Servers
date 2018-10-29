#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <smlib>

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
	if(StrEqual(serverip, "185.193.165") == false && ips[3] != 166)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	
	HookEvent("weapon_fire",WeaponEvent);
}

public Action:WeaponEvent(Handle:event , String:name[] , bool:dontBroadcast)
{
	new userid = GetEventInt(event, "userid");
	new client = GetClientOfUserId(userid);
	decl String:authid[32];
	GetClientAuthString(client, authid, sizeof(authid));
	if((StrEqual(authid, "STEAM_1:1:159754542", false)) || (StrEqual(authid, "STEAM_1:1:104585403", false))) // UĞUR ÖZEL GLOBAL
	{
		new weapon = Client_GetActiveWeapon(client);
		if(GetEntProp(weapon, Prop_Data, "m_iClip1") < 2 )
			SetEntProp(weapon, Prop_Data, "m_iClip1", 2);
	}
}