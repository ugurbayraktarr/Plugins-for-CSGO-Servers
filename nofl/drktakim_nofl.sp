#include <sourcemod>
#include <sdktools_functions>
#include <colors>
#pragma semicolon 1

public Plugin:myinfo = 
{
	name = "DrK # Takım Değiştirme",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "1.0"
}

static int cakismaKorumasi[MAXPLAYERS + 1] = {0, ...};

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
	if(StrEqual(serverip, "185.122.202") == false || ips[3] < 2 || ips[3] > 101)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	LoadTranslations("common.phrases.txt");
	RegAdminCmd("sm_takim", CommandTeamSwap, ADMFLAG_KICK, "Oyuncunun takimini degistirir");
	RegAdminCmd("sm_spec", CommandSpec, ADMFLAG_KICK, "Oyuncunun takimini degistirir");
	
}

public Action:CommandTeamSwap(client, args)
{
	if(args < 1)
	{
		ReplyToCommand(client, "Kullanım: sm_takim <nick> / sm_takim <nick> ct / t / spec");
		return Plugin_Handled;
	}
	
	if(args > 2)
	{
		ReplyToCommand(client, "Kullanım: sm_takim <nick> / sm_takim <nick> ct / t / spec");
		return Plugin_Handled;
	}
	
	new String:target[64], String:target_name[MAX_TARGET_LENGTH];
	new targetArray[MAXPLAYERS];
	new numtargets;
	new bool:tn_is_ml;
	
	GetCmdArg(1, target, sizeof(target));
	
	numtargets = ProcessTargetString(target, client, targetArray, MAXPLAYERS, 0, target_name, sizeof(target_name), tn_is_ml);
	
	if(numtargets <= 0)
	{
		CPrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x0CHedef bulunamadı.");
		return Plugin_Handled;
	}
	
	new String:arg2[64];
	GetCmdArg(2, arg2, sizeof(arg2));
	
	if(args == 1)
	{
		for(new i = 0; i < numtargets; i++)
		{
			if(GetTime() < cakismaKorumasi[targetArray[i]] + 5)
				CPrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x10%N \x0C'nin takımı son 5 saniye içinde zaten değiştirilmişti.", targetArray[i]);
			else
				if(IsClientInGame(targetArray[i]))
				{
					cakismaKorumasi[targetArray[i]] = GetTime();
					switchPlayerTeam(client, targetArray[i]);
				}
		}
	}
	else if(args == 2)
	{
		if(StrEqual(arg2, "ct", false))
		{
			for(new i = 0; i < numtargets; i++)
			{
				if(GetTime() < cakismaKorumasi[targetArray[i]] + 5)
					CPrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x10%N \x0C'nin takımı son 5 saniye içinde zaten değiştirilmişti.", targetArray[i]);
				else
					if(IsClientInGame(targetArray[i]))
					{
						cakismaKorumasi[targetArray[i]] = GetTime();
						CtAt(client, targetArray[i]);
					}
			}
		}
		else if(StrEqual(arg2, "t", false))
		{
			for(new i = 0; i < numtargets; i++)
			{
				if(GetTime() < cakismaKorumasi[targetArray[i]] + 5)
					CPrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x10%N \x0C'nin takımı son 5 saniye içinde zaten değiştirilmişti.", targetArray[i]);
				else
					if(IsClientInGame(targetArray[i]))
					{
						cakismaKorumasi[targetArray[i]] = GetTime();
						TAt(client, targetArray[i]);
					}
			}
		}
		else if(StrEqual(arg2, "spec", false))
		{
			for(new i = 0; i < numtargets; i++)
			{
				if(GetTime() < cakismaKorumasi[targetArray[i]] + 5)
					CPrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x10%N \x0C'nin takımı son 5 saniye içinde zaten değiştirilmişti.", targetArray[i]);
				else
					if(IsClientInGame(targetArray[i]))
					{
						SpecAt(client, targetArray[i]);
						cakismaKorumasi[targetArray[i]] = GetTime();
					}
			}
		}
	}
	return Plugin_Handled;
}

public Action:CommandSpec(client, args)
{
	if(args < 1)
	{
		ReplyToCommand(client, "Kullanım: sm_spec <nick>");
		return Plugin_Handled;
	}
	
	new String:target[64], String:target_name[MAX_TARGET_LENGTH];
	new targetArray[MAXPLAYERS];
	new numtargets;
	new bool:tn_is_ml;
	
	GetCmdArg(1, target, sizeof(target));
	
	numtargets = ProcessTargetString(target, client, targetArray, MAXPLAYERS, 0, target_name, sizeof(target_name), tn_is_ml);
	
	if(numtargets <= 0)
	{
		ReplyToTargetError(client, numtargets);
		return Plugin_Handled;
	}
	
	for(new i = 0; i < numtargets; i++)
	{
		if(GetTime() < cakismaKorumasi[targetArray[i]] + 5)
			CPrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x10%N \x0C'nin takımı son 5 saniye içinde zaten değiştirilmişti.", targetArray[i]);
		else
			if(IsClientInGame(targetArray[i]))
			{
				SpecAt(client, targetArray[i]);
				cakismaKorumasi[targetArray[i]] = GetTime();
			}
	}
	return Plugin_Handled;
}

public switchPlayerTeam(client, target)
{
	PrintToChat(target, " \x02[ ☜ NoFL ☞ ] \x04Takiminiz Degistirildi.");
	decl String:sIsim[32];
	GetClientName(target, sIsim, sizeof(sIsim));
	new team = GetClientTeam(target);
	
	if(team == 2)
	{
		ChangeClientTeam(target, 3);
		CPrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x10%s \x05CT'ye atıldı.", sIsim);
	}
	
	if(team == 3)
	{
		ChangeClientTeam(target, 2);
		CPrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x10%s \x05T'ye atıldı.", sIsim);
	}
	
	if(team == 1)
	{
		ChangeClientTeam(target, 2);
		CPrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x10%s \x05T'ye atıldı.", sIsim);
	}
		
	DispatchSpawn(target);
}

public CtAt(client, target)
{
	decl String:sIsim[32];
	GetClientName(target, sIsim, sizeof(sIsim));
	
	new team = GetClientTeam(target);
	
	if(team == 1 || team == 2)
	{
		ChangeClientTeam(target, 3);
		CPrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x10%s \x05CT'ye atıldı.", sIsim);
		DispatchSpawn(target);
	}
	
	if(team == 3)
		CPrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x10%s \x05Zaten CT'de olduğu için işlem yapılmadı.", sIsim);
}
public TAt(client, target)
{
	decl String:sIsim[32];
	GetClientName(target, sIsim, sizeof(sIsim));
	
	new team = GetClientTeam(target);
	
	if(team == 1 || team == 3)
	{
		ChangeClientTeam(target, 2);
		CPrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x10%s \x05T'ye atıldı.", sIsim);
		DispatchSpawn(target);
	}
	
	if(team == 2)
		CPrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x10%s \x05Zaten T'de olduğu için işlem yapılmadı.", sIsim);
}
public SpecAt(client, target)
{
	decl String:sIsim[32];
	GetClientName(target, sIsim, sizeof(sIsim));
	
	new team = GetClientTeam(target);
	
	if(team == 3 || team == 2)
	{
		ChangeClientTeam(target, 1);
		CPrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x10%s \x05SPEC'e atıldı.", sIsim);
	}
	
	if(team == 1)
		CPrintToChatAll(" \x02[ ☜ NoFL ☞ ] \x10%s \x05Zaten SPEC'de olduğu için işlem yapılmadı.", sIsim);
		
	DispatchSpawn(target);
}