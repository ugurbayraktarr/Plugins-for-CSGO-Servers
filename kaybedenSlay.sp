#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

new Handle:g_PluginTagi = INVALID_HANDLE;

public Plugin:myinfo =
{
	name        = "Kaybeden Takımı Slaylama",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

static int kazanan;

public OnPluginStart() 
{
	HookEvent("round_end", Event_RoundEnd);
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");
}

public void Event_RoundEnd(Handle event, const char[] name, bool dontBroadcast)
{
	kazanan = GetEventInt(event, "winner");
	CreateTimer(0.5, SlayAT);
}

public Action SlayAT(Handle timer)
{
	if(kazanan > 1)
	{
		new i;
		for(i=1; i<MaxClients; i++)
		{
			if(IsClientInGame(i))
			{
				if(IsPlayerAlive(i))
				{
					if(GetClientTeam(i) != kazanan)
					{
						new String:sPluginTagi[64];
						GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
						
						PrintToChat(i, " \x02[%s] \x0BKarşı takım kazandığı için öldürüldünüz!", sPluginTagi);
						ForcePlayerSuicide(i);
					}
				}
			}
		}
	}
	kazanan = 0;
}