#include <sourcemod>
#include <sdktools>
#include <sourcemod>

#define MAX_WORDS 400

public Plugin:myinfo =
{
    name = "T Sustum",
    author = "ImPossibLe`",
    description = "DrK # GaminG",
    version = "1.0"
}

new Handle:g_PluginTagi = INVALID_HANDLE;
new String:yazilar[MAX_WORDS][128];
static int randomSayi;
bool yazildi = false;
new String:yazilarDosyasi[PLATFORM_MAX_PATH];
static int toplamYazi;

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

	
	RegAdminCmd("sm_tsustum", RandomYazi, ADMFLAG_GENERIC, "T Sustum oyunu başlatır.");
	AddCommandListener(Command_Say, "say");
	
	yazilariOku();
}

void yazilariOku()
{
	BuildPath(Path_SM, yazilarDosyasi, sizeof(yazilarDosyasi), "configs/sustum_mesajlari.ini");
	if(FileExists(yazilarDosyasi))
	{
		new Handle:yazilarHandle = OpenFile(yazilarDosyasi, "r");
		new i = 0;
		while( i < MAX_WORDS && !IsEndOfFile(yazilarHandle)){
			ReadFileLine(yazilarHandle, yazilar[i], sizeof(yazilar[]));
			TrimString(yazilar[i]);
			i++;
		}
		toplamYazi = i;
		CloseHandle(yazilarHandle);
	}
}

public Action:RandomYazi(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	PrintToChatAll(" \x02[%s] \x10%N \x0ETsustum \x06başlatıyor!", sPluginTagi, client);
	CreateTimer(3.0, Timer);
}

public Action Timer(Handle timer)
{
	randomSayi = GetRandomInt(0, toplamYazi);
	yazdir();
	yazildi = false;
}

void yazdir()
{
	char URL[512];
	Format(URL, 512, "https://cs.center/csctts.php?oku=%s", yazilar[randomSayi]);
	int i = 1;
	while (i <= MaxClients)
	{
		if (IsClientInGame(i))
		{
			ShowHiddenMOTDPanel(i, URL, MOTDPANEL_TYPE_URL);
		}
		i++;
	}
	CreateTimer(0.5, RandomYaziTimer);
	CreateTimer(2.0, RandomYaziTimer);
	CreateTimer(3.0, RandomYaziTimer);
	CreateTimer(4.0, RandomYaziTimer);
	CreateTimer(5.0, RandomYaziTimer);
	CreateTimer(6.0, RandomYaziTimer);
	CreateTimer(7.0, RandomYaziTimer);
	CreateTimer(8.0, RandomYaziTimer);
	CreateTimer(9.0, RandomYaziTimer);
	CreateTimer(10.0, RandomYaziTimer);
	CreateTimer(11.0, RandomYaziTimer);
	CreateTimer(12.0, RandomYaziTimer);
	CreateTimer(13.0, RandomYaziTimer);
	CreateTimer(14.0, RandomYaziTimer);
	CreateTimer(15.0, RandomYaziTimer);
	CreateTimer(16.0, RandomYaziTimer);
	CreateTimer(17.0, RandomYaziTimer);
	CreateTimer(18.0, RandomYaziTimer);
	CreateTimer(19.0, RandomYaziTimer);
	CreateTimer(20.0, RandomYaziTimer);
	CreateTimer(21.0, RandomYaziTimer);
	CreateTimer(22.0, RandomYaziTimer);
	CreateTimer(23.0, RandomYaziTimer);
	CreateTimer(24.0, RandomYaziTimer);
	CreateTimer(25.0, RandomYaziTimer);
	CreateTimer(26.0, RandomYaziTimer);
	CreateTimer(27.0, RandomYaziTimer);
	CreateTimer(28.0, RandomYaziTimer);
	CreateTimer(29.0, RandomYaziTimer);
	CreateTimer(30.0, RandomYaziTimer);
	CreateTimer(32.0, RandomYaziTimer);
	CreateTimer(34.0, RandomYaziTimer);
	CreateTimer(36.0, RandomYaziTimer);
	CreateTimer(38.0, RandomYaziTimer);
	CreateTimer(40.0, RandomYaziTimer);
	CreateTimer(60.0, Bitir);
}

public Action RandomYaziTimer(Handle timer)
{
	if(!yazildi)
		PrintCenterTextAll("<font color='#00ffde'>%s", yazilar[randomSayi]);
}

public Action:Command_Say(client, const String:command[], args)
{
	decl String:yazi[200];
	GetCmdArgString(yazi, sizeof(yazi));
	StripQuotes(yazi);
	
	if(StrEqual(yazi, yazilar[randomSayi], false))
	{
		if(!yazildi)
		{
			if(GetClientTeam(client) != 3)
			{
				new String:sPluginTagi[64];
				GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
				
				ChangeClientTeam(client, 3);
				PrintToChatAll(" \x02[%s] \x10%N \x01ilk doğru yazan kişi, \x06tebrikler!", sPluginTagi, client);
				PrintCenterTextAll("<b><font color='#FFFF00'>%N</font> <font color='#00FFFF'>ilk doğru yazan kişi, tebrikler!</font></b>", client);
				yazildi = true;
				return Plugin_Handled;
			}
		}
	}
	return Plugin_Continue;
}

public Action Bitir(Handle timer)
{
	if(!yazildi)
	{
		yazildi = true;
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public void ShowHiddenMOTDPanel(int client, char[] url, int type)
{
	Handle setup = CreateKeyValues("data");
	KvSetString(setup, "title", "YouTube Music Player by namazso");
	KvSetNum(setup, "type", type);
	KvSetString(setup, "msg", url);
	ShowVGUIPanel(client, "info", setup, false);
	delete setup;
}