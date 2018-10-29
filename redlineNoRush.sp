#include <sdkhooks>
#include <sdktools>

new elBasiZaman;
bool pushKaldirildi;

public Plugin:myinfo =
{
	name        = "Aim Redline Rush Engelleyici",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

new Handle:g_PluginTagi = INVALID_HANDLE;

public OnPluginStart() 
{
	RegConsoleCmd("sm_test", TEST);
	HookEvent("round_start", RoundStart);
	CreateTimer(1.0, SurekliTimer, _,TIMER_REPEAT);
	pushKaldirildi = false;
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
}

public OnMapStart()
{
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	
	//if(!((StrContains(mapName, "jb_", false) != -1) || (StrContains(mapName, "jail_", false)!= -1)))
	if(!(StrEqual(mapName, "aim_redline_norush", false)))
	{
		SetFailState("Bu plugin sadece redline ozel mapinda çalışmaktadır.");
	}
}


public Action:TEST( client, args )
{
	PushKaldir();
}

public Action:RoundStart(Handle:event, const String:name[], bool:dontBroadcast) 
{
	elBasiZaman = GetTime();
	pushKaldirildi = false;
}

public Action:SurekliTimer(Handle:timer)
{
	if(!pushKaldirildi)
	{
		new yasayanTSayisi, yasayanCTSayisi, i;
		
		for(i=1;i<=MaxClients;i++)
		{
			if(!IsClientConnected(i)) continue;
			if(!IsClientInGame(i)) continue;
			if(IsPlayerAlive(i))
			{
				if(GetClientTeam(i) == 2)
					yasayanTSayisi++;
				else if(GetClientTeam(i) == 3)
					yasayanCTSayisi++;
			}
		}
		if(yasayanCTSayisi <= 1 || yasayanTSayisi <= 1)
		{
			PushKaldir();
		}
		if(elBasiZaman + 60 <= GetTime())
		{
			PushKaldir();
		}
	}
}

void PushKaldir()
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	PrintCenterTextAll("<font color='#FF0000'>[%s]<font> <font color='#00FF00'>Engeller kaldırılmıştır.</font>", sPluginTagi);
	for(new i=1; i<=2048; i++)
	{
		if(IsValidEntity(i))
		{
			decl String:entityIsmi[128];
			GetEntityClassname(i, entityIsmi, sizeof(entityIsmi));
			if(StrEqual(entityIsmi, "trigger_push", false))
			{
				AcceptEntityInput(i, "Kill");
			}
		}
	}
}