#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Base'de bekleyenlere slap atma sistemi",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

new Float:roundBasiKonum[MAXPLAYERS+1][3];
new Float:tRoundBasiKonum[3];
new Float:ctRoundBasiKonum[3];
new Float:anlikKonum[MAXPLAYERS+1][3];
new Float:anlikFark[MAXPLAYERS+1];
new roundBasiZaman;
bool cikisYaptiMi[MAXPLAYERS+1];
new kisiyeGoreZaman = 65;

public OnPluginStart() 
{
	HookEvent("round_start", Event_Round_Start, EventHookMode_Pre);
	HookEvent("player_spawn", OnPlayerSpawn);
	CreateTimer(1.0, SurekliTimer, _, TIMER_REPEAT);
}

public OnMapStart()
{
	roundBasiZaman = GetTime();
}

public Action:Event_Round_Start(Handle:event, const String:name[], bool:dontBroadcast) 
{
	roundBasiZaman = GetTime();
	for(new i=1;i<=MaxClients;i++)
		cikisYaptiMi[i] = false;
	CreateTimer(2.0, OrtalamaHesapla);
	
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
	
	if(kisiSay < 34)
		kisiyeGoreZaman = 65;
	else if(kisiSay >= 34 && kisiSay < 44)
		kisiyeGoreZaman = 80;
	else if(kisiSay >= 44)
		kisiyeGoreZaman = 95;
}

public Action:OnPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	GetClientAbsOrigin(client, roundBasiKonum[client]);
}

/*public OnGameFrame()
{
	for(new i=1;i<=MaxClients;i++)
	{
		if(IsClientConnected(i) && IsClientInGame(i))
		{
			GetClientAbsOrigin(i, anlikKonum[i]);
			anlikFark[i] = GetVectorDistance(roundBasiKonum[i], anlikKonum[i]);
			PrintHintText(i, "%.0f, %.0f, %.0f<br>%.0f, %.0f, %.0f<br>%.2f", roundBasiKonum[i][0], roundBasiKonum[i][1], roundBasiKonum[i][2], anlikKonum[i][0], anlikKonum[i][1], anlikKonum[i][2], anlikFark[i]);
		}
	}
}*/

public Action:OrtalamaHesapla(Handle timer)
{
	new tSayac, ctSayac;
	new Float:tToplam[3];
	new Float:ctToplam[3];
	new Float:temp[3];
	
	for(new i=1;i<=MaxClients;i++)
	{
		if(IsClientConnected(i) && IsClientInGame(i) && IsPlayerAlive(i))
		{
			if(GetClientTeam(i) == 2)
			{
				GetClientAbsOrigin(i, temp);
				tToplam[0] += temp[0];
				tToplam[1] += temp[1];
				tToplam[2] += temp[2];
				tSayac++;
			}
			if(GetClientTeam(i) == 3)
			{
				GetClientAbsOrigin(i, temp);
				ctToplam[0] += temp[0];
				ctToplam[1] += temp[1];
				ctToplam[2] += temp[2];
				ctSayac++;
			}
		}
	}
	if(tSayac > 0)
	{
		tRoundBasiKonum[0] = tToplam[0] / tSayac;
		tRoundBasiKonum[1] = tToplam[1] / tSayac;
		tRoundBasiKonum[2] = tToplam[2] / tSayac;
	}
	if(ctSayac > 0)
	{
		ctRoundBasiKonum[0] = ctToplam[0] / tSayac;
		ctRoundBasiKonum[1] = ctToplam[1] / tSayac;
		ctRoundBasiKonum[2] = ctToplam[2] / tSayac;
	}
}

public Action:SurekliTimer(Handle timer)
{
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	new toplamSkor = GetTeamScore(2) + GetTeamScore(3);
	if(toplamSkor > 0 && (GetTeamScore(2) < 16 || GetTeamScore(3) < 16))
	{
		for(new i=1;i<=MaxClients;i++)
		{
			if(IsClientConnected(i) && IsClientInGame(i) && IsPlayerAlive(i))
			{
				GetClientAbsOrigin(i, anlikKonum[i]);
				if(GetClientTeam(i) == 2)
					anlikFark[i] = GetVectorDistance(tRoundBasiKonum, anlikKonum[i]);
				else if(GetClientTeam(i) == 3)
					anlikFark[i] = GetVectorDistance(ctRoundBasiKonum, anlikKonum[i]);
			}
			if(anlikFark[i] > 1800)
				cikisYaptiMi[i] = true;
				
			if(!IsClientInGame(i))
				continue;
			if(roundBasiZaman + kisiyeGoreZaman <= GetTime())
			{
				if(StrContains(mapName, "de_", false) != -1)
				{
					if(GetClientTeam(i) == 2)
					{
						if(!cikisYaptiMi[i])
						{
							if(IsPlayerAlive(i))
							{
								if(GetEntProp(i, Prop_Send, "m_iHealth") > 2)
								{
									if((GetTime() % 2) == 0)
									{
										PrintToChat(i, " \x02[DrK # GaminG] \x10Baseden uzaklaşmadığınız için canınız azaltılıyor.");
										PrintCenterText(i, "<b><font color='#FF8C00'>Baseden uzaklaşmadığınız için canınız azaltılıyor.</font></b>");
									}
									SetEntProp(i, Prop_Send, "m_iHealth", (GetEntProp(i, Prop_Send, "m_iHealth") - 2)); 
								}
							}
						}
					}
				}
				if(StrContains(mapName, "cs_", false) != -1)
				{
					if(GetClientTeam(i) == 3)
					{
						if(!cikisYaptiMi[i])
						{
							if(IsPlayerAlive(i))
							{
								if(GetEntProp(i, Prop_Send, "m_iHealth") > 2)
								{
									if((GetTime() % 2) == 0)
									{
										PrintToChat(i, " \x02[DrK # GaminG] \x10Baseden uzaklaşmadığınız için canınız azaltılıyor.");
										PrintCenterText(i, "<b><font color='#FF8C00'>Baseden uzaklaşmadığınız için canınız azaltılıyor.</font></b>");
									}
									SetEntProp(i, Prop_Send, "m_iHealth", (GetEntProp(i, Prop_Send, "m_iHealth") - 2)); 
								}
							}
						}
					}
				}
			}
		}
	}
}