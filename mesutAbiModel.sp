#pragma semicolon 1
#include <sourcemod>
#include <sdktools>

public Plugin:myinfo =
{
	name        = "Mesut abimizin modeli",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

new String:model[256];

public OnPluginStart() 
{
	model = "models/player/lara/lara.mdl";
	
	AddFileToDownloadsTable(model);
	PrecacheModel(model);
	
	HookEvent("player_spawn", EventPlayerSpawn);
}

public EventPlayerSpawn(Handle:event,const String:name[],bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	decl String:authid[32];
	GetClientAuthString(client, authid, sizeof(authid));
	if(StrEqual(authid, "STEAM_1:1:150784409", false)) // Mesut Abii
	{
		SetEntityModel(client, model); 
	}
}