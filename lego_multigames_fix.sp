#pragma semicolon 1
#include <sourcemod>
#include <sdktools>

#define PLUGIN_VERSION "1.0"


public Plugin:myinfo =
{
	name        = "Büyükisyan Fix",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

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
	
	HookEvent("round_start", Event_Round_Start, EventHookMode_Pre);
}


public OnMapStart()
{
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	
	if(!((StrEqual(mapName, "mg_lego_multigames_go_v6", false))))
		SetFailState("Bu plugin sadece multigames mapinda calismaktadir..");
}

public Action:Event_Round_Start(Handle:event, const String:name[], bool:dontBroadcast) 
{
	CreateTimer(1.0, DecoyKaldir);
}

public Action:DecoyKaldir(Handle:timer, client:yasayan)
{
	for(new i=0;i<=2024;i++)
	{
		if(IsValidEntity(i))
		{
			decl String:clsname[32];
			GetEntityClassname(i, clsname, sizeof(clsname));
			
			if(StrEqual(clsname, "weapon_decoy", false))
				AcceptEntityInput(i, "Kill");
		}
	}
}