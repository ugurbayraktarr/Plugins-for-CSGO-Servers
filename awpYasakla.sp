#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "AWP Yasaklayıcı",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

new const String:FULL_SOUND_PATH[] = "sound/misc/drkozelses/nahalirsinyavrummm.mp3";
new const String:RELATIVE_SOUND_PATH[] = "*/misc/drkozelses/nahalirsinyavrummm.mp3";

public OnMapStart()
{
	AddFileToDownloadsTable( FULL_SOUND_PATH );
	FakePrecacheSound( RELATIVE_SOUND_PATH );
}

stock FakePrecacheSound( const String:szPath[] )
{
	AddToStringTable( FindStringTable( "soundprecache" ), szPath );
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
}

/*
public Action AwpTest(client, args) 
{
	//new awpSayisi;
	new silahEnt, i, awpSayisiT, awpSayisiCT;
	
	for(i=1;i<=MaxClients;i++)
	{
		if(!IsClientConnected(i)) continue;
		if(!IsClientInGame(i)) continue;
		if(!IsPlayerAlive(i)) continue;
		silahEnt = GetPlayerWeaponSlot(i, 0);
		decl String:silahIsmi[32];
		if(silahEnt != -1)
		{
			GetEntityClassname(silahEnt, silahIsmi, sizeof(silahIsmi));
			if(StrEqual(silahIsmi, "weapon_awp", false))
				if(GetClientTeam(i) == 2)
					awpSayisiT++;
				else if(GetClientTeam(i) == 3)
					awpSayisiCT++;
			PrintToChatAll("[TEST] %s @ %N", silahIsmi, i);
		}
	}
	PrintToChatAll("[TEST] AWP Sayısı: CT: %d , T: %d", awpSayisiCT, awpSayisiT);
	return Plugin_Handled;
}*/

int awpSayT()
{
	new silahEnt, i, awpSayisiT;
	
	for(i=1;i<=MaxClients;i++)
	{
		if(!IsClientConnected(i)) continue;
		if(!IsClientInGame(i)) continue;
		if(!IsPlayerAlive(i)) continue;
		silahEnt = GetPlayerWeaponSlot(i, 0);
		decl String:silahIsmi[32];
		if(silahEnt != -1)
		{
			GetEntityClassname(silahEnt, silahIsmi, sizeof(silahIsmi));
			if(StrEqual(silahIsmi, "weapon_awp", false))
				if(GetClientTeam(i) == 2)
					awpSayisiT++;
		}
	}
	return awpSayisiT;
}

int awpSayCT()
{
	new silahEnt, i, awpSayisiCT;
	
	for(i=1;i<=MaxClients;i++)
	{
		if(!IsClientConnected(i)) continue;
		if(!IsClientInGame(i)) continue;
		if(!IsPlayerAlive(i)) continue;
		silahEnt = GetPlayerWeaponSlot(i, 0);
		decl String:silahIsmi[32];
		if(silahEnt != -1)
		{
			GetEntityClassname(silahEnt, silahIsmi, sizeof(silahIsmi));
			if(StrEqual(silahIsmi, "weapon_awp", false))
				if(GetClientTeam(i) == 3)
					awpSayisiCT++;
		}
	}
	return awpSayisiCT;
}

public Action:CS_OnBuyCommand(client, const String:weapon[])
{
	new awpLimitiT, awpLimitiCT, i, TSay, CTSay;
	for(i=1;i<=MaxClients;i++)
	{
		if(!IsClientConnected(i)) continue;
		if(!IsClientInGame(i)) continue;
		if(GetClientTeam(i) == 2)
			TSay++;
		else if(GetClientTeam(i) == 3)
			CTSay++;
	}
	new Float: fawpLimitiCT;
	new Float: fawpLimitiT;
	fawpLimitiCT = CTSay * 0.3;
	fawpLimitiT = TSay * 0.3;
	decl String:sAwpLimitiT[10];
	decl String:sAwpLimitiCT[10];
	FloatToString(fawpLimitiCT, sAwpLimitiCT, sizeof(sAwpLimitiCT));
	FloatToString(fawpLimitiT, sAwpLimitiT, sizeof(sAwpLimitiT));
	awpLimitiCT = StringToInt(sAwpLimitiCT);
	awpLimitiT = StringToInt(sAwpLimitiT);
	awpLimitiCT++;
	awpLimitiT++;
	
	if(StrEqual(weapon, "awp", false))
	{
		if((!(GetUserFlagBits(client) & ADMFLAG_RESERVATION)) && (!(GetUserFlagBits(client) & ADMFLAG_ROOT)))
		{
			if(GetClientTeam(client) == 2)
			{
				if(awpSayT() >= awpLimitiT)
				{
					EmitSoundToClient( client, RELATIVE_SOUND_PATH );
					PrintToChat(client, " \x02[DrK # GaminG] \x04T'de \x10AWP Limiti \x02%d\x07 (Takımın Yüzde30'u) \x10olduğu için \x02awp alamadınız.", awpLimitiT);
					return Plugin_Handled;
				}
			}
			else if(GetClientTeam(client) == 3)
			{
				if(awpSayCT() >= awpLimitiCT)
				{
					EmitSoundToClient( client, RELATIVE_SOUND_PATH );
					PrintToChat(client, " \x02[DrK # GaminG] \x04CT'de \x10AWP Limiti \x02%d\x07 (Takımın Yüzde30'u) \x10olduğu için \x02awp alamadınız.", awpLimitiCT);
					return Plugin_Handled;
				}
			}
		}
		else
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x0EAdmin yetkinizden dolayı awp için sınırlandırılmadınız.");
		}
	}
	if(StrEqual(weapon, "flashbang", false))
	{
		decl String:mapName[64];
		GetCurrentMap(mapName, sizeof(mapName));
		if(StrEqual(mapName, "mm_madmax_v2", false))
		{
			EmitSoundToClient( client, RELATIVE_SOUND_PATH );
			PrintToChat(client, " \x02[DrK # GaminG] \x04Madmax\x10'de \x02flash \x10yasaklanmıştır. \x07Nah alırsın yavruum :))");
			return Plugin_Handled;
		}
	}
	if(StrEqual(weapon, "scar20", false))
	{
		EmitSoundToClient( client, RELATIVE_SOUND_PATH );
		PrintToChat(client, " \x02[DrK # GaminG] \x04Oto \x10yasaklanmıştır. \x07Nah alırsın yavruum :))");
		return Plugin_Handled;
	}
	if(StrEqual(weapon, "g3sg1", false))
	{
		EmitSoundToClient( client, RELATIVE_SOUND_PATH );
		PrintToChat(client, " \x02[DrK # GaminG] \x04Oto \x10yasaklanmıştır. \x07Nah alırsın yavruum :))");
		return Plugin_Handled;
	}
	return Plugin_Continue;
}