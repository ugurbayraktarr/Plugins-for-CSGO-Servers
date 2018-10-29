#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <clientprefs>

public Plugin:myinfo =
{
	name        = "Admin Uyarı Sistemi",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0"
};

static int uyariBekleme[65];
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
	if(StrEqual(serverip, "185.188.144") == false || ips[3] < 2 || ips[3] > 129)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	
	RegAdminCmd("sm_adminuyari", Command_Uyari, ADMFLAG_ROOT);
	RegConsoleCmd("sm_adminuyarim", Command_Uyarim);
	g_hUyariCookie = RegClientCookie("DrKGaminGAdminUyariCookie", "DrK GaminG Admin Uyari Cookie", CookieAccess_Private);
	
	for (new client = 1; client <= MaxClients; client++)
	{
		if (!IsClientInGame(client))
			continue;
		
		if(!AreClientCookiesCached(client))
			continue;
			
		SetClientCookie(client, g_hUyariCookie, "0");
	}
}

public Action:Command_Uyari(client, args)
{
	if(args != 1)
	{

		//Print:
		PrintToConsole(client, "Kullanım: !adminuyari isim");
		PrintToChat(client, " \x02Kullanım:\x04 !adminuyari isim");

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
		PrintToChatAll(" \x02[DrK # GaminG] \x04Kullanıcı bulunamadı: \x05%s", PlayerName);
		PrintToConsole(client, "Kullanıcı bulunamadı: %s", PlayerName);

		//Return:
		return Plugin_Handled;
	}
	else if(eslesme != 1)
	{
		//Print:
		PrintToChatAll(" \x02[DrK # GaminG] \x04Birden fazla eşleşme bulundu.");
		PrintToConsole(client, "Birden fazla eşleşme bulundu.");
		
		//Return:
		return Plugin_Handled;
	}
	else
	{
		if(!(GetUserFlagBits(Player) & ADMFLAG_KICK))
		{
			PrintToChatAll(" \x02[DrK # GaminG] \x04Seçtiğiniz kişi bir admin değil.");
			return Plugin_Handled;
		}
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
					PrintToChatAll(" \x02[DrK # GaminG] \x04%s\x05 adlı adminin\x02 %d\x05 uyarısı oldu!", nick, cookieValue);
					LogAction(client, Player, "\"%L\" adli yonetici \"%L\"'a %d. uyariyi verdi.", client, Player, cookieValue);
					uyariBekleme[Player] = GetTime();
					
					new userId = GetClientUserId(Player);
					if(cookieValue == 1)
					{
						
					}
					if(cookieValue == 2)
					{
						
					}
					
					if(cookieValue >= 3)
					{
						SetClientCookie(Player, g_hUyariCookie, "0");
					}
				}
			}
			else
			{
				PrintToChatAll(" \x02[DrK # GaminG] \x04%s \x05adlı admine uyarı vermek için \x04%d saniye \x05bekleyiniz.", nick, 10 - (GetTime() - uyariBekleme[Player]));
			}
		}
		else
		{
			PrintToChatAll(" \x02[DrK # GaminG] \x04%s \x05adlı admine uyarı yetkiniz bulunmuyor.", nick);
		}
	}
	
	return Plugin_Continue;
}

public Action:Command_Uyarim(client, args)
{
	if(args != 0)
	{
		//Print:
		PrintToConsole(client, "Kullanım: !adminuyarim");
		PrintToChat(client, " \x02Kullanım:\x04 !adminuyarim");

		//Return:
		return Plugin_Handled;
	}
	
	decl String:sCookieDegeri[32];
	GetClientCookie(client, g_hUyariCookie, sCookieDegeri, sizeof(sCookieDegeri));
	int cookieValue = StringToInt(sCookieDegeri);
	
	PrintToChat(client, " \x02[DrK # GaminG] \x04 %d\x05 admin uyarınız var!", cookieValue);
	
	return Plugin_Continue;
}