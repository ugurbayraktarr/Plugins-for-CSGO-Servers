#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <clientprefs>

public Plugin:myinfo =
{
	name        = "Uyarı Sistemi",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "3.0"
};

//static int uyarilar[65] = {0, ...};
//static int silenceKapanmaZamani[65];
//new Float:Zaman;

new Handle:g_PluginTagi = INVALID_HANDLE;

static int uyariBekleme[65];
new Handle:SilenceTimers[65];
new Handle:g_hUyariCookie;


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
	
	HookEvent("player_disconnect", OnPlayerDisconnect, EventHookMode_Pre);
	RegAdminCmd("sm_uyari", Command_Uyari, ADMFLAG_GENERIC);
	RegConsoleCmd("sm_uyarim", Command_Uyarim);
	g_hUyariCookie = RegClientCookie("DrKGaminGUyariCookie", "DrK GaminG Uyari Cookie", CookieAccess_Private);
	//HookEvent("round_start", Event_Round_Start, EventHookMode_Pre);
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
	
	for (new client = 1; client <= MaxClients; client++)
	{
		if (!IsClientInGame(client))
			continue;
		
		if(!AreClientCookiesCached(client))
			continue;
			
		SetClientCookie(client, g_hUyariCookie, "0");
	}
}
/*
public Action:Event_Round_Start(Handle:event, const String:name[], bool:dontBroadcast) 
{
	Zaman = GetEngineTime();
}*/
/*
public OnGameFrame()
{
	float now = GetEngineTime();
	if(now >= Zaman)
	{
		Zaman = now + 1.0;
		new i;
		for(i=0; i<MaxClients;i++)
		if(silenceKapanmaZamani[i] != 0 && (silenceKapanmaZamani[i] <= GetTime()))
		{
			silenceKapanmaZamani[i] = 0;
			new userId = GetClientUserId(i);
			PerformUnSilence(-1, i);
			PrintToChatAll(" \x02[DrK # GaminG] \x04%N\x05 isimli oyuncunun \x0CSilence cezası bitti!", i);
		}
	}
}*/

public Action:Command_Uyari(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));

	if(args != 1)
	{

		//Print:
		PrintToConsole(client, "Kullanım: !uyari isim");
		PrintToChat(client, " \x02Kullanım:\x04 !uyari isim");

		//Return:
		return Plugin_Handled;
	}
	
	//Declare:
	decl MaxPlayers, Player;
	decl String:PlayerName[32];
	decl String:Name[32];
	
	//Initialize:
	Player = -1;
	GetCmdArg(1, PlayerName, sizeof(PlayerName));
	int eslesme = 0;
	
	//Find:
	MaxPlayers = GetMaxClients();
	for(new X = 1; X <= MaxPlayers; X++)
	{

		//Connected:
		if(!IsClientConnected(X)) continue;

		//Initialize:
		GetClientName(X, Name, sizeof(Name));

		//Save:
		if(StrContains(Name, PlayerName, false) != -1) 
		{
			Player = X;
			eslesme++;
		}
	}
	
	//Invalid Name:
	if(Player == -1)
	{
		//Print:
		PrintToChatAll(" \x02[%s] \x04Kullanıcı bulunamadı: \x05%s", sPluginTagi, PlayerName);
		PrintToConsole(client, "Kullanıcı bulunamadı: %s", PlayerName);

		//Return:
		return Plugin_Handled;
	}
	else if(eslesme != 1)
	{
		//Print:
		PrintToChatAll(" \x02[%s] \x04Birden fazla eşleşme bulundu.", sPluginTagi);
		PrintToConsole(client, "Birden fazla eşleşme bulundu.");
		
		//Return:
		return Plugin_Handled;
	}
	else
	{
		new String:nick[32];
		GetClientName(Player, nick, 32);
		if(CanUserTarget(client, Player))
		{
			if(GetTime() > uyariBekleme[Player] + 10)
			{
				if (AreClientCookiesCached(client))
				{
					decl String:sCookieDegeri[32];
					GetClientCookie(Player, g_hUyariCookie, sCookieDegeri, sizeof(sCookieDegeri));
					new cookieValue = StringToInt(sCookieDegeri);
					cookieValue++;
					IntToString(cookieValue, sCookieDegeri, sizeof(sCookieDegeri));
					SetClientCookie(Player, g_hUyariCookie, sCookieDegeri);
					
					//uyarilar[Player]++;
					PrintToChatAll(" \x02[%s] \x04%s\x05 adlı oyuncunun\x02 %d\x05 uyarısı oldu!", sPluginTagi, nick, cookieValue);
					LogAction(client, Player, "\"%L\" adli admin \"%L\"'a %d. uyariyi verdi.", client, Player, cookieValue);
					uyariBekleme[Player] = GetTime();
					//new userId = GetClientUserId(Player);
					new userId = GetClientUserId(Player);
					if(cookieValue == 1)
					{
						//silenceKapanmaZamani[Player] = GetTime() + 60;
						ServerCommand("sm_silence #%d", userId);
						SilenceTimers[Player] = CreateTimer(60.0, SilenceKaldir, userId);
						PrintToChatAll(" \x02[%s] \x04%N\x05 1 dk \x0CSilence aldı!", sPluginTagi, Player);
					}
					if(cookieValue == 2)
					{
						//silenceKapanmaZamani[Player] = GetTime() + 300;
						ServerCommand("sm_silence #%d", userId);
						SilenceTimers[Player] = CreateTimer(300.0, SilenceKaldir, userId);
						PrintToChatAll(" \x02[%s] \x04%N\x05 5 dk \x0CSilence aldı!", sPluginTagi, Player);
					}
					
					if(cookieValue >= 3)
					{
						SetClientCookie(Player, g_hUyariCookie, "0");
						
						PrintToChatAll(" \x02[%s] \x04%s \x05adlı oyuncunun 3 uyarısı olduğu için banlandı", sPluginTagi, nick);
						BanClient(Player, 5, BANFLAG_AUTO, "3 uyarı aldınız ve 5 dk banlandınız.", "3 uyarı aldınız ve 5 dk banlandınız.",  "sm_ban", client);
					}
				}
			}
			else
			{
				PrintToChatAll(" \x02[%s] \x04%s \x05adlı oyuncuya uyarı vermek için \x04%d saniye \x05bekleyiniz.", sPluginTagi, nick, 10 - (GetTime() - uyariBekleme[Player]));
			}
		}
		else
		{
			PrintToChatAll(" \x02[%s] \x04%s \x05adlı admine uyarı yetkiniz bulunmuyor.", sPluginTagi, nick);
		}
	}
	
	return Plugin_Continue;
}

public Action SilenceKaldir(Handle timer, any userId)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));

	ServerCommand("sm_unsilence #%d", userId);
	new client = GetClientOfUserId(userId);
	PrintToChatAll(" \x02[%s] \x10%N \x04nickli oyuncunun silence cezası bitti!", sPluginTagi, client);
	SilenceTimers[client] = null;
}

public Action:Command_Uyarim(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));

	if(args != 0)
	{
		//Print:
		PrintToConsole(client, "Kullanım: !uyarim");
		PrintToChat(client, " \x02Kullanım:\x04 !uyarim");

		//Return:
		return Plugin_Handled;
	}
	
	decl String:sCookieDegeri[32];
	GetClientCookie(client, g_hUyariCookie, sCookieDegeri, sizeof(sCookieDegeri));
	int cookieValue = StringToInt(sCookieDegeri);
	
	PrintToChat(client, " \x02[%s] \x04 %d\x05 uyarınız var!", sPluginTagi, cookieValue);
	
	return Plugin_Continue;
}
	
	

public Action:OnPlayerDisconnect(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	//uyarilar[client] = 0;
	//silenceKapanmaZamani[client] = 0;
	
	if (SilenceTimers[client] != null)
	{
		KillTimer(SilenceTimers[client]);
		SilenceTimers[client] = null;
	}
	
	return Plugin_Continue;
}