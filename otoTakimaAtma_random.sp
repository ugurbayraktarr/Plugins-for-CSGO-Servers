#pragma semicolon 1
#include <sourcemod>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Otomatik Takima Atma Sistemi",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

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
	
	CreateTimer(7.0, AyarYap);
}

public Action AyarYap(Handle timer)
{
	ServerCommand("mp_force_pick_time 1");
}


public OnClientPutInServer(client)
{
	CreateTimer(2.0, TakimaAt, client);
}

public Action TakimaAt(Handle timer, int client)
{
	new tSayisi, ctSayisi, i;
	for(i=1;i<=MaxClients;i++)
	{
		if(IsClientConnected(i))
		{
			if(IsClientInGame(i))
			{
				if(GetClientTeam(i) == 2)
					tSayisi++;
				else if(GetClientTeam(i) == 3)
					ctSayisi++;
			}
		}
	}
	if(ctSayisi < tSayisi)
		ChangeClientTeam(client, 3);
	else
		ChangeClientTeam(client, 2);
}
