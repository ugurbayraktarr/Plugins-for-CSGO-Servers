#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <colors>

public Plugin:myinfo =
{
	name = "Zaman Ayarlı Freeze",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "1.2",
};

new Handle:g_PluginTagi = INVALID_HANDLE;

static int iFreezeSuresi;
static int komutZamani;
static int freezeAtilacak = 0;
bool freezeOynaniyor;

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
	
	HookEvent("round_end", Event_RoundEnd, EventHookMode_Pre);
	RegAdminCmd("sm_freezet", freeze_Komutu, ADMFLAG_GENERIC);
	RegAdminCmd("sm_freezeiptal", freeze_Iptal, ADMFLAG_GENERIC);
	CreateTimer(1.0, Countdown, _, TIMER_REPEAT);
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
}

public Action:freeze_Komutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(args != 1)
	{
		PrintToConsole(client, "Kullanım: !freezet sure");
		PrintToChat(client, "\x02Kullanım:\x04 !freezet sure");
		return Plugin_Handled;
	}
	
	new String:sfreezeSuresi[10];
	GetCmdArg(1, sfreezeSuresi, sizeof(sfreezeSuresi));
	iFreezeSuresi = StringToInt(sfreezeSuresi);
	new String:nick[32];
	GetClientName(client, nick, 32);	
	
	PrintToChatAll(" \x02[%s] \x0EFreeze \x10%s \x01tarafından \x04%d \x01saniyeye ayarlandı.", sPluginTagi, nick, iFreezeSuresi);
	komutZamani = GetTime();
	freezeAtilacak = 1;
	freezeOynaniyor = false;
	return Plugin_Continue;
}

public Action:freeze_Iptal(client, args)
{
	if(args != 0)
	{
		PrintToConsole(client, "Kullanım: !freezeiptal");
		PrintToChat(client, "\x02Kullanım:\x04 !freezeiptal");
		return Plugin_Handled;
	}
	
	PrintCenterTextAll("<b><font color='#00FF00'>Freeze</font> <font color='#FFFFFF'>iptal edilmiştir.</font></b>");
	freezeAtilacak = 0;
	freezeOynaniyor = false;
	return Plugin_Continue;
}


/*public OnGameFrame()
{
	if(freezeAtilacak == 1)
	{
		if(iFreezeSuresi - (GetTime() - komutZamani) > 0)
		{
			PrintCenterTextAll("%d Saniye sonra Freeze atılacaktır!", iFreezeSuresi - (GetTime() - komutZamani));
		}
		else if(iFreezeSuresi - (GetTime() - komutZamani) == 0)
		{
			ServerCommand("sm_freeze @t -1");
			ServerCommand("sm_otogag 1");
			PrintCenterTextAll("Freeze atılmıştır, Bol Şans!", iFreezeSuresi - (GetTime() - komutZamani));
			freezeAtilacak = 0;
		}
	}
}*/

public Action:Countdown(Handle timer)
{	
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(freezeAtilacak == 1)
	{
		if(iFreezeSuresi - (GetTime() - komutZamani) > 0)
		{
			PrintCenterTextAll("<b><font color='#FFFFFF'>Freeze</font> <font color='#00FF00'>%d</font> <font color='#FFFFFF'>saniye sonra atılacak!</font></b>", iFreezeSuresi - (GetTime() - komutZamani));
			if((iFreezeSuresi - (GetTime() - komutZamani)) <= 10)
				PrintToChatAll(" \x0BFreeze \x04%i \x0Bsaniye sonra atılacak!", iFreezeSuresi - (GetTime() - komutZamani));
			if((iFreezeSuresi - (GetTime() - komutZamani)) == 10)
			{
				ServerCommand("sm_otorevkapat");
			}
			if(((iFreezeSuresi - (GetTime() - komutZamani)) % 10) == 0)
				PrintToChatAll(" \x0BFreeze \x04%i \x0Bsaniye sonra atılacak!", iFreezeSuresi - (GetTime() - komutZamani));
		}
		else if(iFreezeSuresi - (GetTime() - komutZamani) == 0)
		{
			ServerCommand("sm_freeze @t -1");
			ServerCommand("sm_otogag 1");
			PrintCenterTextAll("<b><font color='#FF0000'>! ! !</font> <font color='#00FF00'>Freeze atılmıştır</font> <font color='#FF0000'>! ! !</font></b>");
			PrintToChatAll(" \x02[%s] \x0EFreeze \x06atılmıştır.", sPluginTagi);
			freezeAtilacak = 0;
			freezeOynaniyor = true;
		}
	}
}

public Action Event_RoundEnd(Handle event, char[] name, bool dontBroadcast)
{
	if(freezeOynaniyor)
		ServerCommand("sm_otogag 0");
	freezeOynaniyor = false;
	freezeAtilacak = 0;
}