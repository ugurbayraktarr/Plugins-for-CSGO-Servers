#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define pi 3.141592

static int yapildi = 1;
static int yapilacak = 0;
static int zaman;
static int iYapan;

public Plugin:myinfo =
{
	name = "Daire Yapıcı",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "1.0",
};

new Handle:g_PluginTagi = INVALID_HANDLE;
 
//Plugin-Start
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

	RegAdminCmd("sm_daire", Command_Daire, ADMFLAG_GENERIC, "T'lerden olusan bir daire yapar");
}

public Action:Command_Daire(client,args)
{
    //Error:
	if(args < 0)
	{
		PrintToConsole(client, "Kullanım: !daire");
		PrintToChat(client, " \x02Kullanım:\x04 !daire");
		return Plugin_Handled;
	}
	zaman = GetTime();
	yapilacak = 1;
	yapildi = 0;
	iYapan = client;
	return Plugin_Continue;
}

public OnGameFrame()
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(yapilacak == 1)
	{
		PrintCenterTextAll("<b><font color='#FF0000'>[%s]<font> <font color='#00FF00'>%d saniye</font> <font color='#00FFFF'>sonra daire yapılacaktır.</font></b>", sPluginTagi, (zaman + 5 - GetTime()));
		int i;
		float org[3];
		org[0] = 0.0;
		org[1] = 0.0;
		org[2] = 0.0;
		for(i=1;i<=MaxClients;i++)
		{
			if(IsClientInGame(i) && (IsPlayerAlive(i)) && GetClientTeam(i) == 2)
			{
				SetEntProp(i, Prop_Send, "movetype", 0, 1);
				TeleportEntity(i,NULL_VECTOR,NULL_VECTOR, org);
			}
		}
	}
	if(yapildi == 0 && GetTime() == zaman + 5)
	{
		new Float:ClientOrigin[3];
		new Float:TeleportOrigin[3];
		GetClientAbsOrigin(iYapan, ClientOrigin);
		
		int yasayanTSayisi = 0;
		for(new i=1; i<=64; i++)
		{
			if(!IsClientConnected(i)) continue;
			if(!IsClientInGame(i)) continue;
			if(GetClientTeam(i) != 2) continue;
			if(IsPlayerAlive(i)) yasayanTSayisi++;
		}
		
		int k = 1;
		
		for(new i=1; i<=64; i++)
		{
			if(!IsClientConnected(i)) continue;
			if(!IsClientInGame(i)) continue;
			if(GetClientTeam(i) != 2) continue;
			if(!IsPlayerAlive(i)) continue;
			SetEntProp(i, Prop_Send, "movetype", 0, 1);
			float a = ((pi * 2 * k / yasayanTSayisi));
			float b = ((pi * 2 * k / yasayanTSayisi));
			float x = Sine(a);
			float y = Cosine(b);
			k++;
			
			TeleportOrigin[0] = ClientOrigin[0] + x * 400;
			TeleportOrigin[1] = ClientOrigin[1] + y * 400;
			TeleportOrigin[2] = (ClientOrigin[2]);
			
			TeleportEntity(i, TeleportOrigin, NULL_VECTOR, NULL_VECTOR);
		}
		
		decl String:cekenIsim[32];
		GetClientName(iYapan, cekenIsim, sizeof(cekenIsim));
		
		//CPrintToChatAll(" \x02[DrK # GaminG] \x02Daire test.");
		PrintToChatAll(" \x02[%s] \x10%s \x09, T'lerden \x0Edaire oluşturdu..", sPluginTagi, cekenIsim);
		
		ServerCommand("sm_freeze @t -1");
		yapildi = 1;
		yapilacak = 0;
		PrintCenterTextAll("<b><font color='#FF0000'>! ! !</font> <font color='#00FF00'>Daire yapılmıştır</font> <font color='#FF0000'>! ! !</font></b>");
	}
}