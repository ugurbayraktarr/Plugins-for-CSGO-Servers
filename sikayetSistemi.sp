#pragma semicolon 1
#include <sourcemod>

#define PLUGIN_VERSION "1.0"
#define MAX_WORDS 200

new Handle:g_Zaman = INVALID_HANDLE;

public Plugin:myinfo =
{
	name        = "Şikayet Sistemi",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

new String:g_sFilePath[PLATFORM_MAX_PATH];
new sonKullanim[MAXPLAYERS+1];
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
	
	Format(serverip, sizeof(serverip), "%d.%d.%d", ips[0], ips[1], ips[2], ips[3]);
	if(StrEqual(serverip, "185.188.144") == false || ips[3] < 2 || ips[3] > 129)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
		
	BuildPath(Path_SM, g_sFilePath, sizeof(g_sFilePath), "logs/sikayetSistemi/");
	if (!DirExists(g_sFilePath))
	{
		CreateDirectory(g_sFilePath, 511);
		if (!DirExists(g_sFilePath))
			SetFailState("/sourcemod/logs/sikayetSistemi - Bu dizin olusturulamadi. Lutfen elle olusturun..");
	}
	
	RegConsoleCmd("sm_sikayet", SikayetCommand);
	
	AutoExecConfig(true, "sikayetSistemi");
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
	
	g_Zaman	=	CreateConVar("drk_sikayetsistemi_sure", "120", "Şikayet sistemi bilgilendirme mesajları arasındaki süreyi giriniz:");
	CreateTimer(8.0, TimerAyarla);
}

public Action:TimerAyarla(Handle:timer)
{
	CreateTimer(GetConVarFloat(g_Zaman), advert, _,TIMER_REPEAT);
}

public Action:advert(Handle:timer)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	PrintToChatAll (" \x02[%s] \x04!sikayet \x10ile sunucuyla ilgili şikayetlerinizi bize iletebilirsiniz.", sPluginTagi);
	//PrintToChatAll (" \x04/sikayet \x10ile şikayetinizin oyunda görünmesini engelleyebilirsiniz.");
	return Plugin_Continue;
}

public OnMapStart()
{
	BuildPath(Path_SM, g_sFilePath, sizeof(g_sFilePath), "/logs/sikayetSistemi/oyuncu_sikayetleri.txt");
	new Handle:FileHandle = OpenFile(g_sFilePath, "a+");
	CloseHandle(FileHandle);
}

public Action:SikayetCommand(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(args == 0)
	{
		PrintToChat(client, " \x02Kullanım: \x04!sikayet \x0E<yapmak istediğinz şikayet>");
		return Plugin_Handled;
	}
	if(sonKullanim[client] + 300 < GetTime())
	{
		decl String:mesaj[512];
		GetCmdArgString(mesaj, sizeof(mesaj));
		decl String:FormatedTime1[100], String:FormatedTime2[100];
		Handle FileHandle = OpenFile(g_sFilePath, "a+");
		
		new CurrentTime = GetTime();
		
		FormatTime(FormatedTime1, 100, "%d %b %Y", CurrentTime); //name the file 'day month year'
		FormatTime(FormatedTime2, 100, "%X", CurrentTime);
		
		decl String:SteamID[32];
		GetClientAuthString(client, SteamID, sizeof(SteamID));
		
		WriteFileLine(FileHandle, "-------------------------------------------------------------");
		WriteFileLine(FileHandle, " ");
		WriteFileLine(FileHandle, "%s - %s - %N <%s>:", FormatedTime1, FormatedTime2, client , SteamID);
		WriteFileLine(FileHandle, "%s", mesaj);
		WriteFileLine(FileHandle, " ");
		WriteFileLine(FileHandle, "-------------------------------------------------------------");
			
		CloseHandle(FileHandle);
		PrintToChat(client, " \x02[%s] \x04Şikayetiniz kayıt altına alınmıştır.", sPluginTagi);
		PrintToChat(client, " \x10Gösterdiğiniz ilgiden dolayı \x02teşekkür ederiz.");
		sonKullanim[client] = GetTime();
	}
	else
	{
		PrintToChat(client, " \x02[%s] \x04Şikayet sisteminini \x10her 5 dakikada \x041 kez kullanabilirsiniz.", sPluginTagi);
	}
	return Plugin_Continue;
}

