#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <clientprefs>

#define SPECMODE_FIRSTPERSON	4
#define SPECMODE_3RDPERSON 	5

new Handle:g_PluginTagi = INVALID_HANDLE;

public Plugin:myinfo =
{
	name        = "İzleyen Sayısını Gösterme Sistemi",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

static int izleyenSayisi[MAXPLAYERS+1];
Handle g_izleyenCookie;

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
	
	g_izleyenCookie = RegClientCookie("Izleyen Sayisi Gosterme Sistemi", "", CookieAccess_Private);
	SetCookieMenuItem(izleyenCookieHandler, 0, "İzleyen Sayısı Gösterme Sistemi");
	
	RegConsoleCmd("sm_izleyen", IzleyenIptalMenusu, "İzleyen kişi sayısını göstermeyi açma/kapatma.");
	RegConsoleCmd("sm_izleme", IzleyenIptalMenusu, "İzleyen kişi sayısını göstermeyi açma/kapatma.");
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");

	
	CreateTimer(0.2, SurekliTimer, _, TIMER_REPEAT);
}

public void izleyenCookieHandler(int client, CookieMenuAction action, any info, char[] buffer, int maxlen)
{
	izleyenIptalMenu(client, 0);
}

public Action:IzleyenIptalMenusu(client, args)
{
	izleyenIptalMenu(client, 0);
}

public Action izleyenIptalMenu(int client, int args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	int cookievalue = GetIntCookie(client, g_izleyenCookie);
	Handle g_izleyenMenu = CreateMenu(izleyenMenuHandler);
	SetMenuTitle(g_izleyenMenu, "[%s] İzleyen Sayısı Gösterme Sistemi", sPluginTagi);
	char Item[128];
	if(cookievalue == 0)
	{
		Format(Item, sizeof(Item), "Açık (X)"); 
		AddMenuItem(g_izleyenMenu, "ON", Item);
		Format(Item, sizeof(Item), "Kapalı"); 
		AddMenuItem(g_izleyenMenu, "OFF", Item);
	}
	else
	{
		Format(Item, sizeof(Item), "Açık");
		AddMenuItem(g_izleyenMenu, "ON", Item);
		Format(Item, sizeof(Item), "Kapalı (X)"); 
		AddMenuItem(g_izleyenMenu, "OFF", Item);
	}
	SetMenuExitBackButton(g_izleyenMenu, true);
	SetMenuExitButton(g_izleyenMenu, true);
	DisplayMenu(g_izleyenMenu, client, 30);
}

public int izleyenMenuHandler(Handle menu, MenuAction action, int param1, int param2)
{
	Handle g_izleyenMenu = CreateMenu(izleyenMenuHandler);
	if (action == MenuAction_DrawItem)
	{
		return ITEMDRAW_DEFAULT;
	}
	else if(param2 == MenuCancel_ExitBack)
	{
		ShowCookieMenu(param1);
	}
	else if (action == MenuAction_Select)
	{
		switch (param2)
		{
			case 0:
			{
				SetClientCookie(param1, g_izleyenCookie, "0");
				izleyenIptalMenu(param1, 0);
			}
			case 1:
			{
				SetClientCookie(param1, g_izleyenCookie, "1");
				izleyenIptalMenu(param1, 0);
			}
		}
		CloseHandle(g_izleyenMenu);
	}
	return 0;
}

int GetIntCookie(int client, Handle handle)
{
	char sCookieValue[11];
	GetClientCookie(client, handle, sCookieValue, sizeof(sCookieValue));
	return StringToInt(sCookieValue);
}


public Action:SurekliTimer(Handle timer)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	new i, izlenen;
	for(i=1;i<=MaxClients;i++)
		izleyenSayisi[i] = 0;
	
	for(i=1;i<=MaxClients;i++)
	{
		izlenen = -1;
		if(!IsClientConnected(i)) continue;
		if(!IsClientInGame(i)) continue;
		if(GetClientTeam(i) < 1) continue;
		if(IsPlayerAlive(i)) continue;
		
		new iObserverMode = GetEntProp(i, Prop_Send, "m_iObserverMode");
		if(iObserverMode == SPECMODE_FIRSTPERSON || iObserverMode == SPECMODE_3RDPERSON)
			izlenen = GetEntPropEnt(i, Prop_Send, "m_hObserverTarget");
		
		
		if(izlenen > 0 && izlenen <= MaxClients)
			izleyenSayisi[izlenen]++;
	}
	
	for(i=1;i<=MaxClients;i++)
	{
		izlenen = -1;
		if(!IsClientConnected(i)) continue;
		if(!IsClientInGame(i)) continue;
		if(GetClientTeam(i) < 1) continue;
		if(IsPlayerAlive(i))
		{
			if(izleyenSayisi[i] > 2)
				if((GetIntCookie(i, g_izleyenCookie)) == 0)
					PrintHintText(i, "<font color='#FF0000'>%s İzleme Sistemi\n<font color='#00FFFF'>Şuan <font color='#FF00FF'>%d <font color='#00FFFF'>kişi sizi izliyor.", sPluginTagi, izleyenSayisi[i]);
		}
		else
		{
			//izlenen = GetEntPropEnt(i, Prop_Send, "m_hObserverTarget");
			
			new iObserverMode = GetEntProp(i, Prop_Send, "m_iObserverMode");
			if(iObserverMode == SPECMODE_FIRSTPERSON || iObserverMode == SPECMODE_3RDPERSON)
				izlenen = GetEntPropEnt(i, Prop_Send, "m_hObserverTarget");
		
			if(izlenen > 0 && izlenen <= MaxClients)
				if((GetIntCookie(i, g_izleyenCookie)) == 0)
					PrintHintText(i, "<font color='#FF0000'>İzlediğiniz kişi: <font color='#00FF00'>%N\n<font color='#00FFFF'>Şuan <font color='#FF00FF'>%d <font color='#00FFFF'>kişi tarafından izleniyor.", izlenen, izleyenSayisi[izlenen]);
		}
	}	
}
				/*
				iObserverMode = GetEntProp(i, Prop_Send, "m_iObserverMode");
				if(iObserverMode == SPECMODE_FIRSTPERSON || iObserverMode == SPECMODE_3RDPERSON)
				{
					iClientToShow = GetEntPropEnt(i, Prop_Send, "m_hObserverTarget");
				*/
					