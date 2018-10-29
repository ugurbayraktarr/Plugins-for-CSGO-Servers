#include <sourcemod>
#include <sdktools>
#include <cstrike>
#pragma semicolon 1 

public Plugin:myinfo = 
{ 
    name        = "Anında Takım Eşitleme Sistemi", 
    author      = "ImPossibLe`", 
    description = "DrK # GaminG", 
    version     = "2.0", 
}; 

new Handle:g_PluginTagi = INVALID_HANDLE;

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
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");

	HookEvent( "round_end", Event_RoundEnd, EventHookMode);
} 

public Event_RoundEnd(Handle:event, const String:name[], bool:dontBroadcast)
{
	new Float:zamanlama;
	new iZamanlama;
	new String:sZamanlama[10];
	iZamanlama = GetConVarInt(FindConVar("mp_round_restart_delay"));
	IntToString(iZamanlama, sZamanlama, sizeof(sZamanlama));
	zamanlama = StringToFloat(sZamanlama);
	
	//zamanlama = GetConVarFloat("mp_round_restart_delay");
	
	zamanlama -= 0.499999;
	CreateTimer(zamanlama, TakimlariEsitle);
}

public Action TakimlariEsitle(Handle timer)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	bool esitlendi;
	if(TakimdakiOyunculariSay(2) >= 2 && TakimdakiOyunculariSay(3) >= 2)
	{
		//PrintToChatAll("Test1");
		new k;
		new aradakiFark;
		if(TakimdakiOyunculariSay(2) >= TakimdakiOyunculariSay(3))
			aradakiFark = (TakimdakiOyunculariSay(2) - TakimdakiOyunculariSay(3));
		else
			aradakiFark = (TakimdakiOyunculariSay(3) - TakimdakiOyunculariSay(2));
		//PrintToChatAll("Test2");
		//PrintToChatAll("[TEST] Fark: %d", aradakiFark);
		if(aradakiFark % 2 == 1)
			aradakiFark--;
		//PrintToChatAll("[TEST2] Fark: %d", aradakiFark);
		for(k=0; k<aradakiFark; k+=2)
		{
			//PrintToChatAll("Test3");
			if(TakimdakiOyunculariSay(2) - TakimdakiOyunculariSay(3) > 1 || TakimdakiOyunculariSay(2) - TakimdakiOyunculariSay(3) < -1)
			{
				//PrintToChatAll("Test4");
				new cokOlanTakim;
				new takimdakiClientler[MaxClients];
				if(TakimdakiOyunculariSay(3) > TakimdakiOyunculariSay(2))
					cokOlanTakim = 3;
				else
					cokOlanTakim = 2;
				new i, j = 0;
				for(i=1;i<=MaxClients;i++)
				{
					if(IsClientInGame(i) && !IsFakeClient(i))
					{
						if(GetClientTeam(i) == cokOlanTakim)
						{
							takimdakiClientler[j] = i;
							j++;
						}
					}
				}
				j -= 1;
				//for(i=1;i<=MaxClients;i++)
				//PrintToChatAll("Test5");
				new random	= GetRandomInt(0, j);
				//PrintToChatAll("TEST: j: %d ~ Random: %d ~ Client: %d", j, random, takimdakiClientler[random]);
				if(cokOlanTakim == 2)
				{
					CS_SwitchTeam(takimdakiClientler[random], 3);
					CS_UpdateClientModel(takimdakiClientler[random]);
					PrintToChatAll(" \x02[%s] \x0CTakım eşitlemesi için \x10%N \x0CCT'ye atıldı.", sPluginTagi, takimdakiClientler[random]);
				}
				else
				{
					CS_SwitchTeam(takimdakiClientler[random], 2);
					CS_UpdateClientModel(takimdakiClientler[random]);
					PrintToChatAll(" \x02[%s] \x0CTakım eşitlemesi için \x10%N \x0CT'ye atıldı.", sPluginTagi, takimdakiClientler[random]);
				}
				esitlendi = true;
			}
		}
	}
	if(esitlendi)
		PrintToChatAll(" \x02[%s] \x10Takımlar eşitlenmiştir.", sPluginTagi);
}

public int TakimdakiOyunculariSay(takim)
{
	new i;
	new toplam = 0;
	for(i=1;i<=MaxClients; i++)
	{
		if(IsClientConnected(i))
			if(IsClientInGame(i))
				if(GetClientTeam(i) == takim)
					toplam++;
	}
	return toplam;
}