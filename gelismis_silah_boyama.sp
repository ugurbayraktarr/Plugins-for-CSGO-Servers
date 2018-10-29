#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <sdkhooks>
#include <multicolors>
#include <string>

#define IDAYS 26

#undef REQUIRE_PLUGIN
#include <lastrequest>

new Handle:db;

new clientlang[MAXPLAYERS+1];

//bool checked[MAXPLAYERS + 1];

#define MAX_PAINTS 800
#define MAX_LANGUAGES 40

enum Listados
{
	String:Nombre[64],
	index,
	Float:wear,
	stattrak,
	quality,
	pattern,
	String:flag[8]
}

new Handle:menuw[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_negev[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_m249[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_bizon[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_p90[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_scar20[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_g3sg1[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_m4a1[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_m4a1_silencer[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_ak47[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_aug[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_galilar[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_awp[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_sg556[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_ump45[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_mp7[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_famas[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_mp9[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_mac10[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_ssg08[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_nova[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_xm1014[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_sawedoff[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_mag7[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_elite[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_deagle[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_tec9[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_fiveseven[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_cz75a[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_glock[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_usp_silencer[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_p250[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_hkp2000[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_bayonet[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_knife_gut[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_knife_flip[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_knife_m9_bayonet[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_knife_karambit[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_knife_tactical[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_knife_butterfly[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_knife_falchion[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_knife_push[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_revolver[MAX_LANGUAGES] = INVALID_HANDLE;
new Handle:menuw_knife_survival_bowie[MAX_LANGUAGES] = INVALID_HANDLE;
new g_paints[MAX_LANGUAGES][MAX_PAINTS][Listados];
new g_paintCount[MAX_LANGUAGES];
new String:path_paints[PLATFORM_MAX_PATH];

new bool:g_hosties = false;

new bool:g_c4;
new Handle:cvar_c4;

new Handle:arbol[MAXPLAYERS+1] = INVALID_HANDLE;
new Handle:menu1[MAXPLAYERS+1] = INVALID_HANDLE;

new Handle:saytimer;
new Handle:cvar_saytimer;
new g_saytimer;

new Handle:rtimer;
new Handle:cvar_rtimer;
new g_rtimer;

new Handle:cvar_rmenu;
new bool:g_rmenu;

new Handle:cvar_onlyadmin;
new bool:onlyadmin;

new Handle:cvar_zombiesv;
new bool:zombiesv;

new String:s_arma[MAXPLAYERS+1][64];
new s_sele[MAXPLAYERS+1];

new ismysql;

new Handle:array_paints[MAX_LANGUAGES];
new Handle:array_armas;

//new String:base[64] = "weaponpaints";

new bool:uselocal = false;

new bool:comprobado41[MAXPLAYERS+1];

bool chooset[MAXPLAYERS + 1];
new String:g_sFilePath[PLATFORM_MAX_PATH];


public Plugin:myinfo =
{
	name = "Silah Boyama - Ozel Yapim",
	author = "ImPossibLe`",
	description = "",
	version = "1.0"
};

new String:g_sCmdLogPath[256];

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
	
	BuildPath(Path_SM, g_sFilePath, sizeof(g_sFilePath), "logs/silahBoyama/");
	if (!DirExists(g_sFilePath))
	{
		CreateDirectory(g_sFilePath, 511);
		if (!DirExists(g_sFilePath))
			SetFailState("/sourcemod/logs/silahBoyama - Bu dizin olusturulamadi. Lutfen elle olusturun..");
	}
	
 	for(new i=0;;i++)
	{
		BuildPath(Path_SM, g_sCmdLogPath, sizeof(g_sCmdLogPath), "logs/silahBoyama/%d.log", i);
		if ( !FileExists(g_sCmdLogPath) )
			break;
	}
	
	LoadTranslations ("silah_boyama.phrases");
	
	//CreateConVar("sm_wpaints_version", DATA, "", FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY|FCVAR_CHEAT|FCVAR_DONTRECORD);
	
	HookEvent("round_start", roundStart);
	//HookEvent("player_team", EventPlayerTeam);
	//HookEvent("player_spawn", Event_Player_Spawn, EventHookMode_Pre);
	AddCommandListener(OnJoinTeam, "joingame");
	AddCommandListener(OnJoinTeam, "jointeam");
	
	RegConsoleCmd("buyammo1", GetSkins);
	RegConsoleCmd("sm_ws", GetSkins);
	RegConsoleCmd("sm_wskins", GetSkins);
	RegConsoleCmd("sm_paints", GetSkins);
	RegConsoleCmd("sm_boya", GetSkins);
	RegConsoleCmd("sm_sb", GetSkins);
	
	RegAdminCmd("sm_reloadwskins", ReloadSkins, ADMFLAG_ROOT);
	
	cvar_c4 = CreateConVar("drk_silahboyama_c4", "0", "Enable or disable that people can apply paints to the C4. 1 = enabled, 0 = disabled");
	cvar_saytimer = CreateConVar("drk_silahboyama_saytimer", "10", "Time in seconds for block that show the plugin commands in chat when someone type a command. -1.0 = never show the commands in chat");
	cvar_rtimer = CreateConVar("drk_silahboyama_roundtimer", "-1", "Time in seconds roundstart for can use the commands for change the paints. -1.0 = always can use the command");
	cvar_rmenu = CreateConVar("drk_silahboyama_rmenu", "1", "Re-open the menu when you select a option. 1 = enabled, 0 = disabled.");
	cvar_onlyadmin = CreateConVar("drk_silahboyama_onlyadmin", "0", "This feature is only for admins. 1 = enabled, 0 = disabled.");
	cvar_zombiesv = CreateConVar("drk_silahboyama_zombiesv", "1", "Enable this for prevent crashes in zombie servers. 1 = enabled, 0 = disabled.");
	
	g_c4 = GetConVarBool(cvar_c4);
	g_saytimer = GetConVarInt(cvar_saytimer);
	g_rtimer = GetConVarInt(cvar_rtimer);
	g_rmenu = GetConVarBool(cvar_rmenu);
	onlyadmin = GetConVarBool(cvar_onlyadmin);
	zombiesv = GetConVarBool(cvar_zombiesv);
	
	HookConVarChange(cvar_c4, OnConVarChanged);
	HookConVarChange(cvar_saytimer, OnConVarChanged);
	HookConVarChange(cvar_rtimer, OnConVarChanged);
	HookConVarChange(cvar_rmenu, OnConVarChanged);
	HookConVarChange(cvar_onlyadmin, OnConVarChanged);
	HookConVarChange(cvar_zombiesv, OnConVarChanged);
	
	int count = GetLanguageCount();
	for (new i=0; i<count; i++)
		ReadPaints(i);
	
	new String:Items[64];
	
	if(array_armas != INVALID_HANDLE) CloseHandle(array_armas);
	
	array_armas = CreateArray(128);
	
	Format(Items, 64, "negev");
	//Format(Items[desc], 64, "Negev");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "m249");
	//Format(Items[desc], 64, "M249");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "bizon");
	//Format(Items[desc], 64, "PP-Bizon");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "p90");
	//Format(Items[desc], 64, "P90");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "scar20");
	//Format(Items[desc], 64, "SCAR-20");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "g3sg1");
	//Format(Items[desc], 64, "G3SG1");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "m4a1");
	//Format(Items[desc], 64, "M4A1");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "m4a1_silencer");
	//Format(Items[desc], 64, "M4A1-S");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "ak47");
	//Format(Items[desc], 64, "AK-47");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "aug");
	//Format(Items[desc], 64, "AUG");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "galilar");
	//Format(Items[desc], 64, "Galil AR");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "awp");
	//Format(Items[desc], 64, "AWP");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "sg556");
	//Format(Items[desc], 64, "SG 553");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "ump45");
	//Format(Items[desc], 64, "UMP-45");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "mp7");
	//Format(Items[desc], 64, "MP7");
	PushArrayString(array_armas, Items);

	Format(Items, 64, "famas");
	//Format(Items[desc], 64, "FAMAS");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "mp9");
	//Format(Items[desc], 64, "MP9");
	PushArrayString(array_armas, Items);

	Format(Items, 64, "mac10");
	//Format(Items[desc], 64, "MAC-10");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "ssg08");
	//Format(Items[desc], 64, "SSG 08");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "nova");
	//Format(Items[desc], 64, "Nova");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "xm1014");
	//Format(Items[desc], 64, "XM1014");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "sawedoff");
	//Format(Items[desc], 64, "Sawed-Off");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "mag7");
	//Format(Items[desc], 64, "MAG-7");
	PushArrayString(array_armas, Items);
	

	
	// Secondary weapons
	Format(Items, 64, "elite");
	//Format(Items[desc], 64, "Dual Berettas");
	PushArrayString(array_armas, Items);

	Format(Items, 64, "deagle");
	//Format(Items[desc], 64, "Desert Eagle");
	PushArrayString(array_armas, Items);

	Format(Items, 64, "tec9"); // 26
	//Format(Items[desc], 64, "Tec-9");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "fiveseven");
	//Format(Items[desc], 64, "Five-SeveN");
	PushArrayString(array_armas, Items);

	Format(Items, 64, "cz75a");
	//Format(Items[desc], 64, "CZ75-Auto");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "glock");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "usp_silencer");
	//Format(Items[desc], 64, "USP-S");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "p250");
	//Format(Items[desc], 64, "P250");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "hkp2000");
	//Format(Items[desc], 64, "P2000");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "bayonet");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "knife_gut");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "knife_flip");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "knife_m9_bayonet");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "knife_karambit");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "knife_tactical");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "knife_butterfly");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "c4");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "knife_falchion");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "knife_push");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "revolver");
	PushArrayString(array_armas, Items);
	
	Format(Items, 64, "knife_survival_bowie");
	PushArrayString(array_armas, Items);
	
	for (new client = 1; client <= MaxClients; client++)
	{
		if (!IsClientInGame(client))
			continue;
			
		OnClientPutInServer(client);
		//CreateTimer(0.1, Timer_ClientLanguage, GetClientSerial(client), TIMER_FLAG_NO_MAPCHANGE);
		
	}
	
	ComprobarDB(true, "weaponpaints");
}
/*
public OnClientPostAdminCheck(client)
{
	QueryClientConVar(client, "cl_language", ConVarQueryFinished:CallBack);
}

public CallBack(QueryCookie:cookie, client, ConVarQueryResult:result, const String:cvarName[], const String:cvarValue[])
{
	langindex = GetLanguageByName(cvarValue);
    if(langindex == -1)
    {
		CreateTimer(0.1, Timer_ClientLanguage, GetClientSerial(client), TIMER_FLAG_NO_MAPCHANGE);
		return;
    }
    
    clientlang[client] = langindex ;
	CheckSteamID(client);
	
	chooset[client] = true;
}
*/

/*
public Action:EventPlayerTeam(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if(client > 0 && client <= MaxClients)
	{
		if(IsFakeClient(client))
		{
			return Plugin_Continue;
		}
	}
		
	// refresh client channel after a delay to fix invalid memory access bug
	CreateTimer(0.1, Timer_ClientLanguage, GetClientSerial(client), TIMER_FLAG_NO_MAPCHANGE);
	return Plugin_Continue;
}*/

public Action:Timer_ClientLanguage(Handle:timer, any:serial)
{
	new client = GetClientFromSerial(serial);
	
	if (client)
	{
		//if(!checked[client])
		//{
			clientlang[client] = GetClientLanguage(client);
			CheckSteamID(client);
			//checked[client] = true;
		//}
	}

	return Plugin_Stop;
}

public Action OnJoinTeam(int client, const char[] command, int args)
{
	if (chooset[client])return;
	
	clientlang[client] = GetClientLanguage(client);
	CheckSteamID(client);
	
	chooset[client] = true;
}

public OnConVarChanged(Handle:convar, const String:oldValue[], const String:newValue[])
{
	if (convar == cvar_c4)
	{
		g_c4 = bool:StringToInt(newValue);
	}
	else if (convar == cvar_saytimer)
	{
		g_saytimer = StringToInt(newValue);
	}
	else if (convar == cvar_rtimer)
	{
		g_rtimer = StringToInt(newValue);
	}
	else if (convar == cvar_rmenu)
	{
		g_rmenu = bool:StringToInt(newValue);
	}
	else if (convar == cvar_onlyadmin)
	{
		onlyadmin = bool:StringToInt(newValue);
	}
	else if (convar == cvar_zombiesv)
	{
		zombiesv = bool:StringToInt(newValue);
	}
}

public void OnConfigsExecuted() {
	GameRules_SetProp("m_bIsValveDS", 1);
	GameRules_SetProp("m_bIsQuestEligible", 1);
} 

ComprobarDB(bool:reconnect = false,String:basedatos[64] = "weaponpaints")
{
	if(uselocal) basedatos = "clientprefs";
	if(reconnect)
	{
		if (db != INVALID_HANDLE)
		{
			//LogMessage("Reconnecting DB connection");
			CloseHandle(db);
			db = INVALID_HANDLE;
		}
	}
	else if (db != INVALID_HANDLE)
	{
		return;
	}

	if (!SQL_CheckConfig( basedatos ))
	{
		if(StrEqual(basedatos, "clientprefs")) SetFailState("Databases not found");
		else 
		{
			//base = "clientprefs";
			ComprobarDB(true,"clientprefs");
			uselocal = true;
		}
		
		return;
	}
	SQL_TConnect(OnSqlConnect, basedatos);
}

public OnSqlConnect(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if (hndl == INVALID_HANDLE)
	{
		LogToFileEx(g_sCmdLogPath, "Database failure: %s", error);
		
		SetFailState("Databases dont work");
	}
	else
	{
		db = hndl;
		decl String:buffer[3096];
		
		SQL_GetDriverIdent(SQL_ReadDriver(db), buffer, sizeof(buffer));
		ismysql = StrEqual(buffer,"mysql", false) ? 1 : 0;
	
		new String:temp[64][44];
		for(new i=0;i<GetArraySize(array_armas);++i)
		{
			GetArrayString(array_armas, i, temp[i], 64);
		}
		if (ismysql == 1)
		{
			Format(buffer, sizeof(buffer), "CREATE TABLE IF NOT EXISTS `weaponpaints` (`playername` varchar(128) NOT NULL, `steamid` varchar(32) NOT NULL, `last_accountuse` int(64) NOT NULL, `%s` varchar(64) NOT NULL DEFAULT 'none', `%s` varchar(64) NOT NULL DEFAULT 'none', `%s` varchar(64) NOT NULL DEFAULT 'none', `%s` varchar(64) NOT NULL DEFAULT 'none', `%s` varchar(64) NOT NULL DEFAULT 'none', `%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`%s` varchar(64) NOT NULL DEFAULT 'none',`favorite1` varchar(64) NOT NULL DEFAULT 'none',`favorite2` varchar(64) NOT NULL DEFAULT 'none',`favorite3` varchar(64) NOT NULL DEFAULT 'none',`favorite4` varchar(64) NOT NULL DEFAULT 'none',`favorite5` varchar(64) NOT NULL DEFAULT 'none',`favorite6` varchar(64) NOT NULL DEFAULT 'none',`favorite7` varchar(64) NOT NULL DEFAULT 'none',PRIMARY KEY  (`steamid`))",temp[0],temp[1],temp[2],temp[3],temp[4],temp[5],temp[6],temp[7],temp[8],temp[9],temp[10],temp[11],temp[12],temp[13],temp[14],temp[15],temp[16],temp[17],temp[18],temp[19],temp[20],temp[21],temp[22],temp[23],temp[24],temp[25],temp[26],temp[27],temp[28],temp[29],temp[30],temp[31],temp[32],temp[33],temp[34],temp[35],temp[36],temp[37],temp[38],temp[39],temp[40], temp[41], temp[42], temp[43]);

			LogToFileEx(g_sCmdLogPath, "Query %s", buffer);
			SQL_TQuery(db, tbasicoC, buffer);

		}
		else
		{
			Format(buffer, sizeof(buffer), "CREATE TABLE IF NOT EXISTS weaponpaints (playername varchar(128) NOT NULL, steamid varchar(32) NOT NULL, last_accountuse int(64) NOT NULL, %s varchar(64) NOT NULL DEFAULT 'none', %s varchar(64) NOT NULL DEFAULT 'none', %s varchar(64) NOT NULL DEFAULT 'none', %s varchar(64) NOT NULL DEFAULT 'none', %s varchar(64) NOT NULL DEFAULT 'none', %s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',%s varchar(64) NOT NULL DEFAULT 'none',favorite1 varchar(64) NOT NULL DEFAULT 'none',favorite2 varchar(64) NOT NULL DEFAULT 'none',favorite3 varchar(64) NOT NULL DEFAULT 'none',favorite4 varchar(64) NOT NULL DEFAULT 'none',favorite5 varchar(64) NOT NULL DEFAULT 'none',favorite6 varchar(64) NOT NULL DEFAULT 'none',favorite7 varchar(64) NOT NULL DEFAULT 'none',PRIMARY KEY  (steamid))",temp[0],temp[1],temp[2],temp[3],temp[4],temp[5],temp[6],temp[7],temp[8],temp[9],temp[10],temp[11],temp[12],temp[13],temp[14],temp[15],temp[16],temp[17],temp[18],temp[19],temp[20],temp[21],temp[22],temp[23],temp[24],temp[25],temp[26],temp[27],temp[28],temp[29],temp[30],temp[31],temp[32],temp[33],temp[34],temp[35],temp[36],temp[37],temp[38],temp[39],temp[40],temp[41], temp[42], temp[43]);
		
			LogToFileEx(g_sCmdLogPath, "Query %s", buffer);
			SQL_TQuery(db, tbasicoC, buffer);
		}
	}
}

public OnClientDisconnect(client)
{	
	//checked[client] = false;
	chooset[client] = false;
	if(comprobado41[client] && !IsFakeClient(client)) SaveCookies(client);
	comprobado41[client] = false;
	if(arbol[client] != INVALID_HANDLE)
	{
		ClearTrie(arbol[client]);
		CloseHandle(arbol[client]);
		arbol[client] = INVALID_HANDLE;
	}
	if(menu1[client] != INVALID_HANDLE)
	{
		CloseHandle(menu1[client]);
		menu1[client] = INVALID_HANDLE;
	}
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	MarkNativeAsOptional("IsClientInLastRequest");

	return APLRes_Success;
}

public OnLibraryAdded(const String:name[])
{
	if (StrEqual(name, "hosties"))
	{
		g_hosties = true;
	}
}

public OnLibraryRemoved(const String:name[])
{
	if (StrEqual(name, "hosties"))
	{
		g_hosties = false;
	}
	
	
}

public Action:ReloadSkins(client, args)
{	
	int count = GetLanguageCount();
	for (new i=0; i<count; i++)
		ReadPaints(i);
		
	
	ReplyToCommand(client, " \x04[WP]\x01 %T","Weapon paints reloaded", client);
	
	return Plugin_Handled;
}

ShowMenu(client, item)
{
	decl String:Classname[64];
	//GetEdictClassname(windex, Classname, 64)
	//GetEntityClassname(windex, Classname, sizeof(Classname));
	GetClientWeapon(client, Classname, sizeof(Classname));
	new windex = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	new id = GetEntProp(windex, Prop_Send, "m_iItemDefinitionIndex", 4, 0);
	//PrintToChatAll("%d", id);
	//PrintToChatAll("%s", Classname);
	//IntToString(windex, Classname, sizeof(Classname));

	if(id == 28)
	{
		SetMenuTitle(menuw_negev[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_negev[clientlang[client]], 1);
		//RemoveMenuItem(menuw_negev[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_negev[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_negev[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_negev[clientlang[client]], client, item, 0);
	}
	else if(id == 14)
	{
		SetMenuTitle(menuw_m249[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_m249[clientlang[client]], 1);
		//RemoveMenuItem(menuw_m249[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_m249[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_m249[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_m249[clientlang[client]], client, item, 0);
	}
	else if(id == 26)
	{
		SetMenuTitle(menuw_bizon[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_bizon[clientlang[client]], 1);
		//RemoveMenuItem(menuw_bizon[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_bizon[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_bizon[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_bizon[clientlang[client]], client, item, 0);
	}
	else if(id == 19)
	{
		SetMenuTitle(menuw_p90[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_p90[clientlang[client]], 1);
		//RemoveMenuItem(menuw_p90[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_p90[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_p90[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_p90[clientlang[client]], client, item, 0);
	}
	else if(id == 19)
	{
		SetMenuTitle(menuw_scar20[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_scar20[clientlang[client]], 1);
		//RemoveMenuItem(menuw_scar20[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_scar20[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_scar20[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_scar20[clientlang[client]], client, item, 0);
	}
	else if(id == 11)
	{
		SetMenuTitle(menuw_g3sg1[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_g3sg1[clientlang[client]], 1);
		//RemoveMenuItem(menuw_g3sg1[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_g3sg1[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_g3sg1[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_g3sg1[clientlang[client]], client, item, 0);
	}
	else if(id == 16)
	{
		SetMenuTitle(menuw_m4a1[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_m4a1[clientlang[client]], 1);
		//RemoveMenuItem(menuw_m4a1[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_m4a1[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_m4a1[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_m4a1[clientlang[client]], client, item, 0);
	}
	else if(id == 60)
	{
		SetMenuTitle(menuw_m4a1_silencer[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_m4a1_silencer[clientlang[client]], 1);
		//RemoveMenuItem(menuw_m4a1_silencer[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_m4a1_silencer[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_m4a1_silencer[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_m4a1_silencer[clientlang[client]], client, item, 0);
	}
	else if(id == 7)
	{
		SetMenuTitle(menuw_ak47[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_ak47[clientlang[client]], 1);
		//RemoveMenuItem(menuw_ak47[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_ak47[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		////InsertMenuItem(menuw_ak47[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_ak47[clientlang[client]], client, item, 0);
	}
	else if(id == 8)
	{
		SetMenuTitle(menuw_aug[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_aug[clientlang[client]], 1);
		//RemoveMenuItem(menuw_aug[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_aug[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_aug[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_aug[clientlang[client]], client, item, 0);
	}
	else if(id == 13)
	{
		SetMenuTitle(menuw_galilar[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_galilar[clientlang[client]], 1);
		//RemoveMenuItem(menuw_galilar[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_galilar[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_galilar[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_galilar[clientlang[client]], client, item, 0);
	}
	else if(id == 9)
	{
		SetMenuTitle(menuw_awp[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_awp[clientlang[client]], 1);
		//RemoveMenuItem(menuw_awp[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_awp[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_awp[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_awp[clientlang[client]], client, item, 0);
	}
	else if(id == 39)
	{
		SetMenuTitle(menuw_sg556[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_sg556[clientlang[client]], 1);
		//RemoveMenuItem(menuw_sg556[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_sg556[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_sg556[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_sg556[clientlang[client]], client, item, 0);
	}
	else if(id == 24)
	{
		SetMenuTitle(menuw_ump45[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_ump45[clientlang[client]], 1);
		//RemoveMenuItem(menuw_ump45[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_ump45[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_ump45[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_ump45[clientlang[client]], client, item, 0);
	}
	else if(id == 33)
	{
		SetMenuTitle(menuw_mp7[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_mp7[clientlang[client]], 1);
		//RemoveMenuItem(menuw_mp7[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_mp7[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_mp7[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_mp7[clientlang[client]], client, item, 0);
	}
	else if(id == 10)
	{
		SetMenuTitle(menuw_famas[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_famas[clientlang[client]], 1);
		//RemoveMenuItem(menuw_famas[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_famas[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_famas[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_famas[clientlang[client]], client, item, 0);
	}
	else if(id == 34)
	{
		SetMenuTitle(menuw_mp9[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_mp9[clientlang[client]], 1);
		//RemoveMenuItem(menuw_mp9[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_mp9[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_mp9[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_mp9[clientlang[client]], client, item, 0);
	}
	else if(id == 17)
	{
		SetMenuTitle(menuw_mac10[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_mac10[clientlang[client]], 1);
		//RemoveMenuItem(menuw_mac10[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_mac10[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_mac10[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_mac10[clientlang[client]], client, item, 0);
	}
	else if(id == 40)
	{
		SetMenuTitle(menuw_ssg08[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_ssg08[clientlang[client]], 1);
		//RemoveMenuItem(menuw_ssg08[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_ssg08[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_ssg08[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_ssg08[clientlang[client]], client, item, 0);
	}
	else if(id == 35)
	{
		SetMenuTitle(menuw_nova[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_nova[clientlang[client]], 1);
		//RemoveMenuItem(menuw_nova[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_nova[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_nova[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_nova[clientlang[client]], client, item, 0);
	}
	else if(id == 25)
	{
		SetMenuTitle(menuw_xm1014[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_xm1014[clientlang[client]], 1);
		//RemoveMenuItem(menuw_xm1014[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_xm1014[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_xm1014[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_xm1014[clientlang[client]], client, item, 0);
	}
	else if(id == 29)
	{
		SetMenuTitle(menuw_sawedoff[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_sawedoff[clientlang[client]], 1);
		//RemoveMenuItem(menuw_sawedoff[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_sawedoff[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_sawedoff[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_sawedoff[clientlang[client]], client, item, 0);
	}
	else if(id == 27)
	{
		SetMenuTitle(menuw_mag7[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_mag7[clientlang[client]], 1);
		//RemoveMenuItem(menuw_mag7[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_mag7[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_mag7[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_mag7[clientlang[client]], client, item, 0);
	}
	else if(id == 2)
	{
		SetMenuTitle(menuw_elite[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_elite[clientlang[client]], 1);
		//RemoveMenuItem(menuw_elite[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_elite[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_elite[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_elite[clientlang[client]], client, item, 0);
	}
	else if(id == 1)
	{
		SetMenuTitle(menuw_deagle[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_deagle[clientlang[client]], 1);
		//RemoveMenuItem(menuw_deagle[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_deagle[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_deagle[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_deagle[clientlang[client]], client, item, 0);
	}
	else if(id == 30)
	{
		SetMenuTitle(menuw_tec9[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_tec9[clientlang[client]], 1);
		//RemoveMenuItem(menuw_tec9[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_tec9[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_tec9[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_tec9[clientlang[client]], client, item, 0);
	}
	else if(id == 3)
	{
		SetMenuTitle(menuw_fiveseven[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_fiveseven[clientlang[client]], 1);
		//RemoveMenuItem(menuw_fiveseven[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_fiveseven[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_fiveseven[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_fiveseven[clientlang[client]], client, item, 0);
	}
	else if(id == 63)
	{
		SetMenuTitle(menuw_cz75a[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_cz75a[clientlang[client]], 1);
		//RemoveMenuItem(menuw_cz75a[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_cz75a[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_cz75a[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_cz75a[clientlang[client]], client, item, 0);
	}
	else if(id == 4)
	{
		SetMenuTitle(menuw_glock[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_glock[clientlang[client]], 1);
		//RemoveMenuItem(menuw_glock[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_glock[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_glock[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_glock[clientlang[client]], client, item, 0);
	}
	else if(id == 61)
	{
		SetMenuTitle(menuw_usp_silencer[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_usp_silencer[clientlang[client]], 1);
		//RemoveMenuItem(menuw_usp_silencer[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_usp_silencer[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_usp_silencer[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_usp_silencer[clientlang[client]], client, item, 0);
	}
	else if(id == 36)
	{
		SetMenuTitle(menuw_p250[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_p250[clientlang[client]], 1);
		//RemoveMenuItem(menuw_p250[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_p250[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_p250[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_p250[clientlang[client]], client, item, 0);
	}
	else if(id == 32)
	{
		SetMenuTitle(menuw_hkp2000[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_hkp2000[clientlang[client]], 1);
		//RemoveMenuItem(menuw_hkp2000[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_hkp2000[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_hkp2000[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_hkp2000[clientlang[client]], client, item, 0);
	}
	else if(id == 500)
	{
		SetMenuTitle(menuw_bayonet[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_bayonet[clientlang[client]], 1);
		//RemoveMenuItem(menuw_bayonet[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_bayonet[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_bayonet[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_bayonet[clientlang[client]], client, item, 0);
	}
	else if(id == 506)
	{
		SetMenuTitle(menuw_knife_gut[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_knife_gut[clientlang[client]], 1);
		//RemoveMenuItem(menuw_knife_gut[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_knife_gut[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_knife_gut[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_knife_gut[clientlang[client]], client, item, 0);
	}
	else if(id == 505)
	{
		SetMenuTitle(menuw_knife_flip[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_knife_flip[clientlang[client]], 1);
		//RemoveMenuItem(menuw_knife_flip[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_knife_flip[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_knife_flip[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_knife_flip[clientlang[client]], client, item, 0);
	}
	else if(id == 508)
	{
		SetMenuTitle(menuw_knife_m9_bayonet[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_knife_m9_bayonet[clientlang[client]], 1);
		//RemoveMenuItem(menuw_knife_m9_bayonet[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_knife_m9_bayonet[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_knife_m9_bayonet[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_knife_m9_bayonet[clientlang[client]], client, item, 0);
	}
	else if(id == 507)
	{
		SetMenuTitle(menuw_knife_karambit[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_knife_karambit[clientlang[client]], 1);
		//RemoveMenuItem(menuw_knife_karambit[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_knife_karambit[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_knife_karambit[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_knife_karambit[clientlang[client]], client, item, 0);
	}
	else if(id == 509)
	{
		SetMenuTitle(menuw_knife_tactical[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_knife_tactical[clientlang[client]], 1);
		//RemoveMenuItem(menuw_knife_tactical[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_knife_tactical[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_knife_tactical[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_knife_tactical[clientlang[client]], client, item, 0);
	}
	else if(id == 515)
	{
		SetMenuTitle(menuw_knife_butterfly[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_knife_butterfly[clientlang[client]], 1);
		//RemoveMenuItem(menuw_knife_butterfly[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_knife_butterfly[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_knife_butterfly[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_knife_butterfly[clientlang[client]], client, item, 0);
	}
	else if(id == 512)
	{
		SetMenuTitle(menuw_knife_falchion[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_knife_falchion[clientlang[client]], 1);
		//RemoveMenuItem(menuw_knife_falchion[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_knife_falchion[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_knife_falchion[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_knife_falchion[clientlang[client]], client, item, 0);
	}
	else if(id == 516)
	{
		SetMenuTitle(menuw_knife_push[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_knife_push[clientlang[client]], 1);
		//RemoveMenuItem(menuw_knife_push[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_knife_push[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_knife_push[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_knife_push[clientlang[client]], client, item, 0);
	}
	else if(id == 64)
	{
		SetMenuTitle(menuw_revolver[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_revolver[clientlang[client]], 1);
		//RemoveMenuItem(menuw_revolver[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_revolver[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_revolver[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_revolver[clientlang[client]], client, item, 0);
	}
	else if(id == 514)
	{
		SetMenuTitle(menuw_knife_survival_bowie[clientlang[client]], "%T","Menu title 1", client);
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw_knife_survival_bowie[clientlang[client]], 1);
		//RemoveMenuItem(menuw_knife_survival_bowie[clientlang[client]], 0);
		//decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		////InsertMenuItem(menuw_knife_survival_bowie[clientlang[client]], 0, "0", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		//InsertMenuItem(menuw_knife_survival_bowie[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw_knife_survival_bowie[clientlang[client]], client, item, 0);
	}
	else if(id == 31 || id == 42 || id == 43 || id == 44 || id == 45 || id == 46 || id == 47 || id == 48 || id == 49 || id == 59)
	{
		PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha boya kullanamazsınız!");
	}
	else
	{
		SetMenuTitle(menuw[clientlang[client]], "%T","Menu title 1", client);
		
		//RemoveMenuItem(menuw, 2);
		//RemoveMenuItem(menuw[clientlang[client]], 1);
		//RemoveMenuItem(menuw[clientlang[client]], 0);
		decl String:tdisplay[64];
		//Format(tdisplay, sizeof(tdisplay), "%T", "Choose from your favorite paints", client);
		//InsertMenuItem(menuw, 0, "-2", tdisplay);
		//Format(tdisplay, sizeof(tdisplay), "%T", "Random paint", client);
		//InsertMenuItem(menuw[clientlang[client]], 0, "0", tdisplay);
		Format(tdisplay, sizeof(tdisplay), "%T", "Default paint", client);
		InsertMenuItem(menuw[clientlang[client]], 1, "-1", tdisplay);
		
		DisplayMenuAtItem(menuw[clientlang[client]], client, item, 0);
	}
}

/*ShowMenuM(client)
{
	if(onlyadmin && GetUserAdmin(client) == INVALID_ADMIN_ID) return;
	
	new Handle:menu2 = CreateMenu(DIDMenuHandler_2);
	SetMenuTitle(menu2, "%T by Franc1sco franug","Menu title 2", client, DATA);
	
	//decl String:tdisplay[64];
	Format(tdisplay, sizeof(tdisplay), "%T", "Select paint for the current weapon", client);
	AddMenuItem(menu2, "1", tdisplay);
	Format(tdisplay, sizeof(tdisplay), "%T", "Select paint for each weapon", client);
	AddMenuItem(menu2, "2", tdisplay);
	//Format(tdisplay, sizeof(tdisplay), "%T", "Favorite paints", client);
	//AddMenuItem(menu2, "3", tdisplay);
	
	DisplayMenu(menu2, client, 0);
}*/

public Action:GetSkins(client, args)
{	
	Format(s_arma[client], 64, "none");
	//ShowMenuM(client);
	ShowMenu(client, 0);
	
	return Plugin_Handled;
}

public Action:OnClientSayCommand(client, const String:command[], const String:sArgs[])
{
    if(StrEqual(sArgs, "!wskins", false) || StrEqual(sArgs, "!ws", false) || StrEqual(sArgs, "!paints", false))
	{
		Format(s_arma[client], 64, "none");
		//ShowMenuM(client);
		
		if(saytimer != INVALID_HANDLE || g_saytimer == -1) return Plugin_Handled;
		saytimer = CreateTimer(1.0*g_saytimer, Tsaytimer);
		return Plugin_Continue;
		
	}
	else if(StrEqual(sArgs, "!ss", false) || StrEqual(sArgs, "!showskin", false))
	{
		ShowSkin(client);
		
		if(saytimer != INVALID_HANDLE || g_saytimer == -1) return Plugin_Handled;
		saytimer = CreateTimer(1.0*g_saytimer, Tsaytimer);
		return Plugin_Continue;
	}
    
    return Plugin_Continue;
}

ShowSkin(client)
{
	new weapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	if(weapon < 1 || !IsValidEdict(weapon) || !IsValidEntity(weapon))
	{
		CPrintToChat(client, " {green}[WP]{default} %T", "Paint not found", client);
		return;
	}
	
	new buscar = GetEntProp(weapon,Prop_Send,"m_nFallbackPaintKit");
	for(new i=1; i<g_paintCount[clientlang[client]];i++)
	{
		if(buscar == g_paints[clientlang[client]][i][index])
		{
			CPrintToChat(client, " {green}[WP]{default} %T", "Paint found", client, g_paints[clientlang[client]][i][Nombre]);
			return;
		}
	}
	
	CPrintToChat(client, " {green}[WP]{default} %T", "Paint not found", client);
}

public Action:Tsaytimer(Handle:timer)
{
	saytimer = INVALID_HANDLE;
}

public Action:roundStart(Handle:event, const String:name[], bool:dontBroadcast) 
{
	if(g_rtimer == -1) return;
	
	if(rtimer != INVALID_HANDLE)
	{
		KillTimer(rtimer);
		rtimer = INVALID_HANDLE;
	}
	
	rtimer = CreateTimer(1.0*g_rtimer, Rtimer);
}

public Action:Rtimer(Handle:timer)
{
	rtimer = INVALID_HANDLE;
}

public DIDMenuHandler_2(Handle:menu, MenuAction:action, client, itemNum) 
{
	if ( action == MenuAction_Select ) 
	{

		
		decl String:info[4];
		
		GetMenuItem(menu, itemNum, info, sizeof(info));
		new theindex = StringToInt(info);
		if(theindex == 1) ShowMenu(client, 0);
		else if(theindex == 2 && comprobado41[client]) ShowMenuArmas(client, 0);
		//else if(theindex == 3) ShowMenuFav(client);
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

ShowMenuArmas(client, item)
{	
	if(menu1[client] == INVALID_HANDLE) CrearMenu1(client);
	DisplayMenuAtItem(menu1[client], client, item, 0);
}

bool BugVarMi(client, id, theindex)
{
	if(theindex == -1)
		return false;
	if(id == 28)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "negev", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 14)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "m249", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 26)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "bizon", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 19)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "p90", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 38)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "scar-20", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 11)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "g3sg1", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 16)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "m4a4", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 60)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "m4a1", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 7)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "ak-47", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 8)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "aug", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 13)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "galil", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 9)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "awp", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 39)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "sg 553", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 24)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "ump-45", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 33)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "mp7", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 10)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "famas", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 34)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "mp9", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 17)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "mac-10", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 40)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "ssg 08", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 35)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "nova", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 25)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "xm1014", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 29)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "sawed-off", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 27)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "mag-7", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 2)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "beretta", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 1)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "desert eagle", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 30)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "tec-9", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 3)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "five-seven", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 63)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "cz75", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 4)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "glock", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 61)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "usp", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 36)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "p250", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 32)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "p2000", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 500)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "bayonet", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 508)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "M9", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 507)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "karambit", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 515)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "kelebek", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 64)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "revolver", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 514)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "bowie", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 506)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "kancalı", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 505)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "sustalı", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 509)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "avcı", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 512)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "pala ", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	else if(id == 516)
	{
		if(!(StrContains(g_paints[clientlang[client]][theindex][Nombre], "gölge hançer", false) != -1))
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x04Bug koruması! \x10Bu silaha bu skini kullanamazsınız!");
			return true;
		}
	}
	return false;
}

public DIDMenuHandler(Handle:menu, MenuAction:action, client, itemNum) 
{
	if ( action == MenuAction_Select ) 
	{
		if(!comprobado41[client])
		{
			if(g_rmenu) ShowMenu(client, GetMenuSelectionPosition());
			return;
		}
		
		decl String:Classname[64];
		decl String:info[4];
		
		GetMenuItem(menu, itemNum, info, sizeof(info));
		new theindex = StringToInt(info);
		
		if(StrEqual(s_arma[client], "none"))
		{
			if(GetUserAdmin(client) == INVALID_ADMIN_ID && rtimer == INVALID_HANDLE && g_rtimer != -1)
			{
				//CPrintToChat(client, " {green}[WP]{default} %T", "You can use this command only the first seconds", client, g_rtimer);
				PrintToChat(client, " \x02[DrK # GaminG] \x04Silah boyamayı \x10ilk %d \x04saniye kullanabilirsiniz.", g_rtimer);
				if(g_rmenu) ShowMenu(client, GetMenuSelectionPosition());
				return;
			}
			if(!IsPlayerAlive(client))
			{
				//CPrintToChat(client, " {green}[WP]{default} %T", "You cant use this when you are dead", client);
				PrintToChat(client, " \x02[DrK # GaminG] \x04Silah boyamayı \x10canlıyken \x04kullanabilirsiniz.");
				if(g_rmenu) ShowMenu(client, GetMenuSelectionPosition());
				return;
			}
			if(g_hosties && IsClientInLastRequest(client))
			{
				//CPrintToChat(client, " {green}[WP]{default} %T", "You cant use this when you are in a lastrequest", client);
				PrintToChat(client, " \x02[DrK # GaminG] \x04LR Sırasında silah boyayamazsınız.");
				if(g_rmenu) ShowMenu(client, GetMenuSelectionPosition());
				return;
			}

			if(theindex != -1 && !StrEqual(g_paints[clientlang[client]][theindex][flag], "0"))
			{
				if(!CheckCommandAccess(client, "weaponpaints_override", ReadFlagString(g_paints[clientlang[client]][theindex][flag]), true))
				{
					PrintToChat(client, " \x02[DrK # GaminG] \x04Silah boyama yetkiniz bulunmuyor.");
					//CPrintToChat(client, " {green}[WP]{default} %T", "You dont have access to this paint", client);
					if(g_rmenu) ShowMenu(client, GetMenuSelectionPosition());
					return;
				}
			}
			
		
			new windex = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
			if(windex < 1)
			{
				//CPrintToChat(client, " {green}[WP]{default} %T", "You cant use a paint in this weapon", client);
				PrintToChat(client, " \x02[DrK # GaminG] \x04Bu silahı boyayamazsınız.");
				if(g_rmenu) ShowMenu(client, GetMenuSelectionPosition());
				return;
			}

			new id = GetEntProp(windex, Prop_Send, "m_iItemDefinitionIndex", 4, 0);
			//PrintToChatAll("TEST: %d - %d - %d", client, id, theindex);
			bool bug = BugVarMi(client, id, theindex);
			//PrintToChatAll("TEST2: %d - %d - %d", client, id, theindex);
			if(bug) return;
			//PrintToChatAll("TEST3: %d - %d - %d", client, id, theindex);
			if(!GetEdictClassname(windex, Classname, 64) || StrEqual(Classname, "weapon_taser") || (!g_c4 && StrEqual(Classname, "weapon_c4")))
			{
				//CPrintToChat(client, " {green}[WP]{default} %T", "You cant use a paint in this weapon", client);
				PrintToChat(client, " \x02[DrK # GaminG] \x04Bu silahı boyayamazsınız.");
				if(g_rmenu) ShowMenu(client, GetMenuSelectionPosition());
				return;
			}
			ReplaceString(Classname, 64, "weapon_", "");
			new weaponindex = GetEntProp(windex, Prop_Send, "m_iItemDefinitionIndex");
			if(weaponindex == 42 || weaponindex == 59)
			{
				//CPrintToChat(client, " {green}[WP]{default} %T", "You cant use a paint in this weapon", client);
				PrintToChat(client, " \x02[DrK # GaminG] \x04Bu silahı boyayamazsınız.");
				if(g_rmenu) ShowMenu(client, GetMenuSelectionPosition());
				return;
			}
			
			if(GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY) == windex || GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY) == windex || GetPlayerWeaponSlot(client, CS_SLOT_KNIFE) == windex || (g_c4 && GetPlayerWeaponSlot(client, CS_SLOT_C4) == windex))
			{
				switch (weaponindex)
				{
					case 60: strcopy(Classname, 64, "m4a1_silencer");
					case 61: strcopy(Classname, 64, "usp_silencer");
					case 63: strcopy(Classname, 64, "cz75a");
					case 500: strcopy(Classname, 64, "bayonet");
					case 506: strcopy(Classname, 64, "knife_gut");
					case 505: strcopy(Classname, 64, "knife_flip");
					case 508: strcopy(Classname, 64, "knife_m9_bayonet");
					case 507: strcopy(Classname, 64, "knife_karambit");
					case 509: strcopy(Classname, 64, "knife_tactical");
					case 515: strcopy(Classname, 64, "knife_butterfly");
					case 512: strcopy(Classname, 64, "knife_falchion");
					case 516: strcopy(Classname, 64, "knife_push");
					case 64: strcopy(Classname, 64, "revolver");
					case 514: strcopy(Classname, 64, "knife_survival_bowie");
				}
				
				if(arbol[client] == INVALID_HANDLE)
				{
					//checked[client] = false;
					CreateTimer(0.0, Timer_ClientLanguage, GetClientSerial(client), TIMER_FLAG_NO_MAPCHANGE);
					return;
				}
				else 
				{
					new valor = 0;
					if(!GetTrieValue(arbol[client], Classname, valor))
					{
						//CPrintToChat(client, " {green}[WP]{default} %T", "You cant use a paint in this weapon", client);
						PrintToChat(client, " \x02[DrK # GaminG] \x04Bu silahı boyayamazsınız.");
						if(g_rmenu) ShowMenu(client, GetMenuSelectionPosition());
						return;
					}
					
					decl String:buffer[1024], String:nombres[64];
					if(theindex == -1) Format(nombres, sizeof(nombres), "default");
					else Format(nombres, sizeof(nombres), g_paints[clientlang[client]][theindex][Nombre]);
					decl String:steamid[32];
					GetClientAuthId(client, AuthId_Steam2,  steamid, sizeof(steamid) );
					Format(buffer, sizeof(buffer), "UPDATE weaponpaints SET %s = '%s' WHERE steamid = '%s';", Classname,nombres,steamid);
					LogToFileEx(g_sCmdLogPath, "Query %s", buffer);
					SQL_TQuery(db, tbasico, buffer, GetClientUserId(client));
					SetTrieValue(arbol[client], Classname, theindex);
				}
				
				//ChangePaint(client, windex, Classname, weaponindex, true);
				decl String:Classname2[64];
				Format(Classname2, 64, "weapon_%s", Classname);
				Restore(client, windex, Classname2, weaponindex);
				FakeClientCommand(client, "use %s", Classname2);
				if(theindex == -1) /*CPrintToChat(client, " {green}[WP]{default} %T","You have choose your default paint for your",client, Classname);*/
					PrintToChat(client, " \x02[DrK # GaminG] \x04Silah boyanız \x10Normal Boya \x04olarak değiştirildi.");
				/*else if(theindex == 0) CPrintToChat(client, " {green}[WP]{default} %T","You have choose a random paint for your",client, Classname);*/
				else
				{
					//CPrintToChat(client, " {green}[WP]{default} %T", "You have choose a weapon",client, g_paints[clientlang[client]][theindex][Nombre], Classname);
					
					//decl String:silahismi[64][64];
					//Format(silahismi[1], sizeof(silahismi), "%s", g_paints[clientlang[client]][theindex][Nombre]);
					//ExplodeString(g_paints[clientlang[client]][theindex][Nombre], "| ", silahismi,2, sizeof(silahismi));
					PrintToChat(client, " \x02[DrK # GaminG] \x04Silah boyanız \x10%s \x04olarak değiştirildi.", g_paints[clientlang[client]][theindex][Nombre]);
				}
				decl String:temp[128], String:temp1[64];
				if(theindex == -1) Format(temp, 128, "%s", Classname);
				else if (theindex == 0)
				{
				
					Format(temp1, sizeof(temp1), "%T", "Random paint", client);
					Format(temp, 128, "%s - %s", Classname, temp1);
				}
				else Format(temp, 128, "%s - %s", Classname, g_paints[clientlang[client]][theindex][Nombre]);
				if(menu1[client] == INVALID_HANDLE) CrearMenu1(client);
				new imenu = FindStringInArray(array_armas, Classname);
				InsertMenuItem(menu1[client], imenu, Classname, temp);
				FindStringInArray(array_armas, Classname);
				RemoveMenuItem(menu1[client], imenu+1);
			}
			else /*CPrintToChat(client, " {green}[WP]{default} %T", "You cant use a paint in this weapon",client);*/PrintToChat(client, " \x02[DrK # GaminG] \x04Bu silahı boyayamazsınız.");
			
			
			
		}
		else
		{
			Format(Classname, 64, s_arma[client]);
			
			if(arbol[client] == INVALID_HANDLE)
			{
				//checked[client] = false;
				CreateTimer(0.0, Timer_ClientLanguage, GetClientSerial(client), TIMER_FLAG_NO_MAPCHANGE);
				return;
			}
			else 
			{
				decl String:buffer[1024], String:nombres[64];
				if(theindex == -1) Format(nombres, sizeof(nombres), "default");
				else Format(nombres, sizeof(nombres), g_paints[clientlang[client]][theindex][Nombre]);
				decl String:steamid[32];
				GetClientAuthId(client, AuthId_Steam2,  steamid, sizeof(steamid) );
				Format(buffer, sizeof(buffer), "UPDATE weaponpaints SET %s = '%s' WHERE steamid = '%s';", Classname,nombres,steamid);
				LogToFileEx(g_sCmdLogPath, "Query %s", buffer);
				SQL_TQuery(db, tbasico, buffer, GetClientUserId(client));
				SetTrieValue(arbol[client], Classname, theindex);
			}
			
			if(theindex == -1) CPrintToChat(client, " {green}[WP]{default} %T","You have choose your default paint for your",client, Classname);
			else if(theindex == 0) CPrintToChat(client, " {green}[WP]{default} %T","You have choose a random paint for your",client, Classname);
			else CPrintToChat(client, " {green}[WP]{default} %T", "You have choose a weapon",client, g_paints[clientlang[client]][theindex][Nombre], Classname);
			
			decl String:temp[128], String:temp1[64];
			if(theindex == -1) Format(temp, 128, "%s", Classname);
			else if (theindex == 0)
			{
				
				Format(temp1, sizeof(temp1), "%T", "Random paint", client);
				Format(temp, 128, "%s - %s", Classname, temp1);
			}
			else Format(temp, 128, "%s - %s", Classname, g_paints[clientlang[client]][theindex][Nombre]);
			new imenu = FindStringInArray(array_armas, Classname);
			InsertMenuItem(menu1[client], imenu, Classname, temp);
			FindStringInArray(array_armas, Classname);
			RemoveMenuItem(menu1[client], imenu+1);
			Format(s_arma[client], 64, "none");
			ShowMenuArmas(client, s_sele[client]);
			return;
		}
		
		if(g_rmenu) ShowMenu(client, GetMenuSelectionPosition());
		
	}
}

/* public Action:RestoreItemID(Handle:timer, Handle:pack)
{
    new entity;
    new m_iItemIDHigh;
    new m_iItemIDLow;
    
    ResetPack(pack);
    entity = EntRefToEntIndex(ReadPackCell(pack));
    m_iItemIDHigh = ReadPackCell(pack);
    m_iItemIDLow = ReadPackCell(pack);
    
    if(entity != INVALID_ENT_REFERENCE)
	{
		SetEntProp(entity,Prop_Send,"m_iItemIDHigh",m_iItemIDHigh);
		SetEntProp(entity,Prop_Send,"m_iItemIDLow",m_iItemIDLow);
	}
} */

ReadPaints(index_new)
{
	array_paints[index_new] = CreateArray(128);
	char code[64], language[128];
	GetLanguageInfo(index_new, code, 64, language, 128);
	
	BuildPath(Path_SM, path_paints, sizeof(path_paints), "configs/silah_boyama.cfg", language);
	
	if(!FileExists(path_paints)) BuildPath(Path_SM, path_paints, sizeof(path_paints), "configs/silah_boyama.cfg");
	
	decl Handle:kv;
	g_paintCount[index_new] = 1;
	ClearArray(array_paints[index_new]);
	PushArrayString(array_paints[index_new], "random");
	Format(g_paints[index_new][0][Nombre], 64, "random")

	kv = CreateKeyValues("Paints");
	FileToKeyValues(kv, path_paints);

	if (!KvGotoFirstSubKey(kv)) {

		SetFailState("CFG File not found: %s", path_paints);
		CloseHandle(kv);
	}
	do {

		KvGetSectionName(kv, g_paints[index_new][g_paintCount[index_new]][Nombre], 64);
		g_paints[index_new][g_paintCount[index_new]][index] = KvGetNum(kv, "paint", 0);
		g_paints[index_new][g_paintCount[index_new]][wear] = KvGetFloat(kv, "wear", 0.01);
		g_paints[index_new][g_paintCount[index_new]][stattrak] = KvGetNum(kv, "stattrak", -2);
		g_paints[index_new][g_paintCount[index_new]][quality] = KvGetNum(kv, "quality", 3);
		g_paints[index_new][g_paintCount[index_new]][pattern] = KvGetNum(kv, "pattern", 0);
		KvGetString(kv, "flag", g_paints[index_new][g_paintCount[index_new]][flag], 8, "0");

		PushArrayString(array_paints[index_new], g_paints[index_new][g_paintCount[index_new]][Nombre]);
		g_paintCount[index_new]++;
	} while (KvGotoNextKey(kv));
	CloseHandle(kv);
	
	if(menuw[index_new] != INVALID_HANDLE) CloseHandle(menuw[index_new]);
	if(menuw_negev[index_new] != INVALID_HANDLE) CloseHandle(menuw_negev[index_new]);
	if(menuw_m249[index_new] != INVALID_HANDLE) CloseHandle(menuw_m249[index_new]);
	if(menuw_bizon[index_new] != INVALID_HANDLE) CloseHandle(menuw_bizon[index_new]);
	if(menuw_p90[index_new] != INVALID_HANDLE) CloseHandle(menuw_p90[index_new]);
	if(menuw_scar20[index_new] != INVALID_HANDLE) CloseHandle(menuw_scar20[index_new]);
	if(menuw_g3sg1[index_new] != INVALID_HANDLE) CloseHandle(menuw_g3sg1[index_new]);
	if(menuw_m4a1[index_new] != INVALID_HANDLE) CloseHandle(menuw_m4a1[index_new]);
	if(menuw_m4a1_silencer[index_new] != INVALID_HANDLE) CloseHandle(menuw_m4a1_silencer[index_new]);
	if(menuw_ak47[index_new] != INVALID_HANDLE) CloseHandle(menuw_ak47[index_new]);
	if(menuw_aug[index_new] != INVALID_HANDLE) CloseHandle(menuw_aug[index_new]);
	if(menuw_galilar[index_new] != INVALID_HANDLE) CloseHandle(menuw_galilar[index_new]);
	if(menuw_awp[index_new] != INVALID_HANDLE) CloseHandle(menuw_awp[index_new]);
	if(menuw_sg556[index_new] != INVALID_HANDLE) CloseHandle(menuw_sg556[index_new]);
	if(menuw_ump45[index_new] != INVALID_HANDLE) CloseHandle(menuw_ump45[index_new]);
	if(menuw_mp7[index_new] != INVALID_HANDLE) CloseHandle(menuw_mp7[index_new]);
	if(menuw_famas[index_new] != INVALID_HANDLE) CloseHandle(menuw_famas[index_new]);
	if(menuw_mp9[index_new] != INVALID_HANDLE) CloseHandle(menuw_mp9[index_new]);
	if(menuw_mac10[index_new] != INVALID_HANDLE) CloseHandle(menuw_mac10[index_new]);
	if(menuw_ssg08[index_new] != INVALID_HANDLE) CloseHandle(menuw_ssg08[index_new]);
	if(menuw_nova[index_new] != INVALID_HANDLE) CloseHandle(menuw_nova[index_new]);
	if(menuw_xm1014[index_new] != INVALID_HANDLE) CloseHandle(menuw_xm1014[index_new]);
	if(menuw_sawedoff[index_new] != INVALID_HANDLE) CloseHandle(menuw_sawedoff[index_new]);
	if(menuw_mag7[index_new] != INVALID_HANDLE) CloseHandle(menuw_mag7[index_new]);
	if(menuw_elite[index_new] != INVALID_HANDLE) CloseHandle(menuw_elite[index_new]);
	if(menuw_deagle[index_new] != INVALID_HANDLE) CloseHandle(menuw_deagle[index_new]);
	if(menuw_tec9[index_new] != INVALID_HANDLE) CloseHandle(menuw_tec9[index_new]);
	if(menuw_fiveseven[index_new] != INVALID_HANDLE) CloseHandle(menuw_fiveseven[index_new]);
	if(menuw_cz75a[index_new] != INVALID_HANDLE) CloseHandle(menuw_cz75a[index_new]);
	if(menuw_glock[index_new] != INVALID_HANDLE) CloseHandle(menuw_glock[index_new]);
	if(menuw_usp_silencer[index_new] != INVALID_HANDLE) CloseHandle(menuw_usp_silencer[index_new]);
	if(menuw_p250[index_new] != INVALID_HANDLE) CloseHandle(menuw_p250[index_new]);
	if(menuw_hkp2000[index_new] != INVALID_HANDLE) CloseHandle(menuw_hkp2000[index_new]);
	if(menuw_bayonet[index_new] != INVALID_HANDLE) CloseHandle(menuw_bayonet[index_new]);
	if(menuw_knife_gut[index_new] != INVALID_HANDLE) CloseHandle(menuw_knife_gut[index_new]);
	if(menuw_knife_flip[index_new] != INVALID_HANDLE) CloseHandle(menuw_knife_flip[index_new]);
	if(menuw_knife_m9_bayonet[index_new] != INVALID_HANDLE) CloseHandle(menuw_knife_m9_bayonet[index_new]);
	if(menuw_knife_karambit[index_new] != INVALID_HANDLE) CloseHandle(menuw_knife_karambit[index_new]);
	if(menuw_knife_tactical[index_new] != INVALID_HANDLE) CloseHandle(menuw_knife_tactical[index_new]);
	if(menuw_knife_butterfly[index_new] != INVALID_HANDLE) CloseHandle(menuw_knife_butterfly[index_new]);
	if(menuw_knife_falchion[index_new] != INVALID_HANDLE) CloseHandle(menuw_knife_falchion[index_new]);
	if(menuw_knife_push[index_new] != INVALID_HANDLE) CloseHandle(menuw_knife_push[index_new]);
	if(menuw_revolver[index_new] != INVALID_HANDLE) CloseHandle(menuw_revolver[index_new]);
	if(menuw_knife_survival_bowie[index_new] != INVALID_HANDLE) CloseHandle(menuw_knife_survival_bowie[index_new]);
	menuw[index_new] = INVALID_HANDLE;
	menuw_negev[index_new] = INVALID_HANDLE;
	menuw_m249[index_new] = INVALID_HANDLE;
	menuw_bizon[index_new] = INVALID_HANDLE;
	menuw_p90[index_new] = INVALID_HANDLE;
	menuw_scar20[index_new] = INVALID_HANDLE;
	menuw_g3sg1[index_new] = INVALID_HANDLE;
	menuw_m4a1[index_new] = INVALID_HANDLE;
	menuw_m4a1_silencer[index_new] = INVALID_HANDLE;
	menuw_ak47[index_new] = INVALID_HANDLE;
	menuw_aug[index_new] = INVALID_HANDLE;
	menuw_galilar[index_new] = INVALID_HANDLE;
	menuw_awp[index_new] = INVALID_HANDLE;
	menuw_sg556[index_new] = INVALID_HANDLE;
	menuw_ump45[index_new] = INVALID_HANDLE;
	menuw_mp7[index_new] = INVALID_HANDLE;
	menuw_famas[index_new] = INVALID_HANDLE;
	menuw_mp9[index_new] = INVALID_HANDLE;
	menuw_mac10[index_new] = INVALID_HANDLE;
	menuw_ssg08[index_new] = INVALID_HANDLE;
	menuw_nova[index_new] = INVALID_HANDLE;
	menuw_xm1014[index_new] = INVALID_HANDLE;
	menuw_sawedoff[index_new] = INVALID_HANDLE;
	menuw_mag7[index_new] = INVALID_HANDLE;
	menuw_elite[index_new] = INVALID_HANDLE;
	menuw_deagle[index_new] = INVALID_HANDLE;
	menuw_tec9[index_new] = INVALID_HANDLE;
	menuw_fiveseven[index_new] = INVALID_HANDLE;
	menuw_cz75a[index_new] = INVALID_HANDLE;
	menuw_glock[index_new] = INVALID_HANDLE;
	menuw_usp_silencer[index_new] = INVALID_HANDLE;
	menuw_p250[index_new] = INVALID_HANDLE;
	menuw_hkp2000[index_new] = INVALID_HANDLE;
	menuw_bayonet[index_new] = INVALID_HANDLE;
	menuw_knife_gut[index_new] = INVALID_HANDLE;
	menuw_knife_flip[index_new] = INVALID_HANDLE;
	menuw_knife_m9_bayonet[index_new] = INVALID_HANDLE;
	menuw_knife_karambit[index_new] = INVALID_HANDLE;
	menuw_knife_tactical[index_new] = INVALID_HANDLE;
	menuw_knife_butterfly[index_new] = INVALID_HANDLE;
	menuw_knife_falchion[index_new] = INVALID_HANDLE;
	menuw_knife_push[index_new] = INVALID_HANDLE;
	menuw_revolver[index_new] = INVALID_HANDLE;
	menuw_knife_survival_bowie[index_new] = INVALID_HANDLE;
	
	menuw[index_new] = CreateMenu(DIDMenuHandler);
	menuw_negev[index_new] = CreateMenu(DIDMenuHandler);
	menuw_m249[index_new] = CreateMenu(DIDMenuHandler);
	menuw_bizon[index_new] = CreateMenu(DIDMenuHandler);
	menuw_p90[index_new] = CreateMenu(DIDMenuHandler);
	menuw_scar20[index_new] = CreateMenu(DIDMenuHandler);
	menuw_g3sg1[index_new] = CreateMenu(DIDMenuHandler);
	menuw_m4a1[index_new] = CreateMenu(DIDMenuHandler);
	menuw_m4a1_silencer[index_new] = CreateMenu(DIDMenuHandler);
	menuw_ak47[index_new] = CreateMenu(DIDMenuHandler);
	menuw_aug[index_new] = CreateMenu(DIDMenuHandler);
	menuw_galilar[index_new] = CreateMenu(DIDMenuHandler);
	menuw_awp[index_new] = CreateMenu(DIDMenuHandler);
	menuw_sg556[index_new] = CreateMenu(DIDMenuHandler);
	menuw_ump45[index_new] = CreateMenu(DIDMenuHandler);
	menuw_mp7[index_new] = CreateMenu(DIDMenuHandler);
	menuw_famas[index_new] = CreateMenu(DIDMenuHandler);
	menuw_mp9[index_new] = CreateMenu(DIDMenuHandler);
	menuw_mac10[index_new] = CreateMenu(DIDMenuHandler);
	menuw_ssg08[index_new] = CreateMenu(DIDMenuHandler);
	menuw_nova[index_new] = CreateMenu(DIDMenuHandler);
	menuw_xm1014[index_new] = CreateMenu(DIDMenuHandler);
	menuw_sawedoff[index_new] = CreateMenu(DIDMenuHandler);
	menuw_mag7[index_new] = CreateMenu(DIDMenuHandler);
	menuw_elite[index_new] = CreateMenu(DIDMenuHandler);
	menuw_deagle[index_new] = CreateMenu(DIDMenuHandler);
	menuw_tec9[index_new] = CreateMenu(DIDMenuHandler);
	menuw_fiveseven[index_new] = CreateMenu(DIDMenuHandler);
	menuw_cz75a[index_new] = CreateMenu(DIDMenuHandler);
	menuw_glock[index_new] = CreateMenu(DIDMenuHandler);
	menuw_usp_silencer[index_new] = CreateMenu(DIDMenuHandler);
	menuw_p250[index_new] = CreateMenu(DIDMenuHandler);
	menuw_hkp2000[index_new] = CreateMenu(DIDMenuHandler);
	menuw_bayonet[index_new] = CreateMenu(DIDMenuHandler);
	menuw_knife_gut[index_new] = CreateMenu(DIDMenuHandler);
	menuw_knife_flip[index_new] = CreateMenu(DIDMenuHandler);
	menuw_knife_m9_bayonet[index_new] = CreateMenu(DIDMenuHandler);
	menuw_knife_karambit[index_new] = CreateMenu(DIDMenuHandler);
	menuw_knife_tactical[index_new] = CreateMenu(DIDMenuHandler);
	menuw_knife_butterfly[index_new] = CreateMenu(DIDMenuHandler);
	menuw_knife_falchion[index_new] = CreateMenu(DIDMenuHandler);
	menuw_knife_push[index_new] = CreateMenu(DIDMenuHandler);
	menuw_revolver[index_new] = CreateMenu(DIDMenuHandler);
	menuw_knife_survival_bowie[index_new] = CreateMenu(DIDMenuHandler);
	
	
	// TROLLING
	SetMenuTitle(menuw[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_negev[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_m249[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_bizon[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_p90[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_scar20[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_g3sg1[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_m4a1[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_m4a1_silencer[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_ak47[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_aug[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_galilar[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_awp[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_sg556[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_ump45[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_mp7[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_famas[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_mp9[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_mac10[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_ssg08[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_nova[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_xm1014[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_sawedoff[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_mag7[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_elite[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_deagle[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_tec9[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_fiveseven[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_cz75a[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_glock[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_usp_silencer[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_p250[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_hkp2000[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_bayonet[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_knife_gut[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_knife_flip[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_knife_m9_bayonet[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_knife_karambit[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_knife_tactical[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_knife_butterfly[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_knife_falchion[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_knife_push[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_revolver[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	SetMenuTitle(menuw_knife_survival_bowie[index_new], "( Í¡Â° ÍœÊ– Í¡Â°)");
	decl String:item[4];
	AddMenuItem(menuw[index_new], "0", "Random paint");

	AddMenuItem(menuw[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_negev[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_m249[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_bizon[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_p90[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_scar20[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_g3sg1[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_m4a1[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_m4a1_silencer[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_ak47[index_new], "-1", "Normal boya");
	AddMenuItem(menuw_aug[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_galilar[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_awp[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_sg556[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_ump45[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_mp7[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_famas[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_mp9[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_mac10[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_ssg08[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_nova[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_xm1014[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_sawedoff[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_mag7[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_elite[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_deagle[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_tec9[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_fiveseven[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_cz75a[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_glock[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_usp_silencer[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_p250[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_hkp2000[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_bayonet[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_knife_gut[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_knife_flip[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_knife_m9_bayonet[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_knife_karambit[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_knife_tactical[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_knife_butterfly[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_knife_falchion[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_knife_push[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_revolver[index_new], "-1", "Normal boya"); 
	AddMenuItem(menuw_knife_survival_bowie[index_new], "-1", "Normal boya"); 
	// FORGET THIS
	
	for (new i=g_paintCount[index_new]; i<MAX_PAINTS; ++i) {
	
		g_paints[index_new][i][index] = 0;
	}
	decl String:ayirma[2];
	Format(ayirma, sizeof(ayirma), "| ");
	for (new i=1; i<g_paintCount[index_new]; ++i) {
		Format(item, 4, "%i", i);
		if(StrContains(g_paints[index_new][i][Nombre], "negev", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_negev[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "m249", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_m249[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "bizon", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_bizon[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "p90", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_p90[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "scar-20", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_scar20[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "g3sg1", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_g3sg1[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "m4a4", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_m4a1[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "m4a1", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_m4a1_silencer[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "ak-47", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_ak47[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "aug", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_aug[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "galil", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_galilar[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "awp", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_awp[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "sg 553", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_sg556[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "ump-45", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_ump45[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "mp7", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_mp7[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "famas", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_famas[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "mp9", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_mp9[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "mac-10", false) != -1) //degısıklık yapıldı.
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_mac10[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "ssg 08", false) != -1) //degısıklık yapıldı.
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_ssg08[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "nova", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_nova[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "xm1014", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_xm1014[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "sawed-off", false) != -1) //degısıklık yapıldı. 
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_sawedoff[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "mag-7", false) != -1) //degısıklık yapıldı.
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_mag7[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "beretta", false) != -1) //degısıklık yapıldı.
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_elite[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "desert eagle", false) != -1) //degısıklık yapıldı.
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_deagle[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "tec-9", false) != -1) //degısıklık yapıldı.
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_tec9[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "five-seven", false) != -1) //degısıklık yapıldı.
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_fiveseven[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "cz75", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_cz75a[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "glock", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_glock[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "usp", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_usp_silencer[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "p250", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_p250[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "p2000", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_hkp2000[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "bayonet", false) != -1) //degısıklık yapıldı.
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_bayonet[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "kancalı", false) != -1) //degısıklık yapıldı.
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_knife_gut[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "sustalı", false) != -1) //degısıklık yapıldı.
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_knife_flip[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "M9 ", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_knife_m9_bayonet[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "karambit", false) != -1) //degısıklık yapıldı.
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_knife_karambit[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "avcı", false) != -1) //degısıklık yapıldı.
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_knife_tactical[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "kelebek", false) != -1) //degısıklık yapıldı.
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_knife_butterfly[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "pala", false) != -1) //degısıklık yapıldı.
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_knife_falchion[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "gölge han", false) != -1) //degısıklık yapıldı.
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_knife_push[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "revolver", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_revolver[index_new], item, silahismi[1]);
		}
		else if(StrContains(g_paints[index_new][i][Nombre], "bowie", false) != -1)
		{
			decl String:silahismi[64][64];
			Format(silahismi[1], sizeof(silahismi), "%s", g_paints[index_new][i][Nombre]);
			ExplodeString(g_paints[index_new][i][Nombre], "| ", silahismi,2, sizeof(silahismi));
			AddMenuItem(menuw_knife_survival_bowie[index_new], item, silahismi[1]);
		}
		
		AddMenuItem(menuw[index_new], item, g_paints[index_new][i][Nombre]);
	}
		

	SetMenuExitButton(menuw[index_new], true);
	SetMenuExitButton(menuw_negev[index_new], true);
	SetMenuExitButton(menuw_m249[index_new], true);
	SetMenuExitButton(menuw_bizon[index_new], true);
	SetMenuExitButton(menuw_p90[index_new], true);
	SetMenuExitButton(menuw_scar20[index_new], true);
	SetMenuExitButton(menuw_g3sg1[index_new], true);
	SetMenuExitButton(menuw_m4a1[index_new], true);
	SetMenuExitButton(menuw_m4a1_silencer[index_new], true);
	SetMenuExitButton(menuw_ak47[index_new], true);
	SetMenuExitButton(menuw_aug[index_new], true);
	SetMenuExitButton(menuw_galilar[index_new], true);
	SetMenuExitButton(menuw_awp[index_new], true);
	SetMenuExitButton(menuw_sg556[index_new], true);
	SetMenuExitButton(menuw_ump45[index_new], true);
	SetMenuExitButton(menuw_mp7[index_new], true);
	SetMenuExitButton(menuw_famas[index_new], true);
	SetMenuExitButton(menuw_mp9[index_new], true);
	SetMenuExitButton(menuw_mac10[index_new], true);
	SetMenuExitButton(menuw_ssg08[index_new], true);
	SetMenuExitButton(menuw_nova[index_new], true);
	SetMenuExitButton(menuw_xm1014[index_new], true);
	SetMenuExitButton(menuw_sawedoff[index_new], true);
	SetMenuExitButton(menuw_mag7[index_new], true);
	SetMenuExitButton(menuw_elite[index_new], true);
	SetMenuExitButton(menuw_deagle[index_new], true);
	SetMenuExitButton(menuw_tec9[index_new], true);
	SetMenuExitButton(menuw_fiveseven[index_new], true);
	SetMenuExitButton(menuw_cz75a[index_new], true);
	SetMenuExitButton(menuw_glock[index_new], true);
	SetMenuExitButton(menuw_usp_silencer[index_new], true);
	SetMenuExitButton(menuw_p250[index_new], true);
	SetMenuExitButton(menuw_hkp2000[index_new], true);
	SetMenuExitButton(menuw_bayonet[index_new], true);
	SetMenuExitButton(menuw_knife_gut[index_new], true);
	SetMenuExitButton(menuw_knife_flip[index_new], true);
	SetMenuExitButton(menuw_knife_m9_bayonet[index_new], true);
	SetMenuExitButton(menuw_knife_karambit[index_new], true);
	SetMenuExitButton(menuw_knife_tactical[index_new], true);
	SetMenuExitButton(menuw_knife_butterfly[index_new], true);
	SetMenuExitButton(menuw_knife_falchion[index_new], true);
	SetMenuExitButton(menuw_knife_push[index_new], true);
	SetMenuExitButton(menuw_revolver[index_new], true);
	SetMenuExitButton(menuw_knife_survival_bowie[index_new], true);
}

/* stock GetReserveAmmo(client, weapon)
{
    new ammotype = GetEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType");
    if(ammotype == -1) return -1;
    
    return GetEntProp(client, Prop_Send, "m_iAmmo", _, ammotype);
}

stock SetReserveAmmo(client, weapon, ammo)
{
    new ammotype = GetEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType");
    if(ammotype == -1) return;
    
    SetEntProp(client, Prop_Send, "m_iAmmo", ammo, _, ammotype);
}  */

stock GetReserveAmmo(weapon)
{
	new ammotype = GetEntProp(weapon, Prop_Send, "m_iPrimaryReserveAmmoCount");
	if(ammotype == -1) return -1;
    
	return ammotype;
}

stock SetReserveAmmo(weapon, ammo)
{
	SetEntProp(weapon, Prop_Send, "m_iPrimaryReserveAmmoCount", ammo);
	//PrintToChatAll("fijar es %i", ammo);
} 

Restore(client, windex, String:Classname[64], weaponindex)
{
	new bool:knife = false;
	if(StrContains(Classname, "weapon_knife", false) == 0 || StrContains(Classname, "weapon_bayonet", false) == 0) 
	{
		knife = true;
	}
	
	//PrintToChat(client, "weapon %s", Classname);
	new ammo, clip;
	if(!knife)
	{
		ammo = GetReserveAmmo(windex);
		clip = GetEntProp(windex, Prop_Send, "m_iClip1");
	}
	RemovePlayerItem(client, windex);
	AcceptEntityInput(windex, "Kill");
	
	new entity;
	if(zombiesv && knife)
	{
		new id = GetEntProp(windex, Prop_Send, "m_iItemDefinitionIndex", 4, 0);
		//PrintToChatAll("TEST: %d", id);
		new iItem = 0;
		if(id == 500)
		{
			iItem = GivePlayerItem(client, "weapon_bayonet");
		}
		else if(id == 506)
		{
			iItem = GivePlayerItem(client, "weapon_knife_gut");
		}
		else if(id == 505)
		{
			iItem = GivePlayerItem(client, "weapon_knife_flip");
		}
		else if(id == 508)
		{
			iItem = GivePlayerItem(client, "weapon_knife_m9_bayonet");
		}
		else if(id == 507)
		{
			iItem = GivePlayerItem(client, "weapon_knife_karambit");
		}
		else if(id == 509)
		{
			iItem = GivePlayerItem(client, "weapon_knife_tactical");
		}
		else if(id == 515)
		{
			iItem = GivePlayerItem(client, "weapon_knife_butterfly");
		}
		else if(id == 512)
		{
			iItem = GivePlayerItem(client, "weapon_knife_falchion");
		}
		else if(id == 516)
		{
			iItem = GivePlayerItem(client, "weapon_knife_push");
		}
		else if(id == 514)
		{
			iItem = GivePlayerItem(client, "weapon_knife_survival_bowie");
		}
		if (iItem > 0) 
			EquipPlayerWeapon(client, iItem);
	}
	else entity = GivePlayerItem(client, Classname);
	
	if(knife)
	{
		if (weaponindex != 42 && weaponindex != 59 && !zombiesv) 
			EquipPlayerWeapon(client, entity);
	}
	else
	{
		SetReserveAmmo(entity, ammo);
		SetEntProp(entity, Prop_Send, "m_iClip1", clip);
	}
}

ChangePaint(entity, theindex, client)
{
	if(theindex == 0)
	{
		theindex = GetRandomInt(1, g_paintCount[clientlang[client]]-1);
	}
	else if(theindex == -1) return;
	
/* 	new m_iItemIDHigh = GetEntProp(entity, Prop_Send, "m_iItemIDHigh");
	new m_iItemIDLow = GetEntProp(entity, Prop_Send, "m_iItemIDLow"); */

	SetEntProp(entity,Prop_Send,"m_iItemIDLow",-1);
	//SetEntProp(entity,Prop_Send,"m_iItemIDHigh",0);

	SetEntProp(entity,Prop_Send,"m_nFallbackPaintKit",g_paints[clientlang[client]][theindex][index]);
	if(g_paints[clientlang[client]][theindex][wear] >= 0.0) SetEntPropFloat(entity,Prop_Send,"m_flFallbackWear",g_paints[clientlang[client]][theindex][wear]);
	if(g_paints[clientlang[client]][theindex][pattern] >= 0) SetEntProp(entity,Prop_Send,"m_nFallbackSeed",g_paints[clientlang[client]][theindex][pattern]);
	if(g_paints[clientlang[client]][theindex][stattrak] != -2) SetEntProp(entity,Prop_Send,"m_nFallbackStatTrak",g_paints[clientlang[client]][theindex][stattrak]);
	if(g_paints[clientlang[client]][theindex][quality] != -2) SetEntProp(entity,Prop_Send,"m_iEntityQuality",g_paints[clientlang[client]][theindex][quality]);
	
/* 	new Handle:pack;

	CreateDataTimer(0.2, RestoreItemID, pack);
	WritePackCell(pack,EntIndexToEntRef(entity));
	WritePackCell(pack,m_iItemIDHigh);
	WritePackCell(pack,m_iItemIDLow); */
}

public OnClientPutInServer(client)
{
	//CreateTimer(1.0, Timer_ClientLanguage, GetClientSerial(client), TIMER_FLAG_NO_MAPCHANGE);
	//checked[client] = false;
	if(!IsFakeClient(client)) SDKHook(client, SDKHook_WeaponEquipPost, OnPostWeaponEquip);
}

public Action:OnPostWeaponEquip(client, weapon)
{
	if(onlyadmin && GetUserAdmin(client) == INVALID_ADMIN_ID) return;
	
	if(weapon < 1 || !IsValidEdict(weapon) || !IsValidEntity(weapon)) return;
	
	if (GetEntProp(weapon, Prop_Send, "m_hPrevOwner") > 0)
		return;
		
	decl String:Classname[64];
	if(!GetEdictClassname(weapon, Classname, 64) || StrEqual(Classname, "weapon_taser") || (!g_c4 && StrEqual(Classname, "weapon_c4")))
	{
		return;
	}
	ReplaceString(Classname, 64, "weapon_", "");
	new weaponindex = GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex");
	if(weaponindex == 42 || weaponindex == 59)
	{
		return;
	}

	switch (weaponindex)
	{
		case 60: strcopy(Classname, 64, "m4a1_silencer");
		case 61: strcopy(Classname, 64, "usp_silencer");
		case 63: strcopy(Classname, 64, "cz75a");
		case 500: strcopy(Classname, 64, "bayonet");
		case 506: strcopy(Classname, 64, "knife_gut");
		case 505: strcopy(Classname, 64, "knife_flip");
		case 508: strcopy(Classname, 64, "knife_m9_bayonet");
		case 507: strcopy(Classname, 64, "knife_karambit");
		case 509: strcopy(Classname, 64, "knife_tactical");
		case 515: strcopy(Classname, 64, "knife_butterfly");
		case 512: strcopy(Classname, 64, "knife_falchion");
		case 516: strcopy(Classname, 64, "knife_push");
		case 64: strcopy(Classname, 64, "revolver");
		case 514: strcopy(Classname, 64, "knife_survival_bowie");
	}
	if(arbol[client] == INVALID_HANDLE) return;
	new valor = 0;
	if(!GetTrieValue(arbol[client], Classname, valor)) return;
	if(valor == -1 || (valor != 0 && g_paints[clientlang[client]][valor][index] == 0)) return;
	//PrintToChat(client, "prueba");
	ChangePaint(weapon, valor, client);
}

SaveCookies(client)
{
	decl String:steamid[32];
	GetClientAuthId(client, AuthId_Steam2,  steamid, sizeof(steamid) );
	new String:Name[MAX_NAME_LENGTH+1];
	new String:SafeName[(sizeof(Name)*2)+1];
	if (!GetClientName(client, Name, sizeof(Name)))
		Format(SafeName, sizeof(SafeName), "<noname>");
	else
	{
		TrimString(Name);
		SQL_EscapeString(db, Name, SafeName, sizeof(SafeName));
	}	

	decl String:buffer[3096];
	Format(buffer, sizeof(buffer), "UPDATE weaponpaints SET last_accountuse = %d, playername = '%s' WHERE steamid = '%s';",GetTime(), SafeName,steamid);
	LogToFileEx(g_sCmdLogPath, "Query %s", buffer);
	SQL_TQuery(db, tbasico2, buffer);
}

CrearMenu1(client)
{
	
	menu1[client] = CreateMenu(DIDMenuHandler_armas);
	SetMenuTitle(menu1[client], "%T","Menu title 1", client);
	
	new String:Items[64];
	
	decl String:temp[128], String:temp1[64];
	new valor;
	for(new i=0;i<GetArraySize(array_armas);++i)
	{
		GetArrayString(array_armas, i, Items, 64);
		if(GetTrieValue(arbol[client], Items, valor))
		{
			if(valor == -1) Format(temp, 128, "%s", Items);
			else if (valor == 0)
			{
				Format(temp1, sizeof(temp1), "%T", "Random paint", client);
				Format(temp, 128, "%s - %s", Items, temp1);
			}
			else Format(temp, 128, "%s - %s", Items, g_paints[clientlang[client]][valor][Nombre]);
		}
		else Format(temp, 128, "%s", Items);
		AddMenuItem(menu1[client], Items, temp);
	}
}

public DIDMenuHandler_armas(Handle:menu, MenuAction:action, client, itemNum) 
{
	if ( action == MenuAction_Select ) 
	{
		decl String:info[64];
		
		GetMenuItem(menu, itemNum, info, sizeof(info));

		Format(s_arma[client], 64, info);
		s_sele[client] = GetMenuSelectionPosition();
		ShowMenu(client, 0);
	}
}

CheckSteamID(client)
{
	decl String:query[255], String:steamid[32];
	GetClientAuthId(client, AuthId_Steam2,  steamid, sizeof(steamid) );
	
	Format(query, sizeof(query), "SELECT * FROM weaponpaints WHERE steamid = '%s'", steamid);
	LogToFileEx(g_sCmdLogPath, "Query %s", query);
	SQL_TQuery(db, T_CheckSteamID, query, GetClientUserId(client));
}
 
public T_CheckSteamID(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	new client;
 
	/* Make sure the client didn't disconnect while the thread was running */
	if ((client = GetClientOfUserId(data)) == 0)
	{
		return;
	}
	if (hndl == INVALID_HANDLE)
	{
		ComprobarDB();
		return;
	}
	//PrintToChatAll("comprobado41");
	if (!SQL_GetRowCount(hndl) || !SQL_FetchRow(hndl)) 
	{
		Nuevo(client);
		return;
	}
	
	arbol[client] = CreateTrie();

	new String:Items[64];
	
	new String:temp[64];
	new contar = 3;
	for(new i=0;i<GetArraySize(array_armas);++i)
	{
		GetArrayString(array_armas, i, Items, 64);
		SQL_FetchString(hndl, contar, temp, 64);
		SetTrieValue(arbol[client], Items, FindStringInArray(array_paints[clientlang[client]], temp));
		
		//LogMessage("Sacado %i del arma %s", FindStringInArray(array_paints, temp),Items);
		
		contar++;
	}

/*   	SQL_FetchString(hndl, contar, temp, 64);
	SetTrieValue(arbol[client], "favorite1", FindStringInArray(array_paints, temp));
	contar++;
	
	SQL_FetchString(hndl, contar, temp, 64);
	SetTrieValue(arbol[client], "favorite2", FindStringInArray(array_paints, temp));
	contar++;
	
	SQL_FetchString(hndl, contar, temp, 64);
	SetTrieValue(arbol[client], "favorite3", FindStringInArray(array_paints, temp));
	contar++;
	
	SQL_FetchString(hndl, contar, temp, 64);
	SetTrieValue(arbol[client], "favorite4", FindStringInArray(array_paints, temp));
	contar++;
	
	SQL_FetchString(hndl, contar, temp, 64);
	SetTrieValue(arbol[client], "favorite5", FindStringInArray(array_paints, temp));
	contar++;
	
	SQL_FetchString(hndl, contar, temp, 64);
	SetTrieValue(arbol[client], "favorite6", FindStringInArray(array_paints, temp));
	contar++;
	
	SQL_FetchString(hndl, contar, temp, 64);
	SetTrieValue(arbol[client], "favorite7", FindStringInArray(array_paints, temp));
	contar++; */
	
	
	comprobado41[client] = true;
/* 	new String:equipo[64];
	SQL_FetchString( hndl, 0, equipo, 64);
	PrintToChatAll(equipo);
	
	SQL_FetchString( hndl, 1, equipo, 64);
	PrintToChatAll(equipo);
	
	SQL_FetchString( hndl, 2, equipo, 64);
	PrintToChatAll(equipo);
	
	SQL_FetchString( hndl, 3, equipo, 64); // este
	PrintToChatAll(equipo); */
	
	//PrintToChatAll("pasado");
	
/* 	new String:equipo[4];
	SQL_FetchString( hndl, 0, equipo, 4);
	
	if(StrEqual(equipo, "CT", false))
	{
		ft[client] = CS_TEAM_CT;
	}
	else if(StrEqual(equipo, "T", false))
	{
		ft[client] = CS_TEAM_T;
	} */
	Renovar(client);

}

Renovar(client)
{
	if(IsPlayerAlive(client))
	{
		char classname[64];
		int weaponIndex;
		for (new i = 0; i <= 3; i++)
		{
			if(i == CS_SLOT_GRENADE) continue;
			
			if ((weaponIndex = GetPlayerWeaponSlot(client, i)) != -1)
			{
				GetEdictClassname(weaponIndex, classname, 64);
				
				Restore(client, weaponIndex, classname, GetEntProp(weaponIndex, Prop_Send, "m_iItemDefinitionIndex"));
			}
		}
	}
}

Nuevo(client)
{
	//PrintToChatAll("metido");
	decl String:query[255], String:steamid[32];
	GetClientAuthId(client, AuthId_Steam2,  steamid, sizeof(steamid) );
	new userid = GetClientUserId(client);
	
	new String:Name[MAX_NAME_LENGTH+1];
	new String:SafeName[(sizeof(Name)*2)+1];
	if (!GetClientName(client, Name, sizeof(Name)))
		Format(SafeName, sizeof(SafeName), "<noname>");
	else
	{
		TrimString(Name);
		SQL_EscapeString(db, Name, SafeName, sizeof(SafeName));
	}
		
	Format(query, sizeof(query), "INSERT INTO weaponpaints(playername, steamid, last_accountuse) VALUES('%s', '%s', '%d');", SafeName, steamid, GetTime());
	LogToFileEx(g_sCmdLogPath, "Query %s", query);
	SQL_TQuery(db, tbasico3, query, userid);
}


public PruneDatabase()
{
	if (db == INVALID_HANDLE)
	{
		LogToFileEx(g_sCmdLogPath, "Prune Database: No connection");
		ComprobarDB();
		return;
	}

	new maxlastaccuse;
	maxlastaccuse = GetTime() - (IDAYS * 86400);

	decl String:buffer[1024];

	if (ismysql == 1)
		Format(buffer, sizeof(buffer), "DELETE FROM `weaponpaints` WHERE `last_accountuse`<'%d' AND `last_accountuse`>'0';", maxlastaccuse);
	else
		Format(buffer, sizeof(buffer), "DELETE FROM weaponpaints WHERE last_accountuse<'%d' AND last_accountuse>'0';", maxlastaccuse);

	LogToFileEx(g_sCmdLogPath, "Query %s", buffer);
	SQL_TQuery(db, tbasicoP, buffer);
}

public tbasico(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if (hndl == INVALID_HANDLE)
	{
		LogToFileEx(g_sCmdLogPath, "Query failure: %s", error);
	}
	new client;
 
	/* Make sure the client didn't disconnect while the thread was running */
	if ((client = GetClientOfUserId(data)) == 0)
	{
		return;
	}
	comprobado41[client] = true;
	
}

public tbasico2(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if (hndl == INVALID_HANDLE)
	{
		LogToFileEx(g_sCmdLogPath, "Query failure: %s", error);
		ComprobarDB();
	}
}

public tbasico3(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if (hndl == INVALID_HANDLE)
	{
		LogToFileEx(g_sCmdLogPath, "Query failure: %s", error);
		ComprobarDB();
	}
	new client;
 
	/* Make sure the client didn't disconnect while the thread was running */
	if ((client = GetClientOfUserId(data)) == 0)
	{
		return;
	}
	
	arbol[client] = CreateTrie();

	new String:Items[64];
	
	for(new i=0;i<GetArraySize(array_armas);++i)
	{
		GetArrayString(array_armas, i, Items, 64);
		SetTrieValue(arbol[client], Items, -1);
	}
	
	SetTrieValue(arbol[client], "favorite1", -1);
	SetTrieValue(arbol[client], "favorite2", -1);
	SetTrieValue(arbol[client], "favorite3", -1);
	SetTrieValue(arbol[client], "favorite4", -1);
	SetTrieValue(arbol[client], "favorite5", -1);
	SetTrieValue(arbol[client], "favorite6", -1);
	SetTrieValue(arbol[client], "favorite7", -1);
	
	comprobado41[client] = true;
}

public tbasicoC(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if (hndl == INVALID_HANDLE)
	{
		LogToFileEx(g_sCmdLogPath, "Query failure: %s", error);
	}
	//LogMessage("Database connection successful");
	
	for(new client = 1; client <= MaxClients; client++)
	{
		if(IsClientInGame(client))
		{
			//checked[client] = false;
			CreateTimer(0.0, Timer_ClientLanguage, GetClientSerial(client), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

public tbasicoP(Handle:owner, Handle:hndl, const String:error[], any:data)
{
	if (hndl == INVALID_HANDLE)
	{
		LogToFileEx(g_sCmdLogPath, "Query failure: %s", error);
		ComprobarDB();
	}
	//LogMessage("Prune Database successful");
}