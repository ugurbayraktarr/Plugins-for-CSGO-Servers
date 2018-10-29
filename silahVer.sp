#pragma semicolon 1
#include <sdktools>

#include <sourcemod>

// Global Definitions
#define PLUGIN_VERSION "1.0"
#define MAX_WEAPONS 39

// Functions
public Plugin:myinfo =
{
	name = "Silah Verme Komutu",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = PLUGIN_VERSION,
};

new Handle:g_PluginTagi = INVALID_HANDLE;

new const String:g_weapons[MAX_WEAPONS][] = {
	"weapon_ak47", "weapon_aug", "weapon_bizon", "weapon_deagle", "weapon_decoy", "weapon_elite", "weapon_famas", "weapon_fiveseven", "weapon_flashbang",
	"weapon_g3sg1", "weapon_galilar", "weapon_glock", "weapon_hegrenade", "weapon_hkp2000", "weapon_incgrenade", "weapon_knife", "weapon_m249", "weapon_m4a1",
	"weapon_mac10", "weapon_mag7", "weapon_molotov", "weapon_mp7", "weapon_mp9", "weapon_negev", "weapon_nova", "weapon_p250", "weapon_p90", "weapon_sawedoff",
	"weapon_scar20", "weapon_sg556", "weapon_smokegrenade", "weapon_ssg08", "weapon_taser", "weapon_tec9", "weapon_ump45", "weapon_xm1014", "weapon_awp", "weapon_m4a1_silencer", "weapon_usp_silencer"
};


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
	
	RegAdminCmd("sm_silahver", SilahVer, ADMFLAG_SLAY, "sm_silahver <nick> <silah>");
}


public Action:SilahVer(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	decl String:target[32], String:mod[32], String:sWeaponName[32], String:sWeaponNameTemp[32];
	new iValid;

	GetGameFolderName(mod, sizeof(mod));

	if (args < 2)
	{
		ReplyToCommand(client, "Kullanım: !silahver <nick> <silah>");
		return Plugin_Handled;
	}
	else
	{
		GetCmdArg(1, target, sizeof(target));
		GetCmdArg(2, sWeaponName, sizeof(sWeaponName));
	}

	if(StrContains(sWeaponName, "weapon_") == -1)
	{
		FormatEx(sWeaponNameTemp, 31, "weapon_");
		StrCat(sWeaponNameTemp, 31, sWeaponName);
		
		strcopy(sWeaponName, 31, sWeaponNameTemp);
	}
	
	for(new i = 0; i < MAX_WEAPONS; ++i)
	{
		if(StrEqual(sWeaponName, g_weapons[i]))
		{
			iValid = 1;
			break;
		}
	}
	
	if(!iValid)
	{
		PrintToChat(client, " \x04[%s] \x10Girdiğiniz silah geçersiz: \x04%s", sPluginTagi, sWeaponName);
		return Plugin_Handled;
	}

	decl String:target_name[MAX_TARGET_LENGTH];
	new target_list[MAXPLAYERS], target_count, bool:tn_is_ml;

	if ((target_count = ProcessTargetString(
			target,
			client,
			target_list,
			MAXPLAYERS,
			COMMAND_FILTER_ALIVE,
			target_name,
			sizeof(target_name),
			tn_is_ml)) <= 0)
	{
		ReplyToTargetError(client, target_count);
		return Plugin_Handled;
	}

	for (new i = 0; i < target_count; i++)
	{
		GivePlayerItem(target_list[i], sWeaponName);
		if(target_count == 1)
		{
			PrintToChatAll(" \x02[%s] \x10%N \x04adlı oyuncuya \x10%N tarafından \x07%s \x04verildi.", sPluginTagi, target_list[i], client, sWeaponName);
		}
	}
		
	if(StrEqual(target, "@all", false))
	{
		PrintToChatAll(" \x02[%s] \x04Tüm Oyunculara \x10%N tarafından \x07%s \x04verildi.", sPluginTagi, client, sWeaponName);
	}
	else if(StrEqual(target, "@ct", false))
	{
		PrintToChatAll(" \x02[%s] \x04CT'lere \x10%N tarafından \x07%s \x04verildi.", sPluginTagi, client, sWeaponName);
	}
	if(StrEqual(target, "@t", false))
	{
		PrintToChatAll(" \x02[%s] \x04T'lere \x10%N tarafından \x07%s \x04verildi.", sPluginTagi, client, sWeaponName);
	}
	
	return Plugin_Handled;
}