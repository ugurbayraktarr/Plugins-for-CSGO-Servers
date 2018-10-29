#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

static int iOylamaBekleme[65] = { 0, ... };
static int mapBaslangic;
static int bekleme;
new Handle:g_PluginTagi = INVALID_HANDLE;

public Plugin:myinfo =
{
	name = "Admin Yokken Map Değişme",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "2.0",
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
	
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
	RegConsoleCmd("sm_adminyok", AdminYokMapDegis);
	RegConsoleCmd("sm_adminyokmapdegis", AdminYokMapDegis);
}

public OnMapStart()
{
	mapBaslangic = GetTime();
}

public Action:AdminYokMapDegis(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	if(bekleme + 300 < GetTime())
	{
		if(mapBaslangic + 600 < GetTime())
		{
			new String:nick[32];
			GetClientName(client, nick, 32);
			
			if(iOylamaBekleme[client] < GetTime() - 600)
			{
				iOylamaBekleme[client] = GetTime();
				
				PrintToChatAll(" \x02[%s] \x04Map oylamaları, \x02ImPossibLe` \x04tarafından kodlanmıştır.", sPluginTagi);
				int i = 1;
				int adminSay = 0;
				int userSay = 0;
				decl String:mapismi[32];
				GetCmdArgString(mapismi, sizeof(mapismi));
				
				while(i<=64)
				{
					if(IsClientInGame(i))
					{
						if(IsPlayerGenericAdmin(i))
							adminSay++;
						else
							userSay++;
					}
					i++;
				}
				if(args == 1)
				{
					bekleme = GetTime();
					PrintToChatAll(" \x02[%s] \x04%s \x02map oylaması yapmak istiyor.", sPluginTagi, nick);
					PrintToChatAll(" \x02[%s] \x04Admin sayısı: \x02%d", sPluginTagi, adminSay);
					PrintToChatAll(" \x02[%s] \x04User sayısı: \x02%d", sPluginTagi, userSay);
					if(adminSay <= 1)
					{
						{
							if(userSay > 1)
							{
								PrintToChatAll(" \x02[%s] \x04Oyunda admin olmadığı için map oylaması başlatıldı.", sPluginTagi);
								ServerCommand("sm_votemap %s", mapismi);
							}
							else
								PrintToChatAll(" \x02[%s] \x04Oylama yapmak için yeterli sayıda oyuncu yok.", sPluginTagi);
						}
					}
					else
						PrintToChatAll(" \x02[%s] \x04Oyunda 1'den fazla admin varken oylama yapılmaz.", sPluginTagi);
				}
				else
				{
					PrintCenterTextAll("Kullanım: !adminyok mapismi\nOylamaya sadece 1 map koyabilirsiniz.");
				}
				return Plugin_Continue;
			}
			else
			{
				PrintToChatAll(" \x04[%s] \x02%s \x04isimli oyuncu oylama yapabilmek için: \x02%d \x04saniye beklemelidir.", sPluginTagi, nick, 600 - (GetTime() - iOylamaBekleme[client]));
				return Plugin_Handled;
			}
		}
		else
		{
			PrintToChatAll(" \x02[%s] \x04Map yeni açıldı. Oylama yapmak için \x02%d saniye \x04bekleyin.", sPluginTagi, 600 - (GetTime() - mapBaslangic));
		}
	}
	else
	{
		PrintToChatAll(" \x02[%s] \x04Yeni bir ıylama yapmak için \x02%d saniye \x04bekleyin.", sPluginTagi, 300 - (GetTime() - bekleme));
	}
	return Plugin_Continue;
}

bool:IsPlayerGenericAdmin(client)
{
    if (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC, false))
    {
        return true;
    }
    return false;
}