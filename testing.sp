#pragma semicolon 1

#include <sourcemod>
#include <cstrike>

public Plugin:myinfo = 
{
	name = "TEST",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "1.0"
}

public OnPluginStart()
{
	CreateTimer(2.0, TekrarlayanTimer1, _, TIMER_REPEAT);
	CreateTimer(6.0, TekrarlayanTimer2, _, TIMER_REPEAT);
	CreateTimer(7.0, BaslaTimer);
}

public Action BaslaTimer(Handle timer)
{
	ServerCommand("mp_freezetime 60");
	ServerCommand("mp_roundtime_defuse 1");
	ServerCommand("mp_roundtime 1");
	ServerCommand("mp_roundtime_hostage 1");
	ServerCommand("sv_alltalk 1");
	ServerCommand("sv_deadtalk 1");
}

public Action TekrarlayanTimer1(Handle timer)
{
	PrintCenterTextAll(" <font color='#FF0000'>DrK # GaminG Taşındı!</font>\n<font color='#00FFFF'>Lütfen yeni ip'ye gelin");	
}


public Action TekrarlayanTimer2(Handle timer)
{
	PrintToChatAll(" ");
	PrintToChatAll(" \x02Lag sorunlarından dolayı DrK # GaminG Taşındı!");
	PrintToChatAll(" \x07Lütfen Yeni IP Adresimize girin");
	PrintToChatAll(" \x02Konsola şu şekilde yazın:");
	PrintToChatAll(" \x04 connect 95.173.166.51");
	PrintToChatAll(" \x02Yeni serverı favorilere eklemeyi unutmayın");
	PrintToChatAll(" \x10 DrK # GaminG , iyi eğlenceler diler..");
}