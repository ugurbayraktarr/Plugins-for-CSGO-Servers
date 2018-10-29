#include <sourcemod>
#include <colors>
#include <cstrike>
#include <sdktools>
#pragma semicolon 1

public Plugin:myinfo = 
{
	name = "Adminlere Bonus Para Ekleme",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "1.0"
}

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
	if(StrEqual(serverip, "185.193.165") == false && ips[3] != 166)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");

	HookEvent("round_start",Event_RoundStart);
}

public Action:Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if((GetTeamScore(2) + GetTeamScore(3)) >= 2)
	{
		new i;
		for(i=1; i<MAXPLAYERS; i++)
		{
			if(IsClientInGame(i) && IsClientConnected(i) && IsPlayerAlive(i))
			{
				if(GetUserFlagBits(i) & ADMFLAG_ROOT)
				{
					new iPara = 5000;
					PrintToChat(i, " \x02[%s] \x04Admin yetkinizden dolayı\x10 5.000$ \x04kazandınız.", sPluginTagi);
					new g_iAccount = FindSendPropOffs("CCSPlayer", "m_iAccount");
					//new g_iAccount = FindSendPropInfo("CSSPlayer", "m_iAccount");
					new iSuankiPara = GetEntData(i, g_iAccount);
					iPara = iPara + iSuankiPara;
					if (iPara > 16000) // Check this again
					{
						iPara = 16000;
					}
					SetEntData(i, g_iAccount, iPara);
				}
				else if(GetUserFlagBits(i) & ADMFLAG_PASSWORD)
				{
					new iPara = 4000;
					PrintToChat(i, " \x02[%s] \x04Admin yetkinizden dolayı\x10 4.000$ \x04kazandınız.", sPluginTagi);
					new g_iAccount = FindSendPropOffs("CCSPlayer", "m_iAccount");
					//new g_iAccount = FindSendPropInfo("CSSPlayer", "m_iAccount");
					new iSuankiPara = GetEntData(i, g_iAccount);
					iPara = iPara + iSuankiPara;
					if (iPara > 16000) // Check this again
					{
						iPara = 16000;
					}
					SetEntData(i, g_iAccount, iPara);
				}
				else if(GetUserFlagBits(i) & ADMFLAG_CUSTOM6)
				{
					new iPara = 3000;
					PrintToChat(i, " \x02[%s] \x04Admin yetkinizden dolayı\x10 3.000$ \x04kazandınız.", sPluginTagi);
					new g_iAccount = FindSendPropOffs("CCSPlayer", "m_iAccount");
					//new g_iAccount = FindSendPropInfo("CSSPlayer", "m_iAccount");
					new iSuankiPara = GetEntData(i, g_iAccount);
					iPara = iPara + iSuankiPara;
					if (iPara > 16000) // Check this again
					{
						iPara = 16000;
					}
					SetEntData(i, g_iAccount, iPara);
				}
				else if(GetUserFlagBits(i) & ADMFLAG_RESERVATION)
				{
					new iPara = 2000;
					PrintToChat(i, " \x02[%s] \x04Admin yetkinizden dolayı\x10 2.000$ \x04kazandınız.", sPluginTagi);
					new g_iAccount = FindSendPropOffs("CCSPlayer", "m_iAccount");
					//new g_iAccount = FindSendPropInfo("CSSPlayer", "m_iAccount");
					new iSuankiPara = GetEntData(i, g_iAccount);
					iPara = iPara + iSuankiPara;
					if (iPara > 16000) // Check this again
					{
						iPara = 16000;
					}
					SetEntData(i, g_iAccount, iPara);
				}
				else if(GetUserFlagBits(i) & ADMFLAG_GENERIC)
				{
					new iPara = 1000;
					PrintToChat(i, " \x02[%s] \x04Admin yetkinizden dolayı\x10 1.000$ \x04kazandınız.", sPluginTagi);
					new g_iAccount = FindSendPropOffs("CCSPlayer", "m_iAccount");
					//new g_iAccount = FindSendPropInfo("CSSPlayer", "m_iAccount");
					new iSuankiPara = GetEntData(i, g_iAccount);
					iPara = iPara + iSuankiPara;
					if (iPara > 16000) // Check this again
					{
						iPara = 16000;
					}
					SetEntData(i, g_iAccount, iPara);
				}
			}
		}
	}
	return Plugin_Continue;
}