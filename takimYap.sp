#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
//#include <CustomPlayerSkins>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Özel Takım Yapıcı",
	author      = "ImPossibLe`",
	description = "PROOYUNCU",
	version     = PLUGIN_VERSION,
};

static int oyuncuTakimDurumu[MAXPLAYERS + 1];
bool TakimYapildi = false;
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
	if(StrEqual(serverip, "185.188.144") == false || ips[3] < 2 || ips[3] > 129)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
	
	RegAdminCmd("sm_takimyap", CommandGlow, ADMFLAG_GENERIC, "Yaşayan T'leri 2 takıma ayırarak glow verir.");
	RegAdminCmd("sm_takimboz", CommandTakimKapat, ADMFLAG_GENERIC, "Takımları iptal eder.");
	RegAdminCmd("sm_slaymavi", SlayMaviKomutu, ADMFLAG_GENERIC, "Mavi takımı öldürür.");
	RegAdminCmd("sm_slaykirmizi", SlayKirmiziKomutu, ADMFLAG_GENERIC, "Kırmızı takımı öldürür.");
	HookEvent("round_end", Event_Round_End);
	TakimYapildi = false;
}

public OnClientPostAdminCheck(iClient) 
{ 
    SDKHook(iClient, SDKHook_OnTakeDamage, OnTakeDamage); 
}

public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype) 
{
	if(TakimYapildi)
	{
		new iAttacker;
		if(attacker>64)
			iAttacker = GetClientOfUserId(attacker);
		else
			iAttacker = attacker;
		
		if(iAttacker > 0)
		{
			if(oyuncuTakimDurumu[victim] == oyuncuTakimDurumu[iAttacker])
			{
				damage = 0.0;
				return Plugin_Changed;
			}
		}
	}
	return Plugin_Continue;
}





public Action:Event_Round_End(Handle:event, const String:name[], bool:dontBroadcast)
{
	TakimKapat();
}

public Action:CommandTakimKapat(client, args)
{
	TakimKapat();
}

void TakimKapat()
{
	new i;
	TakimYapildi = false;
	for(i=1; i<=MaxClients; i++)
	{
		oyuncuTakimDurumu[i] = 0;
		if(!IsClientConnected(i)) continue;
		if(!IsClientInGame(i)) continue;
		if(GetClientTeam(i) <= 1) continue;
		if(IsPlayerAlive(i))
		{
			SetEntityRenderColor(i, 255, 255, 255, 255);
		}
	}
}

public Action:SlayKirmiziKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));

	if(args != 0)
	{
		PrintToChat(client, " \x02[%s] \x10Kullanım: \x04!slaymavi", sPluginTagi);
		return Plugin_Handled;
	}
	new i, oldurulenSayisi;
	for(i=1; i<=MaxClients; i++)
	{
		if(!IsClientConnected(i)) continue;
		if(!IsClientInGame(i)) continue;
		if(GetClientTeam(i) <= 1) continue;
		if(IsPlayerAlive(i))
		{
			if(oyuncuTakimDurumu[i] == 1)
			{
				ForcePlayerSuicide(i);
				oldurulenSayisi++;
			}
		}
	}
	if(oldurulenSayisi > 0)
		PrintToChatAll(" \x02[%s] \x04Kırmızı Takım Öldürüldü!", sPluginTagi);
	else
		PrintToChatAll(" \x02[%s] \x04Kırmızı takımda yaşayan oyuncu bulunamadı.", sPluginTagi);
	return Plugin_Continue;
}

public Action:SlayMaviKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));

	if(args != 0)
	{
		PrintToChat(client, " \x02[%s] \x10Kullanım: \x04!slaymavi", sPluginTagi);
		return Plugin_Handled;
	}
	new i, oldurulenSayisi;
	for(i=1; i<=MaxClients; i++)
	{
		if(!IsClientConnected(i)) continue;
		if(!IsClientInGame(i)) continue;
		if(GetClientTeam(i) <= 1) continue;
		if(IsPlayerAlive(i))
		{
			if(oyuncuTakimDurumu[i] == 2)
			{
				ForcePlayerSuicide(i);
				oldurulenSayisi++;
			}
		}
	}
	if(oldurulenSayisi > 0)
		PrintToChatAll(" \x02[%s] \x04Mavi Takım Öldürüldü!", sPluginTagi);
	else
		PrintToChatAll(" \x02[%s] \x04Mavi takımda yaşayan oyuncu bulunamadı.", sPluginTagi);
		
	return Plugin_Continue;
}

public Action:CommandGlow(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));

	if(args != 0)
	{
		PrintToChat(client, " \x02[%s] \x10Kullanım: \x04!takimboz", sPluginTagi);
		return Plugin_Handled;
	}
	
	new yasayanTSayisi, i, takimNumarasi[MaxClients];
	for(i=1;i<=MaxClients;i++)
	{
		oyuncuTakimDurumu[i] = 0;
		if(IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
		{
			if(GetClientTeam(i) == 2 && IsPlayerAlive(i))
				yasayanTSayisi++;
		}
	}
	if((yasayanTSayisi % 2) != 0)
	{
		PrintToChat(client, " \x02[%s] \x10Bu komutu kullanabilmek için yaşayan T sayısı \x04çift sayıda \x10olmalıdır.", sPluginTagi);
		return Plugin_Handled;
	}
	new j;
	for(i=1;i<=MaxClients;i++)
	{
		if(IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
		{
			if(GetClientTeam(i) == 2 && IsPlayerAlive(i))
			{
				takimNumarasi[i] = (j % 2) + 1;
				oyuncuTakimDurumu[i] = (j % 2) + 1;
				j++;
			}
		}
	}
	
	PrintToChatAll(" ");
	for(i=1;i<=MaxClients;i++)
	{
		if(IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
		{
			if(GetClientTeam(i) == 2 && IsPlayerAlive(i))
			{
				if(takimNumarasi[i] == 1)
				{
					SetEntityRenderColor(i, 255, 0, 0, 255);
					PrintCenterText(i, "<font color='#00FFFF'>Renginiz:</font>\n<font color='#FF0000'>!! KIRMIZI !!");
					PrintToChatAll(" \x07%N \x02!! KIRMIZI !!", i);
				}
				else if(takimNumarasi[i] == 2)
				{
					SetEntityRenderColor(i, 0, 0, 255, 255);
					PrintCenterText(i, "<font color='#00FFFF'>Renginiz:</font>\n<font color='#00FF00'>!! MAVİ !!");
					PrintToChatAll(" \x0B%N \x0C!! MAVİ !!", i);
				}
			}
		}
	}
	PrintToChatAll(" ");
	for(i=1;i<=MaxClients;i++)
	{
		if(IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
		{
			if(GetClientTeam(i) == 2 && IsPlayerAlive(i))
			{
				if(takimNumarasi[i] == 1)
					PrintToChat(i, " \x02[%s] \x04Sizin Renginiz: \x02!! KIRMIZI !!", sPluginTagi);
					
				else if(takimNumarasi[i] == 2)
					PrintToChat(i, " \x02[%s] \x04Sizin Renginiz: \x0C!! MAVİ !!", sPluginTagi);
			}
		}
	}
	PrintToChatAll(" ");
	TakimYapildi = true;
	return Plugin_Continue;
}