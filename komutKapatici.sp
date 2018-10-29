#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

public Plugin:myinfo =
{
	name        = "El başı yanlış komut kapatıcı",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

new Handle:g_PluginTagi = INVALID_HANDLE;

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
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");

	HookEvent("round_start", RoundStarted);
}

public Action:RoundStarted(Handle: event , const String: name[] , bool: dontBroadcast)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	new Handle:g_hCvarFF = INVALID_HANDLE;
	g_hCvarFF = FindConVar("mp_teammates_are_enemies");

	new Handle:g_hCvarInfAmmo = INVALID_HANDLE;
	g_hCvarInfAmmo = FindConVar("sv_infinite_ammo");
	
	new Handle:g_hCvarGravity = INVALID_HANDLE;
	g_hCvarGravity = FindConVar("sv_gravity");
	
	new iFF;
	new iInfAmmo;
	new iGravity;
	

	if (g_hCvarFF != INVALID_HANDLE)
	{
		iFF = GetConVarInt(g_hCvarFF);
	}  
	
	if (g_hCvarInfAmmo != INVALID_HANDLE)
	{
		iInfAmmo = GetConVarInt(g_hCvarInfAmmo);
	}
	
	if (g_hCvarGravity != INVALID_HANDLE)
	{
		iGravity = GetConVarInt(g_hCvarGravity);
	}
	
	if(iFF || iInfAmmo || (iGravity != 800))
	{
		PrintToChatAll(" \x02[%s] \x06Bir Önceki elden açık kalan kodlar kapatılmıştır..", sPluginTagi);
		if(iFF)
			ServerCommand("mp_teammates_are_enemies 0");
		if(iInfAmmo)
			ServerCommand("sv_infinite_ammo 0");
		if(iGravity != 800)
			ServerCommand("sv_gravity 800");
	}
}