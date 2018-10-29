#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Ozel CFG Ayarlari",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

public OnPluginStart() 
{
	CreateConVar("1", "1", "Bu sayfayı temizleyip başlangıçta çalışmasını istediğiniz ayarları giriniz.");
	AutoExecConfig(true, "ozel_cfg_ayarlari");
	
	CreateTimer(10.0, CfgAc);
}

public OnMapStart() 
{
	CreateTimer(11.0, CfgAc);
}

public Action:CfgAc(Handle:timer)
{
	ServerCommand("exec sourcemod/ozel_cfg_ayarlari.cfg");
}
