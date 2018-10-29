#pragma semicolon 1

#include <sourcemod>
public Plugin:myinfo =
{
	name = "Gelişmiş Admin Listesi",
	author = "ImPossibLe`",
	description = "Oyundaki Adminleri Gösterir",
	version = "1.0"
};

new Handle:yetkiHarf1 = INVALID_HANDLE;
new Handle:yetkiIsim1 = INVALID_HANDLE;
new Handle:yetkiHarf2 = INVALID_HANDLE;
new Handle:yetkiIsim2 = INVALID_HANDLE;
new Handle:yetkiHarf3 = INVALID_HANDLE;
new Handle:yetkiIsim3 = INVALID_HANDLE;
new Handle:yetkiHarf4 = INVALID_HANDLE;
new Handle:yetkiIsim4 = INVALID_HANDLE;
new Handle:yetkiHarf5 = INVALID_HANDLE;
new Handle:yetkiIsim5 = INVALID_HANDLE;
new Handle:yetkiHarf6 = INVALID_HANDLE;
new Handle:yetkiIsim6 = INVALID_HANDLE;
new Handle:yetkiHarf7 = INVALID_HANDLE;
new Handle:yetkiIsim7 = INVALID_HANDLE;
new Handle:yetkiHarf8 = INVALID_HANDLE;
new Handle:yetkiIsim8 = INVALID_HANDLE;
new Handle:yetkiHarf9 = INVALID_HANDLE;
new Handle:yetkiIsim9 = INVALID_HANDLE;
new Handle:yetkiHarf10 = INVALID_HANDLE;
new Handle:yetkiIsim10 = INVALID_HANDLE;

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
	
	yetkiHarf1	= 	CreateConVar("drk_yetki01_harf", "z", "1. Yetki için harfi buraya giriniz. (tırnakların içi boş olan yetki kapalıdır.)");
	yetkiIsim1	=	CreateConVar("drk_yetki01_yetki_ismi", "Sunucu Sahibi", "1. Yetki için oyunda görülecek yetki adını giriniz. Not: Aşağıdaki yetkileri en üst seviyeden alta doğru yazınız ve lütfen türkçe karakter kullanmayınız. Bu plugin !admins dışında, adminler oyuna girdiğinde yetkisine göre bilgi mesajı verme özelliğine sahiptir.");
	
	yetkiHarf2	= 	CreateConVar("drk_yetki02_harf", "", "2. Yetki için harfi buraya giriniz.");
	yetkiIsim2	=	CreateConVar("drk_yetki02_yetki_ismi", "", "2. Yetki için oyunda görülecek yetki adını giriniz.");
	
	yetkiHarf3	= 	CreateConVar("drk_yetki03_harf", "", "3. Yetki için harfi buraya giriniz.");
	yetkiIsim3	=	CreateConVar("drk_yetki03_yetki_ismi", "", "3. Yetki için oyunda görülecek yetki adını giriniz.");
	
	yetkiHarf4	= 	CreateConVar("drk_yetki04_harf", "", "4. Yetki için harfi buraya giriniz.");
	yetkiIsim4	=	CreateConVar("drk_yetki04_yetki_ismi", "", "4. Yetki için oyunda görülecek yetki adını giriniz.");
	
	yetkiHarf5	= 	CreateConVar("drk_yetki05_harf", "", "5. Yetki için harfi buraya giriniz.");
	yetkiIsim5	=	CreateConVar("drk_yetki05_yetki_ismi", "", "5. Yetki için oyunda görülecek yetki adını giriniz.");
	
	yetkiHarf6	= 	CreateConVar("drk_yetki06_harf", "", "6. Yetki için harfi buraya giriniz.");
	yetkiIsim6	=	CreateConVar("drk_yetki06_yetki_ismi", "", "6. Yetki için oyunda görülecek yetki adını giriniz.");
	
	yetkiHarf7	= 	CreateConVar("drk_yetki07_harf", "", "7. Yetki için harfi buraya giriniz.");
	yetkiIsim7	=	CreateConVar("drk_yetki07_yetki_ismi", "", "7. Yetki için oyunda görülecek yetki adını giriniz.");
	
	yetkiHarf8	= 	CreateConVar("drk_yetki08_harf", "", "8. Yetki için harfi buraya giriniz.");
	yetkiIsim8	=	CreateConVar("drk_yetki08_yetki_ismi", "", "8. Yetki için oyunda görülecek yetki adını giriniz.");
	
	yetkiHarf9	= 	CreateConVar("drk_yetki09_harf", "", "9. Yetki için harfi buraya giriniz.");
	yetkiIsim9	=	CreateConVar("drk_yetki09_yetki_ismi", "", "9. Yetki için oyunda görülecek yetki adını giriniz.");
	
	yetkiHarf10	= 	CreateConVar("drk_yetki10_harf", "", "10. Yetki için harfi buraya giriniz.");
	yetkiIsim10	=	CreateConVar("drk_yetki10_yetki_ismi", "", "10. Yetki için oyunda görülecek yetki adını giriniz.");
	
	AutoExecConfig(true, "gelismis_admin_listesi");
	RegConsoleCmd("sm_admins", Command_Admins, "Oyundaki Adminleri Gösterir");
}

public OnClientPutInServer(client)
{
	new userid = GetClientUserId(client);
	CreateTimer(3.2, YoneticiGiris, userid);
}

public Action:Command_Admins( client, args )
{
	new String:yetkiHarfler[11][32];
	new String:yetkiIsimler[20][64];
		
	GetConVarString(yetkiHarf1, yetkiHarfler[1], sizeof(yetkiHarfler));
	GetConVarString(yetkiIsim1, yetkiIsimler[1], sizeof(yetkiIsimler));
	
	GetConVarString(yetkiHarf2, yetkiHarfler[2], sizeof(yetkiHarfler));
	GetConVarString(yetkiIsim2, yetkiIsimler[2], sizeof(yetkiIsimler));
	
	GetConVarString(yetkiHarf3, yetkiHarfler[3], sizeof(yetkiHarfler));
	GetConVarString(yetkiIsim3, yetkiIsimler[3], sizeof(yetkiIsimler));
	
	GetConVarString(yetkiHarf4, yetkiHarfler[4], sizeof(yetkiHarfler));
	GetConVarString(yetkiIsim4, yetkiIsimler[4], sizeof(yetkiIsimler));
	
	GetConVarString(yetkiHarf5, yetkiHarfler[5], sizeof(yetkiHarfler));
	GetConVarString(yetkiIsim5, yetkiIsimler[5], sizeof(yetkiIsimler));
	
	GetConVarString(yetkiHarf6, yetkiHarfler[6], sizeof(yetkiHarfler));
	GetConVarString(yetkiIsim6, yetkiIsimler[6], sizeof(yetkiIsimler));
	
	GetConVarString(yetkiHarf7, yetkiHarfler[7], sizeof(yetkiHarfler));
	GetConVarString(yetkiIsim7, yetkiIsimler[7], sizeof(yetkiIsimler));
	
	GetConVarString(yetkiHarf8, yetkiHarfler[8], sizeof(yetkiHarfler));
	GetConVarString(yetkiIsim8, yetkiIsimler[8], sizeof(yetkiIsimler));
	
	GetConVarString(yetkiHarf9, yetkiHarfler[9], sizeof(yetkiHarfler));
	GetConVarString(yetkiIsim9, yetkiIsimler[9], sizeof(yetkiIsimler));
	
	GetConVarString(yetkiHarf10, yetkiHarfler[10], sizeof(yetkiHarfler));
	GetConVarString(yetkiIsim10, yetkiIsimler[10], sizeof(yetkiIsimler));
	
	new String:yetki1Isimler[15][32];
	new String:yetki2Isimler[15][32];
	new String:yetki3Isimler[15][32];
	new String:yetki4Isimler[15][32];
	new String:yetki5Isimler[15][32];
	new String:yetki6Isimler[15][32];
	new String:yetki7Isimler[15][32];
	new String:yetki8Isimler[15][32];
	new String:yetki9Isimler[15][32];
	new String:yetki10Isimler[15][32];
	new yetkiSayisi[11], i;
	
	
	for(i=1;i<=MaxClients;i++)
	{
		if(IsClientInGame(i) && !IsFakeClient(i))
		{
			if((GetUserFlagBits(i) & ReadFlagString(yetkiHarfler[1])) == ReadFlagString(yetkiHarfler[1])) 
			{
				if(!StrEqual(yetkiHarfler[1], ""))
				{
					GetClientName(i, yetki1Isimler[yetkiSayisi[1]], sizeof(yetki1Isimler[]));
					yetkiSayisi[1]++;
				}
			}
			else if((GetUserFlagBits(i) & ReadFlagString(yetkiHarfler[2])) == ReadFlagString(yetkiHarfler[2])) 
			{
				if(!StrEqual(yetkiHarfler[2], ""))
				{
					GetClientName(i, yetki2Isimler[yetkiSayisi[2]], sizeof(yetki2Isimler[]));
					yetkiSayisi[2]++;
				}
			}
			else if((GetUserFlagBits(i) & ReadFlagString(yetkiHarfler[3])) == ReadFlagString(yetkiHarfler[3])) 
			{
				if(!StrEqual(yetkiHarfler[3], ""))
				{
					GetClientName(i, yetki3Isimler[yetkiSayisi[3]], sizeof(yetki3Isimler[]));
					yetkiSayisi[3]++;
				}
			}
			else if((GetUserFlagBits(i) & ReadFlagString(yetkiHarfler[4])) == ReadFlagString(yetkiHarfler[4])) 
			{
				if(!StrEqual(yetkiHarfler[4], ""))
				{
					GetClientName(i, yetki4Isimler[yetkiSayisi[4]], sizeof(yetki4Isimler[]));
					yetkiSayisi[4]++;
				}
			}
			else if((GetUserFlagBits(i) & ReadFlagString(yetkiHarfler[5])) == ReadFlagString(yetkiHarfler[5])) 
			{
				if(!StrEqual(yetkiHarfler[5], ""))
				{
					GetClientName(i, yetki5Isimler[yetkiSayisi[5]], sizeof(yetki5Isimler[]));
					yetkiSayisi[5]++;
				}
			}
			else if((GetUserFlagBits(i) & ReadFlagString(yetkiHarfler[6])) == ReadFlagString(yetkiHarfler[6])) 
			{
				if(!StrEqual(yetkiHarfler[6], ""))
				{
					GetClientName(i, yetki6Isimler[yetkiSayisi[6]], sizeof(yetki6Isimler[]));
					yetkiSayisi[6]++;
				}
			}
			else if((GetUserFlagBits(i) & ReadFlagString(yetkiHarfler[7])) == ReadFlagString(yetkiHarfler[7])) 
			{
				if(!StrEqual(yetkiHarfler[7], ""))
				{
					GetClientName(i, yetki7Isimler[yetkiSayisi[7]], sizeof(yetki7Isimler[]));
					yetkiSayisi[7]++;
				}
			}
			else if((GetUserFlagBits(i) & ReadFlagString(yetkiHarfler[8])) == ReadFlagString(yetkiHarfler[8])) 
			{
				if(!StrEqual(yetkiHarfler[8], ""))
				{
					GetClientName(i, yetki8Isimler[yetkiSayisi[8]], sizeof(yetki8Isimler[]));
					yetkiSayisi[8]++;
				}
			}
			else if((GetUserFlagBits(i) & ReadFlagString(yetkiHarfler[9])) == ReadFlagString(yetkiHarfler[9])) 
			{
				if(!StrEqual(yetkiHarfler[9], ""))
				{
					GetClientName(i, yetki9Isimler[yetkiSayisi[9]], sizeof(yetki9Isimler[]));
					yetkiSayisi[9]++;
				}
			}
			else if((GetUserFlagBits(i) & ReadFlagString(yetkiHarfler[10])) == ReadFlagString(yetkiHarfler[10])) 
			{
				if(!StrEqual(yetkiHarfler[10], ""))
				{
					GetClientName(i, yetki10Isimler[yetkiSayisi[10]], sizeof(yetki10Isimler[]));
					yetkiSayisi[10]++;
				}
			}
		}
	}
	
	PrintToChat(client, " \x02[DrK # GaminG] \x04Aktif Yetkili Listesi: ");
	new top;
	for(i=0;i<=10;i++)
		top = top + yetkiSayisi[i];
	
	if(top == 0)
	{
		PrintToChat(client, " \x10Aktif yetkili bulunamadı!");
	}
	else
	{
		if(yetkiSayisi[1] != 0)
		{
			decl String:buffer[1024];
			Format(buffer, sizeof(buffer), "\x04%s", yetki1Isimler[yetkiSayisi[1]-1]);
			yetkiSayisi[1]--;
			while(yetkiSayisi[1] != 0)
			{
				Format(buffer, sizeof(buffer), "%s \x01, \x04%s", buffer, yetki1Isimler[yetkiSayisi[1]-1]);
				yetkiSayisi[1]--;
			}
			PrintToChat(client, " \x02%s: %s", yetkiIsimler[1], buffer);
		}
		if(yetkiSayisi[2] != 0)
		{
			decl String:buffer[1024];
			Format(buffer, sizeof(buffer), "\x0C%s", yetki2Isimler[yetkiSayisi[2]-1]);
			yetkiSayisi[2]--;
			while(yetkiSayisi[2] != 0)
			{
				Format(buffer, sizeof(buffer), "%s \x01, \x0C%s", buffer, yetki2Isimler[yetkiSayisi[2]-1]);
				yetkiSayisi[2]--;
			}
			PrintToChat(client, " \x10%s: %s", yetkiIsimler[2], buffer);
		}
		if(yetkiSayisi[3] != 0)
		{
			decl String:buffer[1024];
			Format(buffer, sizeof(buffer), "\x0B%s", yetki3Isimler[yetkiSayisi[3]-1]);
			yetkiSayisi[3]--;
			while(yetkiSayisi[3] != 0)
			{
				Format(buffer, sizeof(buffer), "%s \x01, \x0B%s", buffer, yetki3Isimler[yetkiSayisi[3]-1]);
				yetkiSayisi[3]--;
			}
			PrintToChat(client, " \x0E%s: %s", yetkiIsimler[3], buffer);
		}
		if(yetkiSayisi[4] != 0)
		{
			decl String:buffer[1024];
			Format(buffer, sizeof(buffer), "\x07%s", yetki4Isimler[yetkiSayisi[4]-1]);
			yetkiSayisi[4]--;
			while(yetkiSayisi[4] != 0)
			{
				Format(buffer, sizeof(buffer), "%s \x01, \x07%s", buffer, yetki4Isimler[yetkiSayisi[4]-1]);
				yetkiSayisi[4]--;
			}
			PrintToChat(client, " \x04%s: %s", yetkiIsimler[4], buffer);
		}
		if(yetkiSayisi[5] != 0)
		{
			decl String:buffer[1024];
			Format(buffer, sizeof(buffer), "\x10%s", yetki5Isimler[yetkiSayisi[5]-1]);
			yetkiSayisi[5]--;
			while(yetkiSayisi[5] != 0)
			{
				Format(buffer, sizeof(buffer), "%s \x01, \x10%s", buffer, yetki5Isimler[yetkiSayisi[5]-1]);
				yetkiSayisi[5]--;
			}
			PrintToChat(client, " \x06%s: %s", yetkiIsimler[5], buffer);
		}
		if(yetkiSayisi[6] != 0)
		{
			decl String:buffer[1024];
			Format(buffer, sizeof(buffer), "\x0F%s", yetki6Isimler[yetkiSayisi[6]-1]);
			yetkiSayisi[6]--;
			while(yetkiSayisi[6] != 0)
			{
				Format(buffer, sizeof(buffer), "%s \x01, \x0F%s", buffer, yetki6Isimler[yetkiSayisi[6]-1]);
				yetkiSayisi[6]--;
			}
			PrintToChat(client, " \x09%s: %s", yetkiIsimler[6], buffer);
		}
		if(yetkiSayisi[7] != 0)
		{
			decl String:buffer[1024];
			Format(buffer, sizeof(buffer), "\x05%s", yetki7Isimler[yetkiSayisi[7]-1]);
			yetkiSayisi[7]--;
			while(yetkiSayisi[7] != 0)
			{
				Format(buffer, sizeof(buffer), "%s \x01, \x05%s", buffer, yetki7Isimler[yetkiSayisi[7]-1]);
				yetkiSayisi[7]--;
			}
			PrintToChat(client, " \x0B%s: %s", yetkiIsimler[7], buffer);
		}
		if(yetkiSayisi[8] != 0)
		{
			decl String:buffer[1024];
			Format(buffer, sizeof(buffer), "\x04%s", yetki8Isimler[yetkiSayisi[8]-1]);
			yetkiSayisi[8]--;
			while(yetkiSayisi[8] != 0)
			{
				Format(buffer, sizeof(buffer), "%s \x01, \x04%s", buffer, yetki8Isimler[yetkiSayisi[8]-1]);
				yetkiSayisi[8]--;
			}
			PrintToChat(client, " \x03%s: %s", yetkiIsimler[8], buffer);
		}
		if(yetkiSayisi[9] != 0)
		{
			decl String:buffer[1024];
			Format(buffer, sizeof(buffer), "\x09%s", yetki9Isimler[yetkiSayisi[9]-1]);
			yetkiSayisi[9]--;
			while(yetkiSayisi[9] != 0)
			{
				Format(buffer, sizeof(buffer), "%s \x01, \x09%s", buffer, yetki9Isimler[yetkiSayisi[9]-1]);
				yetkiSayisi[9]--;
			}
			PrintToChat(client, " \x0A%s: %s", yetkiIsimler[9], buffer);
		}
		if(yetkiSayisi[10] != 0)
		{
			decl String:buffer[1024];
			Format(buffer, sizeof(buffer), "\x09%s", yetki10Isimler[yetkiSayisi[10]-1]);
			yetkiSayisi[10]--;
			while(yetkiSayisi[10] != 0)
			{
				Format(buffer, sizeof(buffer), "%s \x01, \x09%s", buffer, yetki10Isimler[yetkiSayisi[10]-1]);
				yetkiSayisi[10]--;
			}
			PrintToChat(client, " \x06%s: %s", yetkiIsimler[10], buffer);
		}
	}
	return Plugin_Handled;
}


public Action YoneticiGiris(Handle timer, int userid)
{
	new client = GetClientOfUserId(userid);
	decl String:authid[32];
	GetClientAuthString(client, authid, sizeof(authid));
	new String:yetkiHarfler[11][32];
	new String:yetkiIsimler[20][128];
		
	GetConVarString(yetkiHarf1, yetkiHarfler[1], sizeof(yetkiHarfler));
	GetConVarString(yetkiIsim1, yetkiIsimler[1], sizeof(yetkiIsimler[]));
	
	GetConVarString(yetkiHarf2, yetkiHarfler[2], sizeof(yetkiHarfler));
	GetConVarString(yetkiIsim2, yetkiIsimler[2], sizeof(yetkiIsimler[]));
	
	GetConVarString(yetkiHarf3, yetkiHarfler[3], sizeof(yetkiHarfler));
	GetConVarString(yetkiIsim3, yetkiIsimler[3], sizeof(yetkiIsimler));
	
	GetConVarString(yetkiHarf4, yetkiHarfler[4], sizeof(yetkiHarfler));
	GetConVarString(yetkiIsim4, yetkiIsimler[4], sizeof(yetkiIsimler[]));
	
	GetConVarString(yetkiHarf5, yetkiHarfler[5], sizeof(yetkiHarfler));
	GetConVarString(yetkiIsim5, yetkiIsimler[5], sizeof(yetkiIsimler[]));
	
	GetConVarString(yetkiHarf6, yetkiHarfler[6], sizeof(yetkiHarfler));
	GetConVarString(yetkiIsim6, yetkiIsimler[6], sizeof(yetkiIsimler[]));
	
	GetConVarString(yetkiHarf7, yetkiHarfler[7], sizeof(yetkiHarfler));
	GetConVarString(yetkiIsim7, yetkiIsimler[7], sizeof(yetkiIsimler[]));
	
	GetConVarString(yetkiHarf8, yetkiHarfler[8], sizeof(yetkiHarfler));
	GetConVarString(yetkiIsim8, yetkiIsimler[8], sizeof(yetkiIsimler[]));
	
	GetConVarString(yetkiHarf9, yetkiHarfler[9], sizeof(yetkiHarfler));
	GetConVarString(yetkiIsim9, yetkiIsimler[9], sizeof(yetkiIsimler[]));
	
	GetConVarString(yetkiHarf10, yetkiHarfler[10], sizeof(yetkiHarfler));
	GetConVarString(yetkiIsim10, yetkiIsimler[10], sizeof(yetkiIsimler[]));
	
	if(GetUserFlagBits(client) & ADMFLAG_GENERIC || GetUserFlagBits(client) & ADMFLAG_ROOT)
	{
		if(StrEqual(authid, "STEAM_1:1:104585403", false))
			return Plugin_Handled;
		if((GetUserFlagBits(client) & ReadFlagString(yetkiHarfler[1])) == ReadFlagString(yetkiHarfler[1])) 
		{
			{
				PrintCenterTextAll("<font color='#FF00FF'>%s </font><font color='#00FFFF'>%N</font>\n<font color='#00FF00'>Şu anda oyunda.</font>", yetkiIsimler[1], client);
			}
		}
		else if((GetUserFlagBits(client) & ReadFlagString(yetkiHarfler[2])) == ReadFlagString(yetkiHarfler[2])) 
		{
			if(!StrEqual(yetkiHarfler[2], ""))
			{
				PrintCenterTextAll("<font color='#FF00FF'>%s </font><font color='#00FFFF'>%N</font>\n<font color='#00FF00'>Şu anda oyunda.</font>", yetkiIsimler[2], client);
			}
		}
		else if((GetUserFlagBits(client) & ReadFlagString(yetkiHarfler[3])) == ReadFlagString(yetkiHarfler[3])) 
		{
			if(!StrEqual(yetkiHarfler[3], ""))
			{
				PrintCenterTextAll("<font color='#FF00FF'>%s </font><font color='#00FFFF'>%N</font>\n<font color='#00FF00'>Şu anda oyunda.</font>", yetkiIsimler[3], client);
			}
		}
		else if((GetUserFlagBits(client) & ReadFlagString(yetkiHarfler[4])) == ReadFlagString(yetkiHarfler[4])) 
		{
			if(!StrEqual(yetkiHarfler[4], ""))
			{
				PrintCenterTextAll("<font color='#FF00FF'>%s </font><font color='#00FFFF'>%N</font>\n<font color='#00FF00'>Şu anda oyunda.</font>", yetkiIsimler[4], client);
			}
		}
		else if((GetUserFlagBits(client) & ReadFlagString(yetkiHarfler[5])) == ReadFlagString(yetkiHarfler[5])) 
		{
			if(!StrEqual(yetkiHarfler[5], ""))
			{
				PrintCenterTextAll("<font color='#FF00FF'>%s </font><font color='#00FFFF'>%N</font>\n<font color='#00FF00'>Şu anda oyunda.</font>", yetkiIsimler[5], client);
			}
		}
		else if((GetUserFlagBits(client) & ReadFlagString(yetkiHarfler[6])) == ReadFlagString(yetkiHarfler[6])) 
		{
			if(!StrEqual(yetkiHarfler[6], ""))
			{
				PrintCenterTextAll("<font color='#FF00FF'>%s </font><font color='#00FFFF'>%N</font>\n<font color='#00FF00'>Şu anda oyunda.</font>", yetkiIsimler[6], client);
			}
		}
		else if((GetUserFlagBits(client) & ReadFlagString(yetkiHarfler[7])) == ReadFlagString(yetkiHarfler[7])) 
		{
			if(!StrEqual(yetkiHarfler[7], ""))
			{
				PrintCenterTextAll("<font color='#FF00FF'>%s </font><font color='#00FFFF'>%N</font>\n<font color='#00FF00'>Şu anda oyunda.</font>", yetkiIsimler[7], client);
			}
		}
		else if((GetUserFlagBits(client) & ReadFlagString(yetkiHarfler[8])) == ReadFlagString(yetkiHarfler[8])) 
		{
			if(!StrEqual(yetkiHarfler[8], ""))
			{
				PrintCenterTextAll("<font color='#FF00FF'>%s </font><font color='#00FFFF'>%N</font>\n<font color='#00FF00'>Şu anda oyunda.</font>", yetkiIsimler[8], client);
			}
		}
		else if((GetUserFlagBits(client) & ReadFlagString(yetkiHarfler[9])) == ReadFlagString(yetkiHarfler[9])) 
		{
			if(!StrEqual(yetkiHarfler[9], ""))
			{
				PrintCenterTextAll("<font color='#FF00FF'>%s </font><font color='#00FFFF'>%N</font>\n<font color='#00FF00'>Şu anda oyunda.</font>", yetkiIsimler[9], client);
			}
		}
		else if((GetUserFlagBits(client) & ReadFlagString(yetkiHarfler[10])) == ReadFlagString(yetkiHarfler[10])) 
		{
			if(!StrEqual(yetkiHarfler[10], ""))
			{
				PrintCenterTextAll("<font color='#FF00FF'>%s </font><font color='#00FFFF'>%N</font>\n<font color='#00FF00'>Şu anda oyunda.</font>", yetkiIsimler[10], client);
			}
		}
		return Plugin_Handled;
	}
	return Plugin_Handled;
}
