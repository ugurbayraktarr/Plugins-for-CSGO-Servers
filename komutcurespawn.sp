#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

public Plugin:myinfo =
{
	name = "Komutcu Oto Respawn",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "1.1",
};

new Handle:g_PluginTagi = INVALID_HANDLE;

static int respawnSayisi;
static int iKomutcu;
static int olmeZamani;
static int respawnAt;
bool OyunOynaniyor;


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
	
	RegConsoleCmd("sm_w", Command_W);
	RegConsoleCmd("sm_uw", Command_UW);
	HookEvent("round_start", Event_Round_Start);
	HookEvent("round_end", Event_Round_End);
	HookEvent("player_death", Event_PlayerDeath);
	CreateTimer(2.0, Hatirlatma, _,TIMER_REPEAT);
}
/*
public OnMapEnd()
{
	ServerCommand("sm plugins reload komutcurespawn");
}*/

public OnMapStart()
{
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	
	if(!((StrContains(mapName, "jb_", false) != -1) || (StrContains(mapName, "jail_", false)!= -1)))
	{
		SetFailState("Bu plugin sadece jail maplarinda calismaktadir..");
	}
}

public Action:Command_W(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));

	if(GetClientTeam(client) == 3)
	{
		if(iKomutcu == 0)
		{
			iKomutcu = client;
		}
		else
			PrintToChat(client, " \x02[%s] \x04Şuan zaten bir komutçu var.", sPluginTagi);
	}
	else
		PrintToChat(client, " \x02[%s] \x04Sadece CT'ler komutçu olabilir.", sPluginTagi);
	/*int i = 1;
	int fail = 0;
	while (i<=64)
	{
		if(komutcuKontrol[i] == true)
			fail = 1;
		i++;
	}
	if(fail == 0)
	{
		komutcuKontrol[client] = true;
		iKomutcu = client;
	}
	else
		CPrintToChat(client, "\x04[DrK # GaminG] \x02Şuan zaten bir komutçu var.");
	*/
}
public Action:Command_UW(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));

	if(GetClientTeam(client) == 3)
	{
		if(iKomutcu == client)
		{
			iKomutcu = 0;
		}
		else
			PrintToChat(client, " \x02[%s] \x04Şuan komutçu siz değilsiniz.", sPluginTagi);
	}
}
public Action:Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));

	new client_died = GetClientOfUserId(GetEventInt(event, "userid"));
	if(client_died == iKomutcu)
	{
		PrintToChatAll(" \x02[%s] \x07Komutçu öldü!", sPluginTagi);
		if(respawnSayisi < 3)
		{
			PrintToChatAll(" \x02[%s] \x06Komutçu \x1010 Saniye içinde \x06otomatik olarak \x0Erevlenecektir.", sPluginTagi);
			respawnAt = 1;
			respawnSayisi++;
		}
		else
			PrintToChatAll(" \x02[%s]\x06 Komutçunun 3 hakkı dolduğu için respawn atılmayacak.", sPluginTagi);
	}
}

public OnGameFrame()
{
	if(iKomutcu != 0)
	{
		if(IsClientInGame(iKomutcu))
		{
			if(!IsPlayerAlive(iKomutcu))
			{
				//if ((10 - (GetTime() - olmeZamani)) == 0)
				//	CPrintToChatAll("\x04[DrK # GaminG] \xKomutçu revlendi. %d hakkı kaldı.", 3 - respawnSayisi);
				
				if(respawnAt == 1)
				{
					olmeZamani = GetTime();
					respawnAt = 0;
				}
				if((10 - (GetTime() - olmeZamani)) > 0)
				{
					PrintCenterTextAll("<b><font color='#FFFFFF'>Komutçu </font><font color='#00FF00'>%d Saniye</font> <font color='#FFFFFF'>sonra revlenecek!</font></b>", 10 - (GetTime() - olmeZamani));
					//PrintToConsole(iKomutcu, "Gettime: %d , olmeZamani: %d", GetTime(), olmeZamani);
				}
				else if ((10 - (GetTime() - olmeZamani)) == 0)
				{
					new String:sPluginTagi[64];
					GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));

					PrintToChatAll(" \x02[%s] \x06Komutçu revlendi. \x07%d rev hakkı \x06kaldı.", sPluginTagi, 3 - respawnSayisi);
					CS_RespawnPlayer(iKomutcu);
				}
			}
		}		
	}
}

public Action:Event_Round_Start(Handle:event, const String:name[], bool:dontBroadcast) 
{
	respawnSayisi = 0;
	iKomutcu = 0;
	OyunOynaniyor = true;
}

public Action:Event_Round_End(Handle:event, const String:name[], bool:dontBroadcast) 
{
	respawnSayisi = 0;
	iKomutcu = 0;
	OyunOynaniyor = false;
}

public Action Hatirlatma(Handle timer)
{
	if(iKomutcu < 1 && OyunOynaniyor)
	{
		for(int i = 1; i<=MaxClients; i++)
		{
			if(!IsClientConnected(i)) continue;
			if(!IsClientInGame(i)) continue;
			if(IsClientInGame(i))
			{
				if(GetClientTeam(i) == 3)
				{
					//PrintToChat(i, " \x02[DrK # GaminG] \x06Komutçu iseniz respawn alabilmek için \x0E!w \x06yazmayı unutmayın.");
					PrintCenterText(i, "<b><font color='#00FF00'>Komutçu iseniz respawn alabilmek için </font><font color='#FF00FF'>!w</font> <font color='#00FF00'>yazmayı unutmayın.</font></b>");
				}
			}
		}
	}
}