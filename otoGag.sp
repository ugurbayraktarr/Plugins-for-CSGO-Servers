#pragma semicolon 1
#include <sourcemod>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Otomatik Gag Atma Sistemi",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

bool otoGag = false;
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

	RegAdminCmd("sm_otogag", OtoGagKomutu, ADMFLAG_GENERIC, "Otomatik gag atma komutu");
	HookEvent("player_death", Event_PlayerDeath);
	HookEvent("player_spawn", Event_PlayerSpawn);
	HookEvent("round_end", Event_Round_End);
}

public OnMapStart()
{
	otoGag = false;
}

public Action:Event_Round_End(Handle:event, const String:name[], bool:dontBroadcast)
{
	otoGag = false;
}

public Action:OtoGagKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	decl String:sKomut[32];
	GetCmdArg(1, sKomut, sizeof(sKomut));
	
	if(args == 1)
	{
		if(StrEqual(sKomut, "1", false))
		{
			otoGag = true;
			ServerCommand("sm_gag @dead");
			PrintToChatAll(" \x02[%s] \x10%N \x01tarafından \x0EOtogag \x06açıldı.", sPluginTagi, client);
		}
		else if(StrEqual(sKomut, "0", false))
		{
			otoGag = false;
			ServerCommand("sm_ungag @all");
			PrintToChatAll(" \x02[%s] \x10%N \x01tarafından \x0EOtogag \x07kapatıldı.", sPluginTagi, client);
		}
		else
		{
			PrintToChat(client, " \x04Hatalı kullanım! \x02(!otogag 1/0)");
		}
	}
	else
	{
		PrintToChat(client, " \x04Hatalı kullanım! \x02(!otogag 1/0)");
	}
	
	return Plugin_Continue;
}

public Action:Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	if(otoGag)
	{
		new client = GetClientOfUserId(GetEventInt(event, "userid"));
		new userid = GetClientUserId(client);
		ServerCommand("sm_gag #%d", userid);
	}
}
	
	
public Action:Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	if(otoGag)
	{
		new client = GetClientOfUserId(GetEventInt(event, "userid"));
		new userid = GetClientUserId(client);
		ServerCommand("sm_ungag #%d", userid);
	}
}

public OnClientPutInServer(client)
{
	if(otoGag)
	{
		new userid = GetClientUserId(client);
		CreateTimer(5.0, LoadStuff, userid);
		//ServerCommand("sm_gag #%d", userid);
	}
}

public Action LoadStuff(Handle timer, int userid)
{
	ServerCommand("sm_gag #%d", userid);
}
