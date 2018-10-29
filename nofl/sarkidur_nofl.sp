#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <colors>

new Handle:g_cVar_ReklamSuresi = INVALID_HANDLE;

public Plugin:myinfo =
{
	name        = "Şarkı Durdurucu",
	author      = "ImPossibLe`",
	description = "NoFL",
	version     = "1.0",
};

new const String:FULL_SOUND_PATH[] = "sound/drkgaming/sarkikapat.mp3";
new const String:RELATIVE_SOUND_PATH[] = "*/drkgaming/sarkikapat.mp3";

public OnPluginStart() 
{
	RegConsoleCmd( "sm_dur", SarkiDurdur );
	
	AutoExecConfig(true, "sarkidur_reklambekleme");
	g_cVar_ReklamSuresi	=	CreateConVar("drk_sarkidur_reklambekleme", "180.0", "!sarkidur reklamları arasındaki bekleme süresi");
	
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
	PrintToChatAll (" \x02[ ☜ NoFL ☞ ] \x04Herhangi bir yerde şarkı çalıyorken durdurmak için \x03!dur \x04yazın.");
	return Plugin_Continue;
}