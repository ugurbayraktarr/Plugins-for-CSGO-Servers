#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "Adminleri Otomatik Yenileme",
	description = "DrK # GaminG",
	author = "ImPossibLe`",
	version = "1.0"
};

public void OnPluginStart()
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
	CreateTimer(5.0, Timer, _, TIMER_REPEAT);
}

	
 
public Action Timer(Handle timer)
{
	ServerCommand("sm_reloadadmins");
	ServerCommand("sm_reloadcc");
	
	return Plugin_Continue;
}
