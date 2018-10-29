#include <sourcemod>

#undef REQUIRE_PLUGIN
#tryinclude <updater>

#pragma semicolon 1


#define UPDATE_URL "http://dl.dropbox.com/u/80272443/blockradio/updatefile.txt"

new Handle:gH_Enabled = INVALID_HANDLE,
	Handle:gH_Message = INVALID_HANDLE,
	Handle:gH_Nade = INVALID_HANDLE,
	Handle:gH_Ignorenade = INVALID_HANDLE;

new Handle:g_PluginTagi = INVALID_HANDLE;


new bool:gB_Enabled,
	bool:gB_Message,
	bool:gB_Nade;

new String:RadioCMDS[][] = {"coverme", "takepoint", "holdpos", "regroup", "followme", "takingfire", "go", "fallback", "sticktog",
	"getinpos", "stormfront", "report", "roger", "enemyspot", "needbackup", "sectorclear", "inposition", "reportingin",
	"getout", "negative","enemydown", "compliment", "thanks", "cheer"};

public OnLibraryAdded(const String:name[])
{
	#if defined _updater_included
    if(StrEqual(name, "updater"))
    {
        Updater_AddPlugin(UPDATE_URL);
    }
	#endif
}

public Plugin:myinfo = 
{
	name = "Radyo Mesajları Engelleyici",
	author = "ImPossibLe`",
	description = "Radyo Mesajlarını Engeller",
	version = "1.0"
}

public OnPluginStart()
{
	int ips[4];
	char serverip[32];
	int ip = GetConVarInt(FindConVar("hostip"));
	ips[0] = (ip >> 24) & 0x000000FF;
	ips[1] = (ip >> 16) & 0x000000FF;
	ips[2] = (ip >> 8) & 0x000000FF;
	ips[3] = ip & 0x000000FF;
	
	Format(serverip, sizeof(serverip), "%d.%d.%d", ips[0], ips[1], ips[2]);
	if(StrEqual(serverip, "185.193.165") == false && ips[3] != 166)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	
	if(GetEngineVersion() != Engine_CSS && GetEngineVersion() != Engine_CSGO)
	{
		SetFailState("[Block Radio] Failed to load because the only game supported is CS:S/CS:GO.");
	}
	
	#if defined _updater_included
	if(LibraryExists("updater"))
    {
        Updater_AddPlugin(UPDATE_URL);
    }
	#endif
	
	for(new i; i < sizeof(RadioCMDS); i++)
	{
		AddCommandListener(BlockRadio, RadioCMDS[i]);
	}
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");

	// Console Variables
	gH_Enabled = CreateConVar("sm_blockradio_enabled", "1", "Is \"Block Radio\" enabled?", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	gB_Enabled = true;
	HookConVarChange(gH_Enabled, ConVarChanged);
	
	gH_Message = CreateConVar("sm_blockradio_message", "1", "Is notifying about blocked radio messages enabled?", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	gB_Message = true;
	HookConVarChange(gH_Message, ConVarChanged);
	
	gH_Nade = CreateConVar("sm_blockradio_grenade", "1", "Is \"Fire in the hole\" radio sound is supressed?", FCVAR_PLUGIN, true, 0.0, true, 1.0);
	gB_Nade = true;
	HookConVarChange(gH_Nade, ConVarChanged);
	
	gH_Ignorenade = FindConVar("sv_ignoregrenaderadio");
	SetConVarInt(gH_Ignorenade, 1);
	
	AutoExecConfig();
}

public ConVarChanged(Handle:cvar, const String:oldVal[], const String:newVal[])
{
	if(cvar == gH_Nade)
	{
		gB_Nade = StringToInt(newVal)? true:false;
		SetConVarInt(gH_Ignorenade, gB_Nade? 1:0);
	}
	
	else if(cvar == gH_Message)
	{
		gB_Message = StringToInt(newVal)? true:false;
	}
	
	else if(cvar == gH_Enabled)
	{
		gB_Enabled = StringToInt(newVal)? true:false;
	}
}

public Action:BlockRadio(client, const String:command[], args) 
{
	if(gB_Enabled)
	{
		if(gB_Message)
		{
			new String:sPluginTagi[64];
			GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
			
			PrintToChat(client, " \x02[%s]\x04 Radyo Mesajları Engellenmiştir.", sPluginTagi);
		}
		
		return Plugin_Handled;
	}
	
	return Plugin_Continue;
}