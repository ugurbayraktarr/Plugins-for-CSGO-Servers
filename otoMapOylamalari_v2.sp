#include <sourcemod>
//#include <colors>
#include <cstrike>
#include <sdktools>
#pragma semicolon 1
#define SARKISAYISI 7

public Plugin:myinfo = 
{
	name = "DrK # GaminG - Otomatik Map Oylamaları Sistemi",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "4.0.1"
}

float karartmaSuresi;
new const String:FULL_SOUND_PATH[SARKISAYISI][128];
new const String:RELATIVE_SOUND_PATH[SARKISAYISI][128];

new const String:FULL_SOUND_PATH_DUR[] = "sound/misc/drkozelses/sarkikapat.mp3";
new const String:RELATIVE_SOUND_PATH_DUR[] = "*/misc/drkozelses/sarkikapat.mp3";

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
	
	RegAdminCmd("sm_mapoyla", Command_AdminMapOyla, ADMFLAG_GENERIC);
	CreateTimer(7.0, Cvarlar);
	HookEvent("round_end", Event_RoundEnd);
	HookEvent("round_start", Event_RoundStart);
}

public Action:Command_AdminMapOyla(client, args)
{
	MapDegisKalOyla();
}

public OnMapStart()
{
	CreateTimer(7.0, Cvarlar);
	
	FULL_SOUND_PATH[0] = "sound/misc/drkozelses/CheapThrills.mp3";
	RELATIVE_SOUND_PATH[0] = "*/misc/drkozelses/CheapThrills.mp3";
	FULL_SOUND_PATH[1] = "sound/misc/drkozelses/Ego.mp3";
	RELATIVE_SOUND_PATH[1] = "*/misc/drkozelses/Ego.mp3";
	FULL_SOUND_PATH[2] = "sound/misc/drkozelses/GunahBenim.mp3";
	RELATIVE_SOUND_PATH[2] = "*/misc/drkozelses/GunahBenim.mp3";
	FULL_SOUND_PATH[3] = "sound/misc/drkozelses/india.mp3";
	RELATIVE_SOUND_PATH[3] = "*/misc/drkozelses/india.mp3";
	FULL_SOUND_PATH[4] = "sound/misc/drkozelses/LeanOn.mp3";
	RELATIVE_SOUND_PATH[4] = "*/misc/drkozelses/LeanOn.mp3";
	FULL_SOUND_PATH[5] = "sound/misc/drkozelses/Work.mp3";
	RELATIVE_SOUND_PATH[5] = "*/misc/drkozelses/Work.mp3";
	FULL_SOUND_PATH[6] = "sound/misc/drkozelses/WorthIt.mp3";
	RELATIVE_SOUND_PATH[6] = "*/misc/drkozelses/WorthIt.mp3";
	
	
	new i;
	for(i=0;i<SARKISAYISI;i++)
	{
		AddFileToDownloadsTable( FULL_SOUND_PATH[i] );
		FakePrecacheSound( RELATIVE_SOUND_PATH[i] );
	}
	
	AddFileToDownloadsTable( FULL_SOUND_PATH_DUR );
	FakePrecacheSound( RELATIVE_SOUND_PATH_DUR );
}

stock FakePrecacheSound( const String:szPath[] )
{
	AddToStringTable( FindStringTable( "soundprecache" ), szPath );
}

public Action Cvarlar(Handle timer)
{
	ServerCommand("mp_endmatch_votenextmap 0");
	ServerCommand("mp_maxrounds 31");
	ServerCommand("mp_halftime 1");
	ServerCommand("mp_endmatch_votenextmap 0");
	ServerCommand("mp_endmatch_votenextleveltime 5");
	ServerCommand("sm_cvar sm_vote_progress_hintbox 1");
}

public Action:Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	new kisiSay = 0;
	for(new i = 1; i<=MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			if(IsClientConnected(i) && GetClientTeam(i) > 1)
			{
				kisiSay++;
			}
		}
	}
	if(GetTeamScore(2) == 0 && GetTeamScore(3) == 0)
	{
		ServerCommand("mp_endmatch_votenextmap 0");
		ServerCommand("mp_maxrounds 31");
		ServerCommand("mp_halftime 1");
		ServerCommand("mp_endmatch_votenextmap 0");
		ServerCommand("mp_endmatch_votenextleveltime 5");
	}
	if(GetTeamScore(2) == 15 || GetTeamScore(3) == 15)
	{
		ServerCommand("sm plugins unload banOyla");
		ServerCommand("mp_timelimit 9999");
		ServerCommand("mp_maxrounds 0");
		ServerCommand("mp_halftime 0");
	}
	if(GetTeamScore(2) == 16 || GetTeamScore(3) == 16)
	{
		CreateTimer(0.25, OylamaTetikleBlind);
		CreateTimer(5.0, OylamaTetikle);
	}
	return Plugin_Continue;
}
public Action OylamaTetikleBlind(Handle timer)
{
	ServerCommand("sm_blind @all 999");
	CreateTimer(10.0, TSReklam);
	CreateTimer(12.0, TSReklam);
	CreateTimer(14.0, TSReklam);
	CreateTimer(16.0, TSReklam);
	CreateTimer(20.0, TSReklam);
	CreateTimer(22.0, TSReklam);
	CreateTimer(24.0, TSReklam);
	CreateTimer(26.0, TSReklam);
	
	CreateTimer(karartmaSuresi, BlindKapat);
	PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>Map oylaması için hazır olun!</font>");
	CreateTimer(1.0, TekrarYaz);
	CreateTimer(2.0, TekrarYaz);
	CreateTimer(3.0, TekrarYaz);
	ServerCommand("sm plugins unload afkSlay");
	
	new random = GetRandomInt(0, SARKISAYISI-1);
	
	for(new i=1;i<=MaxClients;i++)
	{
		if(!IsClientConnected(i)) continue;
		if(!IsClientInGame(i)) continue;
		if(IsFakeClient(i)) continue;
		
		EmitSoundToClient(i, RELATIVE_SOUND_PATH[random]);
	}
}

public Action TekrarYaz(Handle timer)
{
	ServerCommand("sm_strip @all");
	PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>Map oylaması için hazır olun!</font>");
}
	
public Action TSReklam(Handle timer)
{
	PrintCenterTextAll("<font color='#00FFFF'>DrK # GaminG</font> <font color='#FF0000'>iyi oyunlar diler.</font>");
	//PrintCenterTextAll("<font color='#00FFFF'>Adminlik ve VIP satışları İLETİŞİM > teamspeak : </font> <font color='#FF0000'>ts3.sqgaming.com</font>");
}

public Action TSReklam2(Handle timer)
{
	//PrintCenterTextAll("<font color='#00FF00'>TS3 Adresimiz:</font> <font color='#FF0000'>ts.drk-gaming.net</font>");
}

public Action BlindKapat(Handle timer)
{
	ServerCommand("sm_blind @all 0");
	ServerCommand("sm_strip @all");
	for(new i=1;i<=MaxClients;i++)
	{
		if(!IsClientConnected(i)) continue;
		if(!IsClientInGame(i)) continue;
		if(IsFakeClient(i)) continue;
		EmitSoundToClient( i, RELATIVE_SOUND_PATH_DUR );
	}
}

public Action OylamaTetikle(Handle timer)
{
	MapDegisKalOyla();
}
/*
bool:IsPlayerGenericAdmin(client)
{
    if (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC, false))
    {
        return true;
    }
    return false;
}*/

public Action Event_RoundEnd(Handle event, char[] name, bool dontBroadcast)
{
	new kisiSay = 0;
	for(new i = 1; i<=MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			if(IsClientConnected(i) && GetClientTeam(i) > 1)
			{
				kisiSay++;
			}
		}
	}
	if(GetTeamScore(2) == 16 || GetTeamScore(3) == 16)
	{
		if((((GetTime() + 10800) % 86400) >= 5400) && ((GetTime() + 10800) % 86400) <= 39600)
		{
			PrintToChatAll(" \x02[DrK # GaminG] \x10Şuan saat 1:30-11:00 arasında olduğundan \x04 Dust2 \x10açılıyor.");
			ServerCommand("mp_timelimit 0");
			ServerCommand("mp_maxrounds 0");
			ServerCommand("sm_drkmap de_dust2");
		}
		if(kisiSay < 20)
		{
			PrintToChatAll(" \x02[DrK # GaminG] \x10Yeterli sayıda oyuncu olmadığı için\x04 Dust2 \x10açılıyor.");
			ServerCommand("mp_timelimit 0");
			ServerCommand("mp_maxrounds 0");
			ServerCommand("sm_drkmap de_dust2");
		}
		else
		{
			ServerCommand("sm_troll knife");
			if (kisiSay < 36)
			{
				ServerCommand("mp_freezetime 40");
				karartmaSuresi = 40.0;
			}
			else
			{
				ServerCommand("mp_freezetime 55");
				karartmaSuresi = 55.0;
			}
		}
	}
	if(GetTeamScore(2) > 2 || GetTeamScore(3) > 2)
	{
		if(kisiSay < 15)
		{
			decl String:mapName[64];
			GetCurrentMap(mapName, sizeof(mapName));
			if(!StrEqual(mapName, "de_dust2", false))
			{
				PrintToChatAll(" \x02[DrK # GaminG] \x10Serverda yeterli oyuncu bulunmadığı için, \x04dust2 \x10açılıyor.");
				//PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Dust2</font> <font color='#00FFFF'>açılacaktır.</font>");
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_dust2");
			}
		}
	}
	return Plugin_Continue;
}

void MapDegisKalOyla()
{
	if (IsVoteInProgress())
	{
		return;
	}
 
	Menu menu = new Menu(Handle_VoteMenu);
	menu.SetTitle("[DrK # GaminG] Map değiştirilsin mi?");
	menu.AddItem("yes", "Evet, değiştirelim.");
	menu.AddItem("no", "Hayır, tekrar oynayalım.");
	menu.ExitButton = false;
	menu.DisplayVoteToAll(20);
}

public int Handle_VoteMenu(Menu menu, MenuAction action, int param1,int param2)
{
	if (action == MenuAction_End)
	{
		/* This is called after VoteEnd */
		delete menu;
	} else if (action == MenuAction_VoteEnd) {
		/* 0=yes, 1=no */
		if (param1 == 0)
		{
			new kisiSay = 0;
			for(new i = 1; i<=MaxClients; i++)
			{
				if(IsClientInGame(i))
				{
					if(IsClientConnected(i) && GetClientTeam(i) > 1)
					{
						kisiSay++;
					}
				}
			}
			if(kisiSay > 30)
				KlasikFarkliOyla();
			else
				KlasikMaplariOyla();
		}
		if (param1 == 1)
		{
			decl String:mapName[64];
			GetCurrentMap(mapName, sizeof(mapName));
			ServerCommand("mp_timelimit 0");
			ServerCommand("mp_maxrounds 0");
			ServerCommand("sm_drkmap %s", mapName);
			
		}
	}
}


void KlasikFarkliOyla()
{
	if (IsVoteInProgress())
	{
		return;
	}
 
	Menu menuKF = new Menu(Handle_VoteMenuKF);
	menuKF.SetTitle("[DrK # GaminG] Ne tür bir harita istiyorsunuz?");
	menuKF.AddItem("klasik", "Klasik haritalardan açalım");
	menuKF.AddItem("farkli", "Farklı haritalardan açalım");
	menuKF.ExitButton = false;
	menuKF.DisplayVoteToAll(20);
}

public int Handle_VoteMenuKF(Menu menuKF, MenuAction action, int param1,int param2)
{
	if (action == MenuAction_End)
	{
		/* This is called after VoteEnd */
		delete menuKF;
	} else if (action == MenuAction_VoteEnd) {
		/* 0=yes, 1=no */
		if (param1 == 0)
		{
			KlasikMaplariOyla();
		}
		if (param1 == 1)
		{
			FarkliMaplariOyla();
		}
	}
}
 
void KlasikMaplariOyla()
{
	//mapOylamasiYapildi = 1;
	if (IsVoteInProgress())
	{
		return;
	}
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	if(StrEqual(mapName, "de_dust2", false))
	{
		Menu menu2 = new Menu(Handle_VoteMenu2);
		menu2.SetTitle("[DrK # GaminG] Hangi mapı oynamak istersiniz?");
		menu2.AddItem("inferno", "Inferno");
		menu2.AddItem("mirage", "Mirage");
		menu2.AddItem("cache", "Cache");
		menu2.AddItem("westwood", "Westwood");
		menu2.ExitButton = false;
		menu2.DisplayVoteToAll(20);
	}
	else if(StrEqual(mapName, "de_inferno", false))
	{
		Menu menu2 = new Menu(Handle_VoteMenu2);
		menu2.SetTitle("[DrK # GaminG] Hangi mapı oynamak istersiniz?");
		menu2.AddItem("mirage", "Mirage");
		menu2.AddItem("cache", "Cache");
		menu2.AddItem("westwood", "Westwood");
		menu2.AddItem("dust2", "Dust2");
		menu2.ExitButton = false;
		menu2.DisplayVoteToAll(20);
	}
	else if(StrEqual(mapName, "de_mirage", false))
	{
		Menu menu2 = new Menu(Handle_VoteMenu2);
		menu2.SetTitle("[DrK # GaminG] Hangi mapı oynamak istersiniz?");
		menu2.AddItem("inferno", "Inferno");
		menu2.AddItem("cache", "Cache");
		menu2.AddItem("westwood", "Westwood");
		menu2.AddItem("dust2", "Dust2");
		menu2.ExitButton = false;
		menu2.DisplayVoteToAll(20);
	}
	else if(StrEqual(mapName, "de_cache", false))
	{
		Menu menu2 = new Menu(Handle_VoteMenu2);
		menu2.SetTitle("[DrK # GaminG] Hangi mapı oynamak istersiniz?");
		menu2.AddItem("inferno", "Inferno");
		menu2.AddItem("mirage", "Mirage");
		menu2.AddItem("westwood", "Westwood");
		menu2.AddItem("dust2", "Dust2");
		menu2.ExitButton = false;
		menu2.DisplayVoteToAll(20);
	}
	else if(StrEqual(mapName, "de_westwood", false))
	{
		Menu menu2 = new Menu(Handle_VoteMenu2);
		menu2.SetTitle("[DrK # GaminG] Hangi mapı oynamak istersiniz?");
		menu2.AddItem("inferno", "Inferno");
		menu2.AddItem("mirage", "Mirage");
		menu2.AddItem("cache", "Cache");
		menu2.AddItem("dust2", "Dust2");
		menu2.ExitButton = false;
		menu2.DisplayVoteToAll(20);
	}
	else
	{
		Menu menu2 = new Menu(Handle_VoteMenu2);
		menu2.SetTitle("[DrK # GaminG] Hangi mapı oynamak istersiniz?");
		menu2.AddItem("inferno", "Inferno");
		menu2.AddItem("mirage", "Mirage");
		menu2.AddItem("cache", "Cache");
		menu2.AddItem("westwood", "Westwood");
		menu2.AddItem("dust2", "Dust2");
		menu2.ExitButton = false;
		menu2.DisplayVoteToAll(20);
	}
}

public int Handle_VoteMenu2(Menu menu2, MenuAction action, int param1,int param2)
{
	if (action == MenuAction_End)
	{
		/* This is called after VoteEnd */
		delete menu2;
	} else if (action == MenuAction_VoteEnd) {
		/* 0=yes, 1=no */
		if (param1 == 0)
		{
			decl String:secilenMap[64];
			menu2.GetItem(param1, secilenMap, sizeof(secilenMap));
			if(StrContains(secilenMap, "dust2", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_dust2");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Dust2 \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Dust2</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "inferno", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_inferno");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Inferno \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Inferno</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "mirage", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_mirage");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Mirage \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Mirage</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "cache", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_cache");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Cache \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Cache</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "westwood", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_westwood");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Westwood \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Westwood</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
		}
		if (param1 == 1)
		{
			decl String:secilenMap[64];
			menu2.GetItem(param1, secilenMap, sizeof(secilenMap));
			if(StrContains(secilenMap, "dust2", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_dust2");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Dust2 \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Dust2</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "inferno", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_inferno");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Inferno \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Inferno</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "mirage", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_mirage");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Mirage \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Mirage</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "cache", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_cache");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Cache \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Cache</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "westwood", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_westwood");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Westwood \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Westwood</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
		}
		if (param1 == 2)
		{
			decl String:secilenMap[64];
			menu2.GetItem(param1, secilenMap, sizeof(secilenMap));
			if(StrContains(secilenMap, "dust2", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_dust2");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Dust2 \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Dust2</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "inferno", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_inferno");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Inferno \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Inferno</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "mirage", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_mirage");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Mirage \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Mirage</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "cache", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_cache");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Cache \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Cache</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "westwood", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_westwood");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Westwood \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Westwood</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
		}
		if (param1 == 3)
		{
			decl String:secilenMap[64];
			menu2.GetItem(param1, secilenMap, sizeof(secilenMap));
			if(StrContains(secilenMap, "dust2", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_dust2");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Dust2 \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Dust2</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "inferno", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_inferno");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Inferno \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Inferno</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "mirage", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_mirage");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Mirage \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Mirage</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "cache", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_cache");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Cache \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Cache</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "westwood", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_westwood");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Westwood \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Westwood</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
		}
		if (param1 == 4)
		{
			decl String:secilenMap[64];
			menu2.GetItem(param1, secilenMap, sizeof(secilenMap));
			if(StrContains(secilenMap, "dust2", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_dust2");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Dust2 \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Dust2</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "inferno", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_inferno");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Inferno \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Inferno</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "mirage", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_mirage");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Mirage \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Mirage</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "cache", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_cache");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Cache \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Cache</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "westwood", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_westwood");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Westwood \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Westwood</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
		}
	}
}


void FarkliMaplariOyla()
{
	//mapOylamasiYapildi = 1;
	if (IsVoteInProgress())
	{
		return;
	}
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	if(StrEqual(mapName, "cs_downtown", false))
	{
		Menu menufarkli = new Menu(Handle_VoteMenuFarkli);
		menufarkli.SetTitle("[DrK # GaminG] Hangi mapı oynamak istersiniz?");
		menufarkli.AddItem("cs_assault", "Assault");
		menufarkli.AddItem("mirage", "Aztec");
		menufarkli.AddItem("cbble", "Cobblestone");
		menufarkli.AddItem("westwood", "Madmax");
		menufarkli.ExitButton = false;
		menufarkli.DisplayVoteToAll(20);
	}
	else if(StrEqual(mapName, "cs_assault", false))
	{
		Menu menufarkli = new Menu(Handle_VoteMenuFarkli);
		menufarkli.SetTitle("[DrK # GaminG] Hangi mapı oynamak istersiniz?");
		menufarkli.AddItem("cs_downtown", "Downtown");
		menufarkli.AddItem("mirage", "Aztec");
		menufarkli.AddItem("cbble", "Cobblestone");
		menufarkli.AddItem("westwood", "Madmax");
		menufarkli.ExitButton = false;
		menufarkli.DisplayVoteToAll(20);
	}
	else if(StrEqual(mapName, "de_aztec", false))
	{
		Menu menufarkli = new Menu(Handle_VoteMenuFarkli);
		menufarkli.SetTitle("[DrK # GaminG] Hangi mapı oynamak istersiniz?");
		menufarkli.AddItem("cs_downtown", "Downtown");
		menufarkli.AddItem("cs_assault", "Assault");
		menufarkli.AddItem("cbble", "Cobblestone");
		menufarkli.AddItem("westwood", "Madmax");
		menufarkli.ExitButton = false;
		menufarkli.DisplayVoteToAll(20);
	}
	else if(StrEqual(mapName, "de_cbble", false))
	{
		Menu menufarkli = new Menu(Handle_VoteMenuFarkli);
		menufarkli.SetTitle("[DrK # GaminG] Hangi mapı oynamak istersiniz?");
		menufarkli.AddItem("cs_downtown", "Downtown");
		menufarkli.AddItem("cs_assault", "Assault");
		menufarkli.AddItem("mirage", "Aztec");
		menufarkli.AddItem("westwood", "Madmax");
		menufarkli.ExitButton = false;
		menufarkli.DisplayVoteToAll(20);
	}
	else if(StrEqual(mapName, "mm_madmax_v2", false))
	{
		Menu menufarkli = new Menu(Handle_VoteMenuFarkli);
		menufarkli.SetTitle("[DrK # GaminG] Hangi mapı oynamak istersiniz?");
		menufarkli.AddItem("cs_downtown", "Downtown");
		menufarkli.AddItem("cs_assault", "Assault");
		menufarkli.AddItem("mirage", "Aztec");
		menufarkli.AddItem("cbble", "Cobblestone");
		menufarkli.ExitButton = false;
		menufarkli.DisplayVoteToAll(20);
	}
	else
	{
		Menu menufarkli = new Menu(Handle_VoteMenuFarkli);
		menufarkli.SetTitle("[DrK # GaminG] Hangi mapı oynamak istersiniz?");
		menufarkli.AddItem("cs_downtown", "Downtown");
		menufarkli.AddItem("cs_assault", "Assault");
		menufarkli.AddItem("mirage", "Aztec");
		menufarkli.AddItem("cbble", "Cobblestone");
		menufarkli.AddItem("westwood", "Madmax");
		menufarkli.ExitButton = false;
		menufarkli.DisplayVoteToAll(20);
	}
}

public int Handle_VoteMenuFarkli(Menu menufarkli, MenuAction action, int param1,int param2)
{
	if (action == MenuAction_End)
	{
		/* This is called after VoteEnd */
		delete menufarkli;
	} else if (action == MenuAction_VoteEnd) {
		/* 0=yes, 1=no */
		if (param1 == 0)
		{
			decl String:secilenMap[64];
			menufarkli.GetItem(param1, secilenMap, sizeof(secilenMap));
			if(StrContains(secilenMap, "cs_downtown", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap cs_downtown");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Downtown \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Downtown</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "cs_assault", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap cs_assault");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Assault \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Assault</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "mirage", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_aztec");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Aztec \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Aztec</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "cbble", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_cbble");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Cobblestone \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Cobblestone</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "westwood", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap mm_madmax_v2");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Madmax \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Madmax</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
		}
		if (param1 == 1)
		{
			decl String:secilenMap[64];
			menufarkli.GetItem(param1, secilenMap, sizeof(secilenMap));
			if(StrContains(secilenMap, "cs_downtown", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap cs_downtown");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Downtown \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Downtown</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "cs_assault", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap cs_assault");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Assault \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Assault</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "mirage", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_aztec");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Aztec \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Aztec</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "cbble", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_cbble");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Cobblestone \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Cobblestone</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "westwood", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap mm_madmax_v2");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Madmax \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Madmax</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
		}
		if (param1 == 2)
		{
			decl String:secilenMap[64];
			menufarkli.GetItem(param1, secilenMap, sizeof(secilenMap));
			if(StrContains(secilenMap, "cs_downtown", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap cs_downtown");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Downtown \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Downtown</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "cs_assault", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap cs_assault");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Assault \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Assault</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "mirage", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_aztec");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Aztec \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Aztec</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "cbble", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_cbble");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Cobblestone \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Cobblestone</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "westwood", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap mm_madmax_v2");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Madmax \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Madmax</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
		}
		if (param1 == 3)
		{
			decl String:secilenMap[64];
			menufarkli.GetItem(param1, secilenMap, sizeof(secilenMap));
			if(StrContains(secilenMap, "cs_downtown", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap cs_downtown");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Downtown \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Downtown</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "cs_assault", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap cs_assault");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Assault \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Assault</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "mirage", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_aztec");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Aztec \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Aztec</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "cbble", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_cbble");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Cobblestone \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Cobblestone</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "westwood", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap mm_madmax_v2");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Madmax \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Madmax</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
		}
		if (param1 == 4)
		{
			decl String:secilenMap[64];
			menufarkli.GetItem(param1, secilenMap, sizeof(secilenMap));
			if(StrContains(secilenMap, "cs_downtown", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap cs_downtown");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Downtown \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Downtown</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "cs_assault", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap cs_assault");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Assault \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Assault</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "mirage", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_aztec");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Aztec \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Aztec</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "cbble", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap de_cbble");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Cobblestone \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Cobblestone</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
			else if(StrContains(secilenMap, "westwood", false) != -1)
			{
				ServerCommand("mp_timelimit 0");
				ServerCommand("mp_maxrounds 0");
				ServerCommand("sm_drkmap mm_madmax_v2");
				PrintToChatAll(" \x02[DrK # GaminG] \x10Oylamaların sonucuna göre el sonunda\x04 Madmax \x10açılacaktır.");
				PrintToChatAll(" \x05DrK # GaminG , iyi oyunlar diler..");
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FFFF'>El sonu</font>\n<font color='#00FF00'>Madmax</font> <font color='#00FFFF'>açılacaktır.</font>");
			}
		}
	}
}