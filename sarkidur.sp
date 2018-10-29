#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <colors>

new Handle:g_cVar_ReklamSuresi = INVALID_HANDLE;
new Handle:g_PluginTagi = INVALID_HANDLE;


public Plugin:myinfo =
{
	name        = "Şarkı Durdurucu",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

new const String:FULL_SOUND_PATH[] = "sound/drkgaming/sarkikapat.mp3";
new const String:RELATIVE_SOUND_PATH[] = "*/drkgaming/sarkikapat.mp3";

public OnPluginStart() 
{
	RegConsoleCmd( "sm_dur", SarkiDurdur );
	
	AutoExecConfig(true, "sarkidur_reklambekleme");
	g_cVar_ReklamSuresi	=	CreateConVar("drk_sarkidur_reklambekleme", "180.0", "!sarkidur reklamları arasındaki bekleme süresi");
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
	
	CreateTimer(8.0, TimerAyarla);
}

public Action:TimerAyarla(Handle:timer)
{
	CreateTimer(GetConVarFloat(g_cVar_ReklamSuresi), reklam, _,TIMER_REPEAT);
}

public OnMapStart()
{
	AddFileToDownloadsTable( FULL_SOUND_PATH );
	FakePrecacheSound( RELATIVE_SOUND_PATH );
}

public Action:SarkiDurdur( client, args )
{
	EmitSoundToClient( client, RELATIVE_SOUND_PATH );
 
	return Plugin_Handled;
}
 
stock FakePrecacheSound( const String:szPath[] )
{
	AddToStringTable( FindStringTable( "soundprecache" ), szPath );
}

public Action:reklam(Handle:timer)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	PrintToChatAll (" \x02[%s] \x06Herhangi bir yerde şarkı çalıyorken durdurmak için \x0E!dur \x06yazın.", sPluginTagi);
	return Plugin_Continue;
}