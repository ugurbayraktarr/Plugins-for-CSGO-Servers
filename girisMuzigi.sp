#include <sourcemod>
#include <sdktools>
#include <sdktools_sound>

#pragma semicolon 1
#define MAX_FILE_LEN 80
new Handle:g_CvarSoundName = INVALID_HANDLE;
new String:g_soundName[MAX_FILE_LEN];

#define PLUGIN_VERSION "1.0"
public Plugin:myinfo = 
{
	name = "Giriş Müziği",
	author = "ImPossibLe`",
	description = "Join Sound on your CS:GO Server",
	version = PLUGIN_VERSION
};
public OnPluginStart()
{
g_CvarSoundName = CreateConVar("drk_girismuzigi", "music/welcome/deadpool.mp3", "Giris muzigi");
}
public OnConfigsExecuted()
{
	GetConVarString(g_CvarSoundName, g_soundName, MAX_FILE_LEN);
	decl String:buffer[MAX_FILE_LEN];
	PrecacheSound(g_soundName, true);
	Format(buffer, sizeof(buffer), "sound/%s", g_soundName);
	AddFileToDownloadsTable(buffer);
}
public OnClientPostAdminCheck(client)
{
EmitSoundToClient(client,g_soundName);
}