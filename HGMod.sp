#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>
//#include <store>
//#include <colors>

#define PLUGIN_VERSION "3.0"
#define DEFAULT_TIMER_FLAGS TIMER_REPEAT|TIMER_FLAG_NO_MAPCHANGE
new Handle:g_PluginTagi = INVALID_HANDLE;

public Plugin:myinfo =
{
	name        = "DrK # GaminG ~ HG Mod",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

static int iTime;
new Float:locbuff[3];
new Float:loc[65][3];
new Float:orta[3];
new Float:Timer[65];
new Float:Zaman;
new Float:mesafe[65];
static int tlVerildi;
//new Float:spawned[65];

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
	//HookEvent("player_death", OnPlayerDeath);
	//HookEvent("round_end", Event_RoundEnd, EventHookMode_Pre);
	HookEvent("round_start", Event_Round_Start, EventHookMode_Pre);
	HookEvent("player_spawn", OnPlayerSpawn);
	HookEvent("player_death", Event_PlayerDeath);
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");

	
	ServerCommand("mp_roundtime 6");
	ServerCommand("mp_limitteams  1");
}

public OnMapStart()
{
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	
	if(!(StrContains(mapName, "hg_", false) != -1))
	{
		SetFailState("Bu plugin sadece HG maplarinda calismaktadir..");
	}
	else
	{
		ServerCommand("mp_roundtime 6");
		ServerCommand("mp_limitteams  1");
	}
}

public Action:Event_Round_Start(Handle:event, const String:name[], bool:dontBroadcast) 
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	iTime = GetTime();
	Zaman = GetEngineTime();
	ServerCommand("mp_respawn_on_death_ct 1");
	ServerCommand("mp_respawn_on_death_t 1");
	ServerCommand("mp_teammates_are_enemies 1");
	PrintToChatAll(" \x04[%s] \x02Herkese GOD verildi, \x0460 Saniye\x02 sonra kapatılacak..", sPluginTagi);
	tlVerildi = 0;
	for(new i = 1; i<=MaxClients;i++)
	{
		if(IsClientInGame(i) && IsPlayerAlive(i))
			SetEntProp(i, Prop_Data, "m_takedamage", 0, 1);
	}
}
public OnGameFrame()
{
	float now = GetEngineTime();
	if(now >= Zaman)
	{
		int iRoundTime = GetTime() - iTime;
		Zaman = now + 1.0;
		if(iRoundTime > 0 && iRoundTime < 30)
			PrintCenterTextAll("<b>%d Saniye sonra kafesler açılacak!</b>", 30 - iRoundTime);
		if(iRoundTime == 30)
			PrintCenterTextAll("<b>Kafesler Açıldı!</b>");
		if(iRoundTime > 30 && iRoundTime < 60)
			PrintCenterTextAll("<b>%d Saniye sonra god kapatılacak!</b>", 60 - iRoundTime);
		
		/*if(iRoundTime == 50)
			PrintCenterTextAll("10 Saniye sonra god kapatılacak!");
		if(iRoundTime == 51)
			PrintCenterTextAll("9 Saniye sonra god kapatılacak!");
		if(iRoundTime == 52)
			PrintCenterTextAll("8 Saniye sonra god kapatılacak!");
		if(iRoundTime == 53)
			PrintCenterTextAll("7 Saniye sonra god kapatılacak!");
		if(iRoundTime == 54)
			PrintCenterTextAll("6 Saniye sonra god kapatılacak!");
		if(iRoundTime == 55)
			PrintCenterTextAll("5 Saniye sonra god kapatılacak!");
		if(iRoundTime == 56)
			PrintCenterTextAll("4 Saniye sonra god kapatılacak!");
		if(iRoundTime == 57)
			PrintCenterTextAll("3 Saniye sonra god kapatılacak!");
		if(iRoundTime == 58)
			PrintCenterTextAll("2 Saniye sonra god kapatılacak!");
		if(iRoundTime == 59)
			PrintCenterTextAll("1 Saniye sonra god kapatılacak!");*/
		if(iRoundTime == 60)
			GodKapat();
		if(iRoundTime > 210 && iRoundTime < 240)
			PrintCenterTextAll("<b>%d Saniye içinde ortada olmalısınız!</b>", 240 - iRoundTime);
		if(iRoundTime == 150)
			BeaconVer();
		if(iRoundTime == 240)
			OrtayaGit();
			
		
		decl String:kazananIsim[32];
		int kisiSay = 0;
		int yasayan;
		int yasayanSay = 0;
		
		for(new i = 1; i<=MaxClients; i++)
		{
			if(IsClientInGame(i))
			{
				if(IsClientConnected(i) && GetClientTeam(i) > 1)
				{
					kisiSay++;
					if(IsPlayerAlive(i))
						yasayanSay++;
				}
			}
		}

		if(yasayanSay == 1 && kisiSay > 4 && tlVerildi == 0 && iRoundTime >= 90)
		{
			tlVerildi = 1;
			/*int tlHesapla = GetClientCount() * 4;
			if (tlHesapla > 60)
				tlHesapla = 60;*/

			for(int i = 1; i <= MaxClients; i++) 
			{
				if(IsClientInGame(i))
				{
					//PrintToChatAll("Test: %d", i);
					//PrintToChat(i, " \x04[DrK # GaminG] \x02TL kazanma sistemi \x04ImPossibLe` \x02Tarafından kodlanmıştır.");
					if(IsClientConnected(i) && IsPlayerAlive(i))
					{
						//PrintToChat(i, " \x04[DrK # GaminG] \x02HG Kazanma TL'si \x04%d TL \x02kazandınız.", tlHesapla * 6);
						//int id = Store_GetClientAccountID(i);
						//Store_GiveCredits(id, (tlHesapla * 6));
						yasayan = i;
					}
					/*else if (IsClientConnected(i) && !IsPlayerAlive(i))
					{
						PrintToChat(i, " \x04[DrK # GaminG] \x02HG Kaybetme Teselli TL'si \x04%d TL \x02kazandınız.", tlHesapla);
						int id = Store_GetClientAccountID(i);
						Store_GiveCredits(id, (tlHesapla));
					}*/
				}
			}
			new String:sPluginTagi[64];
			GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
			GetClientName(yasayan, kazananIsim, sizeof(kazananIsim));
			PrintToChatAll(" \x04[%s] \x02%s \x04kazandı.", sPluginTagi, kazananIsim);
			CreateTimer(2.0, SlayCek, yasayan);
		}
		/*
		int yasayanSay = 0;
		int kisiSay = 0;
		int yasayan;
		for(new i = 1; i<=MaxClients; i++)
		{
			if(IsClientConnected(i) && IsClientInGame(i)  && GetClientTeam(i) > 1)
			{
				kisiSay++;
				if(IsPlayerAlive(i))
					yasayanSay++;
			}
		}
	
		if(yasayanSay == 1 && kisiSay > 4 && tlVerildi == 0)
		{
			tlVerildi = 1;
			int tlHesapla = GetClientCount() * 4;
			if (tlHesapla > 60)
				tlHesapla = 60;
	
			int i = 1;
			while (i <= MaxClients)
			{
				if(IsClientInGame(i))
				{
					CPrintToChat(i, "\x04[DrK # GaminG] \x02TL kazanma sistemi \x04ImPossibLe` \x02Tarafından kodlanmıştır.");
					if(IsClientConnected(i) && IsClientInGame(i) && IsPlayerAlive(i))
					{
						CPrintToChat(i, "\x04[DrK # GaminG] \x02HG Kazanma TL'si \x04%d TL \x02kazandınız.", tlHesapla * 6);
						int id = Store_GetClientAccountID(i);
						Store_GiveCredits(id, (tlHesapla * 6));
						yasayan = i;
					}
					else if (IsClientConnected(i) && IsClientInGame(i) && !IsPlayerAlive(i))
					{
						GetClientName(i, kazananIsim, sizeof(kazananIsim));
						CPrintToChat(i, "\x04[DrK # GaminG] \x02HG Kaybetme Teselli TL'si \x04%d TL \x02kazandınız.", tlHesapla);
						CPrintToChat(i, "\x04[DrK # GaminG] \x02%s \x04%d TL \x04kazandı.", kazananIsim, tlHesapla * 6);
						int id = Store_GetClientAccountID(i);
						Store_GiveCredits(id, (tlHesapla));
					}
					i++;
				}
			}
			CreateTimer(1.0, SlayCek, yasayan);
		}
		*/
	}
}

public GodKapat()
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	ServerCommand("mp_respawn_on_death_ct 0");
	ServerCommand("mp_respawn_on_death_t 0");
	ServerCommand("sm_god @all 0");
	PrintCenterTextAll("GOD Kapatıldı!");
	PrintToChatAll(" \x04[%s] \x02GOD \x04kapatıldı\x02, bol şans..", sPluginTagi);
	PrintToChatAll(" \x04[%s] \x02Beacon, \x0490 Saniye\x02 sonra verilecek.", sPluginTagi);
	PrintToChatAll(" \x04[%s] \x02Beacon verilince \x04Takımlar bozulur.", sPluginTagi);
	for(new i = 1; i<=MaxClients;i++)
	{
		if(IsClientInGame(i))
		{
			if(IsPlayerAlive(i))	
				SetEntProp(i, Prop_Data, "m_takedamage", 2, 1);	
		}
	}
}

public Action:OnPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));	
	int iRoundTime = GetTime() - iTime;
	if(iRoundTime < 55 && IsClientConnected(client) && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) > 1)
		SetEntProp(client, Prop_Data, "m_takedamage", 0, 1);
}
/*
public OnPlayerDeath(Handle:event, const String:name[], bool:dontBroadcast){
{
	int yasayanSay = 0;
	for(new i = 0; i<=MaxClients; i++)
	if(IsClientConnected(client) && IsClientInGame(client) && IsPlayerAlive(client) && GetClientTeam(client) > 1)
		yasayanSay++;
	
	if(yasayanSay == 1)
	{
		CPrintToChatAll(" \x04[DrK # GaminG] \x02Yaşayan \x041 kişi \x02Ykaldığı için slay çekiliyor!");
		CreateTimer(5.0, SlayCek);
	}
}*/

public Action:SlayCek(Handle:timer, client:yasayan)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	if(IsPlayerAlive(yasayan))
		ForcePlayerSuicide(yasayan);
	//ServerCommand("sm_slay @all");
	PrintToChatAll(" \x04[%s] \x02Slay çekildi!", sPluginTagi);
}


public BeaconVer()
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	ServerCommand("sm_beacon @all");
	PrintToChatAll(" \x04[%s] \x02Beacon verildi.", sPluginTagi);
	PrintToChatAll(" \x04[%s] \x02Ortada olmanız için son \x0490 Saniye!", sPluginTagi);
	PrintCenterTextAll("Beacon verildi, takımları bozun!");
}

public OrtayaGit()
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	ServerCommand("sm_slap @all 0");
	PrintToChatAll(" \x04[%s] \x02Artık ortada olmalısınız.", sPluginTagi);
	CreateTimer(1.0, SlapTimer, _, TIMER_REPEAT);
}

public Action:SlapTimer(Handle:timer)
{
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));

	if (strcmp(mapName, "hg_forest_v1") == 0)
	{
		orta[0] = 0.0;
		orta[1] = 0.0;
		orta[2] = 16.0;
	} 
	else if (strcmp(mapName, "hg_forest_v2") == 0)
	{
		orta[0] = 0.0;
		orta[1] = 0.0;
		orta[2] = 16.0;
	} 
	else if (strcmp(mapName, "hg_forest_v3") == 0)
	{
		orta[0] = 0.0;
		orta[1] = 0.0;
		orta[2] = 16.0;
	} 
	else if (strcmp(mapName, "hg_katana_v2") == 0)
	{
		orta[0] = -600.0;
		orta[1] = -827.0;
		orta[2] = 400.0;
	}  
	else if (strcmp(mapName, "hg_tropical_f2") == 0)
	{
		orta[0] = 39.7;
		orta[1] = 3236.0;
		orta[2] = 88.0;
	}  
	
	int iRoundTime = GetTime() - iTime;

	if(iRoundTime > 240)
	{
		for(new i = 1; i<=MaxClients;i++)
		{
			if(IsClientInGame(i) && IsPlayerAlive(i))
			{
				locbuff[0] = 0.0;
				locbuff[1] = 0.0;
				locbuff[2] = 0.0;
				GetClientAbsOrigin(i, locbuff);
				loc[i][0] = locbuff[0];
				loc[i][1] = locbuff[1];
				loc[i][2] = locbuff[2];
				mesafe[i] = GetVectorDistance(orta, loc[i]);
				float now = GetEngineTime();
				if(now >= Timer[i])
				{
					Timer[i] = now + 1.0;
					{
						if(mesafe[i] > 1700)
						{
							PrintCenterText(i, "Ortaya gittiğinizde tokatlanma duracak!");
							PrintToChat(i, " \x04[%s] \x02Ortada olmadığınız için tokatlanıyorsunuz!", sPluginTagi);
							SlapPlayer(i, 2, true);
						}
					}
				}
			}
		}
	}
	return Plugin_Continue;
}

/*
public Action Event_RoundEnd(Handle event, char[] name, bool dontBroadcast)
{
	decl String:kazananIsim[32];
	int kisiSay = 0;
	int yasayan;
	for(new i = 1; i<=MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			if(IsClientConnected(i) && GetClientTeam(i) > 1)
				kisiSay++;
		}
	}

	if(kisiSay > 4)
	{
		int tlHesapla = GetClientCount() * 4;
		if (tlHesapla > 60)
			tlHesapla = 60;

		int i = 1;
		while (i <= MaxClients)
		{
			if(IsClientInGame(i))
			{
				CPrintToChat(i, "\x04[DrK # GaminG] \x02TL kazanma sistemi \x04ImPossibLe` \x02Tarafından kodlanmıştır.");
				if(IsClientConnected(i) && IsPlayerAlive(i))
				{
					CPrintToChat(i, "\x04[DrK # GaminG] \x02HG Kazanma TL'si \x04%d TL \x02kazandınız.", tlHesapla * 6);
					int id = Store_GetClientAccountID(i);
					Store_GiveCredits(id, (tlHesapla * 6));
					yasayan = i;
				}
				else if (IsClientConnected(i) && !IsPlayerAlive(i))
				{
					GetClientName(i, kazananIsim, sizeof(kazananIsim));
					CPrintToChat(i, "\x04[DrK # GaminG] \x02HG Kaybetme Teselli TL'si \x04%d TL \x02kazandınız.", tlHesapla);
					CPrintToChat(i, "\x04[DrK # GaminG] \x02%s \x04%d TL \x04kazandı.", kazananIsim, tlHesapla * 6);
					int id = Store_GetClientAccountID(i);
					Store_GiveCredits(id, (tlHesapla));
				}
				i++;
			}
		}
		CreateTimer(1.0, SlayCek, yasayan);
	}
}*/
/*
TLVerTekKisi()
{
	int tlHesapla = GetClientCount() * 4;
	if (tlHesapla > 60)
		tlHesapla = 60;
	
	for(new i=1; i<MaxClients;i++)
	{
		CPrintToChat(i, "\x04[DrK # GaminG] \x02TL kazanma sistemi \x04ImPossibLe` \x02Tarafından kodlanmıştır.");
		if(IsClientConnected(i) && IsClientInGame(i) && IsPlayerAlive(i))
		{
			CPrintToChat(i, "\x04[DrK # GaminG] \x02HG Kazanma TL'si \x04%d TL \x02kazandınız.", tlHesapla * 6);
			int id = Store_GetClientAccountID(i);
			Store_GiveCredits(id, (tlHesapla * 6));
		}
		else if (IsClientConnected(i) && IsClientInGame(i) && !IsPlayerAlive(i))
		{
			CPrintToChat(i, "\x04[DrK # GaminG] \x02HG Kaybetme Teselli TL'si \x04%d TL \x02kazandınız.", tlHesapla);
			CPrintToChat(i, "\x04[DrK # GaminG] \x02Kazanan kişi \x04%d TL \x02kazandı.", tlHesapla * 6);
			int id = Store_GetClientAccountID(i);
			Store_GiveCredits(id, (tlHesapla));
		}
	}
}*/

public Action:Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	decl String:diedIsim[32];
	decl String:killerIsim[32];
	new client_died = GetClientOfUserId(GetEventInt(event, "userid"));
	new client_killer = GetClientOfUserId(GetEventInt(event, "attacker"));
	new bool:headshot = GetEventBool(event, "headshot");
	new ilkHp = GetClientHealth(client_killer);
	
	GetClientName(client_died, diedIsim, sizeof(diedIsim));
	GetClientName(client_killer, killerIsim, sizeof(killerIsim));
	int kisiSay = 0;
	int yasayanSay = 0;
	
	for(new i = 1; i<=MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			if(IsClientConnected(i) && GetClientTeam(i) > 1)
			{
				kisiSay++;
				if(IsPlayerAlive(i))
					yasayanSay++;
			}
		}
	}
	//int miktar = kisiSay / yasayanSay;
	if(client_died > 0 && client_killer > 0 && client_died != client_killer)
	{
		PrintToChatAll(" \x04[%s] \x02%s \x04, \x02%s \x04tarafından öldürüldü.", sPluginTagi, diedIsim, killerIsim);
		if (headshot)
		{
			new sonHp = ilkHp + 25;
			//PrintToChatAll(" \x04[DrK # GaminG] \x02%s \x04, \x02%d TL \x04kazandı.", killerIsim, (miktar * 2));
			PrintToChatAll(" \x04[%s] \x02%s \x04, \x02%d HP \x04kazandı.", sPluginTagi, killerIsim, 25);
			PrintToChatAll(" \x04[%s] \x02HS Attığı için \x06, \x04bonus HP verildi.", sPluginTagi, killerIsim, 10);
			//int id = Store_GetClientAccountID(client_killer);
			//Store_GiveCredits(id, (miktar * 2));
			SetEntityHealth(client_killer, sonHp);
		}
		else 
		{
			new sonHp = ilkHp + 10;
			//PrintToChatAll(" \x04[DrK # GaminG] \x02%s \x04, \x02%d TL \x04kazandı.", killerIsim, miktar);
			PrintToChatAll(" \x04[%s] \x02%s \x04, \x02%d HP \x04kazandı.", sPluginTagi, killerIsim, 10);
			//int id = Store_GetClientAccountID(client_killer);
			//Store_GiveCredits(id, miktar);
			SetEntityHealth(client_killer, sonHp);
		}
	}
}