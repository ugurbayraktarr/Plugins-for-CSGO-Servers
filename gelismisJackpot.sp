#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <store>

public Plugin:myinfo =
{
	name        = "Jackpot Sistemi",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

bool oyunOynaniyor;
new toplamMiktar;
new oyuncuYatirilanMiktar[MAXPLAYERS+1];
new const String:FULL_SOUND_PATH[] = "sound/misc/drkozelses/nahalirsinyavrummm.mp3";
new const String:RELATIVE_SOUND_PATH[] = "*/misc/drkozelses/nahalirsinyavrummm.mp3";
new Handle:g_PluginTagi = INVALID_HANDLE;

public OnPluginStart() 
{
	RegConsoleCmd("sm_jackpot", JackpotKomutu, "Jackport oynamanızı sağlar");
	CreateTimer(134.0, jackpotReklam, _,TIMER_REPEAT);
	
	HookEvent("round_start", Event_RoundStart);
	HookEvent("round_end", Event_RoundEnd);
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
}

public OnMapStart()
{
	AddFileToDownloadsTable( FULL_SOUND_PATH );
	FakePrecacheSound( RELATIVE_SOUND_PATH );
}

stock FakePrecacheSound( const String:szPath[] )
{
	AddToStringTable( FindStringTable( "soundprecache" ), szPath );
}

public Action:Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast) 
{
	oyunOynaniyor = true;
	toplamMiktar = 0;
	for(new i=1;i<MAXPLAYERS+1;i++)
		oyuncuYatirilanMiktar[i] = 0;
}

public Action:Event_RoundEnd(Handle:event, const String:name[], bool:dontBroadcast) 
{
	oyunOynaniyor = false;
	new random = GetRandomInt(1, toplamMiktar);
	new altDeger = 1;
	new ustDeger;
	new kazanan;
	
	if(toplamMiktar != 0)
	{
		for(new i=1;i<MAXPLAYERS+1;i++)
		{
			ustDeger = altDeger + oyuncuYatirilanMiktar[i];
			if(altDeger <= random && random < ustDeger)
			{
				kazanan = i;
			}
			altDeger = ustDeger;
		}
		CreateTimer(1.5, Bekleme, kazanan);
	}
}

public Action Bekleme(Handle timer, any kazanan)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	for(new i=1;i<MAXPLAYERS;i++)
	{
		if(!IsClientConnected(i)) continue;
		if(!IsClientInGame(i)) continue;
		
		if(i == kazanan)
		{
			float kazanmaSansi;
			kazanmaSansi = float(oyuncuYatirilanMiktar[i] * 100) / toplamMiktar;
			//int kesinti;
			//kesinti = toplamMiktar / 10;
			//toplamMiktar = toplamMiktar - kesinti;
			PrintToChatAll(" \x02[%s] \x0E!jackpot \x01oyunu kazananı: \x10%N \x0C(%%%.2f şans ile)", sPluginTagi, i, kazanmaSansi);
			PrintCenterTextAll("<font color='#00FFFF'>Jackpot Ödülü: 「 %d TL」</font>\n<font color='#00FF00'>Kazanan:</font> <font color='#FF0000'>%N</font>", toplamMiktar, i);
			PrintToChatAll(" \x02[%s] \x06Kazanılan miktar: \x04%d TL", sPluginTagi, toplamMiktar);
			TLVer(i, toplamMiktar);
		}
		else
		{
			if(oyuncuYatirilanMiktar[i] != 0)
				EmitSoundToClient(i, RELATIVE_SOUND_PATH);
		}
	}
}

public Action:jackpotReklam(Handle:timer)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	PrintToChatAll(" \x02[%s] \x0E!jackpot \x01yazarak \x0Ejackpot oyunu \x01hakkında bilgi alabilirsiniz.", sPluginTagi);
	return Plugin_Continue;
}

public Action JackpotKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	if(args == 0)
	{
		Bilgi(client);
		return Plugin_Handled;
	}
	if(args > 1)
	{
		PrintToChat(client, " \x02[%s] \x04Hatalı Giriş!", sPluginTagi);
		PrintToChat(client, " \x02[%s] \x04Kullanım: \x0E!jackpot <miktar>", sPluginTagi);
		return Plugin_Handled;
	}
	else
	{
		if(!oyunOynaniyor)
		{
			PrintToChat(client, " \x02[%s] \x04Şuan jackpot oynayamazsınız.", sPluginTagi);
			return Plugin_Handled;
		}
		decl String:sMiktar[16];
		GetCmdArg(1, sMiktar, sizeof(sMiktar));
		new iMiktar = StringToInt(sMiktar);
		
		if(Store_GetClientCredits(client) < iMiktar)
		{
			PrintToChat(client, " \x02[%s] \x0EJackpot oynayabilmek için \x02%d TL\x0E'niz bulunmuyor.", sPluginTagi, iMiktar);
			return Plugin_Handled;
		}
		else
		{
			if((iMiktar < 1 || iMiktar > 20000))
			{
				PrintToChat(client, " \x02[%s] \x04Jackpot için \x061-20.000 \x04Arası değer girmeniz gerekiyor.", sPluginTagi);
				return Plugin_Handled;
			}
			if((oyuncuYatirilanMiktar[client] + iMiktar > 20000))
			{
				PrintToChat(client, " \x02[%s] \x04Bir elde en fazla \x0620.000 TL\x04'lik jackpot oynayabilirsiniz.", sPluginTagi);
				return Plugin_Handled;
			}
			TLVer(client, (-1 * iMiktar));
			oyuncuYatirilanMiktar[client] += iMiktar;
			toplamMiktar += iMiktar;
			float kazanmaSansi;
			kazanmaSansi = float(oyuncuYatirilanMiktar[client] * 100) / toplamMiktar;
			PrintToChatAll(" \x02[%s] \x10%N\x06 jackpota \x04%d TL yatırdı. \x0E(%%%.2f şans)", sPluginTagi, client, iMiktar, kazanmaSansi);
			for(new i=1;i<MAXPLAYERS+1;i++)
			{
				if(oyuncuYatirilanMiktar[i] != 0)
				{
					kazanmaSansi = float(oyuncuYatirilanMiktar[i] * 100) / toplamMiktar;
					PrintToChat(i, " \x07Sizin şuanki şansınız: \x10%%%.2f", kazanmaSansi);
				}
			}
		}
	}
	return Plugin_Continue;
}

Bilgi(client)
{
	new Handle:menu = CreateMenu(jackpot, MenuAction_Select | MenuAction_End);
	SetMenuTitle(menu, "Jackpot Bilgilendirme");

	AddMenuItem(menu, "1", "Jackpot oynamak için 1-20.000 TL arası girebilirsiniz");
	AddMenuItem(menu, "2", "İstediğiniz miktarı girebilirsiniz");
	AddMenuItem(menu, "3", "Örnek: !jackpot 7000");
	AddMenuItem(menu, "4", "Jackpot sonuçları el sonu açıklanır");
	AddMenuItem(menu, "5", "Ödül: Jackpot'a yatırılan miktarın tamamı");

	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public jackpot(Handle:menu, MenuAction:action, param1, param2)
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
		}

		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);
		}
	}
}



TLVer(int client, int kazanma)
{
	Store_SetClientCredits(client, (Store_GetClientCredits(client) + kazanma));
}