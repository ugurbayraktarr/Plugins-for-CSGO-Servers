#pragma semicolon 1
#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <cstrike>

public Plugin:myinfo =
{
	name        = "Hasar Alınca Bunny Hızı Düşürme",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};



// When plugin starts
public OnPluginStart()
{
	HookEvent("player_jump", Event_Jumper);
}

// When a Player Jumps
public Action:Event_Jumper(Handle:event, const String:name[], bool:dontBroadcast)
{
// Remind Player that Bunnyhopping isnt allowed, and alter Gravity 
// temporarily to affect Bunnyhopping, but not normal crouch jumps.
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	SetEntityGravity(client, 1.5);
// Starts the 0.3 second timer.
	CreateTimer( 0.3, Timer_Bunnyhop_Detect, GetClientOfUserId(GetEventInt(event, "userid")), TIMER_REPEAT );
	
}
public Action:Timer_Bunnyhop_Detect(Handle:timer, any:client)
{
// Resets the users gravity. 
	SetEntityGravity(client, 1.0);
	return Plugin_Stop;
}

public OnPluginEnd()
{
// When plugin is unloaded, unhook the jump event, and spawn event.
	UnhookEvent("player_jump", Event_Jumper);
}

/*
bool damageAldi[MAXPLAYERS+1];
bool teleportYap[MAXPLAYERS+1];

public OnClientPostAdminCheck(iClient) 
{ 
    SDKHook(iClient, SDKHook_OnTakeDamage, OnTakeDamage); 
} 

public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype) 
{ 
	if(damage >= 1)
	{
		damageAldi[victim] = true;
		teleportYap[victim] = true;
		CreateTimer(2.0, HasarSifirla, victim);
	}
}

public Action HasarSifirla(Handle timer, int victim)
{
	damageAldi[victim] = false;
	teleportYap[victim] = false;
}

public OnPluginStart() 
{
	//RegConsoleCmd("sm_test", test);
}


public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)
{
	if(buttons & IN_JUMP)
	{
		if(damageAldi[client])
		{
			if(teleportYap[client])
			{
				new Float:PlayerOrigin[3];
				GetClientAbsOrigin(client, PlayerOrigin);
				PlayerOrigin[2] += 10;
				TeleportEntity(client, PlayerOrigin, NULL_VECTOR, NULL_VECTOR);
				teleportYap[client]. = false;
			}
			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}*/