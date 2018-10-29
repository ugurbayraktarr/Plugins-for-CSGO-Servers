#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <warden>
#define LoopClients(%1) for(int %1 = 1; %1 <= MaxClients; %1++) if(IsClientInGame(%1))
#define LoopValidClients(%1,%2,%3) for(int %1 = 1; %1 <= MaxClients; %1++) if(IsValidClient(%1, %2, %3))

public Plugin:myinfo =
{
	name        = "Jail Özel Komutçu İşareti",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

new Handle:g_PluginTagi = INVALID_HANDLE;

bool g_bMarkerSetup;
bool g_bCanZoom[MAXPLAYERS + 1];
bool g_bHasSilencer[MAXPLAYERS + 1];
float g_fMarkerRadiusMin = 150.0;
float g_fMarkerRadiusMax = 500.0;
float g_fMarkerRangeMax = 2000.0;
//float g_fMarkerArrowHeight = 90.0;
//float g_fMarkerArrowLength = 20.0;
float g_fMarkerSetupStartOrigin[3];
float g_fMarkerSetupEndOrigin[3];
float g_fMarkerOrigin[8][3];
float g_fMarkerRadius[8];
new g_iWrongWeapon[MAXPLAYERS+1];
char g_sEquipWeapon[MAXPLAYERS+1][32];
int g_iWarden = -1;
int g_iBeamSprite = -1;
int g_iHaloSprite = -1;
int g_iColors[8][4] = 
{
	{255,255,255,255},  //white
	{255,0,0,255},  //red
	{20,255,20,255},  //green
	{0,0,255,255},  //blue
	{255,255,0,255},  //yellow
	{0,255,255,255},  //cyan
	{255,0,255,255},  //magenta
	{255,60,0,255}
};
char g_sColorNames[8][64] ={{"\x01Beyaz"},{"\x02Kırmızı"},{"\x04Yeşil"},{"\x0CMavi"},{"\x09Sarı"},{"\x0BTurkuaz"},{"\x0EPembe"},{"\x10Turuncu"}};

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

	HookEvent("item_equip", ItemEquip);
	HookEvent("round_start", Event_Round_Start);
	RegConsoleCmd("sm_w", Command_W);
	CreateTimer(1.0, Timer_DrawMakers, _, TIMER_REPEAT);
}

public Action:Event_Round_Start(Handle:event, const String:name[], bool:dontBroadcast) 
{
	g_iWarden = -1;
}

public Action:Command_W(client, args)
{
	if(GetClientTeam(client) == 3)
	{
		if(g_iWarden == -1)
		{
			g_iWarden = client;
		}
	}
}

public void OnMapStart()
{
	RemoveAllMarkers();
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
	RemoveAllMarkers();
}

//New Marker

public Action ItemEquip(Handle event, const char[] name, bool dontBroadcast)
{
	int client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	g_bCanZoom[client] = GetEventBool(event, "canzoom");
	g_bHasSilencer[client] = GetEventBool(event, "hassilencer");
	g_iWrongWeapon[client] = GetEventInt(event, "weptype");
	char weapon[32];
	GetEventString(event, "item", weapon, sizeof(weapon));
	g_sEquipWeapon[client] = weapon;

}

public Action Timer_DrawMakers(Handle timer, any data)
{
	Draw_Markers();
	return Plugin_Continue;
}


stock void Draw_Markers()
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if (g_iWarden == -1)
		return;
	
	for(int i = 0; i<8; i++)
	{
		if (g_fMarkerRadius[i] <= 0.0)
			continue;
		
		float fWardenOrigin[3];
		//Entity_GetAbsOrigin(g_iWarden, fWardenOrigin);
		GetClientAbsOrigin(g_iWarden, fWardenOrigin);
		
		if (GetVectorDistance(fWardenOrigin, g_fMarkerOrigin[i]) > g_fMarkerRangeMax)
		{
			//CPrintToChat(g_iWarden, "%t %t", "warden_tag", "warden_marker_faraway", g_sColorNames[i]);
			PrintToChatAll(" \x02[%s] \x10Bir işaret, komutçu uzaklaştığı için kaldırıldı.", sPluginTagi);
			RemoveMarker(i);
			continue;
		}
		
		LoopValidClients(iClient, false, false)
		{
			// Show the ring
			
			new j;
			float fMarkerOrigin[8][3];
			for(j=0;j<8;j++)
			{
				fMarkerOrigin[i][0] = g_fMarkerOrigin[i][0];
				fMarkerOrigin[i][1] = g_fMarkerOrigin[i][1];
				fMarkerOrigin[i][2] = g_fMarkerOrigin[i][2];
			}
			
			j=0;
			fMarkerOrigin[i][2] += 10;
			//for(j=0;j<=6;j++)
			{
				TE_SetupBeamRingPoint(fMarkerOrigin[i], g_fMarkerRadius[i], g_fMarkerRadius[i]+0.1, g_iBeamSprite, g_iHaloSprite, 0, 10, 1.0, 4.0, 0.0, g_iColors[i], 10, 0);
				TE_SendToAll();
				
				fMarkerOrigin[i][2] += 40;
			}
			
			// Show the arrow
			
			/*float fStart[3];
			AddVectors(fStart, g_fMarkerOrigin[i], fStart);
			fStart[2] += g_fMarkerArrowHeight;
			
			float fEnd[3];
			AddVectors(fEnd, fStart, fEnd);
			fEnd[2] += g_fMarkerArrowLength;
			
			
			TE_SetupBeamPoints(fStart, fEnd, g_iBeamSprite, g_iHaloSprite, 0, 10, 1.0, 2.0, 16.0, 1, 0.0, g_iColors[i], 5);
			TE_SendToAll();*/
		}
	}
}

stock void MarkerMenu(int client)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(!(0 < client < MaxClients) || client != g_iWarden)
	{
		//CPrintToChat(client, "%t %t", "warden_tag", "warden_notwarden");
		return;
	}
	
	int marker = IsMarkerInRange(g_fMarkerSetupStartOrigin);
	if (marker != -1)
	{
		RemoveMarker(marker);
		PrintToChatAll(" \x02[%s] %s \x0Eişaret kaldırıldı.", sPluginTagi, g_sColorNames[marker]);
		return;
	}
	
	float radius = 2*GetVectorDistance(g_fMarkerSetupEndOrigin, g_fMarkerSetupStartOrigin);
	if (radius <= 0.0)
	{
		RemoveMarker(marker);
		//CPrintToChat(client, "%t %t", "warden_tag", "warden_wrong");
		return;
	}
	
	float g_fPos[3];
	//Entity_GetAbsOrigin(g_iWarden, g_fPos);
	GetClientAbsOrigin(g_iWarden, g_fPos);
	
	float range = GetVectorDistance(g_fPos, g_fMarkerSetupStartOrigin);
	if (range > g_fMarkerRangeMax)
	{
		//CPrintToChat(client, "%t %t", "warden_tag", "warden_range");
		PrintToChat(client, " \x02[%s] \x10Bu kadar büyük işaret koyamazsınız.", sPluginTagi);
		return;
	}
	
	if (0 < client < MaxClients)
	{
		Handle menu = CreateMenu(Handle_MarkerMenu);
		
		char menuinfo[255];
		
		Format(menuinfo, sizeof(menuinfo), "İşaret rengi ne olsun?", client);
		SetMenuTitle(menu, menuinfo);
		
		Format(menuinfo, sizeof(menuinfo), "Kırmızı", client);
		AddMenuItem(menu, "1", menuinfo);
		Format(menuinfo, sizeof(menuinfo), "Mavi", client);
		AddMenuItem(menu, "3", menuinfo);
		Format(menuinfo, sizeof(menuinfo), "Yeşil", client);
		AddMenuItem(menu, "2", menuinfo);
		Format(menuinfo, sizeof(menuinfo), "Turuncu", client);
		AddMenuItem(menu, "7", menuinfo);
		Format(menuinfo, sizeof(menuinfo), "Beyaz", client);
		AddMenuItem(menu, "0", menuinfo);
		Format(menuinfo, sizeof(menuinfo), "Turkuaz", client);
		AddMenuItem(menu, "5", menuinfo);
		Format(menuinfo, sizeof(menuinfo), "Pembe", client);
		AddMenuItem(menu, "6", menuinfo);
		Format(menuinfo, sizeof(menuinfo), "Sarı", client);
		AddMenuItem(menu, "4", menuinfo);
		
		DisplayMenu(menu, client, 20);
	}
}


public int Handle_MarkerMenu(Handle menu, MenuAction action, int client, int itemNum)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(!(0 < client < MaxClients))
		return;
	
	if(!IsValidClient(client, false, false))
		return;
	
	if (client != g_iWarden)
	{
		//CPrintToChat(client, "%t %t", "warden_tag", "warden_notwarden");
		return;
	}
	
	if (action == MenuAction_Select)
	{
		char info[32]; char info2[32];
		bool found = GetMenuItem(menu, itemNum, info, sizeof(info), _, info2, sizeof(info2));
		int marker = StringToInt(info);
		
		if (found)
		{
			SetupMarker(client, marker);
			PrintToChatAll(" \x02[%s] %s \x03işaret konuldu.", sPluginTagi, g_sColorNames[marker]);
		}
	}
}


stock void SetupMarker(int client, int marker)
{
	g_fMarkerOrigin[marker][0] = g_fMarkerSetupStartOrigin[0];
	g_fMarkerOrigin[marker][1] = g_fMarkerSetupStartOrigin[1];
	g_fMarkerOrigin[marker][2] = g_fMarkerSetupStartOrigin[2];
	
	float radius = 2*GetVectorDistance(g_fMarkerSetupEndOrigin, g_fMarkerSetupStartOrigin);
	if (radius > g_fMarkerRadiusMax)
		radius = g_fMarkerRadiusMax;
	else if (radius < g_fMarkerRadiusMin)
		radius = g_fMarkerRadiusMin;
	g_fMarkerRadius[marker] = radius;
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

stock void RemoveMarker(int marker)
{
	if(marker != -1)
	{
		g_fMarkerRadius[marker] = 0.0;
	}
}


stock void RemoveAllMarkers()
{
	for(int i = 0; i < 8;i++)
		RemoveMarker(i);
}


stock int IsMarkerInRange(float g_fPos[3])
{
	for(int i = 0; i < 8;i++)
	{
		if (g_fMarkerRadius[i] <= 0.0)
			continue;
		
		if (GetVectorDistance(g_fMarkerOrigin[i], g_fPos) < g_fMarkerRadius[i])
			return i;
	}
	return -1;
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

public Action OnPlayerRunCmd(int client, int &buttons, int &impulse, float vel[3], float angles[3], int &weapon)
{
	if (client == g_iWarden)
	{
		if (buttons & IN_ATTACK2)
		{
			if (!g_bCanZoom[client] && !g_bHasSilencer[client] && (g_iWrongWeapon[client] != 0) && (g_iWrongWeapon[client] != 8) && (!StrEqual(g_sEquipWeapon[client], "taser")))
			{
				if(!g_bMarkerSetup)
					GetClientAimTargetPos(client, g_fMarkerSetupStartOrigin);
				
				GetClientAimTargetPos(client, g_fMarkerSetupEndOrigin);
				
				float radius = 2*GetVectorDistance(g_fMarkerSetupEndOrigin, g_fMarkerSetupStartOrigin);
				
				if (radius > g_fMarkerRadiusMax)
					radius = g_fMarkerRadiusMax;
				else if (radius < g_fMarkerRadiusMin)
					radius = g_fMarkerRadiusMin;
				
				if (radius > 0)
				{
					TE_SetupBeamRingPoint(g_fMarkerSetupStartOrigin, radius, radius+0.1, g_iBeamSprite, g_iHaloSprite, 0, 10, 0.1, 2.0, 0.0, {255,255,255,255}, 10, 0);
					TE_SendToClient(client);
				}
				
				g_bMarkerSetup = true;
			}
		}
		else if (g_bMarkerSetup)
		{
			MarkerMenu(client);
			g_bMarkerSetup = false;
		}
	}
	return Plugin_Continue;
}

stock bool IsValidClient(int client, bool bAllowBots = false, bool bAllowDead = true)
{
	if(!(1 <= client <= MaxClients) || !IsClientInGame(client) || (IsFakeClient(client) && !bAllowBots) || IsClientSourceTV(client) || IsClientReplay(client) || (!bAllowDead && !IsPlayerAlive(client)))
	{
		return false;
	}
	return true;
}