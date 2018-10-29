#include <sourcemod>
#include <colors>
#include <cstrike>
#include <sdktools>
#pragma semicolon 1

public Plugin:myinfo = 
{
	name = "Adminlere Bonus Para Ekleme",
	author = "ImPossibLe`",
	description = "NoFL",
	version = "1.0"
}


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
	if(StrEqual(serverip, "185.122.202") == false || ips[3] < 2 || ips[3] > 101)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	HookEvent("round_start",Event_RoundStart);
}

public Action:Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	if(((GetTeamScore(2) + GetTeamScore(3)) % 15) >= 3)
	{
		new i;
		for(i=1; i<MAXPLAYERS; i++)
		{
			if(IsClientInGame(i) && IsClientConnected(i) && IsPlayerAlive(i))
			{
				if(GetUserFlagBits(i) & ADMFLAG_ROOT)
				{
					new iPara = 16000;
					PrintToChat(i, " \x02[ ☜ NoFL ☞ ] \x0EYetkinizden dolayı\x04 16.000$ \x0Ekazandınız.");
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
					new iPara = 15000;
					PrintToChat(i, " \x02[ ☜ NoFL ☞ ] \x0EYetkinizden dolayı\x04 15.000$ \x0Ekazandınız.");
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
				else if(GetUserFlagBits(i) & ADMFLAG_CUSTOM5)
				{
					new iPara = 5000;
					PrintToChat(i, " \x02[ ☜ NoFL ☞ ] \x0EYetkinizden dolayı\x04 5.000$ \x0Ekazandınız.");
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
				else if(GetUserFlagBits(i) & ADMFLAG_CUSTOM4)
				{
					new iPara = 10000;
					PrintToChat(i, " \x02[ ☜ NoFL ☞ ] \x0EYetkinizden dolayı\x04 10.000$ \x0Ekazandınız.");
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
				else if(GetUserFlagBits(i) & ADMFLAG_CUSTOM3)
				{
					new iPara = 5000;
					PrintToChat(i, " \x02[ ☜ NoFL ☞ ] \x0EYetkinizden dolayı\x04 5.000$ \x0Ekazandınız.");
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
				else if(GetUserFlagBits(i) & ADMFLAG_CUSTOM2)
				{
					new iPara = 2500;
					PrintToChat(i, " \x02[ ☜ NoFL ☞ ] \x0EYetkinizden dolayı\x04 2.500$ \x0Ekazandınız.");
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
				else if(GetUserFlagBits(i) & ADMFLAG_CUSTOM1)
				{
					new iPara = 1500;
					PrintToChat(i, " \x02[ ☜ NoFL ☞ ] \x0EYetkinizden dolayı\x04 1.500$ \x0Ekazandınız.");
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