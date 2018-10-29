#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Selam Cevaplama",
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
	
	Format(serverip, sizeof(serverip), "%d.%d.%d", ips[0], ips[1], ips[2], ips[3]);
	if(StrEqual(serverip, "185.193.165") == false && ips[3] != 166)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	
	//AddCommandListener(Command_Say, "say");
	//AddCommandListener(Command_Say, "say_team");
	
	RegConsoleCmd( "say", OnSay );
	RegConsoleCmd( "say_team", OnSay );
}

public Action:OnSay( client, args )
{
	if(!client) return Plugin_Continue;	
	
	new String:text[512];
	GetCmdArgString( text, sizeof(text) );
	
	StripQuotes(text);
	TrimString(text);

	if(StrEqual(text, "s.a", false) || StrEqual(text, "sa", false) || StrEqual(text, "s/a", false) || StrEqual(text, "selam", false) || StrEqual(text, "selamlar", false) || StrEqual(text, "slm", false) || StrEqual(text, "selamın aleyküm", false) || StrEqual(text, "selamun aleyküm", false)|| StrEqual(text, "s.a.", false) || StrEqual(text, "selamin aleykum", false) || StrEqual(text, "selamun aleykum", false))
	{
		CreateTimer(1.0, CevapYaz, client);
	}
	return Plugin_Continue;
}

public Action CevapYaz(Handle timer, int client)
{
	PrintToChat(client, " \x02Aleyküm Selam, \x04serverımıza hoşgeldiniz.");
}