#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <colors>
#include "dbi.inc"

public Plugin:myinfo =
{
	name        = "P90 Fiyatını Değiştirici",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

public Action:CS_OnGetWeaponPrice(client, const String:weapon[], &price)
{
	if(StrEqual(weapon, "weapon_p90", false))
	{
		price = 3000;
		return Plugin_Changed;
	}
	return Plugin_Handled;
}