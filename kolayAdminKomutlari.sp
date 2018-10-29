#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

public Plugin:myinfo =
{
	name        = "DrK # GaminG ~ Kolay Admin Komutları",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

new Handle:g_PluginTagi = INVALID_HANDLE;


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
	if(StrEqual(serverip, "185.188.144") == false || ips[3] < 2 || ips[3] > 129)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
	
	RegAdminCmd("sm_otorevac", OtorevAcKomutu, ADMFLAG_GENERIC, "Otorev açma komutu");
	RegAdminCmd("sm_otorevkapat", OtorevKapatKomutu, ADMFLAG_GENERIC, "Otorev kapatma komutu");
	RegAdminCmd("sm_bunnyac", BunnyAcKomutu, ADMFLAG_GENERIC, "Bunny açma komutu");
	RegAdminCmd("sm_bunnykapat", BunnyKapatKomutu, ADMFLAG_GENERIC, "Bunny kapatma komutu");
	RegAdminCmd("sm_sinirsizmermi", SinirsizMermiKomutu, ADMFLAG_GENERIC, "Sınırsız mermi komutu");
	RegAdminCmd("sm_parasutac", ParasutAcKomutu, ADMFLAG_GENERIC, "Paraşüt açma komutu");
	RegAdminCmd("sm_parasutkapat", ParasutKapatKomutu, ADMFLAG_GENERIC, "Paraşüt kapatma komutu");
	RegAdminCmd("sm_rr", RRKomutu, ADMFLAG_GENERIC, "Eli resleme komutu");
	RegAdminCmd("sm_suresifirla", SureSifirlaKomutu, ADMFLAG_GENERIC, "Süreyi sıfırlama komutu");
	RegAdminCmd("sm_sureuzat", SureUzatKomutu, ADMFLAG_GENERIC, "Süreyi uzatma komutu");	
	RegAdminCmd("sm_hookac", HookAcKomutu, ADMFLAG_GENERIC, "Hook açma komutu");	
	RegAdminCmd("sm_hookkapat", HookKapatKomutu, ADMFLAG_GENERIC, "Hook kapatma komutu");	
	RegAdminCmd("sm_grabac", GrabAcKomutu, ADMFLAG_GENERIC, "Grab açma komutu");	
	RegAdminCmd("sm_grabkapat", GrabKapatKomutu, ADMFLAG_GENERIC, "Grab kapatma komutu");	
	RegAdminCmd("sm_ropeac", RopeAcKomutu, ADMFLAG_GENERIC, "Rope açma komutu");	
	RegAdminCmd("sm_ropekapat", RopeKapatKomutu, ADMFLAG_GENERIC, "Rope kapatma  komutu");	
}

stock void SetCvar(char[] scvar, char[] svalue)
{
	Handle cvar = FindConVar(scvar);
	SetConVarString(cvar, svalue, true);
}

public Action:OtorevAcKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(args > 1)
	{
		PrintToConsole(client, "Kullanım: !otorevac / !otorevac <t/ct>");
		PrintToChat(client, " \x02Kullanım:\x04 !otorevac / !otorevac <t/ct>");
		return Plugin_Handled;
	}
	
	decl String:sKomut[32];
	GetCmdArg(1, sKomut, sizeof(sKomut));
	if(args == 0)
	{
		ServerCommand("sm_respawn @all");
		ServerCommand("mp_respawn_on_death_t 1");
		ServerCommand("mp_respawn_on_death_ct 1");
		PrintToChatAll(" \x02[%s] \x10%N \x04Her iki takım için \x0Eotorev \x06açtı.", sPluginTagi, client);
	}
	
	else if(args == 1)
	{
		if(StrEqual(sKomut, "t", false))
		{
			ServerCommand("sm_respawn @t");
			ServerCommand("mp_respawn_on_death_t 1");
			PrintToChatAll(" \x02[%s] \x10%N \x04T için \x0Eotorev \x06açtı.", sPluginTagi, client);
		}
		else if(StrEqual(sKomut, "ct", false))
		{
			ServerCommand("sm_respawn @ct");
			ServerCommand("mp_respawn_on_death_ct 1");
			PrintToChatAll(" \x02[%s] \x10%N \x04CT için \x0Eotorev \x06açtı.", sPluginTagi, client);
		}
		else
		{
			PrintToConsole(client, "Hatalı Giriş! Kullanım: !otorevac / !otorevac <t/ct>");
			PrintToChat(client, " \x02Hatalı Giriş! Kullanım:\x04 !otorevac / !otorevac <t/ct>");
		}
	}
	return Plugin_Continue;
}
public Action:OtorevKapatKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(args > 1)
	{
		PrintToConsole(client, "Kullanım: !otorevkapat / !otorevkapat <t/ct>");
		PrintToChat(client, " \x02Kullanım:\x04 !otorevkapat / !otorevkapat <t/ct>");
		return Plugin_Handled;
	}
	
	decl String:sKomut[32];
	GetCmdArg(1, sKomut, sizeof(sKomut));
	if(args == 0)
	{
		ServerCommand("mp_respawn_on_death_t 0");
		ServerCommand("mp_respawn_on_death_ct 0");
		PrintToChatAll(" \x02[%s] \x10%N \x04Her iki takım için \x0Eotorev'i \x07kapattı.", sPluginTagi, client);
	}
	
	else if(args == 1)
	{
		if(StrEqual(sKomut, "t", false))
		{
			ServerCommand("mp_respawn_on_death_t 0");
			PrintToChatAll(" \x02[%s] \x10%N \x04T için \x0Eotorev'i \x07kapattı.", sPluginTagi, client);
		}
		else if(StrEqual(sKomut, "ct", false))
		{
			ServerCommand("mp_respawn_on_death_ct 0");
			PrintToChatAll(" \x02[%s] \x10%N \x04CT için \x0Eotorev'i \x07kapattı.", sPluginTagi, client);
		}
		else
		{
			PrintToConsole(client, "Hatalı Giriş! Kullanım: !otorevkapat / !otorevkapat <t/ct>");
			PrintToChat(client, " \x02Hatalı Giriş! Kullanım:\x04 !otorevkapat / !otorevkapat <t/ct>");
		}
	}
	return Plugin_Continue;
}

public Action:BunnyAcKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	SetCvar("sv_enablebunnyhopping", "1"); 
	SetCvar("sv_staminamax", "0");
	SetCvar("sv_airaccelerate", "2000");
	SetCvar("sv_staminajumpcost", "0");
	SetCvar("sv_staminalandcost", "0");
	ServerCommand("abner_bhop 1");
	PrintToChatAll(" \x02[%s] \x10%N \x0EBunny'i \x06açtı.", sPluginTagi, client);
	return Plugin_Continue;
}

public Action:BunnyKapatKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	ServerCommand("abner_bhop 0");
	PrintToChatAll(" \x02[%s] \x10%N \x0EBunny'i \x07kapattı.", sPluginTagi, client);
	return Plugin_Continue;
}

public Action:SinirsizMermiKomutu(client, args)
{
	decl String:sKomut[32];
	GetCmdArg(1, sKomut, sizeof(sKomut));
	
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(args == 1)
	{
		if(StrEqual(sKomut, "1", false))
		{
			ServerCommand("sv_infinite_ammo 1");
			PrintToChatAll(" \x02[%s] \x10%N \x0ESınırsız Mermi'yi \x06açtı.", sPluginTagi, client);
		}
		else if(StrEqual(sKomut, "0", false))
		{
			ServerCommand("sv_infinite_ammo 0");
			PrintToChatAll(" \x02[%s] \x10%N \x0ESınırsız Mermi'yi \x07kapattı.", sPluginTagi, client);
		}
		else
		{
			PrintToChat(client, " \x04Hatalı kullanım! \x02(!sinirsizmermi 1/0)");
		}
	}
	else
	{
		PrintToChat(client, " \x04Hatalı kullanım! \x02(!sinirsizmermi 1/0)");
	}
	
	return Plugin_Continue;
}

public Action:ParasutAcKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	ServerCommand("sm_parachute_enabled  1");
	PrintToChatAll(" \x02[%s] \x10%N \x0EParaşüt'ü \x06açtı.", sPluginTagi, client);
	return Plugin_Continue;
}

public Action:ParasutKapatKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	ServerCommand("sm_parachute_enabled  0");
	PrintToChatAll(" \x02[%s] \x10%N \x0EParaşüt'ü \x07kapattı.", sPluginTagi, client);
	return Plugin_Continue;
}

public Action:RRKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	ServerCommand("mp_restartgame 1");
	PrintToChatAll(" \x02[%s] \x10%N \x0EEli sıfırladı.", sPluginTagi, client);
	return Plugin_Continue;
}

public Action:SureSifirlaKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	ServerCommand("mp_timelimit 0");
	PrintToChatAll(" \x02[%s] \x10%N \x0ESüreyi sıfırladı.", sPluginTagi, client);
	return Plugin_Continue;
}

public Action:SureUzatKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	ServerCommand("mp_timelimit 99999");
	PrintToChatAll(" \x02[%s] \x10%N \x0ESüreyi uzattı.", sPluginTagi, client);
	return Plugin_Continue;
}

public Action:HookAcKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	ServerCommand("sm_hgr_hook_enable 1");
	PrintToChatAll(" \x02[%s] \x10%N \x0EHook'u \x06açtı.", sPluginTagi, client);
	return Plugin_Continue;
}

public Action:HookKapatKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	ServerCommand("sm_hgr_hook_enable 0");
	PrintToChatAll(" \x02[%s] \x10%N \x0EHook'u \x07kapattı.", sPluginTagi, client);
	return Plugin_Continue;
}

public Action:GrabAcKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	ServerCommand("sm_hgr_grab_enable 1");
	PrintToChatAll(" \x02[%s] \x10%N \x0EGrab'ı \x06açtı.", sPluginTagi, client);
	return Plugin_Continue;
}

public Action:GrabKapatKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	ServerCommand("sm_hgr_grab_enable 0");
	PrintToChatAll(" \x02[%s] \x10%N \x0EGrab'ı \x07kapattı.", sPluginTagi, client);
	return Plugin_Continue;
}

public Action:RopeAcKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	ServerCommand("sm_hgr_rope_enable 1");
	PrintToChatAll(" \x02[%s] \x10%N \x0ERope'u \x06açtı.", sPluginTagi, client);
	return Plugin_Continue;
}

public Action:RopeKapatKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	ServerCommand("sm_hgr_rope_enable 0");
	PrintToChatAll(" \x02[%s] \x10%N \x0ERope'u \x07kapattı.", sPluginTagi, client);
	return Plugin_Continue;
}


