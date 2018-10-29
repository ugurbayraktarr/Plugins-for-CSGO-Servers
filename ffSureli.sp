#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <colors>

public Plugin:myinfo =
{
	name = "Zaman Ayarlı Dost Ateşi",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "1.2",
};

static int iffSuresi;
static int komutZamani;
static int ffAtilacak = 0;
new Handle:g_PluginTagi = INVALID_HANDLE;

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
	RegAdminCmd("sm_ffac", ff_Komutu, ADMFLAG_GENERIC);
	RegAdminCmd("sm_ffkapat", ff_KapatKomutu, ADMFLAG_GENERIC);
	RegAdminCmd("sm_ffiptal", ff_Iptal, ADMFLAG_GENERIC);
	CreateTimer(1.0, Countdown, _, TIMER_REPEAT);
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
}

public Action:ff_Komutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	if(args > 1)
	{
		PrintToConsole(client, "Kullanım: !ffac sure");
		PrintToChat(client, "\x02Kullanım:\x04 !ffac sure");
		return Plugin_Handled;
	}
	if(args == 0)
	{
		PrintToChatAll(" \x02[%s] \x10%N \x01tarafından \x0EDost Ateşi \x06açıldı.", sPluginTagi, client);
		ServerCommand("mp_teammates_are_enemies 1");
		//PrintCenterTextAll("<font color='#00FF00'>Dost Ateşi açılmıştır,</font> <font color='#00FFFF'>Bol Şans!</font>");
		PrintCenterTextAll("<b><font color='#FF0000'>! ! !</font> <font color='#00FF00'>Dost Ateşi açılmıştır</font> <font color='#FF0000'>! ! !</font></b>");
		//PrintToChatAll(" \x02[DrK # GaminG] \x10Dost Ateşi açılmıştır, \x04Bol şans!");
		ffAtilacak = 0;
		return Plugin_Handled;
	}
	
	new String:sffSuresi[10];
	GetCmdArg(1, sffSuresi, sizeof(sffSuresi));
	iffSuresi = StringToInt(sffSuresi);
	new String:nick[32];
	GetClientName(client, nick, 32);	
	if(args == 0)
		iffSuresi = 0;
	
	PrintToChatAll(" \x02[%s] \x0EDost Ateşi \x10%s \x01tarafından \x04%d \x01saniyeye ayarlandı.", sPluginTagi, nick, iffSuresi);
	komutZamani = GetTime();
	ffAtilacak = 1;
	
	return Plugin_Continue;
}

public Action:ff_KapatKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(args != 0)
	{
		PrintToConsole(client, "Kullanım: !ffkapat");
		PrintToChat(client, " \x02Kullanım:\x04 !ffkapat");
		return Plugin_Handled;
	}
	
	PrintToChatAll(" \x02[%s] \x10%N \x01tarafından \x0EDost Ateşi \x07kapatıldı.", sPluginTagi, client);
	ServerCommand("mp_teammates_are_enemies 0");
	
	return Plugin_Continue;
}

public Action:ff_Iptal(client, args)
{
	if(args != 0)
	{
		PrintToConsole(client, "Kullanım: !ffiptal");
		PrintToChat(client, "\x02Kullanım:\x04 !ffiptal");
		return Plugin_Handled;
	}
	
	PrintCenterTextAll("<b><font color='#00FF00'>Dost Ateşi</font> <font color='#FFFFFF'>iptal edilmiştir.</font></b>");
	ffAtilacak = 0;
	return Plugin_Continue;
}


public Action:Countdown(Handle timer)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(ffAtilacak == 1)
	{
		if(iffSuresi - (GetTime() - komutZamani) > 0)
		{
			//PrintCenterTextAll("%d Saniye sonra FF açılacaktır!", iffSuresi - (GetTime() - komutZamani));
			PrintCenterTextAll("<b><font color='#FFFFFF'>Dost Ateşi</font> <font color='#00FF00'>%d</font> <font color='#FFFFFF'>saniye sonra açılacak!</font></b>", iffSuresi - (GetTime() - komutZamani));
			if((iffSuresi - (GetTime() - komutZamani)) <= 10)
				PrintToChatAll(" \x0BDost Ateşi \x04%i \x0Bsaniye sonra açılacak!", iffSuresi - (GetTime() - komutZamani));
			if((iffSuresi - (GetTime() - komutZamani)) == 10)
			{
				//ServerCommand("sm_hp @all 100");
				for (new i = 1; i <= MaxClients; i++)
				{
					if(!IsClientConnected(i) || !IsClientInGame(i) || IsFakeClient(i)) continue;
					if(!IsPlayerAlive(i)) continue;
					SetEntityHealth(i, 100);
				}
				ServerCommand("sm_otorevkapat");
			}
			else if(((iffSuresi - (GetTime() - komutZamani)) % 10) == 0)
				PrintToChatAll(" \x0BDost Ateşi \x04%i \x0Bsaniye sonra açılacak!", iffSuresi - (GetTime() - komutZamani));
		}
		else if(iffSuresi - (GetTime() - komutZamani) == 0)
		{
			ServerCommand("mp_teammates_are_enemies 1");
			//PrintCenterTextAll("<b><font color='#00FF00'>Dost Ateşi açılmıştır,</font> <font color='#FFFFFF'>Bol Şans!</font></b>");
			PrintCenterTextAll("<b><font color='#FF0000'>! ! !</font> <font color='#00FF00'>Dost Ateşi açılmıştır</font> <font color='#FF0000'>! ! !</font></b>");
			//PrintToChatAll(" \x02[DrK # GaminG] \x10Dost Ateşi açılmıştır, \x04Bol şans!");
			PrintToChatAll(" \x02[%s] \x0EDost Ateşi \x04açılmıştır.", sPluginTagi);
			ffAtilacak = 0;
		}
	}
}

public Action Event_RoundEnd(Handle event, char[] name, bool dontBroadcast)
{
	ffAtilacak = 0;
}