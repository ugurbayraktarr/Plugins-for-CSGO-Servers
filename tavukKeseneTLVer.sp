#pragma semicolon 1
#include <sourcemod>
#include <sdktools> 
#include <sdkhooks>
#include <store>

public Plugin:myinfo = 
{ 
    name        = "Tavuk Kesen T'Ye TL Verme", 
    author      = "ImPossibLe`", 
    description = "DrK # GaminG", 
    version     = "1.1", 
}; 

new Handle:g_PluginTagi = INVALID_HANDLE;
new sonKesis[MAXPLAYERS+1];
new tavukKatla = 1;

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
	
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	
	if(!((StrContains(mapName, "jb_", false) != -1) || (StrContains(mapName, "jail_", false)!= -1)))
	{
		SetFailState("Bu plugin sadece jail maplarinda calismaktadir..");
	}
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");

	RegAdminCmd("sm_tavukkatla", TavukKatlaKomutu, ADMFLAG_ROOT, "Tavuk Bonusunu Girdiğiniz Miktar Kadar Katlar");
}

public Action:TavukKatlaKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	if(args==1)
	{
		decl String:sKatla[16];
		GetCmdArg(1, sKatla, sizeof(sKatla));
		new katla = StringToInt(sKatla);
		tavukKatla = katla;
		PrintToChatAll(" \x02[%s] \x04%N \x10tarafından tavuk kesme bonusu \x0E%d katına \x10çıkarıldı.", sPluginTagi, client, katla);
		return Plugin_Continue;
	}
	else
	{
		tavukKatla = 1;
		return Plugin_Handled;
	}
}

public OnMapStart()
{
	tavukKatla = 1;
}

public OnEntityCreated(entity) 
{ 
    if(IsValidEntity(entity)) 
    { 
        new String: classname[32]; 
        GetEntityClassname(entity, classname, sizeof(classname)); 
        if(StrEqual(classname, "chicken")) 
        {
			HookSingleEntityOutput(entity, "OnBreak", OnBreak); 
        } 
    } 
} 

public OnBreak(const String: output[], caller, activator, Float: delay) 
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(GetClientTeam(activator) == 2)
	{
		if(sonKesis[activator] + 30 <= GetTime())
		{
			new i, TSay;
			for(i=1;i<=MaxClients;i++)
			{
				if(!IsClientConnected(i)) continue;
				if(!IsClientInGame(i)) continue;
				if(GetClientTeam(i) == 2)
					TSay++;
			}
			
			new kazanilanMiktar = TSay * 2 * tavukKatla;
			
			PrintToChatAll(" \x02[%s] \x10%N \x04bir tavuk kestiği için \x0E%d TL \x04kazandı.", sPluginTagi, activator, kazanilanMiktar);
			TLVer(activator, kazanilanMiktar);
			sonKesis[activator] = GetTime();
		}
		else
		{
			PrintToChat(activator, " \x02[%s] \x0Eher 30 saniyede \x10sadece 1 kez tavuk kesme parası alabilirsiniz.", sPluginTagi);
		}
	}
}

TLVer(int client, int kazanma)
{
	Store_SetClientCredits(client, (Store_GetClientCredits(client) + kazanma));
}