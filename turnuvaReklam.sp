#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.0"


public Plugin:myinfo =
{
	name        = "Turnuva Reklamı",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

public OnPluginStart() 
{
	HookEvent("player_death",  Event_Player_Death);
}

public Event_Player_Death(Handle:event, const String:name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "userid"));
	
	CreateTimer(0.1, Yazdir, victim);
	CreateTimer(1.0, Yazdir, victim);
	CreateTimer(2.0, Yazdir, victim);
	CreateTimer(3.0, Yazdir, victim);
	PrintToChat(victim, " \x04Takım turnuvaları yapılacaktır.");
	PrintToChat(victim, " \x02TS3 \x10Üzerinden kayıt yapabilirsiniz..");
	PrintToChat(victim, " \x04Ödül: \x025x AWP | Kırmızı Çizgi (Görevde Kullanılmış)");
	PrintToChat(victim, " \x04Son kayıt: \x02Bugün \x04Saat: \x1018:00");
}

public Action Yazdir(Handle timer, any client)
{
	PrintCenterText(client, "<font color='#00FF00'>Ödüllü turnuva yapılacaktır.\n<font color='#FF0000'>TS3 <font color='#00FFFF'>Üzerinden kayıt yapabilirsiniz.</font>");
}