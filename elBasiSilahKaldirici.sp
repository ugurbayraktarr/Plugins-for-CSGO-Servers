#include <sourcemod>
#include <smlib>

public Plugin:myinfo = 
{
    name = "El Başı Silah Kaldırıcı",
    author = "ImPossibLe`",
    description = "DrK # GaminG",
    version = "1.0"
};

public OnPluginStart()
{
    //HookEvent("player_spawn", Event_Spawn);
	HookEvent("round_end", Event_End);
	HookEvent("round_start", Event_RoundStart);
}

Handle silahTimer;

/*public Action:Event_Spawn(Handle:event, const String:name[], bool:dontBroadcast)
{
    new i = GetClientOfUserId(GetEventInt(event, "userid"));
    RemoveWeapons(i);
}*/
public Action:Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	if(silahTimer != INVALID_HANDLE)
		KillTimer(silahTimer);
}

public Action:Event_End(Handle:event, const String:name[], bool:dontBroadcast)
{
	new Float:fDelay;
	new Handle:g_hCvarDelay = INVALID_HANDLE;
	g_hCvarDelay = FindConVar("mp_round_restart_delay");
	
	if (g_hCvarDelay != INVALID_HANDLE)
	{
		fDelay = GetConVarFloat(g_hCvarDelay);
	} 
	fDelay = fDelay - 0.1;
	
	silahTimer = CreateTimer(fDelay, SilahlariKaldir);
	
	/*GetConVarFloat()
    new i = GetClientOfUserId(GetEventInt(event, "userid"));
    RemoveWeapons(i);*/
}

public Action SilahlariKaldir(Handle timer)
{
	new i;
	for(i=1;i<=MaxClients;i++)
	{
		if(!IsClientConnected(i)) continue;
		if(!IsClientInGame(i)) continue;
		if(GetClientTeam(i) < 2) continue;
		if(!IsPlayerAlive(i)) continue;
		Client_RemoveAllWeapons(i, "", true);
	}
}

/*RemoveWeapons(client)
{
    Client_RemoveAllWeapons(client, "", true); // Removes all the weapons ; Add a weapon name into the "" to exclude that weapon.
}  */