#pragma semicolon 1

#include <sourcemod>
#include <sdktools>
#include <emitsoundany>

#define PLUGIN_VERSION	"1.1"
#define PLUGIN_AUTHOR	"tuty & Neoxx"
#define EXPLODE_SOUND	"ambient/explosions/explode_8.mp3"

new Handle:gPluginEnabled;
new g_ExplosionSprite;
new g_SmokeSprite;
new Float:iNormal[ 3 ] = { 0.0, 0.0, 1.0 };

public Plugin:myinfo = 
{
	name = "[CS:GO] HeadShot Explode",
	author = PLUGIN_AUTHOR,
	description = "Explode enemy's body on Headshot.",
	version = PLUGIN_VERSION,
	url = "http://www.ligs.us/"
};
public OnPluginStart()
{
	HookEvent( "player_death", Event_PlayerDeath );
	CreateConVar("sm_headshot_explode", PLUGIN_VERSION, "HeadShot Explode", FCVAR_PLUGIN | FCVAR_SPONLY | FCVAR_REPLICATED | FCVAR_NOTIFY );
	gPluginEnabled = CreateConVar( "sm_headshot_explode", "1" );
}
public OnMapStart() 
{
	PrecacheSoundAny( EXPLODE_SOUND, true );
	AddFileToDownloadsTable( "sound/ambient/explosions/explode_8.mp3" );
	g_ExplosionSprite = PrecacheModel( "sprites/blueglow2.vmt" );
	AddFileToDownloadsTable( "materials/sprites/blueglow2.vtf" );
	AddFileToDownloadsTable( "materials/sprites/blueglow2.vmt" );
	g_SmokeSprite = PrecacheModel( "sprites/steam1.vmt" );
	AddFileToDownloadsTable( "materials/sprites/steam2.vtf" );
	AddFileToDownloadsTable( "materials/sprites/steam2.vmt" );
}
public Action:Event_PlayerDeath( Handle:event, const String:name[], bool:dontBroadcast )
{
	if( GetConVarInt( gPluginEnabled ) == 1 )
	{
		new victim = GetClientOfUserId( GetEventInt( event, "userid" ) );
		new attacker = GetClientOfUserId( GetEventInt( event, "attacker" ) );

		if( victim == attacker )
		{
			return Plugin_Handled;
		}
		
		new Float:iVec[ 3 ];
		GetClientAbsOrigin( victim, Float:iVec );
		
		if( GetEventBool( event, "headshot" ) )
		{
			//TE_SetupExplosion( iVec, g_ExplosionSprite, 5.0, 1, 0, 50, 40, iNormal );
			TE_SetupExplosion( iVec, g_ExplosionSprite, 2.0, 1, 0, 20, 40, iNormal );
			TE_SendToAll();
			
			
			
			//TE_SetupSmoke( iVec, g_SmokeSprite, 10.0, 3 );
			//TE_SendToAll();
			
			EmitAmbientSoundAny( EXPLODE_SOUND, iVec, victim, SNDLEVEL_NORMAL );
		}
	}
	return Plugin_Continue;
}
