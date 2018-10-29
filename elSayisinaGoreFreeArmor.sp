#include <sourcemod> 
#include <sdktools> 
#pragma semicolon 1 

public Plugin:myinfo = 
{ 
    name        = "El Sayısına Göre FreeArmor Ayarlayıcı", 
    author      = "ImPossibLe`", 
    description = "DrK # GaminG", 
    version     = "1.0", 
}; 

new Handle:g_PluginTagi = INVALID_HANDLE;

Handle g_hFreeArmorElSayisi;

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
	if(StrEqual(serverip, "185.193.165") == false && ips[3] != 166)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	g_hFreeArmorElSayisi = CreateConVar("drk_freearmor_elsayisi", "2", "Kaçıncı elde sistem açılsın?");
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");	
	
	HookEvent("round_end", RoundEnd, EventHookMode_Post);
} 

public Action:RoundEnd(Handle: event , const String: name[] , bool: dontBroadcast)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	new Handle:g_hCvarFreeArmor = INVALID_HANDLE;
	new bFreeArmor;
	new iElSayisi = GetConVarInt(g_hFreeArmorElSayisi);
	g_hCvarFreeArmor = FindConVar("mp_free_armor");

	if (g_hCvarFreeArmor != INVALID_HANDLE)
	{
		bFreeArmor = GetConVarInt(g_hCvarFreeArmor);
	}
	
	if(((GetTeamScore(2) + GetTeamScore(3)) >= iElSayisi && ((GetTeamScore(2) + GetTeamScore(3)) % 15 != 0) && ((GetTeamScore(2) + GetTeamScore(3)) % 15 != 1)))
	{
		if(bFreeArmor == 0 || bFreeArmor == 1)
		{
			PrintCenterTextAll("<font color='#FF0000'>%s</font>\n<font color='#00FF00'>Free Armor</font> <font color='#00FFFF'>açılmıştır.</font>", sPluginTagi);
			//PrintToChatAll(" \x04[DrK # GaminG] \x02Free Armor açılmıştır..");
			ServerCommand("mp_free_armor 2");
		}
	}
	else
	{
		if(bFreeArmor == 2)
		{
			PrintCenterTextAll("<font color='#FF0000'>%s</font>\n<font color='#00FF00'>Free Armor</font> <font color='#0000FF'>kapatılmıştır.</font>", sPluginTagi);
			//PrintToChatAll(" \x04[DrK # GaminG] \x02Free Armor kapatılmıştır..");
			ServerCommand("mp_free_armor 0");
		}
	}
}