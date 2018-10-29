#include <sourcemod>
#include <sdktools>
#include <sdkhooks>

#define PLUGIN_VERSION "1.0"

new g_Player_Manager = 0;
new zaman;


public Plugin:myinfo =
{
	name = "Ping Düzenleyici",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "1.0"
};


public OnMapStart()
{
	zaman = GetTime() - 1
	g_Player_Manager = FindEntityByClassname(-1, "cs_player_manager");
}

public OnClientPutInServer(Client)
{
	SDKHook(Client, SDKHook_PreThinkPost, OnPreThinkPost);
}

//public OnGameFrame()
public OnPreThinkPost(client)
{
	if(zaman <= GetTime())
	{
		//if(JoinCheck(client))
		{
			if(IsValidEdict(g_Player_Manager))
			{
				for(new i = 1; i <= MaxClients; i++)
				{
					if(IsClientConnected(i) && !IsFakeClient(i))
					{
						new Float:Ping = 20.0;
						if(JoinCheck(i))
							Ping = GetClientAvgLatency(i, NetFlow_Outgoing) * 1024;
						Ping = Ping / 4.5;
						int iPing;
						decl String:sPing[5];
						FloatToString(Ping, sPing, sizeof(sPing));
						iPing = StringToInt(sPing);
						//SetEntProp(g_Player_Manager, Prop_Send, "m_iPing", 0, _, i);
						if(JoinCheck(i))
						{
							SetEntProp(g_Player_Manager, Prop_Send, "m_iPing", iPing, _, i);
							//PrintToChat(i, "TEST: %.6f", ping2);
						}
					}
				}
			}
		}
		zaman = GetTime() + 1;
	}
}

stock bool:JoinCheck(Client)
{
	if(Client > 0 && Client <= MaxClients)
	{
		if(IsClientConnected(Client) == true)
		{
			if(IsClientInGame(Client) == true)
			{
				return true;
			}
			else return false;
		}
		else return false;
	}
	else return false;
}