#pragma semicolon 1

#include <sourcemod>
#include <cstrike>

public Plugin:myinfo = 
{
	name = "Web Kısayolları",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "1.0"
}

public OnPluginStart()
{
	RegConsoleCmd("sm_grup", WEB_Grup, "WEB KISAYOLU");
	RegConsoleCmd("sm_adminlik", WEB_Adminlik, "WEB KISAYOLU");
	RegConsoleCmd("sm_google", WEB_Google, "WEB KISAYOLU");
	RegConsoleCmd("sm_youtube", WEB_Youtube, "WEB KISAYOLU");
	RegConsoleCmd("sm_modeller", WEB_Modeller, "WEB KISAYOLU");
	RegConsoleCmd("sm_komutlar", WEB_Komutlar, "WEB KISAYOLU");
	RegConsoleCmd("sm_kurallar", WEB_Kurallar, "WEB KISAYOLU");	
}

public Action:WEB_Grup(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/grup.html", MOTDPANEL_TYPE_URL);
}

public Action:WEB_Adminlik(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/adminlik.html", MOTDPANEL_TYPE_URL);
}

public Action:WEB_Google(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/google.html", MOTDPANEL_TYPE_URL);
}

public Action:WEB_Youtube(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/youtube.html", MOTDPANEL_TYPE_URL);
}

public Action:WEB_Modeller(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/modeller.html", MOTDPANEL_TYPE_URL);
}

public Action:WEB_Komutlar(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/komutlar.html", MOTDPANEL_TYPE_URL);
}

public Action:WEB_Kurallar(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/kurallar.html", MOTDPANEL_TYPE_URL);
}
