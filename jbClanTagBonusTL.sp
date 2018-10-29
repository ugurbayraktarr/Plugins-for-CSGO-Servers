#include <sourcemod>
#include <colors>
#include <cstrike>
#include <sdktools>
#include <store>
#pragma semicolon 1

new Handle:g_cVar_ClanID = INVALID_HANDLE;
new Handle:g_cVar_ClanTag = INVALID_HANDLE;
new Handle:g_cVar_TLVermeSuresi = INVALID_HANDLE;
new Handle:g_cVar_TLMiktari = INVALID_HANDLE;
bool TLVerildi = false;
new iSonHareket[MAXPLAYERS+1];

new Handle:g_PluginTagi = INVALID_HANDLE;


public Plugin:myinfo = 
{
	name = "Clan Tag Kullanana TL Verme Sistemi",
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
	
	AutoExecConfig(true, "clan_tag_kullanana_bonus_tl");
	
	g_cVar_ClanID			=	CreateConVar("drk_tlverme_clanid", "", "Clan ID'nizi buraya giriniz. (Clan tagı kullanırken oyundan cl_clanid yazarak görebilirsiniz.)");
	g_cVar_ClanTag			=	CreateConVar("drk_tlverme_clantag", "", "Clan Tagınızı buraya giriniz. (Oyunda skor tabelasında görüldüğü şekilde.)");
	g_cVar_TLVermeSuresi	=	CreateConVar("drk_tlvermesuresi", "180", "Kaç saniyede bir TL verilsin?");
	g_cVar_TLMiktari		=	CreateConVar("drk_tlmiktari", "100", "Clan tag kullanana verilecek olan TL miktarı");
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");

	CreateTimer(8.0, TimerAyarla);
}

public Action:TimerAyarla(Handle:timer)
{
	CreateTimer(GetConVarFloat(g_cVar_TLVermeSuresi), TLVerTimer, _,TIMER_REPEAT);
}

public Action:sifirla(Handle:timer)
{
	TLVerildi = false;
}

public Action:TLVerTimer(Handle:timer)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	CreateTimer(5.0, sifirla);
	if(!TLVerildi)
	{
		new miktar = GetConVarInt(g_cVar_TLMiktari);
		new String:sServerinClanID[64];
		new String:sServerinClanTag[64];
		
		GetConVarString(g_cVar_ClanID, sServerinClanID, sizeof(sServerinClanID));
		GetConVarString(g_cVar_ClanTag, sServerinClanTag, sizeof(sServerinClanTag));
		
		for(new i=1; i<MAXPLAYERS; i++)
		{
			if(IsClientInGame(i) && IsClientConnected(i) && IsPlayerAlive(i) && GetClientTeam(i) > 1)
			{
				if(!StrEqual(sServerinClanID, "", false))
				{
					new String:sOyuncununClanID[64];
					GetClientInfo(i, "cl_clanid", sOyuncununClanID, 20);
					
					if(StrEqual(sServerinClanID, sOyuncununClanID, false))
					{
						if(iSonHareket[i] + (GetConVarInt(g_cVar_TLVermeSuresi) / 2) < GetTime())
						{
							PrintToChat(i, " \x02[%s] \x07AFK \x01olduğunuz için \x06Bonus TL kazanamadınız.", sPluginTagi);
						}
						else
						{
							PrintToChat(i, " \x02[%s] \x0E%s \x01Tagı kullandığınız için \x04%d TL kazandınız.", sPluginTagi, sServerinClanTag, miktar);
							TLVer(i, miktar);
						}
					}
					else
					{
						if((GetConVarInt(g_cVar_TLVermeSuresi) % 60) != 0)
							PrintToChat(i, " \x02[%s] \x0E%s \x01Tagı alarak \x0B%d saniyede bir \x04%d TL kazanabilirsiniz.", sPluginTagi, sServerinClanTag, GetConVarInt(g_cVar_TLVermeSuresi),  miktar);
						else
							PrintToChat(i, " \x02[%s] \x0E%s \x01Tagı alarak \x0B%d dakikada bir \x04%d TL kazanabilirsiniz.", sPluginTagi, sServerinClanTag, (GetConVarInt(g_cVar_TLVermeSuresi) / 60),  miktar);
						PrintToChat(i, " \x02[%s] \x10Gruba girmek için \x04!grup \x10yazarak grup sayfasını görebilirsiniz.", sPluginTagi);
						
						CreateTimer(0.1, GrupReklam);
						CreateTimer(1.0, GrupReklam);
						CreateTimer(2.0, GrupReklam);
					}
				}
			}
		}
		TLVerildi = true;
	}
}

public Action GrupReklam(Handle timer, int client)
{
	new String:sServerinClanTag[64];
	GetConVarString(g_cVar_ClanTag, sServerinClanTag, sizeof(sServerinClanTag));
	new miktar = GetConVarInt(g_cVar_TLMiktari);
	
	if((GetConVarInt(g_cVar_TLVermeSuresi) % 60) != 0)
		PrintHintTextToAll("<b><font color='#FF00FF'>%s </font><font color='#FFFFFF'>Tagı alarak </font><font color='#00FFFF'>%d saniyede bir </font><font color='#00FF00'>%d TL kazanabilirsiniz.</font></b>", sServerinClanTag, GetConVarInt(g_cVar_TLVermeSuresi),  miktar);
	else
		PrintHintTextToAll("<b><font color='#FF00FF'>%s </font><font color='#FFFFFF'>Tagı alarak </font><font color='#00FFFF'>%d dakikada bir </font><font color='#00FF00'>%d TL kazanabilirsiniz.</font></b>", sServerinClanTag, (GetConVarInt(g_cVar_TLVermeSuresi) / 60),  miktar);
}

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)
{
	if((buttons & IN_FORWARD) || (buttons & IN_JUMP) || (buttons & IN_MOVELEFT) || (buttons & IN_BACK) || (buttons & IN_MOVERIGHT) || (buttons & IN_DUCK) || (buttons & IN_SPEED) || (buttons & IN_USE) || (buttons & IN_ATTACK) || (buttons & IN_ATTACK2))
	{
		if(GetTime() > iSonHareket[client])
			iSonHareket[client] = GetTime() + 1;
	}
}
 


TLVer(int client, int kazanma)
{
	Store_SetClientCredits(client, (Store_GetClientCredits(client) + kazanma));
}