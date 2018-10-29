#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <store>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Admin TL Verme Yetkisi",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

static int bekleme[65] = {0, ...};


public OnPluginStart() 
{
	HookEvent("player_disconnect", OnPlayerDisconnect, EventHookMode_Pre);
	RegAdminCmd("sm_paraver", Command_Paraver, ADMFLAG_RESERVATION);
}

public Action:Command_Paraver(client, args)
{
	if(args == 0)
	{
		PrintToConsole(client, "Kullanım: !paraver <isim> <miktar>");
		PrintToChat(client, "Kullanım:\x04 !paraver <isim> <miktar>");
		return Plugin_Handled;
	}
	if(args != 2)
	{
		PrintToConsole(client, "[DrK # GaminG] Hatalı Kullanım!");
		PrintToChat(client, "[DrK # GaminG]\x04 Hatalı Kullanım!");
		return Plugin_Handled;
	}
	new MaxPlayers, Player = -1;
	new String:PlayerName[32];
	new String:Name[32];
	new String:nick[32];
	new String:sMiktar[32];
	GetCmdArg(1, PlayerName, sizeof(PlayerName));
	GetCmdArg(2, sMiktar, sizeof(sMiktar));
	new iMiktar = StringToInt(sMiktar);
	

	if(iMiktar > 200)
	{
		PrintToConsole(client, "[DrK # GaminG] En Fazla 200 TL Verebilirsiniz!");
		PrintToChat(client, " \x04[DrK # GaminG]\x02 En Fazla 200 TL Verebilirsiniz!");
		return Plugin_Handled;
	}
	else if(iMiktar < 0)
	{
		PrintToConsole(client, "[DrK # GaminG] 0'dan düşük TL Veremezsiniz!");
		PrintToChat(client, " \x04[DrK # GaminG]\x02 0'dan düşük TL Veremezsiniz!");
		return Plugin_Handled;
	}
	else
	{
		if(bekleme[client] < GetTime() - 300)
		{	
			//Find:
			MaxPlayers = GetMaxClients();
			for(new X = 1; X <= MaxPlayers; X++)
			{

				//Connected:
				if(!IsClientConnected(X)) continue;

				//Initialize:
				GetClientName(X, Name, sizeof(Name));

				//Save:
				if(StrContains(Name, PlayerName, false) != -1) Player = X;
			}
			
			//Invalid Name:
			if(Player == -1)
			{

				//Print:
				PrintToChatAll(" \x02[DrK # GaminG] \x04Kullanıcı bulunamadı: \x05%s", PlayerName);
				PrintToConsole(client, "Kullanıcı bulunamadı: %s", PlayerName);

				//Return:
				return Plugin_Handled;
			}
			else
			{
				PrintToChatAll(" \x04[DrK # GaminG] \x02Admin TL verme sistemi \x04ImPossibLe` \x02Tarafından kodlanmıştır.");
				bekleme[client] = GetTime();
				new String:sAdmin[32];
				GetClientName(client, sAdmin, 32);
				GetClientName(Player, nick, 32);
				PrintToChatAll(" \x02[DrK # GaminG] \x02 %s\x01, \x04%s\x05 adlı oyuncuya\x02 %d TL\x05 verdi!", sAdmin, nick, iMiktar);
				LogAction(client, Player, "\"%L\" adli admin \"%L\"'a %d. TL verdi.", client, Player, iMiktar);
				
				/*int id = Store_GetClientAccountID(Player);
				Store_GiveCredits(id, (iMiktar));*/
				
				Store_SetClientCredits(Player, (Store_GetClientCredits(Player) + iMiktar));
			}
		}
		else
		{
			GetClientName(client, nick, 32);
			PrintToChatAll(" \x04[DrK # GaminG] \x02%s \x04isimli admin TL verebilmek için: \x02%d \x04saniye beklemelidir.", nick, 300 - (GetTime() - bekleme[client]));
			return Plugin_Handled;
		}	
	}
	return Plugin_Continue;
}

public Action:OnPlayerDisconnect(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	bekleme[client] = 0;
	
	return Plugin_Continue;
}  