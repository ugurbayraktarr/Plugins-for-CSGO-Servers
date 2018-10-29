#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "boomix / Mitchell"
#define PLUGIN_VERSION "2.2"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <sdkhooks>
#include <emitsoundany>
#include <autoexecconfig>

#include "paintball2/pb_globals.sp"
#include "paintball2/pb_shoot.sp"
#include "paintball2/pb_downloadprecache.sp"
#include "paintball2/pb_ballglow.sp"
#include "paintball2/pb_shakescreen.sp"
#include "paintball2/pb_paint.sp"
#include "paintball2/pb_grenade.sp"




public Plugin myinfo = 
{
	name = "Paintball for CS:GO",
	author = PLUGIN_AUTHOR,
	description = "Paintball gamemode for CS:GO made by boomix, some code from Mitchell",
	version = PLUGIN_VERSION,
	url = "http://www.burst.lv"
};

public void OnPluginStart()
{
	LoopAllPlayers(i)
	{
		SDKHook(i, SDKHook_WeaponSwitchPost,	WeaponEquipPost);
		SDKHook(i, SDKHook_WeaponDrop,			WeaponDrop);
		//SDKHook(i, SDKHook_WeaponEquipPost, 	WeaponEquipPost);
		SetDefaultPlayerCvars(i);
		QueryClientConVar(i, "cl_autowepswitch", ConVar_QueryClient);
	}
	
	HookEvent("hegrenade_detonate", Event_GrenadeStarted, EventHookMode_Pre);
	HookEvent("player_spawn", 		Event_PlayerSpawn);

	//Config files
	AutoExecConfig_SetFile("paintball");

	HookConVarChange(GrenadeEnable 	=	AutoExecConfig_CreateConVar("sm_grenades_enable", 	"1", 		"Gives randomly grenades every round"), 	OnCvarChanged);
	HookConVarChange(GranadeChance 	=	AutoExecConfig_CreateConVar("sm_grenades_chance", 	"10", 		"% chance to get grenade on spawn (max 100%)"), 		OnCvarChanged);
	
	AutoExecConfig_ExecuteFile();
	AutoExecConfig_CleanFile();
	
	UpdateConvars();

	
	
}


public void OnCvarChanged(Handle hConvar, const char[] chOldValue, const char[] chNewValue)
{
	UpdateConvars();
}

public void UpdateConvars()
{
	GRENADE_ENABLE 	= GetConVarInt(GrenadeEnable);
	GRENADE_CHANCE 	= GetConVarInt(GranadeChance);
}

public void WeaponDrop(int client, int weapon)
{
	if(weapon > 0 && IsValidEntity(weapon))
	{
		char classname[120];
		GetEntityClassname(weapon, classname, 120);
		if(StrContains(classname, "weapon_") != -1)
		{
			SetEntProp(weapon, Prop_Data, "m_nSolidType", 6);
			SetEntProp(weapon, Prop_Send, "m_CollisionGroup", 1); 
		}
	}
}


public void WeaponEquipPost(int client, int weapon)
{	
	char WeaponName[120];
	GetEntityClassname(weapon, WeaponName, sizeof(WeaponName));
			
	if (WeaponTookTimer[client] != null)
	{
		KillTimer(WeaponTookTimer[client]);
		WeaponTookTimer[client] = null;
	}

	//PrintToChatAll("%s", WeaponName);
	
	//Get stuff from config file
	KeyValues kvPaint = CreateKeyValues("Paintball-guns");
	
	SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", 1.0);
	
	if(!kvPaint.ImportFromFile(g_PaintballConfig)) return;
	if (!kvPaint.JumpToKey(WeaponName, false)) {
		b_HWShootable[client] = false;
		return;
	} else {
		b_HWShootable[client] = true;
	}

	//Weapon automatic
	if(KvGetNum(kvPaint, "auto", 0) == 1)
		b_IsGunAutomic[client] = true;
	else
		b_IsGunAutomic[client] = false;
	
	
	//HW == Holding weapon
	
	//Bullet speed
	i_HWBulletSpeed[client] 		= kvPaint.GetFloat("bullet-speed", 1600.0);

	//Bullet gravity
	f_HWBulletGravity[client] 		= kvPaint.GetFloat("bullet-gravity", 0.2);
	
	//Accuaracy
	f_HWAccuracy[client] 			= kvPaint.GetFloat("accuracy", 0.0);
	
	//Jump accuracy
	f_HWJumpAccuracy[client] 		= kvPaint.GetFloat("jump-accuracy", 0.0);
	
	//Running speed
	SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", kvPaint.GetFloat("running-speed", 1.0));
	//f_HWRunningSpeed[client]		= kvPaint.GetFloat("running-speed", 1.0);
	
	//Reload speed
	f_HWReloadingSpeed[client]		= kvPaint.GetFloat("reload-speed", 1.0);
	
	//Gun switch speed
	f_HWSwitchGunSpeed[client]		= kvPaint.GetFloat("switch-guns-speed", 1.0);
	
	//Time between shots
	f_HWTimeBetweenShots[client]	= kvPaint.GetFloat("shot-delay", 0.01);
	
	

	if(IsValidEntity(weapon) && b_HWShootable[client])
	{
		b_JustTookWeapon[client] = true;

		int ammo = GetEntProp(weapon, Prop_Send, "m_iClip1");
		if(ammo == 0)
		{
			UnBlockRealShooting(weapon);
			b_IsReloading[client] = true;
		} else {
			BlockRealShooting(weapon);
			b_IsReloading[client] = false;
		}
		
		
		WeaponTookTimer[client] = CreateTimer(f_HWSwitchGunSpeed[client], JustTookWeaponDisable, client);
		
		
	} else {
		
		//PrintToChatAll("%s", WeaponName);
		
		if(StrContains(WeaponName, "knife") == -1 && StrContains(WeaponName, "weapon_hegrenade") == -1)
			BlockRealShooting(weapon);
		
		b_IsReloading[client] = false;
		b_JustTookWeapon[client] = false;
		
	}
	
	b_JustFired[client] = false;
		
}

public Action JustTookWeaponDisable(Handle tmr, any client)
{
	b_JustTookWeapon[client] = false;
	WeaponTookTimer[client] = null;
}
