#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.2"

public Plugin:myinfo =
{
	name        = "Ban Oylama Menüsü",
	author      = "ImPossibLe`",
	description = "PROOYUNCU",
	version     = PLUGIN_VERSION,
};

ConVar g_oyYuzde;
static int evetOy = 0;
static int hayirOy = 0;
static int kisiSay = 0;
static int globalUserid = 0;
static int kisiYasaklamaBaslangici[65];
//static int sonKullanim;
//Handle OylamaTimer;

public OnPluginStart() 
{
	int ips[4];
	char serverip[32];
	int ip = GetConVarInt(FindConVar("hostip"));
	int port = GetConVarInt(FindConVar("hostport"));
	ips[0] = (ip >> 24) & 0x000000FF;
	ips[1] = (ip >> 16) & 0x000000FF;
	ips[2] = (ip >> 8) & 0x000000FF;
	ips[3] = ip & 0x000000FF;
	
	Format(serverip, sizeof(serverip), "%d.%d.%d.%d:%d", ips[0], ips[1], ips[2], ips[3],port);
	if(StrEqual(serverip, "77.223.155.181:27015") == false)
	{
		LogError("Bu plugin ImPossibLe` tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	CreateTimer(220.0, advert, _,TIMER_REPEAT);
	g_oyYuzde = CreateConVar("prooyuncu_ctgec_yuzde", "0.50", "Ban icin gereken oy yuzdesi (0.1-1.0 arasi girin) def. 0.76",	_, true, 0.1, true,	1.0);
	RegConsoleCmd("sm_ctgec", CtGecKomutu, "CT'ye geçebilmek için oylama başlatır.");
}

public Action:advert(Handle:timer)
{
	PrintToChatAll(" \x02[PROOYUNCU] \x04Oyunda admin yoksa \x10!ctgec \x04komutu ile CT geçme oylaması başlatabilirsiniz.");
	return Plugin_Continue;
}

public Action:CtGecKomutu(client, args)
{
	new i;
	new adminSay;
	new userSay;
	new CTSayisi;
	for(i=1;i<=64;i++)
	{
		if(IsClientInGame(i))
		{
			if(GetClientTeam(i) == 3)
				CTSayisi++;
			if(IsPlayerGenericAdmin(i))
				adminSay++;
			else
				userSay++;
		}
	}
	if (IsVoteInProgress())
	{
		PrintToChatAll(" \x02[PROOYUNCU] \x04Şuan başka bir oylama yürürlükte.");
		return Plugin_Handled;
	}
	if(adminSay > 0)
	{
		PrintToChat(client, " \x02[PROOYUNCU] \x04Oyunda \x10%d Admin\x04 olduğu için bu komutu kullanamazsınız.", adminSay);
		return Plugin_Handled;
	}
	if(CTSayisi > 0)
	{
		PrintToChat(client, " \x02[PROOYUNCU] \x04Oyunda \x10%d CT\x04 olduğu için bu komutu kullanamazsınız.", CTSayisi);
		return Plugin_Handled;
	}
	if(kisiYasaklamaBaslangici[client] + 300 > GetTime())
	{
		PrintToChat(client, " \x02[PROOYUNCU] \x04CT Geçme komutunu \x025 dakikada bir\x04 kullanabilirsiniz.");
		PrintToChat(client, " \x02[PROOYUNCU] \x04Bu komutu \x10%d saniye\x04 sonra kullanabilirsiniz.", ((GetTime()+300) - kisiYasaklamaBaslangici[client]));
		return Plugin_Handled;
	}
	globalUserid = GetClientUserId(client);
	OylamaBaslat(client);
	kisiYasaklamaBaslangici[client] = GetTime();
	return Plugin_Continue;
}

public void OylamaBaslat(int client)
{
	Menu hMenu2 =  new Menu(MenuHandler2);

	SetMenuTitle(hMenu2, "[PROOYUNCU] %N CT'ye geçsin mi?", client);
	hMenu2.SetTitle("[PROOYUNCU] %N CT'ye geçsin mi?", client);
	hMenu2.AddItem("hayir", "Hayır, geçmesin.");
	hMenu2.AddItem("evet", "Evet, geçsin.");
	kisiSay = 0;
	for(new i = 1; i <= MaxClients; i++)
	{
		if(!IsClientInGame(i) || IsFakeClient(i)) continue;
		//DisplayMenu(hMenu2, i, 20);
		kisiSay++;
	}
	hMenu2.DisplayVoteToAll(20);
}

public MenuHandler2(Handle:hMenu2, MenuAction:action, param1, param2)
{
	switch(action)
	{
 		case MenuAction_Select:
		{
			decl String:info[32];
			GetMenuItem(hMenu2, param2, info, sizeof(info));
			if(StrEqual(info, "evet", false))
				evetOy++;
			else if(StrEqual(info, "hayir", false))
				hayirOy++;
			//PrintHintTextToAll("<font color='#FF0000'>[PROOYUNCU] Kullanılan oy:</font>\n<font color='#00FFFF'>Evet: %d\nHayır: %d", evetOy, hayirOy);
			kisiSay++;
			//int iSecilen = StringToInt(info);
			//OylamaBaslat(iSecilen);
			//PrintToChatAll("Seçilen: %s", info);
			if(kisiSay == evetOy + hayirOy)
			{
				CTOylamaSonuclari();
				if(hMenu2 != INVALID_HANDLE)
					CloseHandle(hMenu2);
			}
		}
		
		case MenuAction_VoteEnd:
		{
			CTOylamaSonuclari();
		}

		case MenuAction_End:
		{
			CloseHandle(hMenu2);
		}
 
	}
	return 0;
}

public void CTOylamaSonuclari()
{
	//if(OylamaTimer != INVALID_HANDLE)
	//	KillTimer(OylamaTimer);
	char sEvetOy[10];
	char sHayirOy[10];
	float fEvetOy;
	float fHayirOy;
	
	PrintToChatAll(" \x02[PROOYUNCU] \x04Evet Sayısı: \x10%d \x04, Hayır sayısı: \x10%d", evetOy, hayirOy);
	float fOran;
	float fYuzde = GetConVarFloat(g_oyYuzde);
	IntToString(evetOy, sEvetOy, sizeof(sEvetOy));
	IntToString(hayirOy, sHayirOy, sizeof(sHayirOy));
	fEvetOy = StringToFloat(sEvetOy);
	fHayirOy = StringToFloat(sHayirOy);
	fOran = (fEvetOy / (fEvetOy + fHayirOy));
	fYuzde = fYuzde + 0.000001;
	//PrintToChatAll("Oran: %.2f , Gereken: %.2f", fOran, fYuzde);
	
	int client = GetClientOfUserId(globalUserid);
	if(fOran >= fYuzde)
	{
		//PrintToChatAll("%N banlanacak. Userid: %d", client, globalUserid);
		//PrintToChatAll("SteamID: %s", authid);
		//decl String:banla[128];
		if(client>0 && (GetClientTeam(client) != 3))
		{
			PrintToChatAll(" \x02[PROOYUNCU] \x04Oyuncularımız \x02%N\x04'nin CT'ye geçmesini tercih etti :))", client);
			ChangeClientTeam(client, 3);
		}
	}
	else
	{
		PrintToChatAll(" \x02[PROOYUNCU] \x04Oyuncularımız \x02%N\x04'nin CT'ye geçmemesini tercih etti :((", client);
	}
}

bool:IsPlayerGenericAdmin(client)
{
    if (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC, false))
    {
        return true;
    }
    return false;
}