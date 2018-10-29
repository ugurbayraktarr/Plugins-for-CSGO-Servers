#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <entity>

public Plugin:myinfo =
{
	name        = "Eldivenler",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

new String:silahIsmi[MAXPLAYERS+1][10][32];
new String:eldiven1[256];
new String:eldiven2[256];
new String:eldiven3[256];
new String:eldiven4[256];
new String:eldiven5[256];
new String:eldiven6[256];
new String:eldiven7[256];
new String:eldiven8[256];
new secimler[MAXPLAYERS+1];


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
	
	eldiven1 = "models/weapons/v_models/arms/glove_fingerless/v_glove_fingerless.mdl";
	eldiven2 = "models/weapons/v_models/arms/glove_hardknuckle/v_glove_hardknuckle.mdl";
	eldiven3 = "models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl";
	eldiven4 = "models/weapons/v_models/arms/glove_sporty/v_glove_sporty.mdl";
	eldiven5 = "models/weapons/v_models/arms/glove_handwrap_leathery/v_glove_handwrap_leathery.mdl";
	eldiven6 = "models/weapons/v_models/arms/glove_slick/v_glove_slick.mdl";
	eldiven7 = "models/weapons/v_models/arms/glove_specialist/v_glove_specialist.mdl";
	eldiven8 = "models/weapons/v_models/arms/glove_motorcycle/v_glove_motorcycle.mdl";
	
	AddFileToDownloadsTable(eldiven1);
	PrecacheModel(eldiven1);
	AddFileToDownloadsTable(eldiven2);
	PrecacheModel(eldiven2);
	AddFileToDownloadsTable(eldiven3);
	PrecacheModel(eldiven3);
	AddFileToDownloadsTable(eldiven4);
	PrecacheModel(eldiven4);
	AddFileToDownloadsTable(eldiven5);
	PrecacheModel(eldiven5);
	AddFileToDownloadsTable(eldiven6);
	PrecacheModel(eldiven6);
	AddFileToDownloadsTable(eldiven7);
	PrecacheModel(eldiven7);
	AddFileToDownloadsTable(eldiven8);
	PrecacheModel(eldiven8);
	

	RegAdminCmd("sm_eldiven", EldivenKomutu, ADMFLAG_GENERIC, "Delay Giderme Komutu");
	RegAdminCmd("sm_eldiven2", EldivenKomutu2, ADMFLAG_GENERIC, "Delay Giderme Komutu");
	RegAdminCmd("sm_eldiven3", EldivenKomutu3, ADMFLAG_GENERIC, "Delay Giderme Komutu");
}

public Action:EldivenKomutu(client, args)
{
	new String:sSecim[32];
	GetCmdArg(1, sSecim, sizeof(sSecim));
	new iSecim = StringToInt(sSecim, sizeof(sSecim));
	secimler[client] = iSecim;
	
	CreateTimer(0.0, SilahlariSil, client);
	CreateTimer(0.1, KoluVer, client);
	
	
	return Plugin_Continue;
}

public OnEntityCreated(entity, const String:classname[])
{
	PrintToChatAll("%d, %s", entity, classname);
}

public Action:EldivenKomutu2(client, args)
{
	for(new i=1;i<=2048;i++)
	{
		if(IsValidEntity(i))
		{
			decl String:sEnt[64];
			GetEntityClassname(i, sEnt, sizeof(sEnt));
			PrintToChatAll("%d, %s", i, sEnt);
		}
	}
}

public Action:EldivenKomutu3(client, args)
{
	new String:sSecim[32];
	GetCmdArg(1, sSecim, sizeof(sSecim));
	new iSecim = StringToInt(sSecim, sizeof(sSecim));
	
	SetEntProp(iSecim, Prop_Send, "m_hMyWearables",10026);
}

public Action:KoluVer(Handle:timer, client)
{
	if(secimler[client] == 1)
		SetEntPropString(client, Prop_Send, "m_szArmsModel", eldiven1); 
	if(secimler[client] == 2)
		SetEntPropString(client, Prop_Send, "m_szArmsModel", eldiven2);
	if(secimler[client] == 3)
		SetEntPropString(client, Prop_Send, "m_szArmsModel", eldiven3);
	if(secimler[client] == 4)
		SetEntPropString(client, Prop_Send, "m_szArmsModel", eldiven4);
	if(secimler[client] == 5)
		SetEntPropString(client, Prop_Send, "m_szArmsModel", eldiven5);
	if(secimler[client] == 6)
		SetEntPropString(client, Prop_Send, "m_szArmsModel", eldiven6);
	if(secimler[client] == 7)
		SetEntPropString(client, Prop_Send, "m_szArmsModel", eldiven7);
	if(secimler[client] == 8)
	{
		SetEntPropString(client, Prop_Send, "m_szArmsModel", eldiven8);

		int entity = CreateEntityByName("wearable_item"); 
		DispatchSpawn(entity);  
		SetEntProp(entity, Prop_Send, "m_iItemDefinitionIndex", 5034);
		SetEntProp(entity, Prop_Send, "m_nFallbackPaintKit", 10009);
		SetEntPropEnt(client, Prop_Send, "m_hMyWearables", entity);
	}
}


public Action:SilahlariSil(Handle:timer, client:client)
{
	new silahEnt, a = 0;
	for(new i=0;i<10;i++)
		silahIsmi[client][i] = "";
	
	decl String:sSilah[32];
	for(new j=0;j<5;j++)
	{
		if(j==4)
		{
			for(new k=0;k<6;k++)
			{
				silahEnt = GetPlayerWeaponSlot(client, j);
				if(silahEnt != -1)
				{
					GetEntityClassname(silahEnt, sSilah, sizeof(sSilah));
					if((StrContains(sSilah, "weapon_", false) != -1))
					{
						a++;
						Format(silahIsmi[client][a], sizeof(silahIsmi), "%s", sSilah);
						AcceptEntityInput(silahEnt, "Kill");
					}
				}
			}
		}
		else
		{
			silahEnt = GetPlayerWeaponSlot(client, j);
			if(silahEnt != -1)
			{
				GetEntityClassname(silahEnt, sSilah, sizeof(sSilah));
				if((StrContains(sSilah, "weapon_", false) != -1))
				{
					a++;
					Format(silahIsmi[client][a], sizeof(silahIsmi), "%s", sSilah);
					AcceptEntityInput(silahEnt, "Kill");
				}
			}
		}
	}
	
	CreateTimer(0.2, SilahlariVer, client);
}

public Action:SilahlariVer(Handle:timer, client:client)
{
	for(new i=0;i<10;i++)
		if((StrContains(silahIsmi[client][i], "weapon_", false) != -1))
			if(IsPlayerAlive(client))
				GivePlayerItem(client, silahIsmi[client][i]);
}
