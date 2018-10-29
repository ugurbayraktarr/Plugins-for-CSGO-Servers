#pragma semicolon 1
#include <sourcemod>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Yönetici Giriş Mesajları",
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

public OnClientPutInServer(client)
{
	new userid = GetClientUserId(client);
	CreateTimer(3.0, Kontrol, userid);
}

public Action Kontrol(Handle timer, int userid)
{
	new client = GetClientOfUserId(userid);
	decl String:authid[32];
	GetClientAuthString(client, authid, sizeof(authid));
	
	if(GetUserFlagBits(client) & ADMFLAG_ROOT)
	{
		if(StrEqual(authid, "STEAM_1:1:104585403", false)) // UĞUR ÖZEL GLOBAL
			return Plugin_Handled;
		PrintCenterTextAll("<font color='#FF0000'>Sunucu Sahibi</font> <font color='#00FFFF'>%N</font>\n<font color='#00FF00'>Şu anda oyunda.</font>", client);
	}
	else if(GetUserFlagBits(client) & ADMFLAG_GENERIC)
	{
		PrintCenterTextAll("<font color='#FF00FF'>Admin</font> <font color='#00FFFF'>%N</font>\n<font color='#00FF00'>Şu anda oyunda.</font>", client);
		return Plugin_Handled;
	}
	return Plugin_Handled;
}
