#pragma semicolon 1

#include <sourcemod>

public Plugin:myinfo =
{
	name = "Admin Listesi",
	author = "ImPossibLe`",
	description = "Oyundaki Adminleri Gösterir",
	version = "1.0"
};

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
	
	RegConsoleCmd("sm_admins", Command_Admins, "Oyundaki Adminleri Gösterir");
}

public Action:Command_Admins( client, args )
{
	new i;
	new sunucuSahibiSayisi, ustYetkiliSayisi, ozelSayisi, yetkiliSayisi, adminSayisi;
	decl String:sunucuSahibiIsimler[MAXPLAYERS+1][MAX_NAME_LENGTH+1];
	decl String:ustYetkiliIsimler[MAXPLAYERS+1][MAX_NAME_LENGTH+1];
	decl String:ozelIsimler[MAXPLAYERS+1][MAX_NAME_LENGTH+1];
	decl String:yetkiliIsimler[MAXPLAYERS+1][MAX_NAME_LENGTH+1];
	decl String:adminIsimler[MAXPLAYERS+1][MAX_NAME_LENGTH+1];
	
	for(i=1;i<=MaxClients;i++)
	{
		if(IsClientInGame(i) && !IsFakeClient(i))
		{
			if(GetUserFlagBits(i) & ADMFLAG_ROOT)
			{
				GetClientName(i, sunucuSahibiIsimler[sunucuSahibiSayisi], sizeof(sunucuSahibiIsimler[]));
				sunucuSahibiSayisi++;
			}
			else if (GetUserFlagBits(i) & ADMFLAG_RCON)
			{
				GetClientName(i, ustYetkiliIsimler[ustYetkiliSayisi], sizeof(ustYetkiliIsimler[]));
				ustYetkiliSayisi++;
			}
			else if (GetUserFlagBits(i) & ADMFLAG_GENERIC)
			{
				GetClientName(i, ozelIsimler[ozelSayisi], sizeof(ozelIsimler[]));
				ozelSayisi++;
			}
			else if (GetUserFlagBits(i) & ADMFLAG_CUSTOM1)
			{
				GetClientName(i, yetkiliIsimler[yetkiliSayisi], sizeof(yetkiliIsimler[]));
				yetkiliSayisi++;
			}
			else if (GetUserFlagBits(i) & ADMFLAG_CUSTOM2)
			{
				GetClientName(i, adminIsimler[adminSayisi], sizeof(adminIsimler[]));
				//adminSayisi++;
			}
		}
	}
	PrintToChat(client, " \x02[DrK # GaminG] \x04Aktif Yetkili Listesi: ");
	if((sunucuSahibiSayisi + ustYetkiliSayisi + ozelSayisi + yetkiliSayisi + adminSayisi) == 0)
	{
		PrintToChat(client, " \x10Aktif yetkili bulunamadı!");
	}
	else
	{
		if(sunucuSahibiSayisi != 0)
		{
			decl String:bufferSunucuSahibi[1024];	
			Format(bufferSunucuSahibi, sizeof(bufferSunucuSahibi), "\x04%s", sunucuSahibiIsimler[sunucuSahibiSayisi-1]);
			sunucuSahibiSayisi--;
			while(sunucuSahibiSayisi != 0)
			{
				Format(bufferSunucuSahibi, sizeof(bufferSunucuSahibi), "%s \x02, \x04%s", bufferSunucuSahibi, sunucuSahibiIsimler[sunucuSahibiSayisi-1]);
				sunucuSahibiSayisi--;
			}
			PrintToChat(client, " \x02Sunucu Sahibi: %s", bufferSunucuSahibi);
		}
		if(ustYetkiliSayisi != 0)
		{
			decl String:bufferUstYetkili[1024];	
			Format(bufferUstYetkili, sizeof(bufferUstYetkili), "\x0C%s", ustYetkiliIsimler[ustYetkiliSayisi-1]);
			ustYetkiliSayisi--;
			while(ustYetkiliSayisi != 0)
			{
				Format(bufferUstYetkili, sizeof(bufferUstYetkili), "%s \x02, \x0C%s", bufferUstYetkili, ustYetkiliIsimler[ustYetkiliSayisi-1]);
				ustYetkiliSayisi--;
			}
			PrintToChat(client, " \x07Sunucu Yardımcısı: %s", bufferUstYetkili);
		}
		if(ozelSayisi != 0)
		{
			decl String:bufferOzel[1024];	
			Format(bufferOzel, sizeof(bufferOzel), "\x10%s", ozelIsimler[ozelSayisi-1]);
			ozelSayisi--;
			while(ozelSayisi != 0)
			{
				Format(bufferOzel, sizeof(bufferOzel), "%s \x02, \x10%s", bufferOzel, ozelIsimler[ozelSayisi-1]);
				ozelSayisi--;
			}
			PrintToChat(client, " \x0BAdmin: \x10%s", bufferOzel);
		}
		if(yetkiliSayisi != 0)
		{
			decl String:bufferYetkili[1024];
			Format(bufferYetkili, sizeof(bufferYetkili), "\x03%s", yetkiliIsimler[yetkiliSayisi-1]);
			yetkiliSayisi--;
			while(yetkiliSayisi != 0)
			{
				Format(bufferYetkili, sizeof(bufferYetkili), "%s \x02, \x03%s", bufferYetkili, yetkiliIsimler[yetkiliSayisi-1]);
				yetkiliSayisi--;
			}
			PrintToChat(client, " \x0EKomutçu: %s", bufferYetkili);
		}
		if(adminSayisi != 0)
		{
			decl String:bufferAdmin[1024];
			Format(bufferAdmin, sizeof(bufferAdmin), "\x06%s", adminIsimler[adminSayisi-1]);
			adminSayisi--;
			while(adminSayisi != 0)
			{
				Format(bufferAdmin, sizeof(bufferAdmin), "%s \x02, \x06%s", bufferAdmin, adminIsimler[adminSayisi-1]);
				adminSayisi--;
			}
			//PrintToChat(client, " \x04VIP Oyuncu: %s", bufferAdmin);
		}
	}
	return Plugin_Handled;
}