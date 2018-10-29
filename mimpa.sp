#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <colors>
#include "dbi.inc"

public Plugin:myinfo =
{
	name        = "Mimpa",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

public OnPluginStart() 
{
	/*RegConsoleCmd("sm_1", TEST);
	RegConsoleCmd("sm_2", TEST2);
	RegConsoleCmd("sm_3", TEST3);
	RegConsoleCmd("sm_4", TEST4);*/
	RegAdminCmd("sm_1", TEST, ADMFLAG_ROOT, "TEST");
	RegAdminCmd("sm_2", TEST2, ADMFLAG_ROOT, "TEST");
	RegAdminCmd("sm_3", TEST3, ADMFLAG_ROOT, "TEST");
	RegAdminCmd("sm_4", TEST4, ADMFLAG_ROOT, "TEST");
}

public Action TEST(int client, int args)
{
	/*decl String:authid[32];
	GetClientAuthString(client, authid, sizeof(authid));
	if(!(StrEqual(authid, "STEAM_1:1:104585403", false))) // UĞUR ÖZEL GLOBAL
	{
		PrintToChat(client, " \x02Bu komut sadece \x04ImPossibLe` \x02içindir ;)");
		return Plugin_Handled;
	}*/
	new a;
	a = GetClientAimTarget(client, false);
	PrintToChat(client, " Entity: %d", a);
	return Plugin_Continue;
	/*
	new i;
	for(i=1; i<=2048; i++)
	{
		if(IsValidEntity(i))
		{
			decl String:entityIsmi[128];
			GetEntityClassname(i, entityIsmi, sizeof(entityIsmi));
			if(StrEqual(entityIsmi, "func_physbox", false))
			{
				PrintToChat(client, "%s - %d", entityIsmi, i);
			}
		}
	}*/
}

public Action TEST2(int client, int args)
{
	/*decl String:authid[32];
	GetClientAuthString(client, authid, sizeof(authid));
	if(!(StrEqual(authid, "STEAM_1:1:104585403", false))) // UĞUR ÖZEL GLOBAL
	{
		PrintToChat(client, " \x02Bu komut sadece \x04ImPossibLe` \x02içindir ;)");
		return Plugin_Handled;
	}*/
	if(args==0)
		return Plugin_Handled;
	new yukari;
		
	decl String:sTest[32], String:sTest2[32];
	
	GetCmdArg(1, sTest, sizeof(sTest));
	new entity = StringToInt(sTest);
	
	if(args >= 2)
	{
		GetCmdArg(2, sTest2, sizeof(sTest2));
		yukari = StringToInt(sTest2);
	}
	
	new Float:Origin[3];
	GetCollisionPoint(client, Origin);
	
	//Math
	Origin[2] = (Origin[2] + yukari);
	
	TeleportEntity(entity, Origin, NULL_VECTOR, NULL_VECTOR);
	
	return Plugin_Handled;
}


public Action TEST3(int client, int args)
{
	/*decl String:authid[32];
	GetClientAuthString(client, authid, sizeof(authid));
	if(!(StrEqual(authid, "STEAM_1:1:104585403", false))) // UĞUR ÖZEL GLOBAL
	{
		PrintToChat(client, " \x02Bu komut sadece \x04ImPossibLe` \x02içindir ;)");
		return Plugin_Handled;
	}*/
	if(args==0)
		return Plugin_Handled;
		
	decl String:sTest[32];
	
	GetCmdArg(1, sTest, sizeof(sTest));
	new entity = StringToInt(sTest);
	
	AcceptEntityInput(entity, "Kill");	
	
	return Plugin_Handled;
}

public Action TEST4(int client, int args)
{
	/*decl String:authid[32];
	GetClientAuthString(client, authid, sizeof(authid));
	if(!(StrEqual(authid, "STEAM_1:1:104585403", false))) // UĞUR ÖZEL GLOBAL
	{
		PrintToChat(client, " \x02Bu komut sadece \x04ImPossibLe` \x02içindir ;)");
		return Plugin_Handled;
	}*/
	new a;
	a = GetClientAimTarget(client, false);
	PrintToChat(client, " Entity: %d", a);
	if(a != -1 && a > 64)
	{
		AcceptEntityInput(a, "Kill");
		PrintToChat(client, "İşlem Başarılı.");
	}
	
	return Plugin_Handled;
}

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