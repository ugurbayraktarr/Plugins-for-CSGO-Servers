#include <sourcemod>
#include <colors>
#include <cstrike>
#include <sdktools>
#pragma semicolon 1

new Handle:g_PluginTagi = INVALID_HANDLE;
new Handle:g_cVar_ClanID = INVALID_HANDLE;
new Handle:g_cVar_ClanTag = INVALID_HANDLE;
new Handle:g_cVar_ParaMiktari = INVALID_HANDLE;

public Plugin:myinfo = 
{
	name = "Clan Tag Kullanana Bonus Para Ekleme",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
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
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
	
	g_cVar_ClanID			=	CreateConVar("drk_paraverme_clanid", "", "Clan ID'nizi buraya giriniz. (Clan tagı kullanırken oyundan cl_clanid yazarak görebilirsiniz.)");
	g_cVar_ClanTag			=	CreateConVar("drk_paraverme_clantag", "", "Clan Tagınızı buraya giriniz. (Oyunda skor tabelasında görüldüğü şekilde.)");
	g_cVar_ParaMiktari		=	CreateConVar("drk_para_miktari", "1000", "Clan tag kullanana verilecek olan TL miktarı");
	
	AutoExecConfig(true, "clan_tag_kullanana_bonus_para_pro");
	
	HookEvent("round_start", Event_RoundStart);
}

public Action:Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	new miktar = GetConVarInt(g_cVar_ParaMiktari);
	new String:sServerinClanID[64];
	new String:sServerinClanTag[64];
	
	GetConVarString(g_cVar_ClanID, sServerinClanID, sizeof(sServerinClanID));
	GetConVarString(g_cVar_ClanTag, sServerinClanTag, sizeof(sServerinClanTag));
		
	
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
						if(StrEqual(clantagid, sServerinClanID) == true)
						{
							new iPara = miktar;
							PrintToChat(i, " \x02[%s] \x0C%s \x09Clan tagı kullandığınız için \x0E%d$ \x09kazandınız.", sPluginTagi, sServerinClanTag, miktar);
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
							PrintToChat(i, " \x02[%s] \x0C%s \x09Clan tagı kullanırsanız, her el \x0Efazladan %d$ \x09kazanırsınız.", sPluginTagi, sServerinClanTag, miktar);
							PrintToChat(i, " \x04!grup \x06Yazarak grup sayfasını görebilirsiniz.");
							PrintToChat(i, " \x06Gruba girdikten konsola \n\x02cl_clanid %s\x06 yazarak kullanabilirsiniz.", sServerinClanID);
							CreateTimer(1.0, GrupReklam);
							CreateTimer(2.0, GrupReklam);
							CreateTimer(3.0, GrupReklam);
							CreateTimer(4.0, GrupReklam);
							CreateTimer(5.0, GrupReklam);
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
	new String:sServerinClanTag[64];
	GetConVarString(g_cVar_ClanTag, sServerinClanTag, sizeof(sServerinClanTag));
	
	new miktar = GetConVarInt(g_cVar_ParaMiktari);
	
	PrintHintTextToAll("<font color='#FF0000'>%s </font><font color='#00FF00'>tagı alarak her el fazladan </font><font color='#FF00FF'>%d$</font> <font color='#00FFFF'>kazanabilirsiniz</font>", sServerinClanTag, miktar);
}