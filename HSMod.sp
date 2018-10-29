#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "HS MOD",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

bool hsmod = false;

public OnPluginStart() 
{
	RegAdminCmd("sm_hsmod", HSMod, ADMFLAG_ROOT, "HSMod'u Açar/Kapatır.");
	HookEvent("player_spawn", OnPlayerSpawn);
	HookEvent("player_death", Event_PlayerDeath);
	hsmod = false;
}

public OnMapStart()
{
	hsmod = false;
}

public Action:HSMod( client, args )
{
	if(hsmod)
	{
		PrintToChatAll(" \x02[DrK # GaminG] \x0EHSMod \x04%N \x10tarafından kapatıldı.", client);
		hsmod = false;
	}
	else
	{
		PrintToChatAll(" \x02[DrK # GaminG] \x0EHSMod \x04%N \x10tarafından açıldı.", client);
		hsmod = true;
	}
	return Plugin_Continue;
}

public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype) 
{
	if(hsmod)
	{
		if(!(damagetype & CS_DMG_HEADSHOT))
		{
			damage = 0.0;
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}

public Action:OnPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));	
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage); 
}

public Action:Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	SDKUnhook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}