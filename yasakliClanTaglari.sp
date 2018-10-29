#include <sourcemod>
#include <colors>
#include <cstrike>
#include <sdktools>

#pragma semicolon 1

new Handle:g_cVar_ClanID1 = INVALID_HANDLE;
new Handle:g_cVar_ClanID2 = INVALID_HANDLE;
new Handle:g_cVar_ClanID3 = INVALID_HANDLE;
new Handle:g_cVar_ClanID4 = INVALID_HANDLE;
new Handle:g_cVar_ClanID5 = INVALID_HANDLE;
new Handle:g_PluginTagi = INVALID_HANDLE;

public Plugin:myinfo = 
{
	name = "Clan Tag Yasaklama Sistemi",
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
	if(StrEqual(serverip, "185.193.165") == false && ips[3] != 166)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	
	AutoExecConfig(true, "clantag_yasaklama");
	
	g_cVar_ClanID1			=	CreateConVar("drk_izinli_clanid1", "8741175", "izinli 1. Clan ID'nizi buraya giriniz. (Clan tagı kullanırken oyundan cl_clanid yazarak görebilirsiniz.) 8741175 sayisi DrK # taginin ornegidir.");
	g_cVar_ClanID2			=	CreateConVar("drk_izinli_clanid2", "", "izinli 2. Clan ID'nizi buraya giriniz.");
	g_cVar_ClanID3			=	CreateConVar("drk_izinli_clanid3", "", "izinli 3. Clan ID'nizi buraya giriniz.");
	g_cVar_ClanID4			=	CreateConVar("drk_izinli_clanid4", "", "izinli 4. Clan ID'nizi buraya giriniz.");
	g_cVar_ClanID5			=	CreateConVar("drk_izinli_clanid5", "", "izinli 5. Clan ID'nizi buraya giriniz.");
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
	
	HookEvent("round_start", Event_Round_Start);
}

public Action:Event_Round_Start(Handle:event, const String:name[], bool:dontBroadcast) 
{
	CreateTimer(3.0, TagKontrol);
}

public Action:TagKontrol(Handle:timer)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	new String:sServerinClanID1[64];
	new String:sServerinClanID2[64];
	new String:sServerinClanID3[64];
	new String:sServerinClanID4[64];
	new String:sServerinClanID5[64];
	
	GetConVarString(g_cVar_ClanID1, sServerinClanID1, sizeof(sServerinClanID1));
	GetConVarString(g_cVar_ClanID2, sServerinClanID2, sizeof(sServerinClanID2));
	GetConVarString(g_cVar_ClanID3, sServerinClanID3, sizeof(sServerinClanID3));
	GetConVarString(g_cVar_ClanID4, sServerinClanID4, sizeof(sServerinClanID4));
	GetConVarString(g_cVar_ClanID5, sServerinClanID5, sizeof(sServerinClanID5));
	
	for(new i=1; i<=MaxClients; i++)
	{
		if(IsClientConnected(i))
		{
			if(IsClientInGame(i))
			{
				new String:sOyuncununClanID[64];
				GetClientInfo(i, "cl_clanid", sOyuncununClanID, 20);
				
				//PrintToChat(i, "Test: %s", sOyuncununClanID);
				
				if(!StrEqual(sOyuncununClanID, "", false))
				{
					if((StrEqual(sServerinClanID1, sOyuncununClanID, false)) || (StrEqual(sServerinClanID2, sOyuncununClanID, false)) || (StrEqual(sServerinClanID3, sOyuncununClanID, false)) || (StrEqual(sServerinClanID4, sOyuncununClanID, false)) || (StrEqual(sServerinClanID5, sOyuncununClanID, false)) || (StrEqual("8741175", sOyuncununClanID, false)) || (StrEqual("", sOyuncununClanID, false)))
					{
						continue;
					}
					else
					{
						new String:anlikTag[64];
						CS_GetClientClanTag(i, anlikTag, sizeof(anlikTag));
						if(!StrEqual("", anlikTag))
							PrintToChat(i, " \x02[%s] \x06Serverda yasaklı bir clan tagı kullandığınız için clan tagınız gizlendi.", sPluginTagi);
						CS_SetClientClanTag(i, "");
					}
				}
			}
		}
	}
	
}