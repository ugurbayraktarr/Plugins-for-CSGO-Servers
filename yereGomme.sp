#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

public Plugin:myinfo =
{
	name        = "Yere Gömme",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

bool gomuldu = false;
static int iGomSuresi;
static int komutZamani;
static int gomAtilacak = 0;
new Float:gomulecekYerler[MAXPLAYERS+1][3];
new Handle:g_PluginTagi = INVALID_HANDLE;

public OnMapStart()
{
	gomuldu = false;
	
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	
	if(!((StrContains(mapName, "jb_", false) != -1) || (StrContains(mapName, "jail_", false)!= -1)))
	{
		SetFailState("Bu plugin sadece jail maplarinda calismaktadir..");
	}
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
}

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
	
	//RegAdminCmd("sm_gom", GomKomutu, ADMFLAG_GENERIC, "Oyuncuları yere gömer.");
	RegAdminCmd("sm_cikar", CikarKomutu, ADMFLAG_GENERIC, "Oyuncuları yerden çıkarır.");
	
	HookEvent("round_end", Event_RoundEnd, EventHookMode_Pre);
	RegAdminCmd("sm_gom", GomKomutu, ADMFLAG_GENERIC, "Oyuncuları yere gömer.");
	RegAdminCmd("sm_gomiptal", GomIptal, ADMFLAG_GENERIC, "Oyuncuları gömme işlemini iptal eder.");
	CreateTimer(1.0, Countdown, _, TIMER_REPEAT);
	
	//RegAdminCmd("sm_maxx", MaxKomutu, ADMFLAG_ROOT);
}

/*public Action:MaxKomutu(client, args)
{
	new Float:maxFloat[3];
	GetClientMaxs(client, maxFloat);
	PrintToChatAll("> Max: \x02%.2f , \x04%.2f , \x10%.2f", maxFloat[0], maxFloat[1], maxFloat[2]);
	new Float:minFloat[3];
	GetClientMins(client, minFloat);
	PrintToChatAll("> Min: \x02%.2f , \x04%.2f , \x10%.2f", minFloat[0], minFloat[1], minFloat[2]);
	new Float:absFloat[3];
	GetClientAbsOrigin(client, absFloat);
	PrintToChatAll("> Abs: \x02%.2f , \x04%.2f , \x10%.2f", absFloat[0], absFloat[1], absFloat[2]);
	
	new Float:Pos[3];
	GetEntPropVector(client, Prop_Send, "m_vecOrigin", Pos);
	PrintToChatAll("> Pos: \x02%.2f , \x04%.2f , \x10%.2f", Pos[0], Pos[1], Pos[2]);
}*/



public Action:Event_Round_Start(Handle:event, const String:name[], bool:dontBroadcast) 
{
	gomuldu = false;
}

/*public Action:GomKomutu(client, args)
{
	if(gomuldu)
	{
		PrintToChatAll(" \x02[DrK # GaminG] \x04Oyuncular zaten gömülmüştü!");
		return Plugin_Handled;
	}
	else
	{
		new i;
		for(i=1;i<=MaxClients;i++)
		{
			if(!IsClientConnected(i)) continue;
			if(!IsClientInGame(i)) continue;
			if(GetClientTeam(i) != 2) continue;
			if(!IsPlayerAlive(i)) continue;
			if(GetClientTeam(i) != 2) continue;
			float miktar;
			new Float:PlayerOrigin[3];
			miktar = GetClientDistanceToGround(i);
			GetClientAbsOrigin(i, PlayerOrigin);
			PlayerOrigin[2] -= miktar + 50.0;
			TeleportEntity(i, PlayerOrigin, NULL_VECTOR, NULL_VECTOR);
			gomuldu = true;
		}
		ServerCommand("sm_freeze @t -1");
		PrintToChatAll(" \x02[DrK # GaminG] \x04T'ler \x10%N \x04tarafından \x07yere gömüldü!", client);
		return Plugin_Continue;
	}
}*/

public Action:CikarKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(!gomuldu)
	{
		PrintToChatAll(" \x02[%s] \x06Oyuncular henüz gömülmedi!", sPluginTagi);
		return Plugin_Handled;
	}
	else
	{
		new i;
		for(i=1;i<=MaxClients;i++)
		{
			if(!IsClientConnected(i)) continue;
			if(!IsClientInGame(i)) continue;
			if(GetClientTeam(i) != 2) continue;
			if(!IsPlayerAlive(i)) continue;
			new Float:PlayerOrigin[3];
			GetClientAbsOrigin(i, PlayerOrigin);
			PlayerOrigin[2] += 80.0;
			
			TeleportEntity(i, PlayerOrigin, NULL_VECTOR, NULL_VECTOR);
		}
		gomuldu = false;
		ServerCommand("sm_freeze @t 1");
		PrintToChatAll(" \x02[%s] \x10%N \x01tarafından T'ler \x0EYerden çıkarıldı.", sPluginTagi, client);
	}
	
	return Plugin_Continue;
}

float GetClientDistanceToGround(client)
{
    if(GetEntPropEnt(client, Prop_Send, "m_hGroundEntity") == 0)
		return 0.0;
    
    new Float:fOrigin[3], Float:fGround[3];
    GetClientAbsOrigin(client, fOrigin);
    
    fOrigin[2] += 10.0;
    
    TR_TraceRayFilter(fOrigin, Float:{90.0,0.0,0.0}, MASK_PLAYERSOLID, RayType_Infinite, TraceRayNoPlayers, client);
    if (TR_DidHit())
    {
        TR_GetEndPosition(fGround);
        fOrigin[2] -= 10.0;
        return GetVectorDistance(fOrigin, fGround);
    }
    return 0.0;
}

public bool:TraceRayNoPlayers(entity, mask, any:data)
{
    if(entity == data || (entity >= 1 && entity <= MaxClients))
    {
        return false;
    }
    return true;
}
//

public Action:GomKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(gomuldu)
	{
		PrintToChat(client, " \x02[%s] \x10Oyuncular zaten gömüldü!", sPluginTagi);
		return Plugin_Handled;
	}
	if(args > 1)
	{
		PrintToConsole(client, "Kullanım: !gom sure");
		PrintToChat(client, "\x02Kullanım:\x04 !gom sure");
		return Plugin_Handled;
	}
	else if(args == 0)
	{
		new i;
		for(i=1;i<=MaxClients;i++)
		{
			if(!IsClientConnected(i)) continue;
			if(!IsClientInGame(i)) continue;
			if(GetClientTeam(i) != 2) continue;
			if(!IsPlayerAlive(i)) continue;
			if(GetClientTeam(i) != 2) continue;
			float miktar;
			new Float:PlayerOrigin[3];
			miktar = GetClientDistanceToGround(i);
			GetClientAbsOrigin(i, PlayerOrigin);
			new Float:maxFloat[3];
			GetClientMaxs(i, maxFloat);
			if(maxFloat[2] < 72.0)
			{
				PlayerOrigin[2]+= (72.0 - maxFloat[2]);
			}
			PlayerOrigin[2] -= miktar + 50.0;
			gomulecekYerler[i][0] = PlayerOrigin[0];
			gomulecekYerler[i][1] = PlayerOrigin[1];
			gomulecekYerler[i][2] = PlayerOrigin[2];
			
			TeleportEntity(i, PlayerOrigin, NULL_VECTOR, NULL_VECTOR);
			CreateTimer(0.1, TekrarGom);
			CreateTimer(1.0, TekrarGom);
			CreateTimer(3.0, TekrarGom);
			CreateTimer(5.0, TekrarGom);
		}
		gomuldu = true;
		ServerCommand("sm_freeze @t -1");
		//PrintToChatAll(" \x02[DrK # GaminG] \x04T'ler \x10%N \x04tarafından \x07yere gömüldü!", client);
		//PrintCenterTextAll("<font color='#00FF00'>T'ler yere gömüldü,</font> <font color='#00FFFF'>Bol Şans!</font>");
		PrintCenterTextAll("<b><font color='#FF0000'>! ! !</font> <font color='#00FF00'>T'ler yere gömüldü.</font> <font color='#FF0000'>! ! !</font></b>");
		//PrintToChatAll(" \x02[DrK # GaminG] \x10T'ler \x04%N \x10tarafından yere gömüldü, \x04Bol şans!", client);
		PrintToChatAll(" \x02[%s] \x10%N \x01tarafından T'ler \x0EYere gömüldü.", sPluginTagi, client);
		return Plugin_Continue;
	}
	
	new String:sGomSuresi[10];
	GetCmdArg(1, sGomSuresi, sizeof(sGomSuresi));
	iGomSuresi = StringToInt(sGomSuresi);
	new String:nick[32];
	GetClientName(client, nick, 32);	
	
	//PrintToChatAll(" \x04[DrK # GaminG] \x02%s \x04%d Saniye \x02sonrası için yere gömme işlemi ayarladı.", nick, iGomSuresi);
	PrintToChatAll(" \x02[%s] \x0EYere Gömme \x10%s \x01tarafından \x04%d \x01saniyeye ayarlandı.", sPluginTagi, nick, iGomSuresi);
	komutZamani = GetTime();
	gomAtilacak = 1;
	
	return Plugin_Continue;
}

public Action TekrarGom(Handle timer)
{
	new i;
	for(i=1;i<=MaxClients;i++)
	{
		if(!IsClientConnected(i)) continue;
		if(!IsClientInGame(i)) continue;
		if(GetClientTeam(i) != 2) continue;
		if(!IsPlayerAlive(i)) continue;
		if(GetClientTeam(i) != 2) continue;
		
		if(gomuldu)
			TeleportEntity(i, gomulecekYerler[i], NULL_VECTOR, NULL_VECTOR);
	}
}


public Action:GomIptal(client, args)
{
	if(args != 0)
	{
		PrintToConsole(client, "Kullanım: !gomiptal");
		PrintToChat(client, "\x02Kullanım:\x04 !gomiptal");
		return Plugin_Handled;
	}
	
	//PrintCenterTextAll("<font color='#00FF00'>Yere gömme işlemi</font> <font color='#FF0000'>iptal edilmiştir.</font>");
	PrintCenterTextAll("<b><font color='#00FF00'>Yere Gömme</font> <font color='#FFFFFF'>iptal edilmiştir.</font></b>");
	gomAtilacak = 0;
	return Plugin_Continue;
}


public Action:Countdown(Handle timer)
{
	if(gomAtilacak == 1)
	{
		if(iGomSuresi - (GetTime() - komutZamani) > 0)
		{
			//PrintCenterTextAll("%d Saniye sonra FF açılacaktır!", iGomSuresi - (GetTime() - komutZamani));
			//PrintCenterTextAll("<font color='#00FFFF'>Yere gömme işlemi</font> <font color='#00FF00'>%d</font> <font color='#00FFFF'>saniye sonra yapılacaktır!</font>", iGomSuresi - (GetTime() - komutZamani));
			PrintCenterTextAll("<b><font color='#FFFFFF'>Yere Gömme</font> <font color='#00FF00'>%d</font> <font color='#FFFFFF'>saniye sonra yapılacaktır!</font></b>", iGomSuresi - (GetTime() - komutZamani));
			if((iGomSuresi - (GetTime() - komutZamani)) <= 10)
				PrintToChatAll(" \x0BYere Gömme \x04%i \x0Bsaniye sonra yapılacaktır!", iGomSuresi - (GetTime() - komutZamani));
				
			//PrintToChatAll(" \x02[DrK # GaminG] \x10T'ler \x04%i \x10saniye yere gömülecek!", iGomSuresi - (GetTime() - komutZamani));
		}
		else if(iGomSuresi - (GetTime() - komutZamani) == 0)
		{
			//ServerCommand("mp_teammates_are_enemies 1");
			new i;
			for(i=1;i<=MaxClients;i++)
			{
				if(!IsClientConnected(i)) continue;
				if(!IsClientInGame(i)) continue;
				if(GetClientTeam(i) != 2) continue;
				if(!IsPlayerAlive(i)) continue;
				if(GetClientTeam(i) != 2) continue;
				float miktar;
				new Float:PlayerOrigin[3];
				miktar = GetClientDistanceToGround(i);
				GetClientAbsOrigin(i, PlayerOrigin);
				new Float:maxFloat[3];
				GetClientMaxs(i, maxFloat);
				if(maxFloat[2] < 72.0)
				{
					PlayerOrigin[2]+= (72.0 - maxFloat[2]);
				}
				PlayerOrigin[2] -= miktar + 50.0;
				gomulecekYerler[i][0] = PlayerOrigin[0];
				gomulecekYerler[i][1] = PlayerOrigin[1];
				gomulecekYerler[i][2] = PlayerOrigin[2];
				
				TeleportEntity(i, PlayerOrigin, NULL_VECTOR, NULL_VECTOR);
				CreateTimer(0.1, TekrarGom);
				CreateTimer(1.0, TekrarGom);
				CreateTimer(3.0, TekrarGom);
				CreateTimer(5.0, TekrarGom);
			}
				
			gomuldu = true;
			ServerCommand("sm_freeze @t -1");
			
			new String:sPluginTagi[64];
			GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
			
			//PrintCenterTextAll("<font color='#00FF00'>T'ler yere gömüldü,</font> <font color='#00FFFF'>Bol Şans!</font>");
			PrintCenterTextAll("<b><font color='#FF0000'>! ! !</font> <font color='#00FF00'>T'ler yere gömüldü.</font> <font color='#FF0000'>! ! !</font></b>");
			//PrintToChatAll(" \x02[DrK # GaminG] \x10T'ler yere gömüldü, \x04Bol şans!");
			PrintToChatAll(" \x02[%s] \x10T'ler \x0EYere Gömüldü.", sPluginTagi);
			gomAtilacak = 0;
		}
	}
}

public Action Event_RoundEnd(Handle event, char[] name, bool dontBroadcast)
{
	gomAtilacak = 0;
}