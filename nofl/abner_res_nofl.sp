#include <sourcemod>
#include <sdktools>
#include <colors>
#include <clientprefs>
#include <cstrike>

//#pragma newdecls required // 2015 rules 
#pragma semicolon 1

//MapSounds Stuff
int g_iSoundEnts[2048];
int g_iNumSounds;

//Cvars
Handle g_hCTPath;
Handle g_hTRPath;
Handle g_hPlayType;
Handle g_AbNeRCookie;
Handle g_hStop;
Handle g_roundDrawPlay;

bool clutch = false;
bool clutchIhtimali = false;
static int clutchTakimi = 1;
static int clutchSayisi = 0;
static int iClutch;

bool SoundsTRSucess = false;
bool SoundsCTSucess = false;
bool SamePath = false;
bool CSGO;
//Sounds Arrays
ArrayList ctSound;
ArrayList trSound;

public Plugin myinfo =
{
	name = "Gelişmiş Round Sonu Şarkıları",
	author = "ImPossibLe`",
	description = "Round Sonu Şarkıları",
	version = "4.0"
}

public void OnPluginStart()
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
	
	//Cvars
	g_hTRPath              = CreateConVar("res_tr_path", "misc/drkroundsonu", "Path off tr sounds in /cstrike/sound");
	g_hCTPath              = CreateConVar("res_ct_path", "misc/drkroundsonu", "Path off ct sounds in /cstrike/sound");
	g_hPlayType           = CreateConVar("res_play_type", "1", "1 - Random, 2- Play in queue");
	g_hStop                  = CreateConVar("res_stop_map_music", "1", "Stop map musics");	
	g_roundDrawPlay   = CreateConVar("res_rounddraw_play", "0", "0 - Don´t play sounds, 1 - Play TR sounds, 2 - Play CT sounds.");
	
	//ClientPrefs
	g_AbNeRCookie = RegClientCookie("AbNeR Round End Sounds", "", CookieAccess_Private);
	SetCookieMenuItem(SoundCookieHandler, 0, "AbNeR Round End Sounds");
	
	LoadTranslations("common.phrases");
	LoadTranslations("abner_res.phrases");
	AutoExecConfig(true, "abner_res");

	RegAdminCmd("res_refresh", CommandLoad, ADMFLAG_SLAY);
	RegConsoleCmd("res", abnermenu);
	
	HookConVarChange(g_hTRPath, PathChange);
	HookConVarChange(g_hCTPath, PathChange);
	HookConVarChange(g_hPlayType, PathChange);
	
	char theFolder[40];
	GetGameFolderName(theFolder, sizeof(theFolder));
	CSGO = StrEqual(theFolder, ("csgo"));
	HookEvent("round_start", Event_RoundStart, EventHookMode_PostNoCopy);
	HookEvent("round_end", Event_RoundEnd);
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
	
	ctSound = new ArrayList(512);
	trSound = new ArrayList(512);
	AddFileToDownloadsTable("sound/misc/drkclutch/15 Kisiye Saldirdim.mp3");
}

public Action Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	if(!clutchIhtimali)
	{
		if(GetTeamClientCount(2) > 5 && GetTeamClientCount(3) > 5)
		{
			new i;
			new yasayanT = 0, yasayanCT = 0;
			for(i=1; i<MaxClients; i++)
			{
				if(IsClientInGame(i))
				{
					if(IsPlayerAlive(i))
					{
						if(GetClientTeam(i) == 2)
							yasayanT++;
						if(GetClientTeam(i) == 3)
							yasayanCT++;
					}
				}
			}
			if(yasayanT == 1 && yasayanCT > 2)
			{
				clutchIhtimali = true;
				clutchTakimi = 2;
				clutchSayisi = yasayanCT;
				for(i=1; i<MaxClients; i++)
				{
					if(IsClientInGame(i))
						if(IsPlayerAlive(i) && GetClientTeam(i) == 2)
							iClutch = i;
				}
			}
			if(yasayanCT == 1 && yasayanT > 2)
			{
				clutchIhtimali = true;
				clutchTakimi = 3;
				clutchSayisi = yasayanT;
				for(i=1; i<MaxClients; i++)
				{
					if(IsClientInGame(i))
						if(IsPlayerAlive(i) && GetClientTeam(i) == 3)
							iClutch = i;
				}
			}
		}
	}
}

stock bool IsValidClient(int client)
{
	if(client <= 0 ) return false;
	if(client > MaxClients) return false;
	if(!IsClientConnected(client)) return false;
	return IsClientInGame(client);
}

public void StopMapMusic()
{
	char sSound[PLATFORM_MAX_PATH];
	int entity = INVALID_ENT_REFERENCE;
	for(int i=1;i<=MaxClients;i++){
		if(!IsClientInGame(i)){ continue; }
		for (int u=0; u<g_iNumSounds; u++){
			entity = EntRefToEntIndex(g_iSoundEnts[u]);
			if (entity != INVALID_ENT_REFERENCE){
				GetEntPropString(entity, Prop_Data, "m_iszSound", sSound, sizeof(sSound));
				Client_StopSound(i, entity, SNDCHAN_STATIC, sSound);
			}
		}
	}
}

stock void Client_StopSound(int client, int entity, int channel, const char[] name)
{
	EmitSoundToClient(client, name, entity, channel, SNDLEVEL_NONE, SND_STOP, 0.0, SNDPITCH_NORMAL, _, _, _, true);
}

public void Event_RoundEnd(Handle event, const char[] name, bool dontBroadcast)
{
	int winner = GetEventInt(event, "winner");
	int reason =  GetEventInt(event, "reason");
	if(winner == clutchTakimi)
		clutch = true;
	if(view_as<CSRoundEndReason>(reason) == CSRoundEnd_Draw)
	{
		if(GetConVarInt(g_roundDrawPlay) == 1) winner = CS_TEAM_T;
		else if(GetConVarInt(g_roundDrawPlay) == 2) winner = CS_TEAM_CT;
	}
	
	if((winner == CS_TEAM_CT && SamePath) || winner == CS_TEAM_T)
	{
		if(SoundsTRSucess)
		{
			PlaySoundTR();
		}
		else
		{
			if(!SamePath) 
			{
				PrintToServer("[AbNeR RES] TR_SOUNDS ERROR: Sounds not loaded.");
				PrintToChatAll("{green}[AbNeR RES] {default}TR_SOUNDS ERROR: Sounds not loaded.");
			}
			else
			{
				PrintToServer("[AbNeR RES] SOUNDS ERROR: Sounds not loaded.");
				PrintToChatAll("{green}[AbNeR RES] {default}SOUNDS ERROR: Sounds not loaded.");
			}
			return;
		}
	}
	else if(winner == CS_TEAM_CT)
	{
		if(SoundsCTSucess)
		{
			PlaySoundCT();
		}
		else
		{
			PrintToServer("[AbNeR RES] CT_SOUNDS ERROR: Sounds not loaded.");
			return;
		}
	}
	
	if(GetConVarInt(g_hStop) == 1)
		StopMapMusic();
}

public void Event_RoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	clutch = false;
	clutchIhtimali = false;
	clutchTakimi = 1;
	clutchSayisi = 0;
	if(GetConVarInt(g_hStop) == 1)
	{
		// Ents are recreated every round.
		g_iNumSounds = 0;
		
		// Find all ambient sounds played by the map.
		char sSound[PLATFORM_MAX_PATH];
		int entity = INVALID_ENT_REFERENCE;
		
		while ((entity = FindEntityByClassname(entity, "ambient_generic")) != INVALID_ENT_REFERENCE)
		{
			GetEntPropString(entity, Prop_Data, "m_iszSound", sSound, sizeof(sSound));
			
			int len = strlen(sSound);
			if (len > 4 && (StrEqual(sSound[len-3], "mp3") || StrEqual(sSound[len-3], "wav")))
			{
				g_iSoundEnts[g_iNumSounds++] = EntIndexToEntRef(entity);
			}
		}
	}
}

public void SoundCookieHandler(int client, CookieMenuAction action, any info, char[] buffer, int maxlen)
{
	abnermenu(client, 0);
} 

public void OnClientPutInServer(int client)
{
	CreateTimer(3.0, msg, client);
}

public Action msg(Handle timer, any client)
{
	if(IsValidClient(client))
	{
		CPrintToChat(client, "{default}{green}[ ☜ NoFL ☞ ] {default}%t", "JoinMsg");
	}
}

public Action abnermenu(int client, int args)
{
	int cookievalue = GetIntCookie(client, g_AbNeRCookie);
	Handle g_AbNeRMenu = CreateMenu(AbNeRMenuHandler);
	SetMenuTitle(g_AbNeRMenu, "Round End Sounds by AbNeR_CSS");
	char Item[128];
	if(cookievalue == 0)
	{
		Format(Item, sizeof(Item), "%t %t", "RES_ON", "Selected"); 
		AddMenuItem(g_AbNeRMenu, "ON", Item);
		Format(Item, sizeof(Item), "%t", "RES_OFF"); 
		AddMenuItem(g_AbNeRMenu, "OFF", Item);
	}
	else
	{
		Format(Item, sizeof(Item), "%t", "RES_ON");
		AddMenuItem(g_AbNeRMenu, "ON", Item);
		Format(Item, sizeof(Item), "%t %t", "RES_OFF", "Selected"); 
		AddMenuItem(g_AbNeRMenu, "OFF", Item);
	}
	SetMenuExitBackButton(g_AbNeRMenu, true);
	SetMenuExitButton(g_AbNeRMenu, true);
	DisplayMenu(g_AbNeRMenu, client, 30);
}

public int AbNeRMenuHandler(Handle menu, MenuAction action, int param1, int param2)
{
	Handle g_AbNeRMenu = CreateMenu(AbNeRMenuHandler);
	if (action == MenuAction_DrawItem)
	{
		return ITEMDRAW_DEFAULT;
	}
	else if(param2 == MenuCancel_ExitBack)
	{
		ShowCookieMenu(param1);
	}
	else if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				SetClientCookie(param1, g_AbNeRCookie, "0");
				abnermenu(param1, 0);
			}
			case 1:
			{
				SetClientCookie(param1, g_AbNeRCookie, "1");
				abnermenu(param1, 0);
			}
		}
		CloseHandle(g_AbNeRMenu);
	}
	return 0;
}

public void PathChange(Handle cvar, const char[] oldVal, const char[] newVal)
{       
	RefreshSounds(0);
}

public void OnConfigsExecuted()
{
	RefreshSounds(0);
}

void RefreshSounds(int client)
{
	char soundpath[PLATFORM_MAX_PATH];
	char soundpath2[PLATFORM_MAX_PATH];
	GetConVarString(g_hTRPath, soundpath, sizeof(soundpath));
	GetConVarString(g_hCTPath, soundpath2, sizeof(soundpath2));
	SamePath = StrEqual(soundpath, soundpath2);
	int size;
	if(SamePath)
	{
		size = LoadSoundsTR();
		SoundsTRSucess = (size > 0);
		if(SoundsTRSucess)
		{
			ReplyToCommand(client, "[AbNeR RES] SOUNDS: %d sounds loaded.", size);
		}
		else
		{
			ReplyToCommand(client, "[AbNeR RES] INVALID SOUND PATH.");
		}
	}
	else
	{
		size = LoadSoundsTR();
		SoundsTRSucess = (size > 0);
		if(SoundsTRSucess)
		{
			ReplyToCommand(client, "[AbNeR RES] TR_SOUNDS: %d sounds loaded.", size);
		}
		else
		{
			ReplyToCommand(client, "[AbNeR RES] INVALID TR SOUND PATH.");
		}
		
		size = LoadSoundsCT();
		SoundsCTSucess = (size > 0);
		if(SoundsCTSucess)
		{
			ReplyToCommand(client, "[AbNeR RES] CT_SOUNDS: %d sounds loaded.", size);
		}
		else
		{
			ReplyToCommand(client, "[AbNeR RES] INVALID CT SOUND PATH.");
		}
	}
}
 
int LoadSoundsCT()
{
	ctSound.Clear();
	char name[128];
	char soundname[512];
	char soundpath[PLATFORM_MAX_PATH];
	char soundpath2[PLATFORM_MAX_PATH];
	GetConVarString(g_hCTPath, soundpath, sizeof(soundpath));
	Format(soundpath2, sizeof(soundpath2), "sound/%s/", soundpath);
	Handle pluginsdir = OpenDirectory(soundpath2);
	SoundsCTSucess = (pluginsdir != INVALID_HANDLE);
	if(SoundsCTSucess)
	{
		while(ReadDirEntry(pluginsdir,name,sizeof(name)))
		{
			int namelen = strlen(name) - 4;
			if(StrContains(name,".mp3",false) == namelen)
			{
				Format(soundname, sizeof(soundname), "sound/%s/%s", soundpath, name);
				AddFileToDownloadsTable(soundname);
				Format(soundname, sizeof(soundname), "%s/%s", soundpath, name);
				ctSound.PushString(soundname);
			}
		}
	}
	return ctSound.Length;
}

int LoadSoundsTR()
{
	trSound.Clear();
	char name[128];
	char soundname[512];
	char soundpath[PLATFORM_MAX_PATH];
	char soundpath2[PLATFORM_MAX_PATH];
	GetConVarString(g_hTRPath, soundpath, sizeof(soundpath));
	Format(soundpath2, sizeof(soundpath2), "sound/%s/", soundpath);
	Handle pluginsdir = OpenDirectory(soundpath2);
	SoundsCTSucess = (pluginsdir != INVALID_HANDLE);
	if(SoundsCTSucess)
	{
		while(ReadDirEntry(pluginsdir,name,sizeof(name)))
		{
			int namelen = strlen(name) - 4;
			if(StrContains(name,".mp3",false) == namelen)
			{
				Format(soundname, sizeof(soundname), "sound/%s/%s", soundpath, name);
				AddFileToDownloadsTable(soundname);
				Format(soundname, sizeof(soundname), "%s/%s", soundpath, name);
				trSound.PushString(soundname);
			}
		}
	}
	return trSound.Length;
}

void PlaySoundCT()
{
	int soundToPlay;
	if(GetConVarInt(g_hPlayType) == 1)
	{
		soundToPlay = GetRandomInt(0, ctSound.Length-1);
	}
	else
	{
		soundToPlay = 0;
	}
	
	char szSound[128];
	ctSound.GetString(soundToPlay, szSound, sizeof(szSound));
	ctSound.Erase(soundToPlay);
	PlayMusicAll(szSound);
	if(ctSound.Length == 0)
		LoadSoundsCT();
}

void PlaySoundTR()
{
	int soundToPlay;
	if(GetConVarInt(g_hPlayType) == 1)
	{
		soundToPlay = GetRandomInt(0, trSound.Length-1);
	}
	else
	{
		soundToPlay = 0;
	}
	
	char szSound[128];
	trSound.GetString(soundToPlay, szSound, sizeof(szSound));
	trSound.Erase(soundToPlay);
	PlayMusicAll(szSound);
	if(trSound.Length == 0)
		LoadSoundsTR();
}

void PlayMusicAll(char[] szSound)
{	
	if(CSGO)
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if(IsValidClient(i) && GetIntCookie(i, g_AbNeRCookie) == 0)
			{
				if(!clutch)
				{
					ClientCommand(i, "playgamesound Music.StopAllMusic");
					ClientCommand(i, "play \"*%s\"", szSound);
					//EmitSoundToClient( i, szSound );
				}
				else if(clutch)
				{
					ClientCommand(i, "playgamesound Music.StopAllMusic");
					ClientCommand(i, "play \"*misc/drkclutch/15 Kisiye Saldirdim.mp3\"");
				}
			}
		}
	}
	else
	{
		for (int i = 1; i <= MaxClients; i++)
		{
			if(IsValidClient(i) && GetIntCookie(i, g_AbNeRCookie) == 0)
			{
				ClientCommand(i, "play \"*%s\"", szSound);
			}
		}
	}
	char sarkiIsmiYazdir[128];
	int k = 0, j = 0;
	int klasorGec = 0;
	while( szSound[k + 4] != '\0' )
	{
		if(klasorGec < 2)
		{
			if(szSound[k] == '\\' || szSound[k] == '/')
				klasorGec++;
		}
		else
		{
			sarkiIsmiYazdir[j] = szSound[k];
			j++;
		}
		k++;
	}
	
	if(!clutch)
	{
		CPrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x10Şuan Çalınan:\n \x04%s", sarkiIsmiYazdir);
	}
	else if(clutch)
	{
		decl String:clutchIsim[32];
		GetClientName(iClutch, clutchIsim, sizeof(clutchIsim));
		CPrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x04%s \x03, \x0C1 v %d \x10Clutch Atmıştır, \x04Tebrikler!", clutchIsim, clutchSayisi);
		PrintCenterTextAll("<font color='#FF0000'>[ ☜ NoFL ☞ ]</font> <font color='#00FF00'>%s</font>\n<font color='#ff7700'>1 v %d</font> <font color='#00FFFF'>Clutch atmıştır, Tebrikler!</font>",clutchIsim, clutchSayisi);
			
		CPrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x10Şuan Çalınan:\n \x0415 Kişiye Saldırdım");
	}
}


public Action CommandLoad(int client, int args)
{   
	RefreshSounds(client);
	return Plugin_Handled;
}

int GetIntCookie(int client, Handle handle)
{
	char sCookieValue[11];
	GetClientCookie(client, handle, sCookieValue, sizeof(sCookieValue));
	return StringToInt(sCookieValue);
}





