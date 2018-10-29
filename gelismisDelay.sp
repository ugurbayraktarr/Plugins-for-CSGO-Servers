#pragma semicolon 1
#include <sourcemod>
#include <basecomm>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

new Handle:g_PluginTagi = INVALID_HANDLE;

public Plugin:myinfo =
{
	name        = "Delay Düzeltme",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

bool muteKontrol[MAXPLAYERS+1];
bool delayUygulaniyor;
static int iDelaySuresi;
static int komutZamani;

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
	
	CreateTimer(1.0, Countdown, _, TIMER_REPEAT);
	RegAdminCmd("sm_delay", DelayKomutu, ADMFLAG_GENERIC, "Delay Giderme Komutu");
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
}

public Action:DelayKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));

	if(args != 1)
	{
		PrintToChat(client, " \x02[%s] \x04Kullanım: \x0E!delay süre", sPluginTagi);
		return Plugin_Handled;
	}
	else
	{
		new String:sSure[10];
		GetCmdArg(1, sSure, sizeof(sSure));
		new Float:fSure = StringToFloat(sSure);
		iDelaySuresi = StringToInt(sSure);
		
		if(fSure < 1.0 || fSure > 10.0)
		{
			PrintToChat(client, " \x02[%s] \x04Süreyi 1-10sn arası giriniz.", sPluginTagi);
			return Plugin_Handled;
		}
		
		for(new i=1;i<=MaxClients;i++)
		{
			muteKontrol[i] = false;
			if(!IsClientConnected(i)) continue;
			if(!IsClientInGame(i)) continue;
			if(GetClientTeam(i) == 3)
			{
				if(!BaseComm_IsClientMuted(i))
				{
					muteKontrol[i] = true;
					BaseComm_SetClientMute(i, true);
				}
			}
		}
		
		delayUygulaniyor = true;
		komutZamani = GetTime();
		PrintToChatAll(" \x02[%s] \x10%N \x01, \x04%.0f saniyelik \x0Edelay \x06komutu uyguladı.", sPluginTagi, client, fSure);
		CreateTimer(fSure, MuteKaldir);
		
	}
	return Plugin_Continue;
}

public Action:MuteKaldir(Handle:timer)
{
	for(new i=1;i<=MaxClients;i++)
	{
		if(!IsClientConnected(i)) continue;
		if(!IsClientInGame(i)) continue;
		if(GetClientTeam(i) == 3)
		{
			if(muteKontrol[i])
			{
				BaseComm_SetClientMute(i, false);
				muteKontrol[i] = false;
			}
		}
	}
	PrintCenterTextAll("<b><font color='#FF0000'>! ! !</font> <font color='#00FF00'>Komutçunun mutesi açılmıştır</font> <font color='#FF0000'>! ! !</font></b>");
	delayUygulaniyor = false;
}

public Action:Countdown(Handle timer)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(delayUygulaniyor)
	{
		if(iDelaySuresi - (GetTime() - komutZamani) > 0)
			PrintCenterTextAll("<b><font color='#FFFFFF'>Komutçunun mutesi</font> <font color='#00FF00'>%d</font> <font color='#FFFFFF'>saniye sonra açılacak!</font></b>", iDelaySuresi - (GetTime() - komutZamani));
	}
}