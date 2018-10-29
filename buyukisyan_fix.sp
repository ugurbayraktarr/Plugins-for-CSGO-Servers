#include <sdkhooks>
#include <sdktools>

public Plugin:myinfo =
{
	name        = "Büyükisyan Fix",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

public OnPluginStart() 
{
	HookEvent("round_start", Event_RoundStart);
}

public Action Event_RoundStart(Handle event, char[] name, bool dontBroadcast)
{
	CreateTimer(1.0, MuftuleriKaldir);
}

public Action MuftuleriKaldir(Handle timer)
{
	new i;
	for(i=1; i<=2048; i++)
	{
		if(IsValidEntity(i))
		{
			decl String:entityIsmi[128];
			GetEntityClassname(i, entityIsmi, sizeof(entityIsmi));
			if(StrEqual(entityIsmi, "func_physbox", false))
			{
				//PrintToChat(client, "%s - %d", entityIsmi, i);
				AcceptEntityInput(i, "Kill");
			}
		}
	}
}

public OnMapStart()
{
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	
	if(!((StrEqual(mapName, "jb_buyukisyan_son", false)) || (StrEqual(mapName, "jb_buyukisyan_pgg", false))))
		SetFailState("Bu plugin sadece buyukisyan maplarinda calismaktadir..");
}

public OnEntityCreated(entity, const char[] classname) 
{
	if (StrEqual(classname, "weapon_m4a1_silencer"))
	{
		PrintToChatAll(" \x04[DrK # GaminG] \x10Büyükisyan FIX!");
		AcceptEntityInput(entity, "Kill");
		//SDKHook(entity, SDKHook_Spawn, OnDeagleSpawn);
	}
}

/*
public Action:OnDeagleSpawn(entity) 
{
	PrintToChatAll("TEST2");
	return Plugin_Handled; 
}  */