#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <string>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "No Scope MOD",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

bool noScopeMod = false;
new String:silahlar[MAXPLAYERS+1][32];

public OnPluginStart() 
{
	HookEvent("weapon_zoom", EventWeaponZoom, EventHookMode_Post);
	
	RegAdminCmd("sm_noscope", NoScopeMode, ADMFLAG_ROOT, "NoScope Mod'u Açar/Kapatır.");
}

public OnMapStart()
{
	noScopeMod = false;
}

public Action:NoScopeMode(client, args)
{
	if(noScopeMod)
	{
		PrintToChatAll(" \x02[DrK # GaminG] \x0ENo-Scope Modu \x04%N \x10tarafından kapatıldı.", client);
		noScopeMod = false;
	}
	else
	{
		PrintToChatAll(" \x02[DrK # GaminG] \x0ENo-Scope Modu \x04%N \x10tarafından açıldı.", client);
		noScopeMod = true;
	}
	return Plugin_Continue;
}

public Action:GiveItem(Handle:Timer, any:client)
{
	GivePlayerItem(client, silahlar[client]);
}

public Action:EventWeaponZoom(Handle:event,const String:name[],bool:dontBroadcast)
{
	if(noScopeMod)
	{
		new client = GetClientOfUserId(GetEventInt(event, "userid"));
		new String:weaponname[32];
		GetClientWeapon(client, weaponname, sizeof(weaponname));
		if ((StrEqual(weaponname, "weapon_ssg08", false)) || (StrEqual(weaponname, "weapon_awp", false)) || (StrEqual(weaponname, "weapon_scar20", false)) || (StrEqual(weaponname, "weapon_g3sg1", false)))
		{
			new weapon = GetPlayerWeaponSlot(client, 0);
			if (IsValidEdict(weapon))
			{
				strcopy(silahlar[client], 32, weaponname);
				RemovePlayerItem(client, weapon);
				RemoveEdict(weapon);
				CreateTimer(0.1, GiveItem, client);
			}
			PrintToChat(client, " \x02[DrK # GaminG] \x0EŞuan scope açamazsınız.");
			return Plugin_Handled;
		}
		return Plugin_Continue;
	}
	else
		return Plugin_Continue;
}