#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <CustomPlayerSkins>

#define PLUGIN_VERSION "2.0"

public Plugin:myinfo =
{
	name        = "Özel Glow Yapıcı",
	author      = "ImPossibLe`",
	description = "PROOYUNCU",
	version     = PLUGIN_VERSION,
};

public OnPluginStart() 
{
	int ips[4];
	char serverip[32];
	int ip = GetConVarInt(FindConVar("hostip"));
	ips[0] = (ip >> 24) & 0x000000FF;
	ips[1] = (ip >> 16) & 0x000000FF;
	ips[2] = (ip >> 8) & 0x000000FF;
	ips[3] = ip & 0x000000FF;
	
	Format(serverip, sizeof(serverip), "%d.%d.%d", ips[0], ips[1], ips[2]);
	if(StrEqual(serverip, "185.188.144") == false || ips[3] < 2 || ips[3] > 129)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	
	RegAdminCmd("sm_takimyap", CommandTakimYap, ADMFLAG_GENERIC, "Yaşayan T'leri 2 takıma ayırarak glow verir.");
	RegAdminCmd("sm_takimboz", CommandTakimBoz, ADMFLAG_GENERIC, "Takımları iptal eder.");
}

static int oyuncuTakimDurumu[MAXPLAYERS + 1];

public Action:OnSetTransmit0(entity, client)
{
	// Dont show custom player skins if player is not observing/using ESP
	return Plugin_Continue;
}
public Action:OnSetTransmit1(entity, client)
{
	// Dont show custom player skins if player is not observing/using ESP
	if(oyuncuTakimDurumu[client] == 1)
		return Plugin_Continue;
	else
		return Plugin_Handled;
}
public Action:OnSetTransmit2(entity, client)
{
	// Dont show custom player skins if player is not observing/using ESP
	if(oyuncuTakimDurumu[client] == 2)
		return Plugin_Continue;
	else
		return Plugin_Handled;
}


public Action:CommandTakimBoz(client, args)
{
	TakimKapat();
}

void TakimKapat()
{
	new i;
	for(i=1; i<=MaxClients; i++)
	{
		new entity;
		if(IsClientInGame(i))
		{
			CPS_RemoveSkin(i);
			entity = CPS_GetSkin(i);
		}
		if(entity > 0)
			SetEntProp(entity, Prop_Send, "m_bShouldGlow", false, true);
	}
	PrintToChatAll(" \x02[DrK # GaminG] \x10T'lerin takımları bozuldu!");
	//PrintToChatAll("TEST");
}

public Action:CommandTakimYap(client, args)
{
	if(args != 0)
	{
		PrintToChat(client, " \x02[DrK # GaminG] \x10Kullanım: \x04!takimayir");
		return Plugin_Handled;
	}
	
	new yasayanTSayisi, i, takimNumarasi[MaxClients];
	for(i=1;i<=MaxClients;i++)
	{
		oyuncuTakimDurumu[i] = 0;
		if(IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
		{
			if(GetClientTeam(i) == 2 && IsPlayerAlive(i))
				yasayanTSayisi++;
		}
	}
	if((yasayanTSayisi % 2) != 0)
	{
		PrintToChat(client, " \x02[DrK # GaminG] \x10Bu komutu kullanabilmek için yaşayan T sayısı \x04çift sayıda \x10olmalıdır.");
		return Plugin_Handled;
	}
	PrintToChatAll(" \x02[DrK # GaminG] \x10T'ler 2 farklı takıma ayrıldı!");
	new j;
	for(i=1;i<=MaxClients;i++)
	{
		if(IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
		{
			if(GetClientTeam(i) == 2 && IsPlayerAlive(i))
			{
				takimNumarasi[i] = (j % 2) + 1;
				oyuncuTakimDurumu[i] = (j % 2) + 1;
				j++;
			}
			else
				takimNumarasi[i] = 3;
		}
	}
	
	
	for(i=1;i<=MaxClients;i++)
	{
		if(IsClientConnected(i) && IsClientInGame(i) && !IsFakeClient(i))
		{
			//PrintToChatAll("YEŞİL T TEST1");
			decl String:model[PLATFORM_MAX_PATH];

			// Retrieve current player model
			GetClientModel(i, model, sizeof(model));

			// Remove old custom skin and create a new one with same model as player
			CPS_RemoveSkin(i); // Does not make the model invisible. (useful for glows) (c) CustomPlayerSkins.inc file
			CPS_SetSkin(i, model, CPS_RENDER);
			
			// Retrieve skin entity from core plugin
			new skin = CPS_GetSkin(i);

			if(GetClientTeam(i) == 2 && IsPlayerAlive(i))
			{
				//if(takimNumarasi[i] == 1)
				{
					if (SDKHookEx(skin, SDKHook_SetTransmit, OnSetTransmit0))
					{
						// Declare convar strings to properly colorize players
						decl String:color[16], String:pieces[4][sizeof(color)];

						// Get values from plugin convars
						switch (takimNumarasi[i])
						{
							case 1: color = "255 0 0 255";
							case 2: color = "0 255 0 255";
						}

						// Get rid of spaces to get all the RGBA values
						if (ExplodeString(color, " ", pieces, sizeof(pieces), sizeof(pieces[])) == 4)
						{
							// Enable glow on prop_physics_override entity, aka custom player skin
							SetupGlow(skin, StringToInt(pieces[0]), StringToInt(pieces[1]), StringToInt(pieces[2]), StringToInt(pieces[3]));
						}
						if(takimNumarasi[i] == 1)
							{
								PrintCenterText(i, "<font color='#00FFFF'>Renginiz:</font>\n<font color='#FF0000'>!! KIRMIZI !!");
							}
							else if(takimNumarasi[i] == 2)
							{
								PrintCenterText(i, "<font color='#00FFFF'>Renginiz:</font>\n<font color='#00FF00'>!! YEŞİL !!");
							}
					}
				}
			}
		}
	}
	return Plugin_Continue;
}
SetupGlow(entity, r, g, b, a)
{
	static offset;

	// Get sendprop offset for prop_dynamic_override
	if (!offset && (offset = GetEntSendPropOffs(entity, "m_clrGlow")) == -1)
	{
		LogError("Unable to find property offset: \"m_clrGlow\"!");
		return;
	}

	// Enable glow for custom skin
	SetEntProp(entity, Prop_Send, "m_bShouldGlow", true, true);

	// So now setup given glow colors for the skin
	SetEntData(entity, offset, r, _, true);    // Red
	SetEntData(entity, offset + 1, g, _, true); // Green
	SetEntData(entity, offset + 2, b, _, true); // Blue
	SetEntData(entity, offset + 3, a, _, true); // Alpha
}