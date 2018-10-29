#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <colors>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Çekiliş Sistemi",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
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
	if(StrEqual(serverip, "185.188.144") == false || ips[3] < 2 || ips[3] > 129)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
	
	RegAdminCmd("sm_cek", Command_Cekilis, ADMFLAG_GENERIC);
	RegAdminCmd("sm_ycek", Command_YCekilis, ADMFLAG_GENERIC);
	RegAdminCmd("sm_olucek", Command_OLUCekilis, ADMFLAG_GENERIC);
}

/*public Action:Command_Cekilis(client, args)
{
	decl String:yapanIsim[32];
	decl String:sonucIsim[32];
	int oyuncuSayisi = 0;
	int rastgele;
	GetClientName(client, yapanIsim, sizeof(yapanIsim));
	
	if(args != 0)
	{
		PrintToChat(client, " \x02[DrK # GaminG] \x04Hatalı giriş yaptınız. Kullanım: \x03!cekilis");
	}
	
	else
	{
		do
		{
			new i;
			for(i = 1; i<=64; i++)
			{
				if(IsClientInGame(i))
					oyuncuSayisi++;
			}
			rastgele = GetRandomInt(1, oyuncuSayisi);
		}
		while(!IsClientInGame(rastgele));
		GetClientName(rastgele, sonucIsim, sizeof(sonucIsim));
		PrintToChatAll(" \x02[DrK # GaminG] \x04%s \x03çekiliş yaptı.", yapanIsim);
		PrintToChatAll(" \x02[DrK # GaminG] \x03Çekilişten çıkan oyuncu: \x04%s", sonucIsim);
	}
}

public Action:Command_YCekilis(client, args)
{
	decl String:yapanIsim[32];
	decl String:sonucIsim[32];
	int oyuncuSayisi = 0;
	int rastgele = -1;
	GetClientName(client, yapanIsim, sizeof(yapanIsim));
	int yasama[1000] = {0, 0, 0, ...};
	
	if(args != 0)
	{
		PrintToChat(client, " \x02[DrK # GaminG] \x04Hatalı giriş yaptınız. Kullanım: \x03!cekilis");
	}
	
	else
	{
		do
		{
			do
			{
				new i;
				for(i = 1; i<=64; i++)
				{
					if(IsClientInGame(i))
					{
						oyuncuSayisi++;
						if(IsPlayerAlive(i))
							yasama[i] = 1;
						else
							yasama[i] = 0;
					}
				}
				
				rastgele = GetRandomInt(1, oyuncuSayisi);
			}
			while(!IsClientInGame(rastgele));
		}
		while(yasama[rastgele] == 0);
		
		GetClientName(rastgele, sonucIsim, sizeof(sonucIsim));
		PrintToChatAll(" \x02[DrK # GaminG] \x04%s \x03yaşayanlar arasından çekiliş yaptı.", yapanIsim);
		PrintToChatAll(" \x02[DrK # GaminG] \x03Çekilişten çıkan oyuncu: \x04%s", sonucIsim);
	}
}*/

public Action:Command_Cekilis(client, args)
{
	int cikan = RandomVer();
	
	decl String:yapanIsim[32];
	decl String:sonucIsim[32];
	GetClientName(client, yapanIsim, sizeof(yapanIsim));
	GetClientName(cikan, sonucIsim, sizeof(sonucIsim));
	
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	PrintToChatAll(" \x02[%s] \x04%s \x03çekiliş yaptı.", sPluginTagi, yapanIsim);
	PrintToChatAll(" \x02[%s] \x03Çekilişten çıkan oyuncu: \x04%s", sPluginTagi, sonucIsim);
	return Plugin_Continue;
}
public Action:Command_YCekilis(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	int iYasayan = 0;
	for(new i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
			if(IsPlayerAlive(i))
				iYasayan++;
	}
	if(iYasayan < 1)
	{
		PrintToChatAll(" \x02[%s] \x04Yaşayan oyuncu bulunamadı!", sPluginTagi);
		return Plugin_Handled;
	}
	
	else
	{
		int cikan = RandomVer();
		while(!IsPlayerAlive(cikan))
			cikan = RandomVer();
		
		decl String:yapanIsim[32];
		decl String:sonucIsim[32];
		GetClientName(client, yapanIsim, sizeof(yapanIsim));
		GetClientName(cikan, sonucIsim, sizeof(sonucIsim));
		
		PrintToChatAll(" \x02[%s] \x04%s \x03yaşayanlar arasında çekiliş yaptı.", sPluginTagi, yapanIsim);
		PrintToChatAll(" \x02[%s] \x03Çekilişten çıkan oyuncu: \x04%s", sPluginTagi, sonucIsim);
		return Plugin_Continue;
	}
}
public Action:Command_OLUCekilis(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	int iOlu = 0;
	for(new i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i))
			if(!IsPlayerAlive(i))
				iOlu++;
	}
	if(iOlu == 0)
	{
		PrintToChatAll(" \x02[%s] \x04Ölü oyuncu bulunamadı!", sPluginTagi);
		return Plugin_Handled;
	}
	else
	{
		int cikan = RandomVer();
		while(IsPlayerAlive(cikan))
			cikan = RandomVer();
		
		decl String:yapanIsim[32];
		decl String:sonucIsim[32];
		GetClientName(client, yapanIsim, sizeof(yapanIsim));
		GetClientName(cikan, sonucIsim, sizeof(sonucIsim));
		
		PrintToChatAll(" \x02[%s] \x04%s \x03ölüler arasında çekiliş yaptı.", sPluginTagi, yapanIsim);
		PrintToChatAll(" \x02[%s] \x03Çekilişten çıkan oyuncu: \x04%s", sPluginTagi, sonucIsim);
		return Plugin_Continue;
	}
}


RandomVer()
{
	new clients[MaxClients+1], clientCount;
	for (new i = 1; i <= MaxClients; i++)
	if (IsClientInGame(i) && (GetClientTeam(i) > 1))
		clients[clientCount++] = i;
	return (clientCount == 0) ? -1 : clients[GetRandomInt(0, clientCount-1)];

	
	
    /*new iPlayers[32], iNum;
    get_players(iPlayers, iNum, "ac");
    if( iNum <= 1 )
    {
        return iPlayers[0];
    }
    new iRandomNum = random(iNum);
    new iRandomPlayer = iPlayers[ iRandomNum ];
    if( iRandomPlayer == g_iLastChoosenPlayer )
    {
        iPlayers[ iRandomNum ] = iPlayers[ --iNum ];
        iRandomPlayer = iPlayers[ random(iNum) ];
    }
   // g_iLastChoosenPlayer  = iRandomPlayer
    return iRandomPlayer;*/
}  