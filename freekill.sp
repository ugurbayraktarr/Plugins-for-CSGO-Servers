#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>
//#include <store>

#define PLUGIN_VERSION "3.0"

public Plugin:myinfo =
{
	name        = "FreeKill Respawn Sistemi",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

new g_Models[MAXPLAYERS + 1] = {-1, ...};
static int iFree = -1;
static int oynananEl[MAXPLAYERS+1] = {0, ...};
static int elKontrol[MAXPLAYERS+1] = {0, ...};
static int saniyeKontrol;
static int killer[MAXPLAYERS+1];
static int yalanciCeza[MAXPLAYERS+1];
new Float:g_OlmeNoktasi[MAXPLAYERS+1][3];
new const String:FULL_SOUND_PATH[] = "sound/drkgaming/freekill.mp3";
new const String:RELATIVE_SOUND_PATH[] = "*/drkgaming/freekill.mp3";

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
	
	AddFileToDownloadsTable( FULL_SOUND_PATH );
	FakePrecacheSound( RELATIVE_SOUND_PATH );
	PrecacheModel("materials/sprites/drkgamingfree.vmt" , true);
	PrecacheModel("materials/sprites/drkgamingfree.vtf" , true);
	AddFileToDownloadsTable("materials/sprites/drkgamingfree.vmt");
	AddFileToDownloadsTable("materials/sprites/drkgamingfree.vtf");
	
	//RegAdminCmd("sm_test", Command_Test, ADMFLAG_ROOT);
	//RegAdminCmd("sm_test2", Command_Test2, ADMFLAG_ROOT);
	//RegAdminCmd("sm_testsil", Command_TestSil, ADMFLAG_ROOT);
	RegConsoleCmd("sm_free", Command_Free);
	RegConsoleCmd("sm_revle", Command_Revle);
	RegConsoleCmd("sm_revleme", Command_Revleme);

	HookEvent("round_start", Event_RoundStart);
	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Pre);
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Pre);
}

public OnMapStart()
{
	AddFileToDownloadsTable( FULL_SOUND_PATH );
	FakePrecacheSound( RELATIVE_SOUND_PATH );
	
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	
	if(!((StrContains(mapName, "jb_", false) != -1) || (StrContains(mapName, "jail_", false)!= -1)))
	{
		SetFailState("Bu plugin sadece jail maplarinda calismaktadir..");
	}
}

public OnGameFrame()
{
	float zaman = GetEngineTime ();
	if(zaman <= GetEngineTime ())
	{
		zaman = zaman + 1.0;
		if(iFree != -1)
		{
			decl String:freeIsim[32];
			GetClientName(iFree, freeIsim, sizeof(freeIsim));
			decl String:killerIsim[32];
			GetClientName(killer[iFree], killerIsim, sizeof(killerIsim));
			if(saniyeKontrol + 15 > GetTime())
			{
				if(GetTime() > saniyeKontrol + 2)
					PrintCenterTextAll("<font color='#FFFF00'>%d<font> - <font color='#0000FF'>%s <font color='#00FF00'>%s <font color='#00FFFF'>tarafından öldürüldü,</font> <font color='#FF0000'>free işlemi bekliyor.</font>",saniyeKontrol + 15 - GetTime(), freeIsim, killerIsim);
			
			}
			if(saniyeKontrol + 15 <= GetTime())
			{
				PrintToChatAll(" \x02[DrK # GaminG] \x04Admin komut uygulamadığı için, \x10%s\x0C'nin \x05free işlemi iptal edilmiştir.", freeIsim);
				PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> \n<font color='#00FF00'>Free İşlemi İptal Edilmiştir.");

				Entity_SafeDelete(g_Models[iFree]);
				iFree = -1;
			}
		}
	}
}

stock FakePrecacheSound( const String:szPath[] )
{
	AddToStringTable( FindStringTable( "soundprecache" ), szPath );
}

public OnClientDisconnect(client)
{
	oynananEl[client] = 0;
	Entity_SafeDelete(g_Models[client]);
	yalanciCeza[client] = 0;
	if(iFree == client)
	{
		iFree = -1;
	}
}


public Action Event_PlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	killer[client] = GetClientOfUserId(GetEventInt(event, "attacker"));
	GetClientAbsOrigin(client, g_OlmeNoktasi[client]);
	g_OlmeNoktasi[client][2] -= 45.0;
}
public Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	killer[client] = -1;
	CreateTimer(0.2, RespawnSifirlama, client);
}

public Action:RespawnSifirlama(Handle:timer, any client)
{
	Entity_SafeDelete(g_Models[client]);
	if(iFree == client)
	{
		iFree = -1;
	}
}

public Action Event_RoundStart(Handle event, char[] name, bool dontBroadcast)
{
	new i;
	for(i=1;i<MAXPLAYERS;i++)
	{
		if(IsClientInGame(i) && IsPlayerAlive(i))
		{
			oynananEl[i]++;
			elKontrol[i] = 0;
		}
		Entity_SafeDelete(g_Models[i]);
	}
	iFree = -1;
}

public OnPluginEnd()
{
	for(new i = 0; i < sizeof(g_Models); i++) {
		Entity_SafeDelete(g_Models[i]);
	}
}

Entity_SafeDelete(entity)
{
	if(IsValidEntity(entity)) {
		AcceptEntityInput(entity, "Kill");
	}
}

SpawnSprite(Float:a, Float:b, Float:c)
{
	new Float:pos[3];
	pos[0] = a;
	pos[1] = b;
	pos[2] = c;
	
	new Ent = CreateEntityByName("env_sprite");
	if(!Ent) return -1;
	DispatchKeyValue(Ent, "model", "materials/sprites/drkgamingfree.vmt");
	DispatchKeyValue(Ent, "classname", "env_sprite");
	DispatchKeyValue(Ent, "spawnflags", "1");
	DispatchKeyValue(Ent, "scale", "0.1");
	DispatchKeyValue(Ent, "rendermode", "1");
	DispatchKeyValue(Ent, "rendercolor", "255 255 255");
	DispatchSpawn(Ent);
	TeleportEntity(Ent, pos, NULL_VECTOR, NULL_VECTOR);
	return Ent;
}

public Action:Command_Free(client, args)
{
	if(args != 0)
	{
		PrintToConsole(client, "Kullanım: !free");
		PrintToChat(client, " \x02Kullanım:\x04 !free");

		return Plugin_Handled;
	}
	decl String:mapIsmi[64];
	GetCurrentMap(mapIsmi, sizeof(mapIsmi));
	
	/*if (strncmp(mapIsmi, "jb_", 3) != 0 || strncmp(mapIsmi, "ba_jail_", 7) != 0 )
	{
		PrintToChat(client, " \x02[DrK # GaminG]\x04 Bu komut sadece jail maplarda çalışmaktadır.");
		return Plugin_Handled;
	}*/
	if(iFree != -1)
	{
		PrintToChat(client, " \x02[DrK # GaminG]\x04 Şuan başka bir free işlemi yürürlükte.");
		return Plugin_Handled;
	}
	if(IsPlayerAlive(client))
	{
		PrintToChat(client, " \x02[DrK # GaminG]\x04 Bu komutu yaşıyorken kullanamazsınız.");
		return Plugin_Handled;
	}
	if(GetClientTeam(client) != 2)
	{
		PrintToChat(client, " \x02[DrK # GaminG]\x04 Bu komutu \x10sadece T'de \x04kullanabilirsiniz..");
		return Plugin_Handled;
	}
	if(oynananEl[client] == 0)
		{
		PrintToChat(client, " \x02[DrK # GaminG]\x10 Bu komutu \x04oyuna yeni girdiğiniz için \x10kullanamazsınız.");
		return Plugin_Handled;
	}
	if(elKontrol[client] != 0)
	{
		PrintToChat(client, " \x02[DrK # GaminG]\x04 Bu komutu \x10her el sadece 1 kez \x04kullanabilirsiniz.");
		return Plugin_Handled;
	}
	if(killer[client] < 1)
	{
		PrintToChat(client, " \x02[DrK # GaminG]\x04 Kimse sizi öldürmediği için free komutunu kullanamazsınız.");
		return Plugin_Handled;
	}
	if(killer[client] == client)
	{
		PrintToChat(client, " \x02[DrK # GaminG]\x04 Kendi kendinizi öldürdüğünüz için free komutunu kullanamazsınız.");
		return Plugin_Handled;
	}
	if(yalanciCeza[client] > GetTime())
	{
		PrintToChat(client, " \x02[DrK # GaminG]\x10 Daha önce yalan söylediğiniz için bu komutu \x02%d saniye \x10sonra kullanabilirsiniz.", yalanciCeza[client] - GetTime());
		return Plugin_Handled;
	}
	else
	{
		saniyeKontrol = GetTime();
		iFree = client;
		decl String:freeIsim[32];
		decl String:killerIsim[32];
		GetClientName(client, freeIsim, sizeof(freeIsim));
		GetClientName(killer[iFree], killerIsim, sizeof(killerIsim));
		float a = g_OlmeNoktasi[iFree][0];
		float b = g_OlmeNoktasi[iFree][1];
		float c = g_OlmeNoktasi[iFree][2] + 70;
		g_Models[client] = SpawnSprite(a, b, c);
		//PrintCenterTextAll("<font color='#FF0000'>[DrK # GaminG]</font> <font color='#00FF00'>%s</font> \n<font color='#30D5C8'>Free öldüğünü iddia ediyor!</font>", freeIsim);
		PrintCenterTextAll("<font color='#0000FF'>%s <font color='#00FF00'>%s <font color='#00FFFF'>tarafından öldürüldü,</font> <font color='#FF0000'>işlem bekliyor.</font>", freeIsim, killerIsim);
		
		//PrintToChatAll (" \x01-\x02-\x03-\x04-\x05-\x06-\x07-\x08-\x09-\x10-\x01-\x02-\x03-\x04-\x05-\x06-\x07-\x08-\x09-\x10-\x01-\x02-\x03-\x04-\x05-\x06-\x07-\x08-\x09-\x10-\x01-\x02-\x03-\x04-\x05-\x06-\x07-\x08-\x09-\x10-\x01-\x02-\x03-\x04-\x05-\x06-\x07-\x08-\x09-\x10-\x01-\x02-");
		PrintToChatAll (" ");
		PrintToChatAll (" \x02[DrK # GaminG] \x05 %s\x04 Free öldüğünü iddia ediyor!", freeIsim);
		PrintToChatAll (" \x04Adminler \x0C!revle \x10yada \x0C!revleme \x10yazarak komut uygulayabilir.");
		if(killer[iFree] != -1)
			PrintToChatAll (" \x04%s \x0C, \x02%s \x10tarafından öldürülmüştü.", freeIsim, killerIsim);
		PrintToChatAll (" ");
		//PrintToChatAll (" \x01-\x02-\x03-\x04-\x05-\x06-\x07-\x08-\x09-\x10-\x01-\x02-\x03-\x04-\x05-\x06-\x07-\x08-\x09-\x10-\x01-\x02-\x03-\x04-\x05-\x06-\x07-\x08-\x09-\x10-\x01-\x02-\x03-\x04-\x05-\x06-\x07-\x08-\x09-\x10-\x01-\x02-\x03-\x04-\x05-\x06-\x07-\x08-\x09-\x10-\x01-\x02-");
		EmitSoundToAll(RELATIVE_SOUND_PATH);
	}
	return Plugin_Handled;
}

public Action:Command_Revle(client, args)
{
	if(!(IsPlayerGenericAdmin(client) || GetClientTeam(client) == 3))
	{
		PrintToChatAll(" \x02[DrK # GaminG]\04 Bu komut için yetkiniz bulunmamaktadır.");
		return Plugin_Handled;
	}
	if(iFree == -1)
	{
		PrintToChatAll(" \x02[DrK # GaminG]\04 Şuan bekleyen bir free olayı bulunmuyor.");
		return Plugin_Handled;
	}
	decl String:freeIsim[32];
	GetClientName(iFree, freeIsim, sizeof(freeIsim));
	decl String:adminIsim[32];
	GetClientName(client, adminIsim, sizeof(adminIsim));
	PrintToChatAll(" \x02[DrK # GaminG]\x10 %s \x04isimli oyuncu \x10%s \x04tarafından free öldüğü için revlendi.", freeIsim, adminIsim);
	CS_RespawnPlayer(iFree);
	TeleportEntity(iFree, g_OlmeNoktasi[iFree], NULL_VECTOR, NULL_VECTOR);
	//PrintToChatAll("TeleportTest: %.4f %.4f %.4f", g_OlmeNoktasi[iFree][0], g_OlmeNoktasi[iFree][1], g_OlmeNoktasi[iFree][2]);
	Entity_SafeDelete(g_Models[iFree]);
	iFree = -1;
	return Plugin_Handled;
}

public Action:Command_Revleme(client, args)
{
	if(!(IsPlayerGenericAdmin(client) || GetClientTeam(client) == 3))
	{
		PrintToChatAll(" \x02[DrK # GaminG]\04 Bu komut için yetkiniz bulunmamaktadır.");
		return Plugin_Handled;
	}
	if(iFree == -1)
	{
		PrintToChatAll(" \x02[DrK # GaminG]\04 Şuan bekleyen bir free olayı bulunmuyor.");
		return Plugin_Handled;
	}
	decl String:freeIsim[32];
	GetClientName(iFree, freeIsim, sizeof(freeIsim));
	decl String:adminIsim[32];
	GetClientName(client, adminIsim, sizeof(adminIsim));
	
	yalanciCeza[iFree] = (GetTime() + 420);
	
	PrintToChatAll(" \x02[DrK # GaminG]\x10 %s \x04isimli oyuncu \x10%s \x04tarafından \x02free ölmediği için \x04revlenmedi.", freeIsim, adminIsim);
	
	//new id[1];
	//id[0] = Store_GetClientAccountID(iFree);
	//Store_GiveCreditsToUsers(id, 1, -500);
	//PrintToChatAll(" \x02[DrK # GaminG]\x10 %s \x04'dan \x10yalan söylediği için \x02500TL \x04alındı.", freeIsim, adminIsim);
	PrintToChatAll(" \x02[DrK # GaminG]\x10 %s \x047 dk boyunca \x10!free komutunu kullanamayacak.", freeIsim, adminIsim);
	Entity_SafeDelete(g_Models[iFree]);
	elKontrol[iFree] = 1;
	iFree = -1;
	return Plugin_Handled;
}

bool:IsPlayerGenericAdmin(client)
{
    if (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC, false))
    {
        return true;
    }
    return false;
}
/*
public Action:teleportYap(Handle:timer) 
{
	new Float:teleportOrigin[3];
	PrintToChatAll("TeleportTest1");
	teleportOrigin[0] = olmeNoktasiX[iFree];
	teleportOrigin[1] = olmeNoktasiY[iFree];
	teleportOrigin[2] = olmeNoktasiZ[iFree] - 20;
	TeleportEntity(iFree, teleportOrigin, NULL_VECTOR, NULL_VECTOR);
	iFree = -1;
	PrintToChatAll("TeleportTest2");
}*/

/*
public Action:Command_Test2(client, args)
{
	decl String:sA[10];
	decl String:sB[10];	
	decl String:sC[10];
	float a;
	float b; 
	float c;
	GetCmdArg(1, sA, sizeof(sA));
	GetCmdArg(2, sB, sizeof(sB));
	GetCmdArg(3, sC, sizeof(sC));
	a = StringToFloat(sA);
	b = StringToFloat(sB);
	c = StringToFloat(sC);
	g_Models[client] = SpawnSprite2(a, b, c);
}*/

/*
SpawnSprite2(Float:a, Float:b, Float:c)
{
	new Float:pos[3];
	pos[0] = a;
	pos[1] = b;
	pos[2] = c;
	new g_Sprite;
	if(!g_Sprite)
		g_Sprite = PrecacheModel("materials/sprites/drkgamingfree.vmt");
	PrintToChatAll(" \x10 //   drkgamingfree yüklendi.   \\");

	TE_SetupGlowSprite(pos, g_Sprite, 10.0 , 1.0, 255);
    	TE_SendToAll();
}*/

/*public Action:Command_Test(client, args)
{
	decl String:sA[10];
	decl String:sB[10];	
	decl String:sC[10];
	float a;
	float b; 
	float c;
	GetCmdArg(1, sA, sizeof(sA));
	GetCmdArg(2, sB, sizeof(sB));
	GetCmdArg(3, sC, sizeof(sC));
	a = StringToFloat(sA);
	b = StringToFloat(sB);
	c = StringToFloat(sC);
	g_Models[client] = SpawnSprite(a, b, c);
}

public Action:Command_TestSil(client, args)
{
	Entity_SafeDelete(g_Models[client]);
}*/