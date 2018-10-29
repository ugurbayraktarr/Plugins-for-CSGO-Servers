#include <sourcemod> 
#include <cstrike>
#include <sdktools>
#pragma semicolon 1 

public Plugin:myinfo = 
{ 
    name        = "Takım Karıştırma Sistemi", 
    author      = "ImPossibLe`", 
    description = "DrK # GaminG", 
    version     = "2.0", 
};

new Handle:g_PluginTagi = INVALID_HANDLE;

new sonKazananTakim;
new kacElKazandi;
new tSiralama[MAXPLAYERS+1][2];
new ctSiralama[MAXPLAYERS+1][2];
new const String:FULL_SOUND_PATH[] = "sound/drkgaming/karistir.mp3";
new const String:RELATIVE_SOUND_PATH[] = "*/drkgaming/karistir.mp3";
new tSayisi, ctSayisi;
bool karistirilacak = false;

public OnPluginStart()
{
	int ips[4];
	char serverip[32];
	int ip = GetConVarInt(FindConVar("hostip"));
	int port = GetConVarInt(FindConVar("hostport"));
	ips[0] = (ip >> 24) & 0x000000FF;
	ips[1] = (ip >> 16) & 0x000000FF;
	ips[2] = (ip >> 8) & 0x000000FF;
	ips[3] = ip & 0x000000FF;
	
	Format(serverip, sizeof(serverip), "%d.%d.%d", ips[0], ips[1], ips[2], ips[3]);
	if(StrEqual(serverip, "185.188.144") == false || ips[3] < 2 || ips[3] > 129)
	{
		LogError("Bu plugin ImPossibLe` tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");

	AddFileToDownloadsTable( FULL_SOUND_PATH );
	FakePrecacheSound( RELATIVE_SOUND_PATH );
	
	RegAdminCmd("sm_karistir", KaristirKomutu, ADMFLAG_GENERIC, "Takımları Karıştırır.");
	HookEvent("round_end", RoundEnd);
	HookEvent("round_start", RoundStart);
}

public OnMapStart()
{
	sonKazananTakim = 0;
	kacElKazandi = 0;
	karistirilacak = false;
	AddFileToDownloadsTable( FULL_SOUND_PATH );
	FakePrecacheSound( RELATIVE_SOUND_PATH );
}

stock FakePrecacheSound( const String:szPath[] )
{
	AddToStringTable( FindStringTable( "soundprecache" ), szPath );
}

public Action:KaristirKomutu(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	PrintToChatAll(" \x02[%s] \x10%N \x07el sonu takımların karıştırılmasını ayarladı.", sPluginTagi, client);
	karistirilacak = true;
	/*if(sonKazananTakim > 1)
		TakimlariKaristir(sonKazananTakim);
	else
		TakimlariKaristir(GetRandomInt(2,3));*/
}

public Action:RoundStart(Handle: event , const String: name[] , bool: dontBroadcast)
{
	if(GetTeamScore(2) == 0 && GetTeamScore(3) == 0)
	{
		sonKazananTakim = 0;
		kacElKazandi = 0;
	}
	karistirilacak = false;
}

public Action:RoundEnd(Handle: event , const String: name[] , bool: dontBroadcast)
{
	new kisiSay = 0;
	for(new i = 1; i<=MaxClients; i++)
	{
		if(IsClientInGame(i))
		{
			if(IsClientConnected(i) && GetClientTeam(i) > 1)
			{
				kisiSay++;
			}
		}
	}
	
	if(kisiSay >= 10)
	{
		new simdikiKazanan = GetEventInt(event, "winner");
		if(sonKazananTakim > 1)
		{
			if(simdikiKazanan == sonKazananTakim)
			{
				kacElKazandi++;
				
				if(kacElKazandi >= 5 || karistirilacak)
				{
					new Float:fDelay;
					new Handle:g_hCvarDelay = INVALID_HANDLE;
					g_hCvarDelay = FindConVar("mp_round_restart_delay");

					if (g_hCvarDelay != INVALID_HANDLE)
					{
						fDelay = GetConVarFloat(g_hCvarDelay);
					} 
					fDelay = fDelay - 2.5;
					CreateTimer(fDelay, TakimKaristir);
				}
			}
		}
		sonKazananTakim = simdikiKazanan;
	}
}

public Action TakimKaristir(Handle timer)
{
	TakimlariKaristir(sonKazananTakim);
}

void TakimlariKaristir(int simdikiKazanan)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	tSayisi = 0;
	ctSayisi = 0;
	
	if(simdikiKazanan > 1)
	{
		new j, k;
		for(new i=1; i<=MaxClients;i++)
		{
			if(!IsClientConnected(i) || !IsClientInGame(i) || IsFakeClient(i)) continue;
			if(GetClientTeam(i) == 2)
			{
				tSiralama[j][0] = i;
				tSiralama[j][1] = CS_GetClientContributionScore(i);
				j++;
				tSayisi++;
			}
			else if(GetClientTeam(i) == 3)
			{
				ctSiralama[k][0] = i;
				ctSiralama[k][1] = CS_GetClientContributionScore(i);
				k++;
				ctSayisi++;
			}
		}
		siralaT2();
		siralaCT2();
		
		new sayi = ctSayisi;
		if(tSayisi < ctSayisi)
			sayi = tSayisi;
		sayi = sayi / 2;
		
		new a = 1;
		if(simdikiKazanan == 2)
		{
			for(new x=tSayisi-1; x>=sayi;x--)
			{
				if((a % 2) == 1)
				{
					if(tSiralama[x][0] == 0) continue;
					if(GetClientTeam(tSiralama[x][0]) < 2) continue;
					if(!IsClientConnected(tSiralama[x][0]) || !IsClientInGame(tSiralama[x][0]) || IsFakeClient(tSiralama[x][0])) continue;
					CS_SwitchTeam(tSiralama[x][0], 3);
					PrintToChat(tSiralama[x][0], " \x02[%s] \x10Takım karıştırılması için \x0CCT'ye \x10atıldınız.", sPluginTagi);
				}
				else
				{
					if(ctSiralama[x][0] == 0) continue;
					if(GetClientTeam(tSiralama[x][0]) < 2) continue;
					if(!IsClientConnected(ctSiralama[x][0]) || !IsClientInGame(ctSiralama[x][0]) || IsFakeClient(ctSiralama[x][0])) continue;
					CS_SwitchTeam(ctSiralama[x][0], 2);
					PrintToChat(ctSiralama[x][0], " \x02[%s] \x10Takım karıştırılması için \x02T'ye \x10atıldınız.", sPluginTagi);
				}
				a++;
			}
		}
		else if(simdikiKazanan == 3)
		{
			for(new x=tSayisi-1; x>=sayi;x--)
			{
				if((a % 2) == 1)
				{
					if(ctSiralama[x][0] == 0) continue;
					if(!IsClientConnected(ctSiralama[x][0]) || !IsClientInGame(ctSiralama[x][0]) || IsFakeClient(ctSiralama[x][0])) continue;
					CS_SwitchTeam(ctSiralama[x][0], 2);
					PrintToChat(ctSiralama[x][0], " \x02[%s] \x10Takım karıştırılması için \x02T'ye \x10atıldınız.", sPluginTagi);
				}
				else
				{
					if(tSiralama[x][0] == 0) continue;
					if(!IsClientConnected(tSiralama[x][0]) || !IsClientInGame(tSiralama[x][0]) || IsFakeClient(tSiralama[x][0])) continue;
					CS_SwitchTeam(tSiralama[x][0], 3);
					PrintToChat(tSiralama[x][0], " \x02[%s] \x10Takım karıştırılması için \x0CCT'ye \x10atıldınız.", sPluginTagi);
				}
				a++;
			}
		}
		EmitSoundToAll(RELATIVE_SOUND_PATH);
		CreateTimer(1.5, MesajVer);
	}
}

public Action MesajVer(Handle timer)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	sonKazananTakim = 0;
	kacElKazandi = 0;
	PrintToChatAll(" \x02[%s] \x04Takımlar Karıştırılmıştır.", sPluginTagi);
}

/*void siralaT() 
{
	bool swapped = true;
	int j = 0;
	int tmp, tmp2;
	int n = 64;
	while (swapped)
	{
		swapped = false;
		j++;
		for (int i = 1; i <= n - j; i++)
		{
			if (tSiralama[i][1] > tSiralama[i + 1][1])
			{
				tmp = tSiralama[i][0];
				tmp2 = tSiralama[i][1];
				tSiralama[i][0] = tSiralama[i + 1][0];
				tSiralama[i][1] = tSiralama[i + 1][1];
				tSiralama[i + 1][0] = tmp;
				tSiralama[i + 1][1] = tmp2;
				swapped = true;
			}
		}
	}
}

void siralaCT() 
{
	bool swapped = true;
	int j = 0;
	int tmp, tmp2;
	int n = 64;
	while (swapped)
	{
		swapped = false;
		j++;
		for (int i = 1; i <= n - j; i++)
		{
			if (ctSiralama[i][1] > ctSiralama[i + 1][1])
			{
				tmp = ctSiralama[i][0];
				tmp2 = ctSiralama[i][1];
				ctSiralama[i][0] = ctSiralama[i + 1][0];
				ctSiralama[i][1] = ctSiralama[i + 1][1];
				ctSiralama[i + 1][0] = tmp;
				ctSiralama[i + 1][1] = tmp2;
				swapped = true;
			}
		}
	}
}*/

void siralaT2()
{
	new n = tSayisi;
	new tmp, tmp2;
	new min;
	
	for(new i=0; i < n-1; i++)
	{
		min=i;
		
		for(new j=i; j < n; j++)
		{
			if (tSiralama[j][1] < tSiralama[min][1])
			{
				min=j;
			}
		}
		tmp = tSiralama[i][1];
		tmp2 = tSiralama[i][0];
		
		tSiralama[i][1]=tSiralama[min][1];
		tSiralama[i][0]=tSiralama[min][0];
		
		tSiralama[min][1]=tmp;
		tSiralama[min][0]=tmp2;
	}
}

void siralaCT2()
{
	new n = ctSayisi;
	new tmp, tmp2;
	new min;
	
	for(new i=0; i < n-1; i++)
	{
		min=i;
		
		for(new j=i; j < n; j++)
		{
			if (ctSiralama[j][1] < ctSiralama[min][1])
			{
				min=j;
			}
		}
		tmp = ctSiralama[i][1];
		tmp2 = ctSiralama[i][0];
		
		ctSiralama[i][1]=ctSiralama[min][1];
		ctSiralama[i][0]=ctSiralama[min][0];
		
		ctSiralama[min][1]=tmp;
		ctSiralama[min][0]=tmp2;
	}
}
