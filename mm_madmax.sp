#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Madmax Özel Ayarları",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

static int iTime;
static int roundBasiZaman;
new Float:Zaman;
bool mesajVerildi[MAXPLAYERS + 1];
bool mesajVerildi2[MAXPLAYERS + 1];
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
	
	Format(serverip, sizeof(serverip), "%d.%d.%d", ips[0], ips[1], ips[2], ips[3]);
	if(StrEqual(serverip, "185.188.144") == false || ips[3] < 2 || ips[3] > 129)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	CreateTimer(5.0, mesajlariSifirla, _, TIMER_REPEAT);
	CreateTimer(5.0, KonusmaKapat);
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
	
	HookEvent("player_spawn", OnPlayerSpawn);
	HookEvent("round_start", Event_Round_Start, EventHookMode_Pre);
}

public Action mesajlariSifirla(Handle timer)
{
	new i;
	for(i=1;i<=MAXPLAYERS; i++)
	{
		mesajVerildi[i] = false;
		mesajVerildi2[i] = false;
		if(!IsClientConnected(i)) continue;
		if(!IsClientInGame(i)) continue;
		if(GetClientTeam(i) <= 1) continue;
		if(IsPlayerAlive(i))
		{
			new Float:origin[3];
			GetClientAbsOrigin(i, origin);
			if(origin[2] < -300)
			{
				new String:sPluginTagi[64];
				GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
				ForcePlayerSuicide(i);
				PrintToChat(i, " \x02[%s] \x0BHarita altı bugu yasaktır :))", sPluginTagi);
			}
		}
	}
		
}

public OnClientPutInServer(client)
{
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)  
{
	if(GetTime() < roundBasiZaman+30)
	{
		if((buttons & IN_ATTACK) || (buttons & IN_ATTACK2))
		{
			if(!mesajVerildi2[client])
			{
				new String:sPluginTagi[64];
				GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
				
				PrintToChat(client, " \x02[%s] \x0BMadmax'de \x04ilk 30 saniye \x0Bsilah kullanamazsınız.", sPluginTagi);
				mesajVerildi2[client] = true;
			}
			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}

public Action:OnTakeDamage(client, &attacker, &inflictor, &Float:damage, &damagetype)
{
	
	if(attacker > MaxClients)
	{
		if(!mesajVerildi[client])
		{
			new String:sPluginTagi[64];
			GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
			PrintToChat(client, " \x02[%s] \x0BEzilmeniz özel sistemimiz tarafından engelleniyor :))", sPluginTagi);
			mesajVerildi[client] = true;
		}
		return Plugin_Handled;
	}
	else
		return Plugin_Continue;
}


public Action:Event_Round_Start(Handle:event, const String:name[], bool:dontBroadcast) 
{
	CreateTimer(30.0, KonusmaKapat);
	CreateTimer(35.0, OyunAmaci);
	roundBasiZaman = GetTime();
	iTime = GetTime();
	Zaman = GetEngineTime();
}

public Action KonusmaKapat(Handle timer)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	ServerCommand("sv_talk_enemy_dead 1");
	ServerCommand("sv_talk_enemy_living 0");
	PrintToChatAll(" \x02[%s] \x04Takımlar arası konuşmalar kapatılmıştır.", sPluginTagi);
}

public Action OyunAmaci(Handle timer)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	PrintHintTextToAll("<font color='#FF0000'>[%s]</font> <font color='#00FF00'>Oyunun amacı,</font>\n<font color='#00FFFF'>T'lerin CT Base'deki tankı alıp T Base'e götürmesidir.</font>", sPluginTagi);
	PrintToChatAll(" \x02[%s] \x04Oyunun amacı, \x02T'\x04lerin \x02CT Base\x04'deki \x10tankı alıp \x02T Base\x10'e götürmesidir.", sPluginTagi);
}

public OnGameFrame()
{
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	if((StrEqual(mapName, "mm_madmax", false)) || (StrEqual(mapName, "mm_madmax_v2", false)))
	{
		float now = GetEngineTime();
		if(now >= Zaman)
		{
			int iRoundTime = GetTime() - iTime;
			Zaman = now + 1.0;
			if(iRoundTime > 0 && iRoundTime < 30)
			{
				new String:sPluginTagi[64];
				GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
				
				PrintCenterTextAll("<font color='#FF0000'>[%s]</font>\n<font color='#00FF00'>%d Saniye</font> <font color='#00FFFF'>sonra T'ler başlayacak!</font>", sPluginTagi, 30 - iRoundTime);
				new i;
				for(i=1;i<=MaxClients;i++)
				{
					if(IsClientConnected(i))
					{
						if(IsClientInGame(i))
						{
							if(!IsPlayerAlive(i) && GetClientTeam(i) > 1)
							{
								PrintToChatAll(" \x02[%s] \x0C%N \x04İlk 30 saniyede öldüğü için revlendi.", sPluginTagi, i);
								CS_RespawnPlayer(i);
							}
						}
					}
				}
			}
		}
	}
	else
	{
		ServerCommand("sm plugins unload mm_madmax");
		SetFailState("Bu plugin sadece madmax mapında çalışmaktadır.");
	}
}

public Action:CS_OnBuyCommand(client, const String:weapon[])
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(StrEqual(weapon, "flashbang", false))
	{
		PrintToChat(client, " \x02[%s] \x04Madmax\x10'de \x02flash \x0Eyasaklanmıştır.", sPluginTagi);
		return Plugin_Handled;
	}
	if(StrEqual(weapon, "scar20", false))
	{
		PrintToChat(client, " \x02[%s] \x04Madmax\x10'de \x02Oto \x0Eyasaklanmıştır.", sPluginTagi);
		return Plugin_Handled;
	}
	if(StrEqual(weapon, "g3sg1", false))
	{
		PrintToChat(client, " \x02[%s] \x04Madmax\x10'de \x02Oto \x0Eyasaklanmıştır.", sPluginTagi);
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public Action:OnPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));	
	if(GetClientTeam(client) == 2)
		silahMenusu1(client);
}

silahMenusu1(client)
{
	new Handle:menu3 = CreateMenu(istenenSilahSor1, MenuAction_Select | MenuAction_End);
	SetMenuTitle(menu3, "Hangi Silahı İstiyorsunuz");

	AddMenuItem(menu3, "p90", "P90");
	AddMenuItem(menu3, "ak47", "AK47");
	AddMenuItem(menu3, "m4a4", "M4A4");
	AddMenuItem(menu3, "m4a1s", "M4A1-S");
	

	DisplayMenu(menu3, client, MENU_TIME_FOREVER);
}

public istenenSilahSor1(Handle:menu3, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item
			
			new String:item[64];
			GetMenuItem(menu3, param2, item, sizeof(item));

			if (StrEqual(item, "negev"))
			{
				GivePlayerItem(param1, "weapon_negev");
			}
			else if (StrEqual(item, "scar20"))
			{
				GivePlayerItem(param1, "weapon_scar20");
			}
			else if (StrEqual(item, "p90"))
			{
				GivePlayerItem(param1, "weapon_p90");
			}
			else if (StrEqual(item, "ak47"))
			{
				GivePlayerItem(param1, "weapon_ak47");
			}
			else if (StrEqual(item, "awp"))
			{
				GivePlayerItem(param1, "weapon_awp");
			}
			else if (StrEqual(item, "m4a4"))
			{
				GivePlayerItem(param1, "weapon_m4a1");
			}
			else if (StrEqual(item, "m4a1s"))
			{
				GivePlayerItem(param1, "weapon_m4a1_silencer");
			}
				
			silahMenusu2(param1);
			
		}

		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason

		}
	}
}

silahMenusu2(client)
{
	new Handle:menu4 = CreateMenu(istenenSilahSor2, MenuAction_Select | MenuAction_End);
	SetMenuTitle(menu4, "Hangi Tabancayı İstiyorsunuz");

	AddMenuItem(menu4, "deagle", "Deagle");
	AddMenuItem(menu4, "tec9", "TEC-9");
	AddMenuItem(menu4, "fiveseven", "Five Seven");
	AddMenuItem(menu4, "p250", "P250");
	AddMenuItem(menu4, "usp", "USP-S");

	DisplayMenu(menu4, client, MENU_TIME_FOREVER);
}

public istenenSilahSor2(Handle:menu4, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item			
			
			new String:item[64];
			GetMenuItem(menu4, param2, item, sizeof(item));
			if (StrEqual(item, "deagle"))
			{
				GivePlayerItem(param1, "weapon_deagle");
			}
			else if (StrEqual(item, "tec9"))
			{
				GivePlayerItem(param1, "weapon_tec9");
			}
			else if (StrEqual(item, "fiveseven"))
			{
				GivePlayerItem(param1, "weapon_fiveseven");
			}
			else if (StrEqual(item, "p250"))
			{
				GivePlayerItem(param1, "weapon_p250");
			}
			else if (StrEqual(item, "usp"))
			{
				GivePlayerItem(param1, "weapon_usp_silencer");
			}

		}

		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
		}
	}
}