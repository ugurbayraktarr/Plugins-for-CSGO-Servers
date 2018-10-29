#pragma semicolon 1
#include <sourcemod>
#include <sdktools>

public Plugin:myinfo =
{
	name        = "Oto ve Negevin Sinirlandirilmasi",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

new iKomutcu;
new otoNegevHakki;
new Handle:g_PluginTagi = INVALID_HANDLE;

public OnPluginStart() 
{
	RegConsoleCmd("sm_w", Command_W);
	HookEvent("round_start", EventRoundStart);
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");

	CreateTimer(2.0, otoNegevKontrol, _, TIMER_REPEAT);
}

public OnMapStart()
{
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	
	if(!((StrContains(mapName, "jb_", false) != -1) || (StrContains(mapName, "jail_", false)!= -1)))
	{
		SetFailState("Bu plugin sadece jail maplarinda calismaktadir..");
	}
}

public Action:Command_W(client, args)
{
	if(GetClientTeam(client) == 3)
	{
		if(iKomutcu < 1)
		{
			iKomutcu = client;
			OtoNegevMenu(client);
		}
	}
}

public Action:EventRoundStart(Handle:event, const String:name[], bool:dontBroadcast) 
{
	iKomutcu = -1;
	otoNegevHakki = -1;
}

public Action otoNegevKontrol(Handle timer)
{
	new silahEnt;
	
	for(new i=1;i<=MaxClients;i++)
	{
		if(!IsClientConnected(i)) continue;
		if(!IsClientInGame(i)) continue;
		if(!IsPlayerAlive(i)) continue;
		silahEnt = GetPlayerWeaponSlot(i, 0);
		decl String:silahIsmi[32];
		if(silahEnt != -1)
		{
			GetEntityClassname(silahEnt, silahIsmi, sizeof(silahIsmi));
			if((StrEqual(silahIsmi, "weapon_negev", false)) || (StrEqual(silahIsmi, "weapon_g3sg1", false)) || (StrEqual(silahIsmi, "weapon_scar20", false)))
			{
				if(GetClientTeam(i) == 3)
				{
					if(otoNegevHakki > 0)
					{
						if(otoNegevHakki != i)
						{
							new String:sPluginTagi[64];
							GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
							
							AcceptEntityInput(silahEnt, "Kill");
							PrintToChat(i, " \x02[%s] \x0EBu silahı kullanma izniniz bulunmuyor.", sPluginTagi);
						}
					}
				}
			}
		}
	}
}

OtoNegevMenu(int client)
{
	new Handle:menu = CreateMenu(hMenu, MenuAction_Select | MenuAction_End);
	
	SetMenuTitle(menu, "Oto ve Negev Hakkı Kimde Olsun");

	AddMenuItem(menu, "nolimit", "Sınırlama Olmasın");
	
	decl String:sClientName[40];
	decl String:sClientIndex[4];
	for(new i = 1; i <= MaxClients; i++)
	{
		if(!IsClientInGame(i) || IsFakeClient(i) || GetClientTeam(i) != 3) continue;
		IntToString(i, sClientIndex, sizeof(sClientIndex));
		GetClientName(i, sClientName, sizeof(sClientName));
		AddMenuItem(menu, sClientIndex, sClientName);
	}

	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public hMenu(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "nolimit"))
			{
				otoNegevHakki = -1;
			}
			else
			{
				otoNegevHakki = StringToInt(item);
			}
		}

		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);

		}
	}
	return 0;
}
