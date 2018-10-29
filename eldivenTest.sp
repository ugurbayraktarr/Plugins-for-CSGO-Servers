#pragma semicolon 1
#include <sourcemod>
#include <sdktools>

public Plugin:myinfo =
{
	name        = "Eldiven Test",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

public void OnPluginStart()
{
    RegConsoleCmd("sm_armsmodel", ConsoleCmd_ArmsModel);    
    
    HookEvent("player_spawn", Event_OnSpawn);
}

public OnMapStart()
{
	PrecacheModel("materials/models/weapons/ct_base_glove_cloud9.vtf");
}

public Action ConsoleCmd_ArmsModel(int client, int args)
{
    SetEntPropString(client, Prop_Send, "m_szArmsModel", "materials/models/weapons/ct_base_glove_cloud9.vtf");
    
    static char armsModel[128];
    GetEntPropString(client, Prop_Send, "m_szArmsModel", armsModel, sizeof(armsModel));
    
    PrintToChat(client, "[TEST] Arms Model Path is: %s", armsModel);    
}

public Action Event_OnSpawn(Event event, const char[] name, bool dontBroadcast)
{
    int client = GetClientOfUserId(event.GetInt("userid"));
    
    SetEntPropString(client, Prop_Send, "m_szArmsModel", "materials/models/weapons/ct_base_glove_cloud9.vtf");
}  