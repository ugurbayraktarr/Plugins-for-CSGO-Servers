#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.2"

public Plugin:myinfo =
{
	name        = "Ban Oylama Menüsü",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

ConVar g_oyYuzde;
static int evetOy = 0;
static int hayirOy = 0;
static int kisiSay = 0;
static int globalUserid = 0;
static int sonKullanim;
static int beklemeSuresi;
char authid[32];

new Handle:g_PluginTagi = INVALID_HANDLE;

//Handle OylamaTimer;

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
	
	CreateTimer(240.0, advert, _,TIMER_REPEAT);
	g_oyYuzde = CreateConVar("drk_banoyla_yuzde", "0.76", "Ban icin gereken oy yuzdesi (0.1-1.0 arasi girin) def. 0.76",	_, true, 0.1, true,	1.0);
	RegConsoleCmd("sm_banoyla", KisiSecMenu, "Ban oylamalari icin kisi secimi menusunu acar.");
	beklemeSuresi = 300;
}

public Action:advert(Handle:timer)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	PrintToChatAll (" \x02[%s] \x04!banoyla \x10ile istemediğiniz oyuncunun banlanması için oylama yapabilirsiniz.", sPluginTagi);
	return Plugin_Continue;
}

public Action:KisiSecMenu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	new i;
	new adminSay;
	new userSay;
	for(i=1;i<=64;i++)
	{
		if(IsClientInGame(i))
		{
			if(GetClientTeam(i) > 1)
			{
				if(IsPlayerGenericAdmin(i))
					adminSay++;
				else
					userSay++;
			}
		}
	}
	if (IsVoteInProgress())
	{
		PrintToChatAll(" \x02[%s] \x04Şuan başka bir oylama yürürlükte.", sPluginTagi);
		return Plugin_Handled;
	}
	if(GetTime() < sonKullanim + beklemeSuresi)
	{
		PrintToChat(client, " \x02[%s] \x04Bu komut \x10%d\x04 saniye önce kullanılmıştır. Yeniden kullanabilmek için \x10%d \x04saniye bekleyin.", sPluginTagi, GetTime()-sonKullanim, beklemeSuresi-(GetTime()-sonKullanim));
		return Plugin_Handled;
	}
	beklemeSuresi = 300;
	/*if((userSay) < 10)
	{
		PrintToChat(client, " \x02[DrK # GaminG] \x04Bu komut \x10%d\x04 saniye önce kullanılmıştır. Yeniden kullanabilmek için \x10%d \x04saniye bekleyin.", GetTime()-sonKullanim, 600-(GetTime()-sonKullanim));
		return Plugin_Handled;
	}*/
	
	if(adminSay > 0)
	{
		PrintToChat(client, " \x02[%s] \x04Oyunda aktif \x10%d Admin\x04 olduğu için bu komutu kullanamazsınız.", sPluginTagi, adminSay);
		return Plugin_Handled;
	}
	new Handle:hMenu = CreateMenu(MenuHandler1);

	SetMenuTitle(hMenu, "[%s] Ban Oylama Menüsü", sPluginTagi);

	decl String:sClientName[40];
	decl String:sClientIndex[4];
	for(i = 1; i <= MaxClients; i++)
	{
		if(!IsClientInGame(i) || IsFakeClient(i) || IsPlayerGenericAdmin(i)) continue;
		IntToString(i, sClientIndex, sizeof(sClientIndex));
		GetClientName(i, sClientName, sizeof(sClientName));
		AddMenuItem(hMenu, sClientIndex, sClientName);
	}
	DisplayMenu(hMenu, client, 30);
	return Plugin_Continue;
}

public MenuHandler1(Handle:hMenu, MenuAction:action, param1, param2)
{
	switch(action)
	{
 		case MenuAction_Select:
		{
			decl String:info[32];
			GetMenuItem(hMenu, param2, info, sizeof(info));
			int iSecilen = StringToInt(info);
			evetOy = 0;
			hayirOy = 0;
			OylamaBaslat(iSecilen);
			//OylamaTimer = CreateTimer(20.0, OylamaSuresiBitis);
			globalUserid = GetClientUserId(iSecilen);
			
			//GetClientAuthString(iSecilen, authid, sizeof(authid));
			GetClientAuthId(iSecilen, AuthId_Steam2, authid, sizeof(authid));
			//PrintToChatAll("Seçilen: %s", info);
			sonKullanim = GetTime();
		}

		case MenuAction_End:
		{
			CloseHandle(hMenu);
		}
	}
	return 0;
}

public void OylamaBaslat(int iSecilen)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	Menu hMenu2 =  new Menu(MenuHandler2);

	SetMenuTitle(hMenu2, "[%s] %N banlansın mı?", sPluginTagi, iSecilen);
	hMenu2.SetTitle("[%s] %N banlansın mı?", sPluginTagi, iSecilen);
	hMenu2.AddItem("", "", ITEMDRAW_DISABLED);
	hMenu2.AddItem("", "Seçeneklere dikkat ediniz.", ITEMDRAW_DISABLED);
	hMenu2.AddItem("", "Kişinin banlanabilmesi için \%76 oy gereklidir.", ITEMDRAW_DISABLED);
	hMenu2.AddItem("", "", ITEMDRAW_DISABLED);
	hMenu2.AddItem("evet", "Evet, banlansın.");
	hMenu2.AddItem("hayir", "Hayır, banlanmasın.");
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
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
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
			PrintHintTextToAll("<font color='#FF0000'>[%s] Kullanılan oy:</font>\n<font color='#00FFFF'>Evet: %d\nHayır: %d", sPluginTagi, evetOy, hayirOy);
			kisiSay++;
			int iSecilen = StringToInt(info);
			OylamaBaslat(iSecilen);
			//PrintToChatAll("Seçilen: %s", info);
			if(kisiSay == evetOy + hayirOy)
			{
				BanOylamaSonuclari();
				if(hMenu2 != INVALID_HANDLE)
					CloseHandle(hMenu2);
			}
		}
		
		case MenuAction_VoteEnd:
		{
			BanOylamaSonuclari();
		}

		case MenuAction_End:
		{
			CloseHandle(hMenu2);
		}
 
	}
	return 0;
}

/*public Action OylamaSuresiBitis(Handle timer)
{
	BanOylamaSonuclari();
}*/

public void BanOylamaSonuclari()
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	//if(OylamaTimer != INVALID_HANDLE)
	//	KillTimer(OylamaTimer);
	char sEvetOy[10];
	char sHayirOy[10];
	float fEvetOy;
	float fHayirOy;
	
	PrintToChatAll(" \x02[%s] \x04Evet Sayısı: \x10%d \x04, Hayır sayısı: \x10%d", sPluginTagi, evetOy, hayirOy);
	float fOran;
	float fYuzde = GetConVarFloat(g_oyYuzde);
	IntToString(evetOy, sEvetOy, sizeof(sEvetOy));
	IntToString(hayirOy, sHayirOy, sizeof(sHayirOy));
	fEvetOy = StringToFloat(sEvetOy);
	fHayirOy = StringToFloat(sHayirOy);
	fOran = (fEvetOy / (fEvetOy + fHayirOy));
	fYuzde = fYuzde + 0.000001;
	PrintToChatAll(" \x06Oran: %.2f , Gereken: %.2f", fOran, fYuzde);
	
	int client = GetClientOfUserId(globalUserid);
	if(fOran >= fYuzde)
	{
		//PrintToChatAll("%N banlanacak. Userid: %d", client, globalUserid);
		//PrintToChatAll("SteamID: %s", authid);
		decl String:banla[128];
		if(client>0)
			BanClient(client, 15, BANFLAG_AUTO, "Oylama ile 15 dk banlandınız", "Oylama ile 15 dk banlandınız.",  "sm_ban", 0);
		
		Format(banla, sizeof(banla), "sm_addban 15 %s Oylama ile 15 dk banlandınız", authid);
		//PrintToChatAll("%s", banla);
		ServerCommand("%s", banla);
		beklemeSuresi = 600;

	}
	else
	{
		PrintToChatAll(" \x02[%s] \x04Oyuncularımız \x10%N\x04'nin banlanmamasını tercih etti :))", sPluginTagi, client);
		PrintToChatAll("SteamID: %s", authid);
	}
}

bool:IsPlayerGenericAdmin(client)
{
    if (CheckCommandAccess(client, "generic_admin", ADMFLAG_GENERIC, false))
    {
        return true;
    }
	else if (CheckCommandAccess(client, "generic_admin", ADMFLAG_ROOT, false))
	{
        return true;
    }
    return false;
}