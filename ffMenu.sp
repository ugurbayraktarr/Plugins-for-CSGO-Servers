#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

public Plugin:myinfo =
{
	name = "FF Menüsü",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "2.0",
};

bool ffAtilacak;
bool ffOynaniyor;
new kacSaniyeSonra;
new komutZamani;


bool yasakla_negev;
bool yasakla_scar20;
bool yasakla_p90;
bool yasakla_ak47;
bool yasakla_awp;
bool yasakla_m4a4;
bool yasakla_m4a1s;

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
	
	RegAdminCmd("sm_ffmenu", FFMenuKomutu, ADMFLAG_GENERIC, "Dost Ateşi Menüsünü Açar");
	RegAdminCmd("sm_ffiptal", FFIptal, ADMFLAG_GENERIC, "Dost Ateşi Açma işlemini iptal eder");
	HookEvent("round_start", EventRoundStart);
	HookEvent("round_end", EventRoundStart);
	HookEvent("player_spawn", OnPlayerSpawn);
	CreateTimer(1.0, SurekliTimer, _, TIMER_REPEAT);
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
}

public EventRoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	ffAtilacak = false;
	ffOynaniyor = false;
}

public Action:FFIptal(client, args)
{
	if(args != 0)
	{
		PrintToConsole(client, "Kullanım: !ffiptal");
		PrintToChat(client, "\x02Kullanım:\x04 !ffiptal");
		return Plugin_Handled;
	}
	ServerCommand("sm_beacon @ct");
	PrintCenterTextAll("<b><font color='#00FF00'>Dost Ateşi</font> <font color='#FFFFFF'>iptal edilmiştir.</font></b>");
	ffAtilacak = false;
	return Plugin_Continue;
}

public Action:FFMenuKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(args > 0)
	{
		PrintToConsole(client, "Kullanım: !ffmenu");
		PrintToChat(client, "\x02Kullanım:\x04 !ffmenu");
		return Plugin_Handled;
	}
	if(ffOynaniyor)
	{
		PrintToChat(client, " \x02[%s] \x06Şuan zaten bir \x0EDost Ateşi \x06oynanıyor!", sPluginTagi);
		return Plugin_Handled;
	}
	
	ZamanSor(client);
	return Plugin_Continue;
}

public Action Event_RoundEnd(Handle event, char[] name, bool dontBroadcast)
{
	ffAtilacak = false;
}

public Action:OnPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	if(IsClientConnected(client) && IsClientInGame(client) && GetClientTeam(client) == 2 && ffAtilacak)
		silahMenusu1(client);
}

ZamanSor(int client)
{
	new Handle:menu = CreateMenu(ffZamanSor, MenuAction_Select | MenuAction_End | MenuAction_DisplayItem);
	SetMenuTitle(menu, "Kaç Saniye Sonra Dost Ateşi Açılsın");

	AddMenuItem(menu, "20sn", "20 Saniye");
	AddMenuItem(menu, "40sn", "40 Saniye");
	AddMenuItem(menu, "60sn", "60 Saniye");
	AddMenuItem(menu, "80sn", "80 Saniye");
	AddMenuItem(menu, "100sn", "100 Saniye");

	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public ffZamanSor(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "20sn"))
			{
				kacSaniyeSonra = 20;
			}
			else if (StrEqual(item, "40sn"))
			{
				kacSaniyeSonra = 40;
			}
			else if (StrEqual(item, "60sn"))
			{
				kacSaniyeSonra = 60;
			}
			else if (StrEqual(item, "80sn"))
			{
				kacSaniyeSonra = 80;
			}
			else if (StrEqual(item, "100sn"))
			{
				kacSaniyeSonra = 100;
			}
			
			yasakla_negev = false;
			yasakla_scar20 = false;
			yasakla_p90 = false;
			yasakla_ak47 = false;
			yasakla_awp = false;
			yasakla_m4a4 = false;
			yasakla_m4a1s = false;
			
			
			yasakSilahSor(param1);
		}

		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);
		}
	}
	return 0;
}

yasakSilahSor(client)
{
	new Handle:menu2 = CreateMenu(yasakSilahlarSor, MenuAction_Select | MenuAction_Cancel | MenuAction_End);
	SetMenuTitle(menu2, "Hangi Silahlar Yasak Olsun");

	AddMenuItem(menu2, "yasakliSilahlariOnayla", "Yasaklı Silahları Onayla");
	
	if(yasakla_negev)
		AddMenuItem(menu2, "negev", "[X] Negev");
	else
		AddMenuItem(menu2, "negev", "[ ] Negev");
	
	if(yasakla_scar20)
		AddMenuItem(menu2, "scar20", "[X] Scar20");
	else
		AddMenuItem(menu2, "scar20", "[ ] Scar20");
	
	if(yasakla_p90)
		AddMenuItem(menu2, "P90", "[X] P90");
	else
		AddMenuItem(menu2, "P90", "[ ] P90");
	
	if(yasakla_ak47)
		AddMenuItem(menu2, "ak47", "[X] AK47");
	else
		AddMenuItem(menu2, "ak47", "[ ] AK47");
	
	if(yasakla_awp)
		AddMenuItem(menu2, "awp", "[X] AWP");
	else
		AddMenuItem(menu2, "awp", "[ ] AWP");
	
	if(yasakla_m4a4)
		AddMenuItem(menu2, "m4a4", "[X] M4A4");
	else
		AddMenuItem(menu2, "m4a4", "[ ] M4A4");
	
	if(yasakla_m4a1s)
		AddMenuItem(menu2, "m4a1s", "[X] M4A1-S");
	else
		AddMenuItem(menu2, "m4a1s", "[ ] M4A1-S");


	DisplayMenu(menu2, client, MENU_TIME_FOREVER);
}

public yasakSilahlarSor(Handle:menu2, MenuAction:action, param1, param2)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu2, param2, item, sizeof(item));

			if (StrEqual(item, "yasakliSilahlariOnayla"))
			{
				ffAtilacak = true;
				komutZamani = GetTime();
				ServerCommand("sm_otorevac");
				ServerCommand("sm_god @ct 1");
				ServerCommand("sm_beacon @ct");
				PrintToChatAll(" \x02[%s] \x10%N \x01tarafından \x0EDost Ateşi \x06başlatılıyor.", sPluginTagi, param1);
				ServerCommand("sm_strip @t 12");
				for(new i=1;i<=MaxClients;i++)
				{
					if(!IsClientConnected(i)) continue;
					if(!IsClientInGame(i)) continue;
					if(!IsPlayerAlive(i)) continue;
					if(GetClientTeam(i) == 2)
						silahMenusu1(i);
				}
			}
			else
			{
				if (StrEqual(item, "negev"))
				{
					if(yasakla_negev)
						yasakla_negev = false;
					else
						yasakla_negev = true;
				}
				else if (StrEqual(item, "scar20"))
				{
					if(yasakla_scar20)
						yasakla_scar20 = false;
					else
						yasakla_scar20 = true;
				}
				else if (StrEqual(item, "P90"))
				{
					if(yasakla_p90)
						yasakla_p90 = false;
					else
						yasakla_p90 = true;
				}
				else if (StrEqual(item, "ak47"))
				{
					if(yasakla_ak47)
						yasakla_ak47 = false;
					else
						yasakla_ak47 = true;
				}
				else if (StrEqual(item, "awp"))
				{
					if(yasakla_awp)
						yasakla_awp = false;
					else
						yasakla_awp = true;
				}
				else if (StrEqual(item, "m4a4"))
				{
					if(yasakla_m4a4)
						yasakla_m4a4 = false;
					else
						yasakla_m4a4 = true;
				}
				else if (StrEqual(item, "m4a1s"))
				{
					if(yasakla_m4a1s)
						yasakla_m4a1s = false;
					else
						yasakla_m4a1s = true;
				}
				
				yasakSilahSor(param1);
			}
		}

		case MenuAction_Cancel:
		{
			//param1 is client, param2 is cancel reason (see MenuCancel types)
			if (param2 == MenuCancel_ExitBack)
			{
				//Code to return to parent menu

			}

		}

		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason

		}

	}
}

silahMenusu1(client)
{
	new Handle:menu3 = CreateMenu(istenenSilahSor1, MenuAction_Select | MenuAction_End);
	SetMenuTitle(menu3, "Hangi Silahı İstiyorsunuz");

	if(!yasakla_negev)
		AddMenuItem(menu3, "negev", "Negev");
	if(!yasakla_scar20)
		AddMenuItem(menu3, "scar20", "SCAR-20");
	if(!yasakla_p90)
		AddMenuItem(menu3, "p90", "P90");
	if(!yasakla_ak47)
		AddMenuItem(menu3, "ak47", "AK47");
	if(!yasakla_awp)
		AddMenuItem(menu3, "awp", "AWP");
	if(!yasakla_m4a4)
		AddMenuItem(menu3, "m4a4", "M4A4");
	if(!yasakla_m4a1s)
		AddMenuItem(menu3, "m4a1s", "M4A1-S");
	

	DisplayMenu(menu3, client, MENU_TIME_FOREVER);
}

public istenenSilahSor1(Handle:menu3, MenuAction:action, param1, param2)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item
			
			new String:item[64];
			GetMenuItem(menu3, param2, item, sizeof(item));
			
			if(ffAtilacak)
			{
				if (StrEqual(item, "negev"))
				{
					GivePlayerItem(param1, "weapon_negev");
				}
				else if (StrEqual(item, "scar20"))
				{
					GivePlayerItem(param1, "weapon_scar20");
				}
				else if (StrEqual(item, "p90"))
				{
					GivePlayerItem(param1, "weapon_p90");
				}
				else if (StrEqual(item, "ak47"))
				{
					GivePlayerItem(param1, "weapon_ak47");
				}
				else if (StrEqual(item, "awp"))
				{
					GivePlayerItem(param1, "weapon_awp");
				}
				else if (StrEqual(item, "m4a4"))
				{
					GivePlayerItem(param1, "weapon_m4a1");
				}
				else if (StrEqual(item, "m4a1s"))
				{
					GivePlayerItem(param1, "weapon_m4a1_silencer");
				}
				
				silahMenusu2(param1);
			}
			else
			{
				PrintToChat(param1, " \x02[%s] \x10Bu menüyü kullanmak için çok geç kaldınız :(", sPluginTagi);
			}
			
		}

		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason

		}
	}
}

silahMenusu2(client)
{
	new Handle:menu4 = CreateMenu(istenenSilahSor2, MenuAction_Select | MenuAction_End);
	SetMenuTitle(menu4, "Hangi Tabancayı İstiyorsunuz");

	AddMenuItem(menu4, "deagle", "Deagle");
	AddMenuItem(menu4, "tec9", "TEC-9");
	AddMenuItem(menu4, "fiveseven", "Five Seven");
	AddMenuItem(menu4, "p250", "P250");
	AddMenuItem(menu4, "usp", "USP-S");

	DisplayMenu(menu4, client, MENU_TIME_FOREVER);
}

public istenenSilahSor2(Handle:menu4, MenuAction:action, param1, param2)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item			
			
			new String:item[64];
			GetMenuItem(menu4, param2, item, sizeof(item));
			if(ffAtilacak)
			{
				if (StrEqual(item, "deagle"))
				{
					GivePlayerItem(param1, "weapon_deagle");
				}
				else if (StrEqual(item, "tec9"))
				{
					GivePlayerItem(param1, "weapon_tec9");
				}
				else if (StrEqual(item, "fiveseven"))
				{
					GivePlayerItem(param1, "weapon_fiveseven");
				}
				else if (StrEqual(item, "p250"))
				{
					GivePlayerItem(param1, "weapon_p250");
				}
				else if (StrEqual(item, "usp"))
				{
					GivePlayerItem(param1, "weapon_usp_silencer");
				}
			}
			else
			{
				PrintToChat(param1, " \x02[%s] \x10Bu menüyü kullanmak için çok geç kaldınız :(", sPluginTagi);
			}
		}

		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason

		}
	}
}

public Action:SurekliTimer(Handle timer)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(ffAtilacak)
	{
		if(kacSaniyeSonra - (GetTime() - komutZamani) > 0)
		{
			//PrintCenterTextAll("%d Saniye sonra FF açılacaktır!", kacSaniyeSonra - (GetTime() - komutZamani));
			PrintCenterTextAll("<b><font color='#FFFFFF'>Dost Ateşi</font> <font color='#00FF00'>%d</font> <font color='#FFFFFF'>saniye sonra açılacak!</font></b>", kacSaniyeSonra - (GetTime() - komutZamani));
			if((kacSaniyeSonra - (GetTime() - komutZamani)) <= 10)
				PrintToChatAll(" \x0BDost Ateşi \x04%i \x0Bsaniye sonra açılacak!", kacSaniyeSonra - (GetTime() - komutZamani));
			if((kacSaniyeSonra - (GetTime() - komutZamani)) == 10)
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
			else if(((kacSaniyeSonra - (GetTime() - komutZamani)) % 10) == 0)
				PrintToChatAll(" \x0BDost Ateşi \x04%i \x0Bsaniye sonra açılacak!", kacSaniyeSonra - (GetTime() - komutZamani));
		}
		else if(kacSaniyeSonra - (GetTime() - komutZamani) == 0)
		{
			ServerCommand("mp_teammates_are_enemies 1");
			//PrintCenterTextAll("<b><font color='#00FF00'>Dost Ateşi açılmıştır,</font> <font color='#FFFFFF'>Bol Şans!</font></b>");
			PrintCenterTextAll("<b><font color='#FF0000'>! ! !</font> <font color='#00FF00'>Dost Ateşi açılmıştır</font> <font color='#FF0000'>! ! !</font></b>");
			//PrintToChatAll(" \x02[DrK # GaminG] \x10Dost Ateşi açılmıştır, \x04Bol şans!");
			PrintToChatAll(" \x02[%s] \x0EDost Ateşi \x04açılmıştır.", sPluginTagi);
			ffAtilacak = false;
		}
	}
}