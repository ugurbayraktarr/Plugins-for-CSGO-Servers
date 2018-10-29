#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <colors>
#include "dbi.inc"


public Plugin:myinfo =
{
	name = "Gel & Git",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "1.0",
};

new Handle:g_PluginTagi = INVALID_HANDLE;
 
//Plugin-Start
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
	
	RegAdminCmd("sm_git", Command_Goto, ADMFLAG_SLAY,"Bir oyuncuya git");
	RegAdminCmd("sm_gel", Command_Bring, ADMFLAG_SLAY,"Bir oyuncuyu getir");
	RegAdminCmd("sm_gelt", Command_Bring_t, ADMFLAG_SLAY,"Tum T'leri getirir");
	RegAdminCmd("sm_gelct", Command_Bring_ct, ADMFLAG_SLAY,"Tum CT'leri getirir");
	RegAdminCmd("sm_gelall", Command_Bring_all, ADMFLAG_SLAY,"Tum oyunculari getirir");
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
}

public Action:Command_Goto(Client,args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	decl String:sSecim[32];
    //Error:
	if(args < 1)
	{
		if(args == 1)
		{
			
			GetCmdArg(1, sSecim, sizeof(sSecim));
			if(StrEqual(sSecim, "@t", false))
			{
				Command_Bring_t(Client, args);
				return Plugin_Handled;
			}
			if(StrEqual(sSecim, "@ct", false))
			{
				Command_Bring_ct(Client, args);
				return Plugin_Handled;
			}
			if(StrEqual(sSecim, "@all", false))
			{
				Command_Bring_all(Client, args);
				return Plugin_Handled;
			}
		}
		//Print:
		PrintToConsole(Client, "Kullanım: !git isim");
		PrintToChat(Client, "Kullanım:\x04 !git isim");

		//Return:
		return Plugin_Handled;
	}
	
	//Declare:
	decl MaxPlayers, Player;
	decl String:PlayerName[32];
	GetCmdArg(1, PlayerName, sizeof(PlayerName));
	new Float:TeleportOrigin[3];
	new Float:PlayerOrigin[3];
	decl String:Name[32];
	decl String:cekilenIsim[32];
	
	//Initialize:
	Player = -1;


	//Find:
	MaxPlayers = GetMaxClients();
	for(new X = 1; X <= MaxPlayers; X++)
	{

		//Connected:
		if(!IsClientConnected(X)) continue;

		//Initialize:
		GetClientName(X, Name, sizeof(Name));

		//Save:
		if(StrContains(Name, PlayerName, false) != -1) Player = X;
	}
	
	//Invalid Name:
	if(Player == -1)
	{

		//Print:
		PrintToConsole(Client, "Kullanıcı bulunamadı: \x04%s", PlayerName);

		//Return:
		return Plugin_Handled;
	}
	
	//Initialize
	GetClientName(Player, Name, sizeof(Name));
	GetClientAbsOrigin(Player, PlayerOrigin);
	
	//Math
	TeleportOrigin[0] = PlayerOrigin[0];
	TeleportOrigin[1] = PlayerOrigin[1];
	TeleportOrigin[2] = (PlayerOrigin[2] + 1);
	
	//Teleport
	TeleportEntity(Client, TeleportOrigin, NULL_VECTOR, NULL_VECTOR);
	
	decl String:cekenIsim[32];
	GetClientName(Client, cekenIsim, sizeof(cekenIsim));
	GetClientName(Player, cekilenIsim, sizeof(cekenIsim));
	PrintToChatAll(" \x02[%s] \x10%s \x01adlı oyuncu, \x10%s\x01'nin \x0Eyanına gitti.", sPluginTagi, cekenIsim, cekilenIsim);
	
	return Plugin_Handled;
}

public Action:Command_Bring(client,args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
    //Error:
	if(args < 1)
	{

		//Print:
		PrintToConsole(client, "Kullanım: !gel isim");
		PrintToChat(client, "Kullanım:\x04 !gel isim");

		//Return:
		return Plugin_Handled;
	}
	
	//Declare:
	decl MaxPlayers, Player;
	decl String:PlayerName[32];
	new Float:TeleportOrigin[3];
	new Float:PlayerOrigin[3];
	decl String:Name[32];
	decl String:cekilenIsim[32];
	
	//Initialize:
	Player = -1;
	GetCmdArg(1, PlayerName, sizeof(PlayerName));
	
	//Find:
	MaxPlayers = GetMaxClients();
	for(new X = 1; X <= MaxPlayers; X++)
	{

		//Connected:
		if(!IsClientConnected(X)) continue;

		//Initialize:
		GetClientName(X, Name, sizeof(Name));

		//Save:
		if(StrContains(Name, PlayerName, false) != -1) Player = X;
		
	}
		
	
	//Invalid Name:
	if(Player == -1)
	{
		//Print:
		PrintToConsole(client, "Kullanıcı bulunamadı: \x04%s", PlayerName);

		//Return:
		return Plugin_Handled;
	}
	

	
	//Initialize
	GetClientName(Player, Name, sizeof(Name));
	GetCollisionPoint(client, PlayerOrigin);
	
	//Math
	TeleportOrigin[0] = PlayerOrigin[0];
	TeleportOrigin[1] = PlayerOrigin[1];
	TeleportOrigin[2] = (PlayerOrigin[2] + 4);
	
	//Teleport
	TeleportEntity(Player, TeleportOrigin, NULL_VECTOR, NULL_VECTOR);
	
	decl String:cekenIsim[32];
	GetClientName(client, cekenIsim, sizeof(cekenIsim));
	GetClientName(Player, cekilenIsim, sizeof(cekenIsim));
	PrintToChatAll(" \x02[%s] \x10%s\x04 \x01adlı oyuncu \x10%s \x01'i \x0Eçekti.", sPluginTagi, cekenIsim, cekilenIsim);
	
	return Plugin_Handled;
}


public Action:Command_Bring_t(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
    //Error:
	if(args != 0)
	{

		//Print:
		PrintToConsole(client, "Kullanım: !gel_t");
		PrintToChat(client, "Kullanım:\x04 !gel_t");

		//Return:
		return Plugin_Handled;
	}
	
	//Declare:
	new Float:TeleportOrigin[3];
	new Float:PlayerOrigin[3];
	
	for(new i = 1; i <= 64; i++)
	{
		if(i != client)
		{
			if(IsClientInGame(i))
			{
				if(IsPlayerAlive(i))
				{
					if(GetClientTeam(i) == 2)
					{
						//Initialize
						GetCollisionPoint(client, PlayerOrigin);
						
						//Math
						TeleportOrigin[0] = PlayerOrigin[0];
						TeleportOrigin[1] = PlayerOrigin[1];
						TeleportOrigin[2] = (PlayerOrigin[2] + 4);
						
						//Teleport
						TeleportEntity(i, TeleportOrigin, NULL_VECTOR, NULL_VECTOR);

					}
				}
			}
		}
	}
	decl String:cekenIsim[32];
	GetClientName(client, cekenIsim, sizeof(cekenIsim));
	PrintToChatAll(" \x02[%s] \x10%s \x01adlı oyuncu, \x09T'leri \x0Eçekti.", sPluginTagi, cekenIsim);
	return Plugin_Handled;
}

public Action:Command_Bring_ct(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
    //Error:
	if(args != 0)
	{

		//Print:
		PrintToConsole(client, "Kullanım: !gel_t");
		PrintToChat(client, "Kullanım:\x04 !gel_t");

		//Return:
		return Plugin_Handled;
	}
	
	//Declare:
	new Float:TeleportOrigin[3];
	new Float:PlayerOrigin[3];
	
	for(new i = 1; i <= 64; i++)
	{
		if(i != client)
		{
			if(IsClientInGame(i))
			{
				if(IsPlayerAlive(i))
				{
					if(GetClientTeam(i) == 3)
					{
						//Initialize
						GetCollisionPoint(client, PlayerOrigin);
						
						//Math
						TeleportOrigin[0] = PlayerOrigin[0];
						TeleportOrigin[1] = PlayerOrigin[1];
						TeleportOrigin[2] = (PlayerOrigin[2] + 4);
						
						//Teleport
						TeleportEntity(i, TeleportOrigin, NULL_VECTOR, NULL_VECTOR);

					}
				}
			}
		}
	}
	decl String:cekenIsim[32];
	GetClientName(client, cekenIsim, sizeof(cekenIsim));
	PrintToChatAll(" \x02[%s] \x10%s\x01 adlı oyuncu, \x0BCT'leri \x05çekti.", sPluginTagi, cekenIsim);
	return Plugin_Handled;
}

public Action:Command_Bring_all(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
    //Error:
	if(args != 0)
	{

		//Print:
		PrintToConsole(client, "Kullanım: !gel_t");
		PrintToChat(client, "Kullanım:\x04 !gel_t");

		//Return:
		return Plugin_Handled;
	}
	
	//Declare:
	new Float:TeleportOrigin[3];
	new Float:PlayerOrigin[3];
	
	for(new i = 1; i <= 64; i++)
	{
		if(i != client)
		{
			if(IsClientInGame(i))
			{
				if(IsPlayerAlive(i))
				{
					if(GetClientTeam(i) != 0)
					{
						//Initialize
						GetCollisionPoint(client, PlayerOrigin);
						
						//Math
						TeleportOrigin[0] = PlayerOrigin[0];
						TeleportOrigin[1] = PlayerOrigin[1];
						TeleportOrigin[2] = (PlayerOrigin[2] + 4);
						
						//Teleport
						TeleportEntity(i, TeleportOrigin, NULL_VECTOR, NULL_VECTOR);
					}
				}
			}
		}
	}
	decl String:cekenIsim[32];
	GetClientName(client, cekenIsim, sizeof(cekenIsim));
	PrintToChatAll(" \x02[%s] \x10%s\x01 adlı oyuncu, \x07herkesi \x0Eçekti.", sPluginTagi, cekenIsim);
	return Plugin_Handled;
}

// Trace

stock GetCollisionPoint(client, Float:pos[3])
{
	decl Float:vOrigin[3], Float:vAngles[3];
	
	GetClientEyePosition(client, vOrigin);
	GetClientEyeAngles(client, vAngles);
	
	new Handle:trace = TR_TraceRayFilterEx(vOrigin, vAngles, MASK_SOLID, RayType_Infinite, TraceEntityFilterPlayer);
	
	if(TR_DidHit(trace))
	{
		TR_GetEndPosition(pos, trace);
		CloseHandle(trace);
		
		return;
	}
	
	CloseHandle(trace);
}

public bool:TraceEntityFilterPlayer(entity, contentsMask)
{
	return entity > MaxClients;
}  

