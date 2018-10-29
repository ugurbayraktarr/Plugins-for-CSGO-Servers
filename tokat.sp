#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <colors>

public Plugin:myinfo =
{
	name        = "Alan dışı tokat atma",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

bool tokatAtilacak;
float g_fAlan[3];
float g_fCap = 2200.0;

int g_iBeamSprite = -1;
int g_iHaloSprite = -1;
int g_iColor[4] = {255,0,255,255};

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
	
	HookEvent("round_end", Event_Round_End);
	HookEvent("round_start", Event_Round_End);
	RegAdminCmd("sm_tokat", TokatKomutu, ADMFLAG_GENERIC, "Belirlenen alan dışındakileri tokatlar.");
	
	CreateTimer(0.5, Timer, _, TIMER_REPEAT);
	CreateTimer(2.0, Tokatla, _, TIMER_REPEAT);
}

public Action:TokatKomutu(client, args)
{
	PrintToChatAll(" \x02[DrK # GaminG] \x04%N \x10tarafından tokat alanı belirlendi!", client);
	GetClientAimTargetPos(client, g_fAlan);
	PrintToChatAll("TEST: %.0f %.0f %.0f", g_fAlan[0], g_fAlan[1], g_fAlan[2]);
	g_fCap = 2200.0;
	tokatAtilacak = true;
	AlanCiz();
	TokatMenu(client);
}

public Action:Event_Round_End(Handle:event, const String:name[], bool:dontBroadcast) 
{
	tokatAtilacak = false;
}

public Action Timer(Handle timer, any data)
{
	if(tokatAtilacak)
		AlanCiz();
	else
	{
		g_fCap = 0.0;
		tokatAtilacak = false;
	}
	return Plugin_Continue;
}

public Action Tokatla(Handle timer, any data)
{
	if(tokatAtilacak)
	{
		for(new i=1; i<=MaxClients; i++)
		{
			if(IsClientInGame(i) && IsClientConnected(i))
			{
				if(GetClientTeam(i) == 2 && IsPlayerAlive(i))
				{
					float vOrigin[3];
					GetClientEyePosition(i, vOrigin);
					if(GetVectorDistance(vOrigin, g_fAlan, false) > g_fCap / 2)
					{
						SlapPlayer(i, 2, true);
						PrintToChat(i, " \x02[DrK # GaminG] \x04Belirlenen alanda olmadığınız için tokatlanıyorsunuz.");
					}
				}
			}
		}
	}
	return Plugin_Continue;
}

public void OnMapStart()
{
	tokatAtilacak = false;
	g_fCap = 0.0;
	g_iBeamSprite = PrecacheModel("materials/sprites/laserbeam.vmt");
	g_iHaloSprite = PrecacheModel("materials/sprites/glow01.vmt");
	
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	
	if(!((StrContains(mapName, "jb_", false) != -1) || (StrContains(mapName, "jail_", false)!= -1)))
	{
		SetFailState("Bu plugin sadece jail maplarinda calismaktadir..");
	}
}

public void OnMapEnd()
{
	g_fCap = 0.0;
	tokatAtilacak = false;
}

stock void AlanCiz()
{
	if (!tokatAtilacak)
		return;
	if(g_fCap == 0.0)
		return;
	
	float fAlan[3];
	fAlan[0] = g_fAlan[0];
	fAlan[1] = g_fAlan[1];
	fAlan[2] = g_fAlan[2];
	
	fAlan[2] += 10;
	
	for(new i=0;i<=12;i++)
	{
		int renk[4];
		renk[0] = GetRandomInt(0, 255);
		renk[1] = GetRandomInt(0, 255);
		renk[2] = GetRandomInt(0, 255);
		renk[3] = 255;
		TE_SetupBeamRingPoint(fAlan, g_fCap, g_fCap+0.1, g_iBeamSprite, g_iHaloSprite, 0, 10, 0.5, 4.0, 0.0, renk, 10, 0);
		TE_SendToAll();
		fAlan[2] += 30;
	}
}


stock int GetClientAimTargetPos(int client, float g_fPos[3]) 
{
	if (client < 1) 
		return -1;
	
	float vAngles[3]; float vOrigin[3];
	
	GetClientEyePosition(client,vOrigin);
	GetClientEyeAngles(client, vAngles);
	
	Handle trace = TR_TraceRayFilterEx(vOrigin, vAngles, MASK_SHOT, RayType_Infinite, TraceFilterAllEntities, client);
	
	TR_GetEndPosition(g_fPos, trace);
	g_fPos[2] += 5.0;
	
	int entity = TR_GetEntityIndex(trace);
	
	CloseHandle(trace);
	
	return entity;
}

public bool TraceFilterAllEntities(int entity, int contentsMask, any client)
{
	if (entity == client)
		return false;
	if (entity > MaxClients)
		return false;
	if(!IsClientInGame(entity))
		return false;
	if(!IsPlayerAlive(entity))
		return false;
	
	return true;
}

TokatMenu(client)
{
	new Handle:menuTokat = CreateMenu(tokatAlani, MenuAction_Select | MenuAction_End);
	SetMenuTitle(menuTokat, "Tokat Alanını Seçiniz");

	AddMenuItem(menuTokat, "Onayla", "Seçimi Onayla");
	AddMenuItem(menuTokat, "buyut", "Alanı Büyüt");
	AddMenuItem(menuTokat, "kucult", "Alanı Küçült");

	DisplayMenu(menuTokat, client, MENU_TIME_FOREVER);
}

public tokatAlani(Handle:menuTokat, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menuTokat, param2, item, sizeof(item));

			if (StrEqual(item, "Onayla"))
			{
			}
			else if (StrEqual(item, "buyut"))
			{
				g_fCap+=100.0;
				TokatMenu(param1);
			}
			else if (StrEqual(item, "kucult"))
			{
				g_fCap-=100.0;
				TokatMenu(param1);
			}
		}

		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menuTokat);
		}
	}
	return 0;
}
