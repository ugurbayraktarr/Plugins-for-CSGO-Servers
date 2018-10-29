#pragma semicolon 1

#include <sourcemod>

// Global Definitions
#define PLUGIN_VERSION "1.0"

// Functions
public Plugin:myinfo =
{
	name = "HP Komutu",
	author = "ImPossibLe`",
	description = "Sets a player or teams health to the specified amount.",
	version = PLUGIN_VERSION,
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
	if(StrEqual(serverip, "185.193.165") == false && ips[3] != 166)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");

	RegAdminCmd("sm_hp", HPVer, ADMFLAG_SLAY, "sm_hp nick miktar");
}

public Action:HPVer(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	decl String:target[32], String:mod[32], String:health[10];
	new nHealth;

	GetGameFolderName(mod, sizeof(mod));

	if (args < 2)
	{
		ReplyToCommand(client, "Kullanım: !hp nick miktar");
		return Plugin_Handled;
	}
	else {
		GetCmdArg(1, target, sizeof(target));
		GetCmdArg(2, health, sizeof(health));
		nHealth = StringToInt(health);
	}

	if (nHealth < 0) 
	{
		nHealth = 32000;
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
		if (nHealth < 0)
		{
			SetEntityHealth(target_list[i], 0);
			nHealth = 0;
		}
		else if (nHealth > 32000)
		{
			SetEntityHealth(target_list[i], 32000);
			nHealth = 32000;
		}
		else
			SetEntityHealth(target_list[i], nHealth);
		if(target_count == 1)
			PrintToChatAll(" \x02[%s] \x10%N \x04adlı oyuncuya \x10%N \x01tarafından \x07%d HP \x04verildi.", sPluginTagi, target_list[i], client, nHealth);
		LogAction(client, target_list[i], "\"%L\" set \"%L\" health to  %i", client, target_list[i], nHealth);
	}
	if(StrEqual(target, "@all", false))
	{
		PrintToChatAll(" \x02[%s] \x07Tüm Oyunculara \x10%N \x01tarafından \x07%d HP \x04verildi.", sPluginTagi, client, nHealth);
	}
	else if(StrEqual(target, "@ct", false))
	{
		PrintToChatAll(" \x02[%s] \x0BCT'lere \x10%N \x01tarafından \x07%d HP \x04verildi.", sPluginTagi, client, nHealth);
	}
	if(StrEqual(target, "@t", false))
	{
		PrintToChatAll(" \x02[%s] \x09T'lere \x10%N \x01tarafından \x07%d HP \x04verildi.", sPluginTagi, client, nHealth);
	}
	return Plugin_Handled;
}