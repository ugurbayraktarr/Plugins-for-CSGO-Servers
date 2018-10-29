#include <sourcemod>
#include <cstrike>

public Plugin myinfo =
{
	name = "HUD",
	author = "ImPossibLe`",
	description = "",
	version = ""
};

bool mesajGosterim[MAXPLAYERS+1];

public OnPluginStart()
{
	RegConsoleCmd("sm_fav", FavoriMesaji, "Favori hatirlatma mesajini kapatir.");
	CreateTimer(5.0, HUD, _, TIMER_REPEAT);
	for (new i = 1; i <= MaxClients; i++)
	{
		mesajGosterim[i] = true;
	}
}

public Action:FavoriMesaji(client, args)
{
	if(mesajGosterim[client] == true)
	{
		mesajGosterim[client] = false;
		PrintToChat(client, " \x02[DrK # GaminG] \x04Favori hatırlatma mesajı kapatılıyor.")
	}
}

public OnClientDisconnect(client)
{
	mesajGosterim[client] = true;
}

public Action HUD(Handle timer)
{
	for (new i = 1; i <= MaxClients; i++)
	{
		if (IsClientInGame(i))
		{
			SetHudTextParams(-1.0, 0.04, 5.0, 150, 2, 31, 150, 1, 0.1, 0.1, 0.1);
			if(mesajGosterim[i])
				ShowHudText(i, 5, "Serverı favorilerde göremeyenler listeyi yenilesinler..\nDrK # GaminG, iyi eğlenceler diler..\nNot: Bu mesajı !fav yazarak kapatabilirsiniz.");
		}
	}
}