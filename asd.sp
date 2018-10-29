#include <sourcemod>
#include <sdktools>
#include <sourcemod>

public Plugin:myinfo =
{
    name = "TEST",
    author = "ImPossibLe`",
    description = "DrK # GaminG",
    version = "1.0"
}

new String:yazilar[8][500];
static int randomSayi;
bool yazildi = false;
 
public OnClientPutInServer(client)
{
	RegAdminCmd("sm_randomyazi", RandomYazi, ADMFLAG_GENERIC);
	AddCommandListener(Command_Say, "say");
}
 
public Action:RandomYazi(client, args)
{
	yazilar[0] = "selim yasar";
	yazilar[1] = "kırmızı araba";
	yazilar[2] = "mavi duvarın karşısındaki siyah reklam";
	yazilar[3] = "böğürtlen ağacı";
	yazilar[4] = "pişmiş muz";
	yazilar[5] = "basketbol sahası";
	yazilar[6] = "büyükisyan";
	yazilar[7] = "Ağır Geldiyse Yaşam Firar Serbest Paşam";
	randomSayi = RandomSayiVer();
	yazdir();
	yazildi = false;
}

int RandomSayiVer()
{
	return GetRandomInt(0, 7);
}
void yazdir()
{
	CreateTimer(2.0, RandomYaziTimer);
	CreateTimer(4.0, RandomYaziTimer);
	CreateTimer(6.0, RandomYaziTimer);
	CreateTimer(8.0, RandomYaziTimer);
	CreateTimer(10.0, RandomYaziTimer);
	CreateTimer(12.0, RandomYaziTimer);
	CreateTimer(14.0, RandomYaziTimer);
	CreateTimer(16.0, RandomYaziTimer);
	CreateTimer(18.0, RandomYaziTimer);
	CreateTimer(20.0, RandomYaziTimer);
	CreateTimer(22.0, RandomYaziTimer);
}

public Action RandomYaziTimer(Handle timer)
{
	PrintHintTextToAll("<font color='#00ffde'>%s", yazilar[randomSayi]);
}

public Action:Command_Say(client, const String:command[], args)
{
	decl String:yazi[200];
	GetCmdArgString(yazi, sizeof(yazi));
	StripQuotes(yazi);
	
	//PrintToChatAll("TEST: %s", yazi);
	//PrintToChatAll("TEST Random: %s", yazilar[randomSayi]);
	
	if(StrEqual(yazi, yazilar[randomSayi], true))
	{
		if(!yazildi)
		{
			if(GetClientTeam(client) != 3)
			{
				ChangeClientTeam(client, 3);
				yazildi = true;
				return Plugin_Handled;
			}
		}
	}
	return Plugin_Continue;
}