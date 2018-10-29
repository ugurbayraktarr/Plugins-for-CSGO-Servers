#pragma semicolon 1
#include <sourcemod>

#define PLUGIN_VERSION "1.0"
#define MAX_WORDS 200

public Plugin:myinfo =
{
	name        = "Küfür Koruması",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

new String:g_sFilePath[PLATFORM_MAX_PATH];
new String:kufurlerDosyasi[PLATFORM_MAX_PATH];
new String:kufurTemizDosyasi[PLATFORM_MAX_PATH];
//new String:kufurler[1000][64];
//new String:kufurTemiz[1000][64];

new String:kufurler[MAX_WORDS][32];
new String:kufurTemiz[MAX_WORDS][32];
new kufurSayisi;
new kufurTemizSayisi;


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
	
	//AddCommandListener(Command_Say, "say");
	//AddCommandListener(Command_Say, "say_team");
	
	BuildPath(Path_SM, g_sFilePath, sizeof(g_sFilePath), "logs/kufurKorumasi/");
	
	if (!DirExists(g_sFilePath))
	{
		CreateDirectory(g_sFilePath, 511);
		
		if (!DirExists(g_sFilePath))
			SetFailState("/sourcemod/logs/kufurKorumasi - Bu dizin olusturulamadi. Lutfen elle olusturun..");
	}
	
	RegConsoleCmd( "say", OnSay );
	RegConsoleCmd( "say_team", OnSay );
	
	RegConsoleCmd("sm_kufurtest", kufurtest);
	RegConsoleCmd("sm_kufurtest2", kufurtest2);
}

public Action:kufurtest(client, args)
{
	for(new i=0;i<=30;i++)
		PrintToConsole(client, "%s", kufurler[i]);
}

public Action:kufurtest2(client, args)
{
	for(new i=0;i<=30;i++)
		PrintToConsole(client, "%s", kufurTemiz[i]);
}

public OnMapStart()
{
	decl String:FormatedTime[100];
		
	new CurrentTime = GetTime();
	
	FormatTime(FormatedTime, 100, "%d_%b_%Y", CurrentTime); //name the file 'day month year'
	
	BuildPath(Path_SM, g_sFilePath, sizeof(g_sFilePath), "/logs/kufurKorumasi/%s.txt", FormatedTime);
	
	new Handle:FileHandle = OpenFile(g_sFilePath, "a+");
	
	FormatTime(FormatedTime, 100, "%X", CurrentTime);
	
	decl String:MapName[64];
	GetCurrentMap(MapName, sizeof(MapName));
	
	WriteFileLine(FileHandle, "");
	WriteFileLine(FileHandle, "%s - ===== Map %s olarak değişti. =====", FormatedTime, MapName);
	WriteFileLine(FileHandle, "");
	
	kufurleriOku();
	kufurSayilmayacaklariOku();
	
	CloseHandle(FileHandle);
}

void kufurleriOku()
{
	kufurSayisi = 0;
	BuildPath(Path_SM,kufurlerDosyasi,sizeof(kufurlerDosyasi),"configs/kufur_yasakla.ini");
	if(FileExists(kufurlerDosyasi))
	{
		new Handle:kufurlerHandle = OpenFile(kufurlerDosyasi, "r");
		new i = 0;
		while( i < MAX_WORDS && !IsEndOfFile(kufurlerHandle)){
			ReadFileLine(kufurlerHandle, kufurler[i], sizeof(kufurler[]));
			TrimString(kufurler[i]);
			i++;
			kufurSayisi++;
		}
		CloseHandle(kufurlerHandle);
	}
}

void kufurSayilmayacaklariOku()
{
	kufurTemizSayisi = 0;
	BuildPath(Path_SM,kufurTemizDosyasi,sizeof(kufurTemizDosyasi),"configs/kufur_temiz.ini");
	if(FileExists(kufurTemizDosyasi))
	{
		new Handle:kufurlerHandle = OpenFile(kufurTemizDosyasi, "r");
		new i = 0;
		while( i < MAX_WORDS && !IsEndOfFile(kufurlerHandle)){
			ReadFileLine(kufurlerHandle, kufurTemiz[i], sizeof(kufurTemiz[]));
			TrimString(kufurTemiz[i]);
			i++;
			kufurTemizSayisi++;
		}
		CloseHandle(kufurlerHandle);
	}
}

/*
void kufurSayilmayacaklariOku()
{
	BuildPath(Path_SM, g_sFilePath, sizeof(g_sFilePath), "/configs/kufur_temiz.ini");
	Handle FileHandle = OpenFile(g_sFilePath, "a+");
	
	new i=0;
	while(ReadFileLine(FileHandle, kufurTemiz[i], sizeof(kufurTemiz)))
		i++;
	
	CloseHandle(FileHandle);
}*/



public Action:OnSay( client, args )
{
	if(!client) return Plugin_Continue;	
	
	decl String:text[191];
	GetCmdArgString( text, sizeof(text) );
	
	decl String:gercekMesaj[191];
	strcopy(gercekMesaj, sizeof(text), text[0]);
	
	StripQuotes(text);
	TrimString(text);
	
	
	string_cleaner(text[0], sizeof(text));
	
	new i = 0;
	bool kufurVar = false;
	//if((StrContains(text, "ananı", false) != -1) || (StrContains(text, "oros", false) != -1) || (StrContains(text, "avrad", false) != -1) || (StrContains(text, "avrat", false) != -1) || (StrContains(text, "anne", false) != -1) || (StrContains(text, "yavşak", false) != -1) || (StrContains(text, "bacı", false) != -1) || (StrContains(text, "sikeyim", false) != -1) || (StrContains(text, "sikerim", false) != -1) || (StrContains(text, "sikecem", false) != -1) || (StrContains(text, "skrm", false) != -1) || (StrContains(text, "sikim", false) != -1) || (StrContains(text, "amcı", false) != -1) || (StrContains(text, "amci", false) != -1) || (StrContains(text, "amın", false) != -1) || (StrContains(text, "amini", false) != -1) || (StrContains(text, "koyayım", false) != -1) || (StrContains(text, "koyuyum", false) != -1) || (StrContains(text, "sikiyim", false) != -1) || (StrContains(text, "yarra", false) != -1) || (StrContains(text, "yarak", false) != -1) )

	while(i < kufurSayisi && strlen(kufurler[i]) > 0)
	{
		if(kufurVar) break;
		if(StrContains(text, kufurler[i], false) != -1)
		{
			kufurVar = true;
		}
		i++;
	}
	if(kufurVar)
	{
		//if((StrContains(text, "kazanan", false) != -1) || (StrContains(text, "selamın", false) != -1))
		i = 0;
		while(i < kufurTemizSayisi)
		{
			if((StrContains(text, kufurTemiz[i], false) != -1) && strlen(kufurTemiz[i]) > 0)
			{
				return Plugin_Continue;
			}
			i++;
		}
		
		Handle FileHandle = OpenFile(g_sFilePath, "a+");
		
		decl String:PlayerName[64], String:FormatedTime[64], String:Authid[64];
		
		GetClientName(client, PlayerName, 64);
		FormatTime(FormatedTime, 64, "%X", GetTime());
		
		if (!GetClientAuthString(client, Authid, 64))
			Format(Authid, 64, "Unknown SteamID");
		
		WriteFileLine(FileHandle, "%s - %s <%s> : %s", FormatedTime, PlayerName, Authid , gercekMesaj);
		
		CloseHandle(FileHandle);
		
		//PrintToChatAll(" \x02[DrK # GaminG] \x10%N \x04Küfür ettiği için silence aldı.", client);
		//new userid = GetClientUserId(client);
		//ServerCommand("sm_silence #%d", userid);
		PrintToChat(client, " \x10Küfür ettiğiniz için \x07mesajınız engellendi. \x04(%s) ", gercekMesaj);
		return Plugin_Handled;
	

	}
	
	return Plugin_Continue;
	
	
	
	
	
	
	
	
	
	
	/*new String:text[256];
	new String:cmd[256];
	GetCmdArg(0, cmd, sizeof(cmd));
	if (GetCmdArg(1, text, sizeof(text)) < 1)
		return Plugin_Continue;
	StripQuotes(text); 

	if((text, "s.a", false) || StrEqual(text, "sa", false) || StrEqual(text, "s/a", false) || StrEqual(text, "selam", false) || StrEqual(text, "selamlar", false) || StrEqual(text, "slm", false) || StrEqual(text, "selamın aleyküm", false) || StrEqual(text, "selamun aleyküm", false)|| StrEqual(text, "selamum aleykum", false))
	{
		CreateTimer(1.0, CevapYaz, client);
	}*/
}


string_cleaner(String:str[], maxlength){
	new i, len = strlen(str);
	ReplaceString ( str, maxlength, " ", "" );
	ReplaceString ( str, maxlength, ".", "" );
	ReplaceString ( str, maxlength, ",", "" );
	ReplaceString ( str, maxlength, ";", "" );
	ReplaceString ( str, maxlength, ":", "" );
	ReplaceString ( str, maxlength, "/", "" );
	ReplaceString ( str, maxlength, "*", "" );
	ReplaceString ( str, maxlength, "-", "" );
	ReplaceString ( str, maxlength, "_", "" );
	ReplaceString ( str, maxlength, "+", "" );
	ReplaceString ( str, maxlength, "^", "" );
	ReplaceString ( str, maxlength, "'", "" );
	ReplaceString ( str, maxlength, "!", "" );
	ReplaceString ( str, maxlength, "{", "" );
	ReplaceString ( str, maxlength, "}", "" );
	ReplaceString ( str, maxlength, "[", "" );
	ReplaceString ( str, maxlength, "]", "" );
	ReplaceString ( str, maxlength, "|", "" );
	

	ReplaceString(str, maxlength, "|<", "k");
	ReplaceString(str, maxlength, "|>", "p");
	ReplaceString(str, maxlength, "()", "o");
	ReplaceString(str, maxlength, "[]", "o");
	ReplaceString(str, maxlength, "{}", "o");

	for(i = 0; i < len; i++)
	{
		if(str[i] == '@')
			str[i] = 'a';

		if(str[i] == '$')
			str[i] = 's';

		if(str[i] == '0')
			str[i] = 'o';

		if(str[i] == '7')
			str[i] = 't';

		if(str[i] == '3')
			str[i] = 'e';

		if(str[i] == '5')
			str[i] = 's';

		if(str[i] == '<')
			str[i] = 'c';
			
		if(str[i] == '3')
			str[i] = 'e';
		
	}
}