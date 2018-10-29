#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <store>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Jail Otomatik TL Verme",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

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
	if(StrEqual(serverip, "185.188.144") == false || ips[3] < 2 || ips[3] > 129)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");

	
	HookEvent("round_end", Event_RoundEnd);
}
public OnMapStart()
{
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	
	if(!((StrContains(mapName, "jb_", false) != -1) || (StrContains(mapName, "jail_", false)!= -1)))
	{
		SetFailState("Bu plugin sadece jail maplarinda calismaktadir..");
	}
}

public Action Event_RoundEnd(Handle event, char[] name, bool dontBroadcast)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	int iCountT;
	iCountT = 0;
	int iCountCT;
	iCountCT = 0;
	
	for(int i = 1; i < MaxClients; i++)
	{
		if( IsClientInGame( i ) && GetClientTeam( i ) == 2 )
			iCountT++;
	}
	for(int i = 1; i < MaxClients; i++)
	{
		if( IsClientInGame( i ) && GetClientTeam( i ) == 3 )
			iCountCT++;
	}
	int kazanma;
	int isyan = 1;
	int oyuncuSayisi = GetClientCount();
	for(int i = 1; i < MaxClients; i++)
	{
		if(IsClientConnected(i) && IsClientInGame(i))
		{
			if(GetClientTeam(i) == GetEventInt(event, "winner"))
				isyan = GiveCreditsToClient(i);
		}
	}
				
	for(int i = 1; i < MaxClients; i++)
	{
		if(IsClientConnected(i))
		{
			if(IsClientInGame(i))
			{
				if(oyuncuSayisi < 12 && oyuncuSayisi > 6)
				{
					kazanma = (iCountT / iCountCT) * 10;
					if(kazanma < 20)
						kazanma = 20;
					if (kazanma > 60)
						kazanma = 60;
					if(isyan == 1 && GetClientTeam(i) == 3 && oyuncuSayisi > 6)
					{
						PrintToChat(i, " \x04[%s] \x02Bu el isyan oldugu için\x04 0 TL\x02 kazandınız.", sPluginTagi);
					}
					if(isyan == 0 && GetClientTeam(i) == 3 && oyuncuSayisi > 6)
					{
						TLVer(i, kazanma);
						PrintToChat(i, " \x04[%s] \x02Bu el isyan olmadığı için\x04 %d TL \x02kazandınız.", sPluginTagi, kazanma);
					}
				}
				if(oyuncuSayisi > 11 && oyuncuSayisi < 17)
				{
					kazanma = (iCountT / iCountCT) * 12;
					if(kazanma < 30)
						kazanma = 30;
					if (kazanma > 80)
						kazanma = 80;
					if(isyan == 1 && GetClientTeam(i) == 3 && oyuncuSayisi > 6)
					{
						PrintToChat(i, " \x04[%s] \x02Bu el isyan oldugu için\x04 0 TL \x02kazandınız.", sPluginTagi);
					}
					if(isyan == 0 && GetClientTeam(i) == 3 && oyuncuSayisi > 6)
					{
						TLVer(i, kazanma);
						PrintToChat(i, " \x04[%s] \x02Bu el isyan olmadığı için\x04 %d TL \x02kazandınız.", sPluginTagi, kazanma);
					}
				}
				if(oyuncuSayisi > 16 && oyuncuSayisi < 26)
				{
					kazanma = (iCountT / iCountCT) * 20;
					if(kazanma < 50)
						kazanma = 50;
					if (kazanma > 110)
						kazanma = 110;
					if(isyan == 1 && GetClientTeam(i) == 3 && oyuncuSayisi > 6)
					{
						PrintToChat(i, " \x04[%s] \x02Bu el isyan oldugu için\x04 0 TL \x02kazandınız.", sPluginTagi);
					}
					if(isyan == 0 && GetClientTeam(i) == 3 && oyuncuSayisi > 6)
					{
						TLVer(i, kazanma);
						PrintToChat(i, " \x04[%s] \x02Bu el isyan olmadığı için\x04 %d TL \x02kazandınız.", sPluginTagi, kazanma);
					}
				}
				
				if(oyuncuSayisi > 25)
				{
					kazanma = (iCountT / iCountCT) * 22;
					if(kazanma < 70)
						kazanma = 70;
					if (kazanma > 130)
						kazanma = 130;
					if(isyan == 1 && GetClientTeam(i) == 3 && oyuncuSayisi > 6)
					{
						PrintToChat(i, " \x04[%s] \x02Bu el isyan oldugu için\x04 0 TL \x02kazandınız.", sPluginTagi);
					}
					if(isyan == 0 && GetClientTeam(i) == 3 && oyuncuSayisi > 6)
					{
						TLVer(i, kazanma);
						PrintToChat(i, " \x04[%s] \x02Bu el isyan olmadığı için\x04 %d TL \x02kazandınız.", sPluginTagi, kazanma);
					}
				}
			}
		}
	}
	return Plugin_Continue;
}

stock bool:GiveCreditsToClient(int client)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(IsClientConnected(client))
	{
		if(IsClientInGame(client))
		{
			int iCountT;
			iCountT = 0;
			int iCountCT;
			iCountCT = 0;
			int iCountTYasayan;
			iCountTYasayan = 0;
			int oyuncuSayisi = GetClientCount();
			int kazanma;
			for(int i = 1; i < MaxClients; i++)
			{
				if( IsClientInGame( i ) && GetClientTeam( i ) == 2 )
					iCountT++;
			}
			for(int i = 1; i < MaxClients; i++)
			{
				if( IsClientInGame( i ) && GetClientTeam( i ) == 2 && IsPlayerAlive(i))
					iCountTYasayan++;
			}
			for(int i = 1; i < MaxClients; i++)
			{
				if( IsClientInGame( i ) && GetClientTeam( i ) == 3 )
					iCountCT++;
			}
			if(GetClientTeam(client) == 2 && oyuncuSayisi > 6)
			{
				if(iCountTYasayan > 1)
				{
					kazanma = ((iCountT / iCountCT) * 8);
					if(kazanma < 20)
						kazanma = 20;
					if (kazanma > 50)
						kazanma = 50;
					TLVer(client, kazanma);
					PrintToChat(client, " \x04[%s] \x02İsyan TLsi: \x04%d TL \x02kazandınız.", sPluginTagi, kazanma);
					return true;
				}
				if(iCountTYasayan == 1 && IsPlayerAlive(client))
				{
					if(oyuncuSayisi < 12)
					{
						kazanma = ((iCountT / iCountCT) * 15);
						if(kazanma < 40)
							kazanma = 40;
						if (kazanma > 200)
							kazanma = 200;
						TLVer(client, (oyuncuSayisi * 10));
						PrintToChat(client, " \x04[%s] \x02Oyun kazanma TLsi: \x04%d TL \x02kazandınız.", sPluginTagi, ((oyuncuSayisi / iCountCT)* 10));
					}
					else if (oyuncuSayisi > 11 && oyuncuSayisi < 17)
					{
						kazanma = ((iCountT / iCountCT) * 30);
						if(kazanma < 20)
							kazanma = 100;
						if (kazanma > 200)
							kazanma = 200;
						TLVer(client, kazanma);
						PrintToChat(client, " \x04[%s] \x02Oyun kazanma TLsi: \x04%d TL \x02kazandınız.", sPluginTagi, kazanma);
					}
					else if (oyuncuSayisi > 16 && oyuncuSayisi < 26)
					{
						kazanma = ((iCountT / iCountCT) * 50);
						if(kazanma < 20)
							kazanma = 150;
						if (kazanma > 350)
							kazanma = 350;
						TLVer(client, kazanma);
						PrintToChat(client, " \x04[%s] \x02Oyun kazanma TLsi: \x04%d TL \x02kazandınız.", sPluginTagi, kazanma);
					}
					else if (oyuncuSayisi > 25)
					{	
						kazanma = ((iCountT / iCountCT) * 50);
						if(kazanma < 20)
							kazanma = 20;
						if (kazanma > 400)
							kazanma = 400;
						kazanma = 400;
						TLVer(client, kazanma);
						PrintToChat(client, " \x04[%s] \x02Oyun kazanma TLsi: \x04%d TL \x02kazandınız.", sPluginTagi, kazanma);
					}
					return false;
				}
			}
		}
	}
	return false;
}

TLVer(int client, int kazanma)
{
	Store_SetClientCredits(client, (Store_GetClientCredits(client) + kazanma));
}