#include <sourcemod>
#include <colors>
#include <cstrike>
#include <sdktools>
#pragma semicolon 1


public Plugin:myinfo = 
{
	name = "Clan Tag Kullanana Bonus Para Ekleme",
	author = "ImPossibLe`",
	description = "DarkLegion",
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
	if(StrEqual(serverip, "185.188.144") == false || ips[3] < 2 || ips[3] > 129)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	HookEvent("round_start", Event_RoundStart);
}

public Action:Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	if((GetTeamScore(2) + GetTeamScore(3)) >= 1)
	{
		new i;
		for(i=1; i<MAXPLAYERS; i++)
		{
			if(IsClientInGame(i) && IsClientConnected(i) && IsPlayerAlive(i))
			{
				new String:clantagid[32];
				{
					if (IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
					{
						GetClientInfo(i, "cl_clanid", clantagid, 9);
						if(StrEqual(clantagid, "26788990") == true)
						{
							new iPara = 1000;
							PrintToChat(i, " \x02[DarkLegioN] \x0CDLN | \x09Clan tagı kullandığınız için \x0E1.000$ \x09kazandınız.");
							new g_iAccount = FindSendPropOffs("CCSPlayer", "m_iAccount");
							new iSuankiPara = GetEntData(i, g_iAccount);
							iPara = iPara + iSuankiPara;
							if (iPara > 16000)
							{
								iPara = 16000;
							}
							SetEntData(i, g_iAccount, iPara);
						}
						else
						{
							PrintToChat(i, " \x02[DarkLegioN] \x0CDLN | \x09Clan tagı kullanırsanız, her el \x0Efazladan 1.000$ \x09kazanırsınız.");
							PrintToChat(i, " \x04!grup \x06Yazarak grup sayfasını görebilirsiniz.");
							PrintToChat(i, " \x06Gruba girdikten konsola \n\x02cl_clanid 26788990\x06 yazarak kullanabilirsiniz.");
							CreateTimer(1.0, GrupReklam);
							CreateTimer(3.0, GrupReklam2);
							CreateTimer(5.0, GrupReklam3);
						}
					}
				}
			}
		}
	}
	return Plugin_Continue;
}
 
public Action GrupReklam(Handle timer, int client)
{
	PrintHintTextToAll("<font color='#FF0000'>DLN | </font><font color='#00FF00'>tagı alarak her el fazladan </font><font color='#FF00FF'>1.000$</font> <font color='#00FFFF'>kazanabilirsiniz</font>");
}

public Action GrupReklam2(Handle timer, int client)
{
	PrintHintTextToAll("<font color='#FF0000'>DLN | </font><font color='#00FF00'>tagı alarak her el fazladan </font><font color='#FF00FF'>1.000$</font> <font color='#00FFFF'>kazanabilirsiniz</font>");
}

public Action GrupReklam3(Handle timer, int client)
{
	PrintHintTextToAll("<font color='#FF0000'>DLN | </font><font color='#00FF00'>tagı alarak her el fazladan </font><font color='#FF00FF'>1.000$</font> <font color='#00FFFF'>kazanabilirsiniz</font>");
}