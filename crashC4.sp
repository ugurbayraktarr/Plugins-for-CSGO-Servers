#include <sourcemod>
#include <cstrike>
#include <sdktools>

#pragma semicolon 1

public Plugin:myinfo = 
{
	name = "Crash C4 Fix",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "1.0"
}

bool c4verilecek = false;

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
	
	HookEvent("round_start", Event_Round_Start);
	HookEvent("round_end", Event_Round_Start);
}

public Action:CS_OnCSWeaponDrop(client, weaponIndex)
{
	new String:sWeapon[32];
	GetEdictClassname(weaponIndex, sWeapon, sizeof(sWeapon));
	
	if(StrEqual(sWeapon, "weapon_c4"))
	{
		PrintToChatAll(" \x02[DrK # GaminG] \x0EC4 Yere düştü.");
		PrintToChatAll(" \x075 Saniye sonra rastgele bir T'ye c4 verilecek.");
		c4verilecek = true;
		CreateTimer(5.0, c4ver);
	}
}  

public Action c4ver(Handle timer)
{
	if(c4verilecek)
	{
		new tSay = 0;
		for(new i=1;i<=MaxClients;i++)
		{
			if(!IsClientConnected(i)) continue;
			if(!IsClientInGame(i)) continue;
			if(!IsPlayerAlive(i)) continue;
			if(GetClientTeam(i) != 2) continue;
			tSay++;
		}
		if(tSay > 0)
			RandomC4Ver();
	}
}

public Action:Event_Round_Start(Handle:event, const String:name[], bool:dontBroadcast) 
{
	c4verilecek = false;
}

void RandomC4Ver()
{
	new randomSayi = GetRandomInt(1,64);
	
	if(!(IsClientConnected(randomSayi)) || !(IsClientInGame(randomSayi)) || !(IsPlayerAlive(randomSayi)) || (GetClientTeam(randomSayi) != 2))
	{
		RandomC4Ver();
	}
	else
	{
		PrintToChatAll(" \x02[DrK # GaminG] \x10%N \x07isimli oyuncuya \x0EC4 verildi.", randomSayi);
		GivePlayerItem(randomSayi, "weapon_c4");
	}
}