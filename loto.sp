#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <store>

public Plugin:myinfo =
{
	name        = "Loto",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.1",
};

new tur, sefer;
new girisSayilar[6];
new sonucSayilar[6];
new String:lotoCikanlar[128];
bool oyunOynaniyor;
new const String:FULL_SOUND_PATH[] = "sound/drkgaming/loto.mp3";
new const String:RELATIVE_SOUND_PATH[] = "*/drkgaming/loto.mp3";
new kisiselBekleme[MAXPLAYERS+1];
new Handle:g_PluginTagi = INVALID_HANDLE;

public OnPluginStart() 
{
	RegConsoleCmd("sm_loto", LotoKomutu, "Loto oynamanızı sağlar");
	CreateTimer(222.0, lotoReklam, _,TIMER_REPEAT);
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
}

public OnMapStart()
{
	oyunOynaniyor = false;
	AddFileToDownloadsTable( FULL_SOUND_PATH );
	FakePrecacheSound( RELATIVE_SOUND_PATH );
}

stock FakePrecacheSound( const String:szPath[] )
{
	AddToStringTable( FindStringTable( "soundprecache" ), szPath );
}

public Action:lotoReklam(Handle:timer)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	PrintToChatAll (" \x02[%s] \x0E!loto \x01yazarak \x0Eloto oyunu \x01hakkında bilgi alabilirsiniz.", sPluginTagi);
	return Plugin_Continue;
}

public OnClientPostAdminCheck(client) 
{
	kisiselBekleme[client] = GetTime() + 120;
} 

public Action LotoKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(args == 0)
	{
		Bilgi(client);
		return Plugin_Handled;
	}
	if(oyunOynaniyor)
	{
		PrintToChat(client, " \x02[%s] \x04Şuan zaten bir loto oynanıyor.", sPluginTagi);
		return Plugin_Handled;
	}	
	if(args == 6)
	{
		decl String:s1[16];
		GetCmdArg(1, s1, sizeof(s1));
		girisSayilar[0] = StringToInt(s1);
		
		decl String:s2[16];
		GetCmdArg(2, s2, sizeof(s2));
		girisSayilar[1] = StringToInt(s2);
		
		decl String:s3[16];
		GetCmdArg(3, s3, sizeof(s3));
		girisSayilar[2] = StringToInt(s3);
		
		decl String:s4[16];
		GetCmdArg(4, s4, sizeof(s4));
		girisSayilar[3] = StringToInt(s4);
		
		decl String:s5[16];
		GetCmdArg(5, s5, sizeof(s5));
		girisSayilar[4] = StringToInt(s5);
		
		decl String:s6[16];
		GetCmdArg(6, s6, sizeof(s6));
		girisSayilar[5] = StringToInt(s6);
		
		for(new i=0;i<6;i++)
		{
			if(girisSayilar[i] < 1 || girisSayilar[i] > 30)
			{
				PrintToChat(client, " \x02[%s] \x0EGirdiğiniz sayılar 1-30 arasında olmalıdır.", sPluginTagi);
				return Plugin_Handled;
			}
		}
		
		new i, j, kacAyni;
		for(i=0; i<6; i++)
		{
			for(j=i;j<6;j++)
			{
				if(i != j && girisSayilar[i] == girisSayilar[j])
				{
					kacAyni++;
				}
			}
		}
		if(kacAyni > 0)
		{
			PrintToChat(client, " \x02[%s] \x0ELotoda aynı sayıları giremezsiniz.", sPluginTagi);
			return Plugin_Handled;
		}
		
		if(Store_GetClientCredits(client) < 1500)
		{
			PrintToChat(client, " \x02[%s] \x0ELoto oynayabilmek için en az \x021500 TL\x0E'ye sahip olmanız gerekmektedir.", sPluginTagi);
			return Plugin_Handled;
		}
		
		if(kisiselBekleme[client] > GetTime())
		{
			if(!((GetUserFlagBits(client) & ADMFLAG_ROOT) || (GetUserFlagBits(client) & ADMFLAG_GENERIC)))
			{
				PrintToChat(client, " \x02[%s] \x0ELoto oynayabilmek için \x04%d saniye \x0Ebeklemelisiniz.", sPluginTagi, kisiselBekleme[client] - GetTime());
				return Plugin_Handled;
			}
		}
		
		kisiselBekleme[client] = GetTime() + 150;
		lotoCikanlar = "";
		oyunOynaniyor = true;
		TLVer(client, -1500);
		PrintToChat(client, " \x02[%s] \x0ELoto için sizden \x021500 TL \x0Ealındı.", sPluginTagi);
		PrintToChatAll(" \x02[%s] \x04%N \x0E%d , %d , %d , %d , %d , %d \x10sayılarıyla loto oynuyor..", sPluginTagi, client, girisSayilar[0], girisSayilar[1], girisSayilar[2], girisSayilar[3], girisSayilar[4], girisSayilar[5]);
		LotoOyna(client);
	}
	else
	{
		PrintToChat(client, " \x02[%s] \x04Loto oynayabilmek için \x106 tane \x04sayı girmelisiniz.", sPluginTagi);
		PrintToChat(client, " \x0EGirdiğiniz sayılar \x021-30 \x0Earasında olmalıdır.");
		PrintToChat(client, " \x05Örnek: \x0C!loto 1 2 3 4 5 6");
	}
	return Plugin_Continue;
}

Bilgi(client)
{
	new Handle:menu = CreateMenu(loto, MenuAction_Select | MenuAction_End);
	SetMenuTitle(menu, "Loto Bilgilendirme");

	AddMenuItem(menu, "1", "Loto oynamak için 1500 TL vermeniz gerekmektedir.");
	AddMenuItem(menu, "2", "1 ile 30 arasında 6 tane sayı girmelisiniz.");
	AddMenuItem(menu, "3", "Örnek: !loto 1 2 3 4 5 6");
	AddMenuItem(menu, "4", "Aynı anda sadece 1 kişi loto oynayabilir");
	AddMenuItem(menu, "5", "Ödüller: 1 Bilen: 500 TL - 2 Bilen: 1.500 TL - 3 Bilen: 5.000 TL");
	AddMenuItem(menu, "6", "4 Bilen: 15.000 TL - 5 Bilen 50.000 TL - 6 Bilen 150.000 TL");

	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public loto(Handle:menu, MenuAction:action, param1, param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			new String:item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "1"))
			{
				DisplayMenu(menu, param1, MENU_TIME_FOREVER);
			}
			else if (StrEqual(item, "2"))
			{
				DisplayMenu(menu, param1, MENU_TIME_FOREVER);
			}
			else if (StrEqual(item, "3"))
			{
				DisplayMenu(menu, param1, MENU_TIME_FOREVER);
			}
			else if (StrEqual(item, "4"))
			{
				DisplayMenu(menu, param1, MENU_TIME_FOREVER);
			}
			else if (StrEqual(item, "5"))
			{
				DisplayMenu(menu, param1, MENU_TIME_FOREVER);
			}
			else if (StrEqual(item, "6"))
			{
				DisplayMenu(menu, param1, MENU_TIME_FOREVER);
			}
		}

		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);
		}
	}
}


void LotoOyna(int client)
{
	new i, a, b;
	for(i=0; i<6; i++)
	{
		a = -1;
		while(a == -1)
		{
			a = 1;
			b = GetRandomInt(1,30);
			for(new j=0; j<6; j++)
			{
				if(b == sonucSayilar[j])
				{
					a = -1;
				}
			}
		}
		sonucSayilar[i] = b;
	}
	tur = 0;
	sefer = 1;
	
	Timer(client);
}

Timer(int client)
{
	if(sefer <= 6)
	{
		CreateTimer(0.1, Cark, client);
		CreateTimer(0.4, Cark, client);
		CreateTimer(0.7, Cark, client);
		CreateTimer(1.0, Cark, client);
		CreateTimer(1.3, Cark, client);
		CreateTimer(1.6, Cark, client);
		CreateTimer(1.8, Cark, client);
		CreateTimer(2.0, Cark, client);
		CreateTimer(2.2, Cark, client);
		CreateTimer(2.4, Cark, client);
		CreateTimer(2.6, Cark, client);
		CreateTimer(2.8, Cark, client);
		CreateTimer(3.0, Cark, client);
		CreateTimer(3.2, Cark, client);
		CreateTimer(3.4, Cark, client);
		CreateTimer(3.6, Cark, client);
		CreateTimer(3.9, Cark, client);
		CreateTimer(4.3, Cark, client);
		CreateTimer(4.7, Cark, client);
		CreateTimer(5.2, Cark, client);
		CreateTimer(6.0, Cark, client);
		CreateTimer(6.9, Cark, client);
		CreateTimer(8.0, Cark, client);
		CreateTimer(8.5, Cark, client);
		CreateTimer(9.0, Cark, client);
		CreateTimer(9.5, Cark, client);
		CreateTimer(10.0, Cark, client);
		CreateTimer(10.5, Cark, client);
	}
}

public Action Cark(Handle timer, any client)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(tur == 1 && sefer <= 6)
	{
		EmitSoundToClient( client, RELATIVE_SOUND_PATH );
	}
	if(sefer<=6)
	{
		if(tur < 22)
		{
			PrintCenterText(client, "<font size='16'><font color='#00FFFF'>「 %d 」</font>\n<font color='#00FF00'>Oynanan: %d , %d , %d , %d , %d , %d </font>\n<font color='#FF0000'>Gelen: %s </font>", 
			GetRandomInt(1,30), girisSayilar[0], girisSayilar[1], girisSayilar[2], girisSayilar[3], girisSayilar[4], girisSayilar[5], lotoCikanlar);
		}
		else if(tur % 2 == 0)
		{
			PrintCenterText(client, "<font size='16'><font color='#00FFFF'>「 %d 」</font>\n<font color='#00FF00'>Oynanan: %d , %d , %d , %d , %d , %d </font>\n<font color='#FF0000'>Gelen: %s </font>", 
			sonucSayilar[sefer-1], girisSayilar[0], girisSayilar[1], girisSayilar[2], girisSayilar[3], girisSayilar[4], girisSayilar[5], lotoCikanlar);
		}
		else
		{
			PrintCenterText(client, "<font size='16'><font color='#FF00FF'>「 %d 」</font>\n<font color='#00FF00'>Oynanan: %d , %d , %d , %d , %d , %d </font>\n<font color='#FF0000'>Gelen: %s </font>", 
			sonucSayilar[sefer-1], girisSayilar[0], girisSayilar[1], girisSayilar[2], girisSayilar[3], girisSayilar[4], girisSayilar[5], lotoCikanlar);
		}
	}
	if(tur == 23)
	{
		if(sefer == 1)
			Format(lotoCikanlar, sizeof(lotoCikanlar), "%d",  sonucSayilar[sefer-1]);
		else
			Format(lotoCikanlar, sizeof(lotoCikanlar), "%s , %d",  lotoCikanlar, sonucSayilar[sefer-1]);
		PrintToChat(client, " \x02[%s] \x04Loto \x10%d. \x04çekiliş: \x10%s", sPluginTagi, sefer, lotoCikanlar);
		PrintToChat(client, " \x06Oynananlar: \x0C%d , %d , %d , %d , %d , %d", girisSayilar[0], girisSayilar[1], girisSayilar[2], girisSayilar[3], girisSayilar[4], girisSayilar[5]);
	}
	if(tur == 27 && sefer <= 6)
	{
		sefer++;
		tur = 0;
		Timer(client);
	}
	if(sefer == 7)
	{
		OyunBitisi(client);
		return Plugin_Handled;
	}
	
	//PrintToChatAll("Tur: %d, Sefer: %d", tur, sefer);
	tur++;
	return Plugin_Continue;
}

OyunBitisi(int client)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(oyunOynaniyor)
	{
		new i, j, kacBildi;
		for(i=0; i<6; i++)
		{
			for(j=0;j<6;j++)
			{
				if(sonucSayilar[i] == girisSayilar[j])
					kacBildi++;
			}
		}
		PrintToChatAll( " \x02[%s] \x04Lotoda \x10%N \x0C%d \x04bildi.", sPluginTagi, client, kacBildi);
		new kazanma;
		if(kacBildi == 0)
		{
			PrintToChatAll(" \x02[%s] \x10%N \x04lotoda \x0Chiç bilemediği için \x10TL kazanamadı.", sPluginTagi, client);
		}
		if(kacBildi == 1)
		{
			kazanma = 500;
			PrintToChatAll(" \x02[%s] \x10%N \x04lotoda \x0C%d bildiği için \x10%d TL kazandı.", sPluginTagi, client, kacBildi, kazanma);
			TLVer(client, kazanma);
		}
		if(kacBildi == 2)
		{
			kazanma = 1500;
			PrintToChatAll(" \x02[%s] \x10%N \x04lotoda \x0C%d bildiği için \x10%d TL kazandı.", sPluginTagi, client, kacBildi, kazanma);
			TLVer(client, kazanma);
		}
		if(kacBildi == 3)
		{
			kazanma = 5000;
			PrintToChatAll(" \x02[%s] \x10%N \x04lotoda \x0C%d bildiği için \x10%d TL kazandı.", sPluginTagi, client, kacBildi, kazanma);
			TLVer(client, kazanma);
		}
		if(kacBildi == 4)
		{
			kazanma = 15000;
			PrintToChatAll(" \x02[%s] \x10%N \x04lotoda \x0C%d bildiği için \x10%d TL kazandı.", sPluginTagi, client, kacBildi, kazanma);
			TLVer(client, kazanma);
		}
		if(kacBildi == 5)
		{
			kazanma = 50000;
			PrintToChatAll(" \x02[%s] \x10%N \x04lotoda \x0C%d bildiği için \x10%d TL kazandı.", sPluginTagi, client, kacBildi, kazanma);
			TLVer(client, kazanma);
		}
		if(kacBildi == 6)
		{
			kazanma = 150000;
			PrintToChatAll(" \x02[%s] \x10%N \x04lotoda \x0C%d bildiği için \x10%d TL kazandı.", sPluginTagi, client, kacBildi, kazanma);
			TLVer(client, kazanma);
		}
		oyunOynaniyor = false;
	}
}

TLVer(int client, int kazanma)
{
	Store_SetClientCredits(client, (Store_GetClientCredits(client) + kazanma));
}