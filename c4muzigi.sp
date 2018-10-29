#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <colors>
#include <clientprefs>
#define SARKISAYISI 7

public Plugin:myinfo =
{
	name        = "C4 Müzikleri",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.5",
};

static int sayacCalinacak = 0;
static int bombaKuruldu = 0;
static int random = 0;
static int g_explosionTime;
Handle g_c4Cookie;

new const String:FULL_SOUND_PATH[SARKISAYISI][128];
new const String:RELATIVE_SOUND_PATH[SARKISAYISI][128];
new Handle:g_PluginTagi = INVALID_HANDLE;

new const String:FULL_SOUND_PATHSON5[] = "sound/drkgaming/son5saniye.mp3";
new const String:RELATIVE_SOUND_PATHSON5[] = "*/drkgaming/son5saniye.mp3";

public OnPluginStart()
{
	g_c4Cookie = RegClientCookie("C4 Muzikleri", "", CookieAccess_Private);
	SetCookieMenuItem(c4CookieHandler, 0, "C4 Muzikleri");
	
	HookEvent("round_start", Event_RoundStart);
	HookEvent("round_end", Event_RoundEnd);
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
	HookEvent( "bomb_planted", Event_BombPlanted );
	RegConsoleCmd("sm_c4", UserKomutC4);	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
}

public void c4CookieHandler(int client, CookieMenuAction action, any info, char[] buffer, int maxlen)
{
	c4muzikMenu(client, 0);
}

public Action c4muzikMenu(int client, int args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	int cookievalue = GetIntCookie(client, g_c4Cookie);
	Handle g_c4Menu = CreateMenu(c4MenuHandler);
	SetMenuTitle(g_c4Menu, "[%s] C4 Muzikleri", sPluginTagi);
	char Item[128];
	if(cookievalue == 0)
	{
		Format(Item, sizeof(Item), "Açık (X)"); 
		AddMenuItem(g_c4Menu, "ON", Item);
		Format(Item, sizeof(Item), "Kapalı"); 
		AddMenuItem(g_c4Menu, "OFF", Item);
	}
	else
	{
		Format(Item, sizeof(Item), "Açık");
		AddMenuItem(g_c4Menu, "ON", Item);
		Format(Item, sizeof(Item), "Kapalı (X)"); 
		AddMenuItem(g_c4Menu, "OFF", Item);
	}
	SetMenuExitBackButton(g_c4Menu, true);
	SetMenuExitButton(g_c4Menu, true);
	DisplayMenu(g_c4Menu, client, 30);
}

public int c4MenuHandler(Handle menu, MenuAction action, int param1, int param2)
{
	Handle g_c4Menu = CreateMenu(c4MenuHandler);
	if (action == MenuAction_DrawItem)
	{
		return ITEMDRAW_DEFAULT;
	}
	else if(param2 == MenuCancel_ExitBack)
	{
		ShowCookieMenu(param1);
	}
	else if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				SetClientCookie(param1, g_c4Cookie, "0");
				c4muzikMenu(param1, 0);
			}
			case 1:
			{
				SetClientCookie(param1, g_c4Cookie, "1");
				c4muzikMenu(param1, 0);
			}
		}
		CloseHandle(g_c4Menu);
	}
	return 0;
}

int GetIntCookie(int client, Handle handle)
{
	char sCookieValue[11];
	GetClientCookie(client, handle, sCookieValue, sizeof(sCookieValue));
	return StringToInt(sCookieValue);
}

public Action:UserKomutC4(client, args)
{
	c4muzikMenu(client, 0);
}
public OnMapStart()
{
	int ips[4];
	char serverip[32];
	int ip = GetConVarInt(FindConVar("hostip"));
	int port = GetConVarInt(FindConVar("hostport"));
	ips[0] = (ip >> 24) & 0x000000FF;
	ips[1] = (ip >> 16) & 0x000000FF;
	ips[2] = (ip >> 8) & 0x000000FF;
	ips[3] = ip & 0x000000FF;
	
	Format(serverip, sizeof(serverip), "%d.%d.%d", ips[0], ips[1], ips[2]);
	if(StrEqual(serverip, "185.193.165") == false && ips[3] != 166)
	{
		LogError("Bu plugin ImPossibLe` tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		CPrintToChatAll(" \x02[DrK # GaminG] \x04Test başarılı.");
		CPrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	
	FULL_SOUND_PATH[0] = "sound/drkgaming/c4muzigi6.mp3";
	RELATIVE_SOUND_PATH[0] = "*/drkgaming/c4muzigi6.mp3";
	FULL_SOUND_PATH[1] = "sound/drkgaming/c4muzigi7.mp3";
	RELATIVE_SOUND_PATH[1] = "*/drkgaming/c4muzigi7.mp3";
	FULL_SOUND_PATH[2] = "sound/drkgaming/c4muzigi8.mp3";
	RELATIVE_SOUND_PATH[2] = "*/drkgaming/c4muzigi8.mp3";
	FULL_SOUND_PATH[3] = "sound/drkgaming/c4muzigi9.mp3";
	RELATIVE_SOUND_PATH[3] = "*/drkgaming/c4muzigi9.mp3";
	FULL_SOUND_PATH[4] = "sound/drkgaming/c4muzigi10.mp3";
	RELATIVE_SOUND_PATH[4] = "*/drkgaming/c4muzigi10.mp3";
	FULL_SOUND_PATH[5] = "sound/drkgaming/c4muzigi11.mp3";
	RELATIVE_SOUND_PATH[5] = "*/drkgaming/c4muzigi11.mp3";
	FULL_SOUND_PATH[6] = "sound/drkgaming/c4muzigi12.mp3";
	RELATIVE_SOUND_PATH[6] = "*/drkgaming/c4muzigi12.mp3";
	
	
	new i;
	for(i=0;i<SARKISAYISI;i++)
	{
		AddFileToDownloadsTable( FULL_SOUND_PATH[i] );
		FakePrecacheSound( RELATIVE_SOUND_PATH[i] );
	}
	AddFileToDownloadsTable( FULL_SOUND_PATHSON5 );
	FakePrecacheSound( RELATIVE_SOUND_PATHSON5 );
	bombaKuruldu = 0;
}
public OnGameFrame()
{
	if((g_explosionTime - GetTime()) == 5 && sayacCalinacak == 1)
	{
		new i;
		for(i=1;i<=MaxClients;i++)
		{
			if(IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))
				if(!IsPlayerAlive(i))
				{
					EmitSoundToClient( i, RELATIVE_SOUND_PATHSON5 );
				}
		}
		sayacCalinacak = 0;
	}
}

stock FakePrecacheSound( const String:szPath[] )
{
	AddToStringTable( FindStringTable( "soundprecache" ), szPath );
}

public Action:Event_BombPlanted( Handle:event, const String:name[], bool:dontBroadcast )
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	random = GetRandomInt(0, SARKISAYISI-1);
	sayacCalinacak = 1;
	new id = GetClientOfUserId( GetEventInt( event, "userid" ) );
	decl String:Name[ 32 ];
	GetClientName( id, Name, sizeof( Name ) - 1 );
	PrintToChatAll( " \x02[%s] \x10%s \x04bombayı kurdu!", sPluginTagi, Name );
	//PrintToChatAll( " \x02Çalan Müzik:\x0C c4muzigi%d", random + 6);
	bombaKuruldu = 1;
	new i;
	for(i=1;i<=MaxClients;i++)
	{
		if(!IsClientInGame(i) || IsFakeClient(i)) continue;
		if(GetIntCookie(i, g_c4Cookie) == 0)
		{	
			PrintToChat(i, " \x02[%s] \x04c4 müziklerini \x02!c4 \x04yazarak kapatabilirsiniz.");
			if(IsClientInGame(i) && IsClientConnected(i))
				if(!IsPlayerAlive(i))
					EmitSoundToClient( i, RELATIVE_SOUND_PATH[random] );
		}
		else
		{
			PrintToChat(i, " \x02[%s] \x0Cc4 müzikleri\x07, sizin için kapalı.", sPluginTagi);
			PrintToChat(i, " \x02[%s] \x04c4 müziklerini \x02!c4 \x04yazarak açabilirsiniz.", sPluginTagi);
		}
	}
	g_explosionTime = GetTime() + GetConVarInt(FindConVar("mp_c4timer"));
	return Plugin_Handled;
}
/*
public OnBombBeep(Handle:event, const String:name[], bool:dontBroadcast)
{
	new now = GetTime();
	//new timer = GetConVarInt(sm_c4timer);
	new diff = g_explosionTime - now;
	if (g_lastCountdown != now && diff >= 0)
	{
		//PrintToChatAll("[DrK # TEST] %d saniye", diff);
		if(diff == 10)
		{
			new i;
			for(i=1;i<=MaxClients;i++)
			{
				if(IsClientInGame(i) && IsClientConnected(i))
					if(!IsPlayerAlive(i))
						EmitSoundToClient( i, RELATIVE_SOUND_PATHSON10 );
			}
		}
		g_lastCountdown = GetTime();
	}
}*/

public Action Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(IsClientInGame(client) && IsClientConnected(client))
			if(!IsPlayerAlive(client) && bombaKuruldu == 1)
			{
				if(GetIntCookie(client, g_c4Cookie) == 0)
				{	
					PrintToChat(client, " \x02[%s] \x04c4 müziklerini \x02!c4 \x04yazarak kapatabilirsiniz.", sPluginTagi);
					EmitSoundToClient( client, RELATIVE_SOUND_PATH[random] );
				}
				else
				{
					PrintToChat(client, " \x02[%s] \x0Cc4 müzikleri\x07, sizin için kapalı.", sPluginTagi);
					PrintToChat(client, " \x02[%s] \x04c4 müziklerini \x02!c4 \x04yazarak açabilirsiniz.", sPluginTagi);
				}
			}
}

public Action Event_RoundStart(Handle event, char[] name, bool dontBroadcast)
{
	bombaKuruldu = 0;
	sayacCalinacak = 0;
}

public Action Event_RoundEnd(Handle event, char[] name, bool dontBroadcast)
{
	bombaKuruldu = 0;
	sayacCalinacak = 0;
}