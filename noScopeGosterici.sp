#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

new Handle:g_PluginTagi = INVALID_HANDLE;

public Plugin:myinfo =
{
	name        = "No Scope Gösterici",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

public OnPluginStart() 
{
	HookEvent("player_death", Event_PlayerDeath);
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
}

public Action:Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	char g_sWeapon[32];
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new client_died = GetClientOfUserId(GetEventInt(event, "userid"));
	
	new Float:attackerOrigin[3];
	new Float:diedOrigin[3];
	
	GetClientEyePosition(attacker, attackerOrigin);
	GetClientEyePosition(client_died, diedOrigin);
	
	new Float:mesafe1 = GetVectorDistance(attackerOrigin, diedOrigin, false);
	mesafe1 = mesafe1 / 40;
	
	
	GetEventString(event, "weapon", g_sWeapon, 32, "");
	if ((StrEqual(g_sWeapon, "awp", true)) || (StrEqual(g_sWeapon, "ssg08", true)))
	{
		if(!(GetEntProp(attacker, Prop_Send, "m_bIsScoped")))
		{
			if (GetEventBool(event, "headshot"))
			{
				PrintToChatAll(" \x02[%s] \x10%N \x0EDürbünsüz \x02HS \x04vurdu. \x01(\x0C%.1fmt\x01)",sPluginTagi, attacker, mesafe1);
			}
			else
			{
				PrintToChatAll(" \x02[%s] \x10%N \x0EDürbünsüz \x04vurdu. \x01(\x0C%.1fmt\x01)",sPluginTagi, attacker, mesafe1);
			}
		}
	}
}