#include <sourcemod>
#include <sdktools>
#include <sourcemod>

public Plugin:myinfo =
{
    name = "CT Sustum",
    author = "ImPossibLe`",
    description = "DrK # GaminG",
    version = "1.0"
}

new String:yazilar[82][256];
static int randomSayi;
bool yazildi = false;

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
	
	RegAdminCmd("sm_ctsustum", RandomYazi, ADMFLAG_GENERIC, "CT Sustum oyunu başlatır.");
	AddCommandListener(Command_Say, "say");
	
	yazilar[0] = "araba";
	yazilar[1] = "kırmızı araba";
	yazilar[2] = "kırmızı elbise";
	yazilar[3] = "siyah ceket";
	yazilar[4] = "pişmiş muz";
	yazilar[5] = "basketbol sahası";
	yazilar[6] = "DrK # GaminG";
	yazilar[7] = "ahmetin çükü kopsun";
	yazilar[8] = "profesyonel";
	yazilar[9] = "kırmızı başlıklı kız";
	yazilar[10] = "karambit";
	yazilar[11] = "mavi dildo";
	yazilar[12] = "Türk Bayrağı";
	yazilar[13] = "sarı çizmeli mehmet ağa";
	yazilar[14] = "fadimenin 50 tonu";
	yazilar[15] = "ne servermış be";
	yazilar[16] = "bilgin ejderha çok bilmiş";
	yazilar[17] = "bi koydum öldü";
	yazilar[18] = "çok soktun çek";
	yazilar[19] = "gizli mod";
	yazilar[20] = "yakışıklı bey";
	yazilar[21] = "hemen geliyorum";
	yazilar[22] = "cenabet";
	yazilar[23] = "ot ota demiş ki biz otuz";
	yazilar[24] = "mavi arabanın yanındaki kule";
	yazilar[25] = "kutsal damacana";
	yazilar[26] = "mavi arabanın yanındaki kırmızı arabanın altındaki mavi kadın";
	yazilar[27] = "memeler baş kaldırmış";
	yazilar[28] = "kavuşmuyor düğmeler";
	yazilar[29] = "kosovalı";
	yazilar[30] = "at";
	yazilar[31] = "kirpi gülüşü";
	yazilar[32] = "t sustum";
	yazilar[33] = "t susmadım";
	yazilar[34] = "sus ulen";
	yazilar[35] = "ilk yazan kazanır";
	yazilar[36] = "son yazan top";
	yazilar[37] = "siti sustum";
	yazilar[38] = "olan var olmayan var kıskanırlar";
	yazilar[39] = "önemli olan boyu değil işlevi";
	yazilar[40] = "çok mu komik?";
	yazilar[41] = "30 cm damarlı";
	yazilar[42] = "konsola demos yazın";
	yazilar[43] = "baban da yazardı böyle";
	yazilar[44] = "trigonometri";
	yazilar[45] = "para bok";
	yazilar[46] = "Muhammet Ali";
	yazilar[47] = "benim dediğimi yaz";
	yazilar[48] = "Uğur Bayrakdar";
	yazilar[49] = "ImPossibLe`";
	yazilar[50] = "global silver";
	yazilar[51] = "bi susun lan";
	yazilar[52] = "yarrabandı";
	yazilar[53] = "ampul";
	yazilar[54] = "kırmızı arabanın yanındaki pembe kızın yanındaki kırmızı şemsiyeli çocuk";
	yazilar[55] = "yarrrrrdım edin";
	yazilar[56] = "keşkekçinin keşkeklenmiş keşkek kepçesi";
	yazilar[57] = "çok sıcak ulen";
	yazilar[58] = "ayşe hanımın keçileri";
	yazilar[59] = "fatmagülün suçu neydi ki ulen";
	yazilar[60] = "babama sordum babama";
	yazilar[61] = "eller ala dana almış danalanmış biz de ala dana alalım danalanalım";
	yazilar[62] = "Bu yoğurdu sarımsaklasak da mı saklasak, sarımsaklamasak da mı saklasak?";
	yazilar[63] = "Bu çorbayı nanelemeli mi de yemeli, nanelememeli mi de yemeli?";
	yazilar[64] = "bir berber bir berbere gel beraber berberistanda bir berber dükkanı açalım demiş";
	yazilar[65] = "müdür müdür müdür";
	yazilar[66] = "Çökertmeden çıktım da halilim aman başım selamet";
	yazilar[67] = "Ne zaferinden bahsediyorsun, sen savaşla aşkı karıştırmışsın";
	yazilar[68] = "çan çin çon";
	yazilar[69] = "Ne senle, ne de sensiz";
	yazilar[70] = "Geçen bir maça girmiştim, yavşağın teki trolledi";
	yazilar[71] = "ben tiki değilim taam mı";
	yazilar[72] = "bu tuşlara basan parmağım kopsun";
	yazilar[73] = "ilk yazan top";
	yazilar[74] = "pandik";
	yazilar[75] = "adana merkez patlıyo herkes";
	yazilar[76] = "komutçunun sesinden kulağım kanadı";
	yazilar[77] = "mavi arabanın yanına gittim, yanında kırmızı kadın vardı";
	yazilar[78] = "dedi naber dedim iyidir";
	yazilar[79] = "çekoslavakyalılaştıramadıklarımızdan mısınız?";
	yazilar[80] = "uçan uçak";
	yazilar[81] = "yürüyen uçah";
}

public Action:RandomYazi(client, args)
{
	PrintToChatAll(" \x02[DrK # GaminG] \x04%N \x10CT sustum başlatıyor!", client);
	CreateTimer(3.0, Timer);
}

public Action Timer(Handle timer)
{
	randomSayi = GetRandomInt(0, 81);
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
			if(GetClientTeam(client) != 2)
			{
				ChangeClientTeam(client, 2);
				PrintToChatAll(" \x02[DrK # GaminG] \x04%N \x10ilk doğru yazan kişi, tebrikler!", client);
				PrintCenterTextAll("<font color='#FFFF00'>%N</font> <font color='#00FFFF'>ilk doğru yazan kişi, tebrikler!</font>", client);
				yazildi = true;
				return Plugin_Handled;
			}
		}
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