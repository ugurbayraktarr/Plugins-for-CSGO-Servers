#pragma semicolon 1
#include <sourcemod>

public Plugin myinfo = {
	name		= "Ayna",
	author		= "ImPossibLe`",
	description = "Rotational Thirdperson View",
	version		= "1.0"
};

bool mirror[MAXPLAYERS + 1] = { false, ... };
Handle mp_forcecamera;

public void OnPluginStart()
{
	mp_forcecamera = FindConVar("mp_forcecamera");
	RegConsoleCmd("sm_ayna", Cmd_Mirror, "Ayna modunu açar");
}

public Action Cmd_Mirror(int client, int args)
{
	if (!IsPlayerAlive(client))
	{
		PrintToChat(client, " \x02[DrK # GaminG] \x04Ölüyken bu komutu kullanamazsınız.");
		return Plugin_Handled;
	}
	
	if (!mirror[client])
	{
		SetEntPropEnt(client, Prop_Send, "m_hObserverTarget", 0); 
		SetEntProp(client, Prop_Send, "m_iObserverMode", 1);
		SetEntProp(client, Prop_Send, "m_bDrawViewmodel", 0);
		SetEntProp(client, Prop_Send, "m_iFOV", 120);
		SendConVarValue(client, mp_forcecamera, "1");
		mirror[client] = true;
		PrintToChat(client, " \x02[DrK # GaminG] \x04Ayna moduna geçildi.");
	}
	else
	{
		SetEntPropEnt(client, Prop_Send, "m_hObserverTarget", -1);
		SetEntProp(client, Prop_Send, "m_iObserverMode", 0);
		SetEntProp(client, Prop_Send, "m_bDrawViewmodel", 1);
		SetEntProp(client, Prop_Send, "m_iFOV", 90);
		decl String:valor[6];
		GetConVarString(mp_forcecamera, valor, 6);
		SendConVarValue(client, mp_forcecamera, valor);
		mirror[client] = false;
		PrintToChat(client, " \x02[DrK # GaminG] \x04Ayna modundan çıkıldı.");
	}
	return Plugin_Handled;
}