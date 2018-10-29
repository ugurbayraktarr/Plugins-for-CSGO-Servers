#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>

public Plugin:myinfo =
{
	name        = "Damage Gösterici",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

public OnPluginStart() 
{
}
public OnClientPostAdminCheck(iClient) 
{ 
    SDKHook(iClient, SDKHook_OnTakeDamage, OnTakeDamage); 
} 

public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype) 
{
	new iAttacker;
	if(attacker>64)
		iAttacker = GetClientOfUserId(attacker);
	else
		iAttacker = attacker;
	
	if(iAttacker > 0)
	{
		new hp = GetClientHealth(victim);
		
		if(hp - damage > 0)
		{
			PrintCenterText(attacker, "Hasar: <font color='#FF0000'>%.0f</font> \nKalan: <font color='#00FF00'>%.0f</font> \nHedef: <font color='#FFFF00'>%N</font>", damage, hp - damage + 1, victim);
		}
		else
		{
			PrintCenterText(attacker, " <font color='#FF0000'>%N</font> \n <font color='#00FFFF'>Kişisini öldürdün!</font>", victim);
		}
	}
	return Plugin_Continue;
}