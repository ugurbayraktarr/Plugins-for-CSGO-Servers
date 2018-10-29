#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Mesaj Okutma",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

public OnPluginStart() 
{
	RegAdminCmd("sm_oku", OkuKomutu, ADMFLAG_RCON, "sm_oku <metin>");
}


public Action:OkuKomutu(client, args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[DrK # GaminG] Kullanım: sm_oku <mesaj>");
		return Plugin_Handled;
	}
	char text[192];
	GetCmdArgString(text, 192);
	
	char URL[512];
	Format(URL, 512, "http://cs.center/csctts.php?oku=%s", text);
	int i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			ShowHiddenMOTDPanel(i, URL, MOTDPANEL_TYPE_URL);
		}
		i++;
	}
	PrintToChat(client, "Okunan: %s", text);

	return Plugin_Continue;
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