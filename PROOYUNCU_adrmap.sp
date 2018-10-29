#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>
//#include <colors>

#define PLUGIN_VERSION "1.1"

public Plugin:myinfo =
{
	name        = "PROOYUNCU ~ Map değişme",
	author      = "ImPossibLe`",
	description = "PROOYUNCU",
	version     = PLUGIN_VERSION,
};

static int mapDegisecek;
static int iDelay;


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
	if(StrEqual(serverip, "77.223.155.181:27015") == false)
	{
		LogError("Bu plugin ImPossibLe` tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	RegAdminCmd("sm_adrmap", Command_DrkMap, ADMFLAG_GENERIC);
	HookEvent("round_end", Event_RoundEnd);
	ServerCommand("mp_win_panel_display_time 0");
}

public OnMapStart()
{
	mapDegisecek = 0;
	ServerCommand("mp_win_panel_display_time 0");
}

public Action:Command_DrkMap(client, args)
{
	new Handle:g_hCvarDelay = INVALID_HANDLE;
	g_hCvarDelay = FindConVar("mp_round_restart_delay");
	
	if (g_hCvarDelay != INVALID_HANDLE)
	{
		iDelay = GetConVarInt(g_hCvarDelay);
	}  
	
	
	
	decl String:mapismi[32];
	GetCmdArgString(mapismi, sizeof(mapismi));
	if(args != 1)
	{
		PrintToChat(client, " \x02[PROOYUNCU] \x04Hatalı giriş yaptınız. Kullanım: \x03!adrmap mapismi");
	}
	else
	{
		if(IsMapValid(mapismi))
		{
			ServerCommand("mp_respawn_on_death_ct 0");
			ServerCommand("mp_respawn_on_death_t 0");
			ServerCommand("sm_nextmap %s", mapismi);
			mapDegisecek = 1;
			ServerCommand("mp_timelimit 0");
		}
		else
			PrintToChat(client, " \x02[PROOYUNCU] \x04Girmiş olduğunuz map bulunamadı: \x10%s", mapismi);
	}
}

public Action Event_RoundEnd(Handle event, char[] name, bool dontBroadcast)
{
	if(mapDegisecek == 1)
	{
		mapDegisecek = 0;
		new String:sSure[16];
		new Float:fSure;
		IntToString(iDelay, sSure, sizeof(sSure));
		fSure = StringToFloat(sSure);
		fSure+=4.0;
		CreateTimer(fSure, MapDegis);
	}
}

public Action MapDegis(Handle timer)
{
	new Handle:g_hNextMap;
	g_hNextMap = FindConVar("sm_nextmap");
	new String:sNextMap[64];
	GetConVarString(g_hNextMap,sNextMap,64);
	ServerCommand("changelevel %s", sNextMap);
}
