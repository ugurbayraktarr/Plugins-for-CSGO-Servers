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
	int ips[4];
	char serverip[32];
	int ip = GetConVarInt(FindConVar("hostip"));
	int port = GetConVarInt(FindConVar("hostport"));
	ips[0] = (ip >> 24) & 0x000000FF;
	ips[1] = (ip >> 16) & 0x000000FF;
	ips[2] = (ip >> 8) & 0x000000FF;
	ips[3] = ip & 0x000000FF;
	
	Format(serverip, sizeof(serverip), "%d.%d.%d.%d:%d", ips[0], ips[1], ips[2], ips[3],port);
	if(StrEqual(serverip, "95.173.166.53:27015") == false)
	{
		LogError("Bu plugin ImPossibLe` tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	
	RegConsoleCmd("sm_ts", ts3ip, "Ts3 IP'sini gosterir");
	RegConsoleCmd("sm_ts3", ts3ip, "Ts3 IP'sini gosterir");
	RegConsoleCmd("sm_ip", ServerIp, "Serverın IP'sini gosterir");
	RegConsoleCmd("sm_svip", ServerIp, "Serverın IP'sini gosterir");
	RegConsoleCmd("sm_swip", ServerIp, "Serverın IP'sini gosterir");
	/*RegConsoleCmd("sm_kural", WEB_Kurallar_Phantom, "WEB KISAYOLU");
	RegConsoleCmd("sm_yetki", WEB_Phantom_Yetki, "WEB KISAYOLU");
	RegConsoleCmd("sm_yetkili", WEB_Phantom_Yetkili, "WEB KISAYOLU");
	RegConsoleCmd("sm_grup", WEB_Phantom_Grup, "WEB KISAYOLU");*/
}

public Action:ts3ip(client, args)
{
	PrintToChat(client, " \x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-");
	PrintToChat(client, " \x02TS3 Adresimiz: \x04ts.drk-gaming.net:3131");
	PrintToChat(client, " \x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-");
}

public Action:ServerIp(client, args)
{
	PrintToChat(client, " \x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-");
	PrintToChat(client, " \x02IP Adresimiz: \x04ph.drk-gaming.net \x02 ~ \x1095.173.166.53");
	PrintToChat(client, " \x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-\x02-\x04-");
}

public Action:WEB_Kurallar_Phantom(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/phantom/phantom_kural.html", MOTDPANEL_TYPE_URL);
}

public Action:WEB_Phantom_Yetki(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/phantom/phantom_yetki.html", MOTDPANEL_TYPE_URL);
}

public Action:WEB_Phantom_Yetkili(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/phantom/phantom_yetkili.html", MOTDPANEL_TYPE_URL);
}

public Action:WEB_Phantom_Grup(client, args)
{
	ShowMOTDPanel(client, "TEST", "http://drk-gaming.net/oyunicihtml/phantom/phantom_grup.html", MOTDPANEL_TYPE_URL);
}