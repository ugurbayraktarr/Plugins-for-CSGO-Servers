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
new sonKazananTakim;
new kacElKazandi;
new tSiralama[MAXPLAYERS+1][2];
new ctSiralama[MAXPLAYERS+1][2];
new komutUygulayan;
new tSayisi, ctSayisi;

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
	
	RegAdminCmd("sm_takimtest", KaristirKomutu, ADMFLAG_GENERIC, "Takımları Karıştırır.");
}

stock FakePrecacheSound( const String:szPath[] )
{
	AddToStringTable( FindStringTable( "soundprecache" ), szPath );
}

public Action:KaristirKomutu(client, args)
{
	komutUygulayan = client;
	PrintToConsole(komutUygulayan, "TEST");
	TakimlariKaristir(2);
}

void TakimlariKaristir(int simdikiKazanan)
{
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
		
		j = 0;
		k = 0;
		
		/*for(new i=1; i<=MaxClients;i++)
		{
			if(!IsClientConnected(i) || !IsClientInGame(i) || IsFakeClient(i)) continue;
			if(GetClientTeam(i) == 2)
			{
				PrintToConsole(komutUygulayan, "T : %d - %N", tSiralama[j][1], tSiralama[j][0]);
				j++;
			}
			else if(GetClientTeam(i) == 3)
			{
				PrintToConsole(komutUygulayan, "CT: %d - %N", ctSiralama[k][1], ctSiralama[k][0]);
				k++;
			}
		}*/
		
		siralaT2();
		siralaCT2();
		
		j = 0;
		k = 0;
		
		for(new i=1; i<=MaxClients;i++)
		{
			if(!IsClientConnected(i) || !IsClientInGame(i) || IsFakeClient(i)) continue;
			if(GetClientTeam(i) == 2)
			{
				PrintToConsole(komutUygulayan, "T : %d - %N", tSiralama[j][1], tSiralama[j][0]);
				j++; 
			}
			else if(GetClientTeam(i) == 3)
			{
				PrintToConsole(komutUygulayan, "CT: %d - %N", ctSiralama[k][1], ctSiralama[k][0]);
				k++;
			}
		}
		
		PrintToConsole(komutUygulayan, "---------------------------------------------");
		for(new i=tSayisi-1; i>=tSayisi/2;i--)
		{
			
			PrintToConsole(komutUygulayan, "T : %d - %N", tSiralama[i][1], tSiralama[i][0]);
		}
		
		PrintToConsole(komutUygulayan, "---------------------------------------------");
		
		for(new i=ctSayisi-1; i>=ctSayisi/2;i--)
		{
			PrintToConsole(komutUygulayan, "CT : %d - %N", ctSiralama[i][1], ctSiralama[i][0]);
		}
		
		/*new sayi = ctSayisi;
		if(tSayisi < ctSayisi)
			sayi = tSayisi;
		sayi *= 2;*/
		
		
		/*if(simdikiKazanan == 2)
		{
			for(new x=1;x<=sayi;x++)
			{
				if((x % 2) == 1)
				{
					if(tSiralama[x][0] == 0) continue;
					if(!IsClientConnected(tSiralama[x][0]) || !IsClientInGame(tSiralama[x][0]) || IsFakeClient(tSiralama[x][0])) continue;
					CS_SwitchTeam(tSiralama[x][0], 3);
					PrintToChat(tSiralama[x][0], " \x02[DrK # GaminG] \x10Takım karıştırılması için \x0CCT'ye \x10atıldınız.");
				}
				else
				{
					if(ctSiralama[x][0] == 0) continue;
					if(!IsClientConnected(ctSiralama[x][0]) || !IsClientInGame(ctSiralama[x][0]) || IsFakeClient(ctSiralama[x][0])) continue;
					CS_SwitchTeam(ctSiralama[x][0], 2);
					PrintToChat(ctSiralama[x][0], " \x02[DrK # GaminG] \x10Takım karıştırılması için \x02T'ye \x10atıldınız.");
				}
			}
		}
		else if(simdikiKazanan == 3)
		{
			for(new x=1;x<=sayi;x++)
			{
				if((x % 2) == 1)
				{
					if(ctSiralama[x][0] == 0) continue;
					if(!IsClientConnected(ctSiralama[x][0]) || !IsClientInGame(ctSiralama[x][0]) || IsFakeClient(ctSiralama[x][0])) continue;
					CS_SwitchTeam(ctSiralama[x][0], 2);
					PrintToChat(ctSiralama[x][0], " \x02[DrK # GaminG] \x10Takım karıştırılması için \x02T'ye \x10atıldınız.");
				}
				else
				{
					if(tSiralama[x][0] == 0) continue;
					if(!IsClientConnected(tSiralama[x][0]) || !IsClientInGame(tSiralama[x][0]) || IsFakeClient(tSiralama[x][0])) continue;
					CS_SwitchTeam(tSiralama[x][0], 3);
					PrintToChat(tSiralama[x][0], " \x02[DrK # GaminG] \x10Takım karıştırılması için \x0CCT'ye \x10atıldınız.");
				}
			}
		}
		EmitSoundToAll(RELATIVE_SOUND_PATH);
		CreateTimer(1.5, MesajVer);*/
	}
}


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