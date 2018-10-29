#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

//#pragma newdecls required // 2015 rules 

Handle hAutoBhop;
bool CSGO;
bool bunnyDurumu = false;
int WATER_LIMIT;

public Plugin myinfo =
{
	name = "Bunny (Hasar aldığında bunny durur)",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "1.0"
}

public void OnPluginStart()
{
	int ips[4];
	char serverip[32];
	int ip = GetConVarInt(FindConVar("hostip"));
	int port = GetConVarInt(FindConVar("hostport"));
	ips[0] = (ip >> 24) & 0x000000FF;
	ips[1] = (ip >> 16) & 0x000000FF;
	ips[2] = (ip >> 8) & 0x000000FF;
	ips[3] = ip & 0x000000FF;
	
	Format(serverip, sizeof(serverip), "%d.%d.%d.%d:%d", ips[0], ips[1], ips[2], ips[3],port);
	if(StrEqual(serverip, "95.173.166.19:27015") == false)
	{
		LogError("Bu plugin ImPossibLe` tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	
	AutoExecConfig(true, "impossiblebunny");
	hAutoBhop = CreateConVar("impo_autobhop", "1", "Oto Bunny Aç/Kapat", FCVAR_NOTIFY|FCVAR_REPLICATED);
	
	char theFolder[40];
	GetGameFolderName(theFolder, sizeof(theFolder));
	CSGO = StrEqual(theFolder, "csgo");
	(CSGO) ? (WATER_LIMIT = 2) : (WATER_LIMIT = 1);
	
	RegAdminCmd("sm_bunnyac", BunnyAc, ADMFLAG_GENERIC, "Bunny açar.");
	RegAdminCmd("sm_bunnykapat", BunnyKapat, ADMFLAG_GENERIC, "Bunny kapatır.");
}

public OnMapStart()
{
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	
	if(StrContains(mapName, "jail_", false)!= -1)
	{
		bunnyDurumu = true;
		BhopOn();
	}
	if(StrContains(mapName, "jb_", false)!= -1)
	{
		bunnyDurumu = true;
		BhopOn();
	}
	if(StrContains(mapName, "awp_", false)!= -1)
	{
		bunnyDurumu = false;
	}
	if(StrContains(mapName, "aim_", false)!= -1)
	{
		bunnyDurumu = false;
	}
	if(StrContains(mapName, "mm_", false)!= -1)
	{
		bunnyDurumu = false;
	}
	if(StrContains(mapName, "mg_", false)!= -1)
	{
		bunnyDurumu = true;
		BhopOn();
	}
	if(StrContains(mapName, "mg_soccer", false)!= -1)
	{
		bunnyDurumu = false;
	}
	if(StrContains(mapName, "deathrun_", false)!= -1)
	{
		bunnyDurumu = true;
		BhopOn();
	}
	if(StrContains(mapName, "dr_", false)!= -1)
	{
		bunnyDurumu = true;
		BhopOn();
	}
	if(StrContains(mapName, "35hp_", false)!= -1)
	{
		bunnyDurumu = true;
		BhopOn();
	}
	if(StrContains(mapName, "1hp_", false)!= -1)
	{
		bunnyDurumu = true;
		BhopOn();
	}
	if(StrContains(mapName, "de_", false)!= -1)
	{
		bunnyDurumu = false;
	}
	if(StrContains(mapName, "cs_", false)!= -1)
	{
		bunnyDurumu = false;
	}
	if(StrContains(mapName, "bhop_", false)!= -1)
	{
		bunnyDurumu = true;
		BhopOn();
	}
}

public Action:BunnyAc(client, args)
{
	PrintToChatAll(" \x02[DrK # GaminG] \x10%N \x0CBunny'i açtı!", client);
	BhopOn();
	bunnyDurumu = true;
}

public Action:BunnyKapat(client, args)
{
	PrintToChatAll(" \x02[DrK # GaminG] \x10%N \x0CBunny'i kapattı!", client);
	bunnyDurumu = false;
}

public void OnConfigsExecuted()
{
	if(bunnyDurumu) BhopOn();
}

public void OnClientPutInServer(int client)
{
	if(!CSGO) // To boost in CSGO use together https://forums.alliedmods.net/showthread.php?t=244387
		SDKHook(client, SDKHook_PreThink, PreThink); //This make you fly in CSS;
}

public Action PreThink(int client)
{
	if(IsValidClient(client) && IsPlayerAlive(client) && bunnyDurumu)
	{
		SetEntPropFloat(client, Prop_Send, "m_flStamina", 0.0); 
	}
}

void BhopOn()
{
	if(!CSGO)
	{
		SetCvar("sv_enablebunnyhopping", "1");
		SetCvar("sv_airaccelerate", "2000");
	}
	else 
	{
		SetCvar("sv_enablebunnyhopping", "1"); 
		SetCvar("sv_staminamax", "0");
		SetCvar("sv_airaccelerate", "2000");
		SetCvar("sv_staminajumpcost", "0");
		SetCvar("sv_staminalandcost", "0");
	}
}

stock void SetCvar(char[] scvar, char[] svalue)
{
	Handle cvar = FindConVar(scvar);
	SetConVarString(cvar, svalue, true);
}

bool damageAldi[MAXPLAYERS+1];
public OnClientPostAdminCheck(iClient) 
{ 
    SDKHook(iClient, SDKHook_OnTakeDamage, OnTakeDamage); 
} 

public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype) 
{ 
	if(GetClientTeam(victim) != GetClientTeam(attacker))
	{
		damageAldi[victim] = true;
		CreateTimer(2.0, HasarSifirla, victim);
	}
}

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon)
{
	if(!damageAldi[client])
		if(bunnyDurumu && GetConVarInt(hAutoBhop) == 1) //Check if plugin and autobhop is enabled
			if (IsPlayerAlive(client) && buttons & IN_JUMP) //Check if player is alive and is in pressing space
				if(!(GetEntityMoveType(client) & MOVETYPE_LADDER) && !(GetEntityFlags(client) & FL_ONGROUND)) //Check if is not in ladder and is in air
					if(waterCheck(client) < WATER_LIMIT)
						buttons &= ~IN_JUMP; 
	return Plugin_Continue;
}


public Action HasarSifirla(Handle timer, int victim)
{
	damageAldi[victim] = false;
}

int waterCheck(int client)
{
	return GetEntProp(client, Prop_Data, "m_nWaterLevel");
}

stock bool IsValidClient(int client)
{
	if(client <= 0 ) return false;
	if(client > MaxClients) return false;
	if(!IsClientConnected(client)) return false;
	return IsClientInGame(client);
}