#pragma semicolon 1

#include <sourcemod>
#include <sdktools>


#define TEAM_UNASSIGNED 0
#define TEAM_SPECTATE   1
#define TEAM_T          2
#define TEAM_CT         3

public Plugin:myinfo =
{
	name = "Jail CT Yasaklaması",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "1.0"
};

// Convar handles
new Handle:h_cvarLimitTeams;

// Plugin convar handles
new Handle:h_cvarChat;
new Handle:h_cvarSuicide;
new Handle:h_cvarASuicide;
new Handle:h_cvarMapLimit;
new Handle:h_cvarRoundLimit;
new Handle:h_cvarRestrict[4];
new Handle:h_cvarPenalty;
new Handle:h_cvarImmunity;

// Convar variables
new g_cvarLimitTeams;

// Plugin convar variables
new bool:g_cvarChat;
new bool:g_cvarSuicide;
new bool:g_cvarASuicide;
new g_cvarMapLimit;
new g_cvarRoundLimit;
new bool:g_cvarRestrict[4];
new String:g_cvarPenalty[16];
new bool:g_cvarImmunity;

// Plugin variables
new g_MapCount[MAXPLAYERS+1];
new g_RoundCount[MAXPLAYERS+1];

/******
 *Load*
*******/

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
	
	
	// Event hooks
	HookEventEx("round_start", OnRoundStart);
	HookEventEx("teamplay_round_start", OnRoundStart);
	
	// Commands
	AddCommandListener(JoinTeamCmd, "jointeam");
	
	// Convars
	h_cvarChat        = CreateConVar("drkgaming_jailctyasagi_chatmesaji", "1", "Give plugin feedback to players in chat (1 - verbose, 0 - silent)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	h_cvarSuicide     = CreateConVar("drkgaming_jailctyasagi_takimdegisenioldur", "1", "Force suicide on alive players who switch teams (1 - force suicide, 0 - no suicide)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	h_cvarASuicide    = CreateConVar("drkgaming_jailctyasagi_takimdegisenadminioldur", "1", "Force suicide on alive admins who switch teams (admin override: teamchange_unlimited_suicide_admin)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	h_cvarMapLimit    = CreateConVar("drkgaming_jailctyasagi_mapbasinatakimdegisebilmesayisi", "0", "Number of times a client can change teams per map (0 - disable)", FCVAR_NOTIFY, true, 0.0);
	h_cvarRoundLimit  = CreateConVar("drkgaming_jailctyasagi_roundbasinatakimdegisebilmesayisi", "0", "Number of times a client can change teams per round (0 - disable)", FCVAR_NOTIFY, true, 0.0);
	h_cvarRestrict[0] = CreateConVar("drkgaming_jailctyasagi_autotakimiyasakla", "1", "Restrict players from auto-assigning (1 - restrict, 0 - allow)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	h_cvarRestrict[1] = CreateConVar("drkgaming_jailctyasagi_spectakimiyasakla", "0", "Restrict players from joining spectate (1 - restrict, 0 - allow)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	h_cvarRestrict[2] = CreateConVar("drkgaming_jailctyasagi_ttakimiyasakla", "0", "Restrict players from joining terrorists (1 - restrict, 0 - allow)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	h_cvarRestrict[3] = CreateConVar("drkgaming_jailctyasagi_cttakimiyasakla", "1", "Restrict players from joining counter-terrorists (1 - restrict, 0 - allow)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	h_cvarPenalty     = CreateConVar("drkgaming_jailctyasagi_sistem", "011111101101", "Count auto-assign team change");
	h_cvarImmunity    = CreateConVar("drkgaming_jailctyasagi_admindokunulmazligi", "0", "Admins receive team change count immunity (admin override: teamchange_unlimited_immunity)", FCVAR_NOTIFY, true, 0.0, true, 1.0);
	h_cvarLimitTeams  = FindConVar("mp_limitteams");
	
	// Convar hooks
	HookConVarChange(h_cvarLimitTeams, OnConvarChanged);
	HookConVarChange(h_cvarChat, OnConvarChanged);
	HookConVarChange(h_cvarSuicide, OnConvarChanged);
	HookConVarChange(h_cvarASuicide, OnConvarChanged);
	HookConVarChange(h_cvarMapLimit, OnConvarChanged);
	HookConVarChange(h_cvarRoundLimit, OnConvarChanged);
	HookConVarChange(h_cvarImmunity, OnConvarChanged);
	HookConVarChange(h_cvarPenalty, OnConvarChanged);
	for(new i = TEAM_UNASSIGNED; i <= TEAM_CT; i++)
		HookConVarChange(h_cvarRestrict[i], OnConvarChanged);
	
	//AutoExecConfig(true, "teamchange_unlimited");
	UpdateAllConvars();
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	return APLRes_Success;
}

/*********
 *Globals*
**********/

public OnMapStart()
{
	for(new i = 1; i <= MaxClients; i++)
	{
		g_MapCount[i] = 0;
		g_RoundCount[i] = 0;
	}
	
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	
	if(!((StrContains(mapName, "jb_", false) != -1) || (StrContains(mapName, "jail_", false)!= -1)))
	{
		SetFailState("Bu plugin sadece jail maplarinda calismaktadir..");
	}
}

public OnConfigsExecuted()
{
	UpdateAllConvars();
}

/********
 *Events*
*********/

public OnRoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	for(new i = 1; i <= MaxClients; i++)
		g_RoundCount[i] = 0;
}

/**********
 *Commands*
***********/

public Action:JoinTeamCmd(client, const String:command[], argc)
{ 
	if(!IsValidClient(client) || argc < 1)
		return Plugin_Handled;
		
	decl String:arg[4];
	GetCmdArg(1, arg, sizeof(arg));
	new toteam = StringToInt(arg);
	
	if(toteam < TEAM_UNASSIGNED || toteam > TEAM_CT || g_cvarRestrict[toteam])
	{
		if(g_cvarChat)
			ReplyToCommand(client, "\x01\x0B\x04[SM]\x01 Joining that team is not allowed.");
		return Plugin_Handled;
	}
	
	new interaction = GetInteraction(GetClientTeam(client), toteam);	
	new String:charr[2] =  "1";
	if(interaction != -1)
		Format(charr, 2, "%c", g_cvarPenalty[interaction]);
	if(StringToInt(charr) > 0)
	{
		g_MapCount[client]++;
		g_RoundCount[client]++;
	}
	
	new bool:Access = StringToInt(charr) == 0 || (g_cvarImmunity && CheckCommandAccess(client, "teamchange_unlimited_immunity", ADMFLAG_GENERIC, true));
	if(g_RoundCount[client] <= g_cvarRoundLimit || g_cvarRoundLimit == 0 || Access)
	{
		if(g_MapCount[client] <= g_cvarMapLimit || g_cvarMapLimit == 0 || Access)
			TeamChangeActual(client, toteam);
		else
		{
			if(g_cvarChat)
				PrintToChat(client, "\x01\x0B\x04[SM]\x01 Only %i team changes allowed per map.", g_cvarMapLimit);
			return Plugin_Handled;
		}
	}
	else
	{
		if(g_cvarChat)
			PrintToChat(client, "\x01\x0B\x04[SM]\x01 Only %i team changes allowed per round.", g_cvarRoundLimit);
		return Plugin_Handled;
	}
	return Plugin_Handled;
}

/*********
 *Helpers*
**********/

GetInteraction(fromteam, toteam)
{
	switch(fromteam)
	{
		case 0:
		{
			switch(toteam)
			{
				case 1: return 0;
				case 2: return 1;
				case 3: return 2;
			}
		}
		case 1:
		{
			switch(toteam)
			{
				case 0: return 3;
				case 2: return 4;
				case 3: return 5;
			}
		}
		case 2:
		{
			switch(toteam)
			{
				case 0: return 6;
				case 1: return 7;
				case 3: return 8;
			}
		}
		case 3:
		{
			switch(toteam)
			{
				case 0: return 9;
				case 1: return 10;
				case 2: return 11;
			}
		}
	}
	return -1;
}

TeamChangeActual(client, toteam)
{
	// Client is auto-assigning
	if(toteam == TEAM_UNASSIGNED)
		toteam = GetRandomInt(TEAM_T, TEAM_CT);
	
	// Proceed with the team change only if client is switching to a team that they are not already on
	new fromteam = GetClientTeam(client);
	if(fromteam == TEAM_UNASSIGNED || fromteam != toteam)
	{
		// Check that the team change doesn't violate mp_limitteams
		new imbalance = GetTeamClientCount(TEAM_CT) - GetTeamClientCount(TEAM_T);
		if(fromteam == TEAM_UNASSIGNED || fromteam == TEAM_SPECTATE)
			imbalance += toteam == TEAM_CT ? 2 : -2;
		else
			imbalance += toteam == TEAM_CT ? 1 : -1;
		if(g_cvarLimitTeams != 0 && imbalance > 0 && toteam == TEAM_CT && imbalance > g_cvarLimitTeams)
		{
			if(g_cvarChat)
				PrintToChat(client, "\x01\x0B\x04[DrK # GaminG]\x01 Girmeye çalıştığınız takım dolu.");
			return;
		}
		else if(g_cvarLimitTeams != 0 && imbalance < 0 && toteam == TEAM_T && -imbalance > g_cvarLimitTeams)
		{
			if(g_cvarChat)
				PrintToChat(client, "\x01\x0B\x04[DrK # GaminG]\x01 Girmeye çalıştığınız takım dolu.");
			return;
		}

		// Check if suicide is not an issue
		if(toteam == TEAM_SPECTATE || fromteam <= TEAM_SPECTATE || !IsPlayerAlive(client))
		{
			ChangeClientTeam(client, toteam);
			return;
		}
		// Check admin suicide conditions
		if(CheckCommandAccess(client, "teamchange_unlimited_suicide_admin", ADMFLAG_GENERIC, true))
		{
			if(g_cvarASuicide)
			{
				ChangeClientTeam(client, toteam);
				return;
			}
		}
		// Check non-admin suicide conditions
		else if(g_cvarSuicide)
		{
			ChangeClientTeam(client, toteam);
			return;
		}
		
		// Otherwise move client to spectate first to avoid killing them
		new Handle:data = CreateDataPack();
		WritePackCell(data, client);
		WritePackCell(data, toteam);
		ChangeClientTeam(client, TEAM_SPECTATE);
		CreateTimer(1.0, TeamChangeActualTimer, data);
	}
}

/********
 *Timers*
*********/

public Action:TeamChangeActualTimer(Handle:timer, any:data)
{
	ResetPack(data);
	new client = ReadPackCell(data);
	new toteam = ReadPackCell(data);
	CloseHandle(data);
	
	if(IsClientInGame(client))
		ChangeClientTeam(client, toteam);
	return Plugin_Handled;
}

/*********
 *Convars*
**********/

public OnConvarChanged(Handle:cvar, const String:oldVal[], const String:newVal[])
{
	if(cvar == h_cvarLimitTeams)
		g_cvarLimitTeams = GetConVarInt(h_cvarLimitTeams);
	else if(cvar == h_cvarChat)
		g_cvarChat       = GetConVarBool(h_cvarChat);
	else if(cvar == h_cvarSuicide)
		g_cvarSuicide    = GetConVarBool(h_cvarSuicide);
	else if(cvar == h_cvarASuicide)
		g_cvarASuicide   = GetConVarBool(h_cvarASuicide);
	else if(cvar == h_cvarMapLimit)
		g_cvarMapLimit   = GetConVarInt(h_cvarMapLimit);
	else if(cvar == h_cvarRoundLimit)
		g_cvarRoundLimit = GetConVarInt(h_cvarRoundLimit);
	else if(cvar == h_cvarImmunity)
		g_cvarImmunity   = GetConVarBool(h_cvarImmunity);
	else if(cvar == h_cvarPenalty)
		GetConVarString(h_cvarPenalty, g_cvarPenalty, sizeof(g_cvarPenalty));
	else
	{
		for(new i = TEAM_UNASSIGNED; i <= TEAM_CT; i++)
			if(cvar == h_cvarRestrict[i])
				g_cvarRestrict[i] = GetConVarBool(h_cvarRestrict[i]);
	}
}

UpdateAllConvars()
{
	g_cvarLimitTeams = GetConVarInt(h_cvarLimitTeams);
	g_cvarChat       = GetConVarBool(h_cvarChat);
	g_cvarSuicide    = GetConVarBool(h_cvarSuicide);
	g_cvarASuicide   = GetConVarBool(h_cvarASuicide);
	g_cvarMapLimit   = GetConVarInt(h_cvarMapLimit);
	g_cvarRoundLimit = GetConVarInt(h_cvarRoundLimit);
	g_cvarImmunity   = GetConVarBool(h_cvarImmunity);
	GetConVarString(h_cvarPenalty, g_cvarPenalty, sizeof(g_cvarPenalty));
	for(new i = TEAM_UNASSIGNED; i <= TEAM_CT; i++)
		g_cvarRestrict[i] = GetConVarBool(h_cvarRestrict[i]);
}

/********
 *Stocks*
*********/

stock IsValidClient(client)
{
	if(client > 0 && client <= MaxClients && IsClientInGame(client))
		return true;
	return false;
}