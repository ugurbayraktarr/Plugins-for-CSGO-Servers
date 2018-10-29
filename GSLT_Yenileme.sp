#include <sourcemod>

#pragma semicolon 1

public Plugin:myinfo = 
{
	name = "GSLT Yenileme Sistemi",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "1.0"
}

new bilgiMesajiSayisi;
bool banGeldi = false;

public OnPluginStart() 
{
	ServerCommand("sv_hibernate_when_empty 0");
	CreateTimer(60.0, TokenKontrol, _, TIMER_REPEAT);
}

public OnMapStart()
{
	banGeldi = false;
}

public Action:TokenKontrol(Handle:timer)
{
	if(!banGeldi)
	{
		new String:buffer[300];
		ServerCommandEx(buffer, sizeof(buffer), "status");
		
		if((StrContains(buffer, " insecure ", false)) != -1)
		{
			banGeldi = true;
			PrintToChatAll(" \x02[DrK # GaminG] \x04Server token ban yedi.");
			PrintToChatAll(" \x04Server'a \x1015 saniye \x04sonra restart atılacaktır.");
			PrintToServer("----- Server Token Ban Yedi. 15 sn sonra res atılacak. -----");
			CreateTimer(3.0, CronBekle);
		}
	}
	return Plugin_Continue;
}

public Action:CronBekle(Handle:timer)
{
	if(banGeldi)
	{
		bilgiMesajiSayisi = 0;
		PrintToChatAll(" ");
		PrintToChatAll(" \x02[DrK # GaminG] \x04Server token ban yedi.");
		PrintToChatAll(" \x04Servera \x10%d saniye \x04sonra restart atılacaktır.", 10 - bilgiMesajiSayisi);
		PrintToChatAll(" \x06Resten sonra konsola \x0Eretry \x06yazara yeninden bağlanın.");
		
		CreateTimer(1.0, BilgiMesaji);
		CreateTimer(2.0, BilgiMesaji);
		CreateTimer(3.0, BilgiMesaji);
		CreateTimer(4.0, BilgiMesaji);
		CreateTimer(5.0, BilgiMesaji);
		CreateTimer(6.0, BilgiMesaji);
		CreateTimer(7.0, BilgiMesaji);
		CreateTimer(8.0, BilgiMesaji);
		CreateTimer(9.0, BilgiMesaji);
		CreateTimer(10.0, BilgiMesaji);
		CreateTimer(11.0, BilgiMesaji);
		CreateTimer(12.0, BilgiMesaji);
	}
}

public Action:BilgiMesaji(Handle:timer)
{
	bilgiMesajiSayisi++;
	if(bilgiMesajiSayisi < 11)
	{
		PrintToChatAll(" \x04Servera \x10%d saniye \x04sonra restart atılacaktır.", 10 - bilgiMesajiSayisi);
		if(bilgiMesajiSayisi > 5)
			PrintToChatAll(" \x06Resten sonra konsola \x0Eretry \x06yazara yeninden bağlanın.");
		if(bilgiMesajiSayisi == 10)
			ServerCommand("sm_kick @all 15 Saniye sonra konsola retry yazarak yeniden giriniz.");
	}
	else
	{
		PrintToServer("----- Servera token bandan dolayı res atılıyor. -----");
		PrintToChatAll(" \x02[DrK # GaminG] \x0CServer'a restart atılıyor.");
		ServerCommand("_restart");
	}
}