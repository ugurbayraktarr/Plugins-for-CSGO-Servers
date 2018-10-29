#include <sourcemod>
#define PLUGIN_VERSION "1.0"

public Plugin:myinfo = 
{
	name = "Para Ayarla",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = PLUGIN_VERSION
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
	
	HookEvent("round_start", RoundStart);
	
	CreateTimer(3.0, Cvarlar);
}

public OnMapStart()
{
	CreateTimer(3.0, Cvarlar);
}

public Action Cvarlar(Handle timer)
{
	ServerCommand("mp_playercashawards 0");
	ServerCommand("mp_teamcashawards 0");
	ServerCommand("mp_maxmoney 50000");
	ServerCommand("mp_startmoney 50000");	
}

public RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{	
	for(new i = 1; i <= MAXPLAYERS+1; i++)
	{
		if(IsValidClient(i)) 
		{
			SetEntProp(i, Prop_Send, "m_iAccount", 50000);
		}
	}
	
}

bool:IsValidClient( client ) 
{
    if ( !( 1 <= client <= MaxClients ) || !IsClientInGame(client) ) 
        return false; 
     
    return true; 
}