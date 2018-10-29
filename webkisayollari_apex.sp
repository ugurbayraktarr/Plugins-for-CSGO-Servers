#pragma semicolon 1

#include <sourcemod>
#include <cstrike>

public Plugin:myinfo = 
{
	name = "Web Kısayolları",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "2.0"
}

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
	
	RegConsoleCmd("sm_kurallar", WEB_Kurallar_Apex, "WEB KISAYOLU");
	RegConsoleCmd("sm_dante", WEB_Dante_Profil, "WEB KISAYOLU");
	RegConsoleCmd("sm_ts3", ts3ip, "Ts3 IP'sini gosterir");
	RegConsoleCmd("sm_yetki", WEB_Apex_Adminlik, "WEB KISAYOLU");
	RegConsoleCmd("sm_adminlik", WEB_Apex_Adminlik, "WEB KISAYOLU");
	RegConsoleCmd("sm_grup", WEB_Apex_Grup, "WEB KISAYOLU");
	RegConsoleCmd("sm_lrkural", WEB_Apex_LRKural, "WEB KISAYOLU");
	RegConsoleCmd("sm_toplanti", WEB_Apex_Toplanti, "WEB KISAYOLU");
	RegConsoleCmd("sm_komut", WEB_Apex_Komut, "WEB KISAYOLU");
	RegConsoleCmd("sm_error", ErrorCozum, "WEB KISAYOLU");
	RegConsoleCmd("sm_youtube", WEB_Apex_Youtube, "WEB KISAYOLU");
	RegConsoleCmd("sm_logo", WEB_Apex_Logo, "WEB KISAYOLU");
}

public Action:WEB_Kurallar_Apex(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/apex/apex_kurallar.html", MOTDPANEL_TYPE_URL);
}

public Action:WEB_Dante_Profil(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/apex/dante_profil.html", MOTDPANEL_TYPE_URL);
}

public Action:ts3ip(client, args)
{
	PrintToChat(client, " \x02TS3 Adresimiz: \x04185.124.85.101:2406");
}

public Action:WEB_Apex_Adminlik(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/apex/apex_adminlik.html", MOTDPANEL_TYPE_URL);
}

public Action:WEB_Apex_Grup(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/apex/apex_grup.html", MOTDPANEL_TYPE_URL);
}

public Action:WEB_Apex_LRKural(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/apex/apex_lrkural.html", MOTDPANEL_TYPE_URL);
}

public Action:WEB_Apex_Toplanti(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/apex/toplanti.html", MOTDPANEL_TYPE_URL);
}

public Action:WEB_Apex_Komut(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/apex/apex_komut.html", MOTDPANEL_TYPE_URL);
}

public Action:ErrorCozum(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/apex/apex_error.html", MOTDPANEL_TYPE_URL);
}

public Action:WEB_Apex_Youtube(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/apex/apex_youtube.html", MOTDPANEL_TYPE_URL);
}

public Action:WEB_Apex_Logo(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/apex/apex_logo.html", MOTDPANEL_TYPE_URL);
}