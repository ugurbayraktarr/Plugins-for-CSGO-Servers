#include <sourcemod> 
#include <sdktools> 
#pragma semicolon 1 

public Plugin:myinfo = 
{
    name        = "Kişi Sayısına Göre Süre Artırıcı", 
    author      = "ImPossibLe`", 
    description = "DrK # GaminG", 
    version     = "1.0", 
}; 

new Handle:g_PluginTagi = INVALID_HANDLE;


public OnPluginStart() 
{
	int ips[4];
	char serverip[32];
	int ip = GetConVarInt(FindConVar("hostip"));
	int port = GetConVarInt(FindConVar("hostport"));
	ips[0] = (ip >> 24) & 0x000000FF;
	ips[1] = (ip >> 16) & 0x000000FF;
	ips[2] = (ip >> 8) & 0x000000FF;
	ips[3] = ip & 0x000000FF;
	
	Format(serverip, sizeof(serverip), "%d.%d.%d", ips[0], ips[1], ips[2], ips[3]);
	if(StrEqual(serverip, "185.193.165") == false && ips[3] != 166)
	{
		LogError("Bu plugin ImPossibLe` tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");

	
	HookEvent("round_end", RoundEnd, EventHookMode_Post);
}

public Action:RoundEnd(Handle: event , const String: name[] , bool: dontBroadcast)
{
	CreateTimer(4.0, Ayarla);
}

public Action Ayarla(Handle timer)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	new Handle:g_sure1 = INVALID_HANDLE;
	g_sure1 = FindConVar("mp_roundtime");

	new Handle:g_sure2 = INVALID_HANDLE;
	g_sure2 = FindConVar("mp_roundtime_defuse");
	
	new Handle:g_sure3 = INVALID_HANDLE;
	g_sure3 = FindConVar("mp_roundtime_hostage");
	
	
	float fSure1, fSure2, fSure3;

	//if (g_sure1 != INVALID_HANDLE)
	{
		fSure1 = GetConVarFloat(g_sure1);
	}  
	
	//if (g_sure2 != INVALID_HANDLE)
	{
		fSure2 = GetConVarFloat(g_sure2);
	}
	
	//if (g_sure3 != INVALID_HANDLE)
	{
		fSure3 = GetConVarFloat(g_sure3);
	}
	
	new kisiSay = 0;
	for(new i = 1; i<=MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			if(IsClientConnected(i) && GetClientTeam(i) > 1)
			{
				kisiSay++;
			}
		}
	}
	
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	
	if(!((StrContains(mapName, "de_", false) != -1) || (StrContains(mapName, "cs_", false)!= -1)))
	{
		return Plugin_Handled;
	}
	
	if(kisiSay < 34)
	{
		if(StrContains(mapName, "de_", false) != -1)
		{
			if(fSure2 != 2)
			{
				PrintToChatAll(" \x02[%s] \x10Kişi sayısından dolayı el süresi \x042 Dakika\x10 olarak ayarlanmıştır.", sPluginTagi);
				ServerCommand("mp_roundtime_defuse 2");
			}
		}		
		else if(StrContains(mapName, "cs_", false) != -1)
		{
			if(fSure3 != 2)
			{
				PrintToChatAll(" \x02[%s] \x10Kişi sayısından dolayı el süresi \x042 Dakika\x10 olarak ayarlanmıştır.", sPluginTagi);
				ServerCommand("mp_roundtime_hostage 2");
			}
		}
		else
		{
			if(fSure1 != 2)
			{
				PrintToChatAll(" \x02[%s] \x10Kişi sayısından dolayı el süresi \x042 Dakika\x10 olarak ayarlanmıştır.", sPluginTagi);
				ServerCommand("mp_roundtime 2");
			}
		}
	}
	else if(kisiSay >= 34 && kisiSay < 44)
	{
		if(StrContains(mapName, "de_", false) != -1)
		{
			if(fSure2 != 2.25)
			{
				PrintToChatAll(" \x02[%s] \x10Kişi sayısından dolayı el süresi \x042 Dakika 15 Saniye\x10 olarak ayarlanmıştır.", sPluginTagi);
				ServerCommand("mp_roundtime_defuse 2.25");
			}
		}		
		else if(StrContains(mapName, "cs_", false) != -1)
		{
			if(fSure3 != 2.25)
			{
				PrintToChatAll(" \x02[%s] \x10Kişi sayısından dolayı el süresi \x042 Dakika 15 Saniye\x10 olarak ayarlanmıştır.", sPluginTagi);
				ServerCommand("mp_roundtime_hostage 2.25");
			}
		}
		else
		{
			if(fSure1 != 2.25)
			{
				PrintToChatAll(" \x02[%s] \x10Kişi sayısından dolayı el süresi \x042 Dakika 15 Saniye\x10 olarak ayarlanmıştır.", sPluginTagi);
				ServerCommand("mp_roundtime 2.25");
			}
		}
	}
	else if(kisiSay >= 44)
	{
		if(StrContains(mapName, "de_", false) != -1)
		{
			if(fSure2 != 2.50)
			{
				PrintToChatAll(" \x02[%s] \x10Kişi sayısından dolayı el süresi \x042 Dakika 30 Saniye\x10 olarak ayarlanmıştır.", sPluginTagi);
				ServerCommand("mp_roundtime_defuse 2.50");
			}
		}		
		else if(StrContains(mapName, "cs_", false) != -1)
		{
			if(fSure3 != 2.50)
			{
				PrintToChatAll(" \x02[%s] \x10Kişi sayısından dolayı el süresi \x042 Dakika 30 Saniye\x10 olarak ayarlanmıştır.", sPluginTagi);
				ServerCommand("mp_roundtime_hostage 2.50");
			}
		}
		else
		{
			if(fSure1 != 2.50)
			{
				PrintToChatAll(" \x02[%s] \x10Kişi sayısından dolayı el süresi \x042 Dakika 30 Saniye\x10 olarak ayarlanmıştır.", sPluginTagi);
				ServerCommand("mp_roundtime 2.50");
			}
		}
	}
}