#include <sourcemod>
#include <sdktools>
#include <sourcemod>

#define MAX_WORDS 400

public Plugin:myinfo =
{
    name = "Deagle Sustum",
    author = "ImPossibLe`",
    description = "DrK # GaminG",
    version = "1.0"
}

new String:yazilar[82][256];
static int deagleKullanan = -1;
static int randomSayi;
bool yazildi = false;
bool oldurulsun = false;
bool oldurdu = false;
bool oynaniyor = false;
new Handle:g_PluginTagi = INVALID_HANDLE;
new String:yazilarDosyasi[PLATFORM_MAX_PATH];
static int toplamYazi;

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

	
	RegAdminCmd("sm_dsustum", RandomYazi, ADMFLAG_GENERIC, "Deagle Sustum oyunu başlatır.");
	AddCommandListener(Command_Say, "say");
	HookEvent("weapon_fire", weapon_fire);
	HookEvent("player_death", Event_PlayerDeath);
	
	yazilariOku();
}

void yazilariOku()
{
	BuildPath(Path_SM, yazilarDosyasi, sizeof(yazilarDosyasi), "configs/sustum_mesajlari.ini");
	if(FileExists(yazilarDosyasi))
	{
		new Handle:yazilarHandle = OpenFile(yazilarDosyasi, "r");
		new i = 0;
		while( i < MAX_WORDS && !IsEndOfFile(yazilarHandle)){
			ReadFileLine(yazilarHandle, yazilar[i], sizeof(yazilar[]));
			TrimString(yazilar[i]);
			i++;
		}
		toplamYazi = i;
		CloseHandle(yazilarHandle);
	}
}

public Action:RandomYazi(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	PrintToChatAll(" \x02[%s] \x10%N \x0EDeagle sustum \x06başlatıyor!", sPluginTagi, client);
	CreateTimer(3.0, Timer);
	Vuramazsa(client);
	oldurulsun = false;
	oldurdu = false;
	oynaniyor = false;
}

public Action Timer(Handle timer)
{
	randomSayi = GetRandomInt(0, toplamYazi);
	yazdir();
	yazildi = false;
}

void yazdir()
{
	char URL[512];
	Format(URL, 512, "https://cs.center/csctts.php?oku=%s", yazilar[randomSayi]);
	int i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			ShowHiddenMOTDPanel(i, URL, MOTDPANEL_TYPE_URL);
		}
		i++;
	}
	CreateTimer(0.5, RandomYaziTimer);
	CreateTimer(2.0, RandomYaziTimer);
	CreateTimer(3.0, RandomYaziTimer);
	CreateTimer(4.0, RandomYaziTimer);
	CreateTimer(5.0, RandomYaziTimer);
	CreateTimer(6.0, RandomYaziTimer);
	CreateTimer(7.0, RandomYaziTimer);
	CreateTimer(8.0, RandomYaziTimer);
	CreateTimer(9.0, RandomYaziTimer);
	CreateTimer(10.0, RandomYaziTimer);
	CreateTimer(11.0, RandomYaziTimer);
	CreateTimer(12.0, RandomYaziTimer);
	CreateTimer(13.0, RandomYaziTimer);
	CreateTimer(14.0, RandomYaziTimer);
	CreateTimer(15.0, RandomYaziTimer);
	CreateTimer(16.0, RandomYaziTimer);
	CreateTimer(17.0, RandomYaziTimer);
	CreateTimer(18.0, RandomYaziTimer);
	CreateTimer(19.0, RandomYaziTimer);
	CreateTimer(20.0, RandomYaziTimer);
	CreateTimer(21.0, RandomYaziTimer);
	CreateTimer(22.0, RandomYaziTimer);
	CreateTimer(23.0, RandomYaziTimer);
	CreateTimer(24.0, RandomYaziTimer);
	CreateTimer(25.0, RandomYaziTimer);
	CreateTimer(26.0, RandomYaziTimer);
	CreateTimer(27.0, RandomYaziTimer);
	CreateTimer(28.0, RandomYaziTimer);
	CreateTimer(29.0, RandomYaziTimer);
	CreateTimer(30.0, RandomYaziTimer);
	CreateTimer(32.0, RandomYaziTimer);
	CreateTimer(34.0, RandomYaziTimer);
	CreateTimer(36.0, RandomYaziTimer);
	CreateTimer(38.0, RandomYaziTimer);
	CreateTimer(40.0, RandomYaziTimer);
	CreateTimer(60.0, Bitir);
}

public Action RandomYaziTimer(Handle timer)
{
	if(!yazildi)
		PrintCenterTextAll("<font color='#00ffde'>%s", yazilar[randomSayi]);
}

public Action:Command_Say(client, const String:command[], args)
{
	decl String:yazi[200];
	GetCmdArgString(yazi, sizeof(yazi));
	StripQuotes(yazi);
	
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(StrEqual(yazi, yazilar[randomSayi], false))
	{
		if(!yazildi)
		{
			if(GetClientTeam(client) != 3 && IsPlayerAlive(client))
			{
				PrintToChatAll(" \x02[%s] \x10%N \x01ilk doğru yazan kişi, \x06tebrikler!", sPluginTagi, client);
				PrintCenterTextAll("<b><font color='#FFFF00'>%N</font> <font color='#00FFFF'>ilk doğru yazan kişi, tebrikler!</font></b>", client);
				oynaniyor = true;
				yazildi = true;
				DeagleSustum(client);
				deagleKullanan = client;
				return Plugin_Handled;
			}
		}
	}
	return Plugin_Continue;
}

public Action Bitir(Handle timer)
{
	if(!yazildi)
	{
		yazildi = true;
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public OnMapStart()
{
	oldurulsun = false;
	oldurdu = false;
	oynaniyor = false;
}

DeagleSustum(client)
{
	new userid = GetClientUserId(client);
	GivePlayerItem(client, "weapon_deagle");
	ServerCommand("sm_beacon #%d", userid);
	deagleKullanan = -1;
}

public weapon_fire(Handle:event,const String:name[],bool:dontBroadcast) 
{
	if(deagleKullanan > 0)
	{
		new userid = GetEventInt(event, "userid");
		new client = GetClientOfUserId(userid);
		new String:weapon_name[50];
		
		GetClientWeapon(client, weapon_name, sizeof(weapon_name));
		TrimString(weapon_name);
		StripQuotes(weapon_name);
		if(client == deagleKullanan)
		{
			if(StrEqual(weapon_name, "weapon_deagle", false))
			{
				CreateTimer(0.1, DeagleBitir, userid);
			}
		}
	}
}

public Action DeagleBitir(Handle timer, any userid)
{
	ServerCommand("sm_strip #%d 2", userid);
	ServerCommand("sm_beacon #%d", userid);
	CreateTimer(0.1, DeagleBitir2, userid);
}

public Action DeagleBitir2(Handle timer, any userid)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	PrintToChatAll(" \x02[%s] \x10%N \x0ADeagle atış hakkını kullandı.", sPluginTagi, deagleKullanan);
	if(oynaniyor)
	{
		if(oldurulsun)
		{
			if(!oldurdu)
			{
				PrintToChatAll(" \x02[%s] \x10%N \x0CAdam vuramadığı için \x07öldürüldü.", sPluginTagi, deagleKullanan);
				ForcePlayerSuicide(deagleKullanan);
			}
			else
			{
				PrintToChatAll(" \x02[%s] \x10%N \x01Adam vurduğu için öldürülmedi, \x06tebrikler..", sPluginTagi, deagleKullanan);
			}
		}
	}
	deagleKullanan = -1;
	oynaniyor = false;
}


Vuramazsa(client)
{
	new Handle:menu = CreateMenu(vuramazsa, MenuAction_Select | MenuAction_End);
	SetMenuTitle(menu, "Vuramazsa Öldürülsün Mü?");

	AddMenuItem(menu, "evet", "Evet, Öldürülsün");
	AddMenuItem(menu, "hayir", "Hayır, Öldürülmesin");

	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public vuramazsa(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "evet"))
			{
				oldurulsun = true;
				oldurdu = false;
			}
			else if (StrEqual(item, "hayir"))
			{
				oldurulsun = false;
				oldurdu = false;
			}
		}

		case MenuAction_End:
		{
			CloseHandle(menu);
		}
	}
	return 0;
}

public Action:Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client_died = GetClientOfUserId(GetEventInt(event, "userid"));
	new client_killer = GetClientOfUserId(GetEventInt(event, "attacker"));
	
	if(oynaniyor)
	{
		if(client_died != client_killer)
		{
			if(deagleKullanan > 0)
			{
				if(client_killer == deagleKullanan)
				{
					oldurdu = true;
				}
			}
		}
	}
}

public void ShowHiddenMOTDPanel(int client, char[] url, int type)
{
	Handle setup = CreateKeyValues("data");
	KvSetString(setup, "title", "YouTube Music Player by namazso");
	KvSetNum(setup, "type", type);
	KvSetString(setup, "msg", url);
	ShowVGUIPanel(client, "info", setup, false);
	delete setup;
}