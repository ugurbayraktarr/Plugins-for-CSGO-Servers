#include <sourcemod>
#include <sdktools>

public Plugin:myinfo = {

	name = "Jail Oyuncu Modelleri",
	author = "ImPossibLe`",
	version = "1.0",
	description = "DrK # GaminG"
};

new Handle:g_PluginTagi = INVALID_HANDLE;

new String:model1[256], String:model2[256], String:model3[256], String:model4[256], String:model5[256], String:model6[256], String:model7[256], String:model8[256], String:model9[256], String:model10[256], String:model11[256], String:model12[256];
new String:kol1[256], String:kol2[256], String:kol3[256], String:kol4[256], String:kol5[256], String:kol6[256], String:kol7[256], String:kol8[256], String:kol9[256], String:kol10[256], String:kol11[256], String:kol12[256];
bool ayilar[MAXPLAYERS+1];

new String:silahIsmi[MAXPLAYERS+1][10][32];

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
	
	g_PluginTagi		=	CreateConVar("drk_plugin_taglari", "DrK # GaminG", "Pluginlerin basinda olmasini istediginiz tagi giriniz( [] olmadan )");

	
	model1 = "models/player/custom_player/kuristaja/jailbreak/guard1/guard1.mdl";
	model2 = "models/player/custom_player/kuristaja/jailbreak/guard2/guard2.mdl";
	model3 = "models/player/custom_player/kuristaja/jailbreak/guard3/guard3.mdl";
	model4 = "models/player/custom_player/kuristaja/jailbreak/guard4/guard4.mdl";
	model5 = "models/player/custom_player/kuristaja/jailbreak/guard5/guard5.mdl";
	model6 = "models/player/custom_player/kuristaja/jailbreak/prisoner1/prisoner1.mdl";
	model7 = "models/player/custom_player/kuristaja/jailbreak/prisoner2/prisoner2.mdl";
	model8 = "models/player/custom_player/kuristaja/jailbreak/prisoner3/prisoner3.mdl";
	model9 = "models/player/custom_player/kuristaja/jailbreak/prisoner4/prisoner4.mdl";
	model10 = "models/player/custom_player/kuristaja/jailbreak/prisoner5/prisoner5.mdl";
	model11 = "models/player/custom_player/kuristaja/jailbreak/prisoner6/prisoner6.mdl";
	model12 = "models/player/custom_player/kuristaja/jailbreak/prisoner7/prisoner7.mdl";
	
	kol1 = "models/player/custom_player/kuristaja/jailbreak/guard1/guard1_arms.mdl";
	kol2 = "models/player/custom_player/kuristaja/jailbreak/guard2/guard2_arms.mdl";
	kol3 = "models/player/custom_player/kuristaja/jailbreak/guard3/guard3_arms.mdl";
	kol4 = "models/player/custom_player/kuristaja/jailbreak/guard4/guard4_arms.mdl";
	kol5 = "models/player/custom_player/kuristaja/jailbreak/guard5/guard5_arms.mdl";
	kol6 = "models/player/custom_player/kuristaja/jailbreak/prisoner1/prisoner1_arms.mdl";
	kol7 = "models/player/custom_player/kuristaja/jailbreak/prisoner2/prisoner2_arms.mdl";
	kol8 = "models/player/custom_player/kuristaja/jailbreak/prisoner3/prisoner3_arms.mdl";
	kol9 = "models/player/custom_player/kuristaja/jailbreak/prisoner4/prisoner4_arms.mdl";
	kol10 = "models/player/custom_player/kuristaja/jailbreak/prisoner5/prisoner5_arms.mdl";
	kol11 = "models/player/custom_player/kuristaja/jailbreak/prisoner6/prisoner6_arms.mdl";
	kol12 = "models/player/custom_player/kuristaja/jailbreak/prisoner7/prisoner7_arms.mdl";
	
	AddFileToDownloadsTable(model1);
	PrecacheModel(model1);
	AddFileToDownloadsTable(model2);
	PrecacheModel(model2);
	AddFileToDownloadsTable(model3);
	PrecacheModel(model3);
	AddFileToDownloadsTable(model4);
	PrecacheModel(model4);
	AddFileToDownloadsTable(model5);
	PrecacheModel(model5);
	AddFileToDownloadsTable(model6);
	PrecacheModel(model6);
	AddFileToDownloadsTable(model7);
	PrecacheModel(model7);
	AddFileToDownloadsTable(model8);
	PrecacheModel(model8);
	AddFileToDownloadsTable(model9);
	PrecacheModel(model9);
	AddFileToDownloadsTable(model10);
	PrecacheModel(model10);
	AddFileToDownloadsTable(model11);
	PrecacheModel(model11);
	AddFileToDownloadsTable(model12);
	PrecacheModel(model12);
	
	AddFileToDownloadsTable(kol1);
	PrecacheModel(kol1);
	AddFileToDownloadsTable(kol2);
	PrecacheModel(kol2);
	AddFileToDownloadsTable(kol3);
	PrecacheModel(kol3);
	AddFileToDownloadsTable(kol4);
	PrecacheModel(kol4);
	AddFileToDownloadsTable(kol5);
	PrecacheModel(kol5);
	AddFileToDownloadsTable(kol6);
	PrecacheModel(kol6);
	AddFileToDownloadsTable(kol7);
	PrecacheModel(kol7);
	AddFileToDownloadsTable(kol8);
	PrecacheModel(kol8);
	AddFileToDownloadsTable(kol9);
	PrecacheModel(kol9);
	AddFileToDownloadsTable(kol10);
	PrecacheModel(kol10);
	AddFileToDownloadsTable(kol11);
	PrecacheModel(kol11);
	AddFileToDownloadsTable(kol12);
	PrecacheModel(kol12);

	HookEvent("player_spawn", EventPlayerSpawn);
	RegAdminCmd("sm_hpayi", HPAyi, ADMFLAG_GENERIC, "Ayılara 150 HP, diger oyunculara 100 HP verir.");
}

public OnMapStart()
{
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	
	if(!((StrContains(mapName, "jb_", false) != -1) || (StrContains(mapName, "jail_", false)!= -1)))
	{
		SetFailState("Bu plugin sadece jail maplarinda calismaktadir..");
	}
}

public EventPlayerSpawn(Handle:event,const String:name[],bool:dontBroadcast)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	
	new client;
	client = GetClientOfUserId(GetEventInt(event, "userid"));
	if (!IsFakeClient(client))
	{
		new team = GetClientTeam(client);
		if (team == 3)
		{
			new sans = GetRandomInt(1,5);
			if(sans == 1)
			{
				SetEntityModel(client, model1); 
				SetEntPropString(client, Prop_Send, "m_szArmsModel", kol1);
				ayilar[client] = false;
			}
			else if(sans == 2)
			{
				SetEntityModel(client, model2); 
				SetEntPropString(client, Prop_Send, "m_szArmsModel", kol2);
				ayilar[client] = false;
			}
			else if(sans == 3)
			{
				SetEntityModel(client, model3); 
				SetEntPropString(client, Prop_Send, "m_szArmsModel", kol3);
				ayilar[client] = false;
			}
			else if(sans == 4)
			{
				SetEntityModel(client, model4); 
				SetEntPropString(client, Prop_Send, "m_szArmsModel", kol4);
				ayilar[client] = false;
			}
			else if(sans == 5)
			{
				SetEntityModel(client, model5); 
				SetEntPropString(client, Prop_Send, "m_szArmsModel", kol5);
				ayilar[client] = false;
			}			
		}
		else if (team == 2)
		{
			new sans = GetRandomInt(6,12);
			if(sans == 6)
			{
				PrintToChat(client, " \x02[%s] \x04Şanslısınız.. \x0C150 HP'li \x10Ayı modeli \x0Ckazandınız..", sPluginTagi);
				SetEntityHealth(client, 150);
				SetEntityModel(client, model6); 
				SetEntPropString(client, Prop_Send, "m_szArmsModel", kol6);
				ayilar[client] = true;
			}
			else if(sans == 7)
			{
				SetEntityModel(client, model7); 
				SetEntPropString(client, Prop_Send, "m_szArmsModel", kol7);
				ayilar[client] = false;
			}
			else if(sans == 8)
			{
				SetEntityModel(client, model8); 
				SetEntPropString(client, Prop_Send, "m_szArmsModel", kol8);
				ayilar[client] = false;
			}
			else if(sans == 9)
			{
				SetEntityModel(client, model9); 
				SetEntPropString(client, Prop_Send, "m_szArmsModel", kol9);
				ayilar[client] = false;
			}
			else if(sans == 10)
			{
				SetEntityModel(client, model10); 
				SetEntPropString(client, Prop_Send, "m_szArmsModel", kol10);
				ayilar[client] = false;
			}
			else if(sans == 11)
			{
				SetEntityModel(client, model11); 
				SetEntPropString(client, Prop_Send, "m_szArmsModel", kol11);
				ayilar[client] = false;
			}
			else if(sans == 12)
			{
				SetEntityModel(client, model12); 
				SetEntPropString(client, Prop_Send, "m_szArmsModel", kol12);
				ayilar[client] = false;
			}
		}
	}
	
	
	CreateTimer(0.1, SilahlariSil, client);
	
}

public Action:SilahlariSil(Handle:timer, client:client)
{
	new silahEnt, a = 0;
	for(new i=0;i<10;i++)
		silahIsmi[client][i] = "";
	
	decl String:sSilah[32];
	for(new j=0;j<5;j++)
	{
		if(j==4)
		{
			for(new k=0;k<6;k++)
			{
				silahEnt = GetPlayerWeaponSlot(client, j);
				if(silahEnt != -1)
				{
					GetEntityClassname(silahEnt, sSilah, sizeof(sSilah));
					if((StrContains(sSilah, "weapon_", false) != -1))
					{
						a++;
						Format(silahIsmi[client][a], sizeof(silahIsmi), "%s", sSilah);
						AcceptEntityInput(silahEnt, "Kill");
					}
				}
			}
		}
		else
		{
			silahEnt = GetPlayerWeaponSlot(client, j);
			if(silahEnt != -1)
			{
				GetEntityClassname(silahEnt, sSilah, sizeof(sSilah));
				if((StrContains(sSilah, "weapon_", false) != -1))
				{
					a++;
					Format(silahIsmi[client][a], sizeof(silahIsmi), "%s", sSilah);
					AcceptEntityInput(silahEnt, "Kill");
				}
			}
		}
	}
	
	CreateTimer(1.1, SilahlariVer, client);
}

public Action:SilahlariVer(Handle:timer, client:client)
{
	for(new i=0;i<10;i++)
		if((StrContains(silahIsmi[client][i], "weapon_", false) != -1))
			if(IsPlayerAlive(client))
				GivePlayerItem(client, silahIsmi[client][i]);
}


public Action:HPAyi(client, args)
{
	new String:sPluginTagi[64];
	GetConVarString(g_PluginTagi, sPluginTagi, sizeof(sPluginTagi));
	for (new i = 1; i <= MaxClients; i++)
	{
		if(!IsClientConnected(i) || !IsClientInGame(i) || IsFakeClient(i)) continue;
		if(GetClientTeam(i) != 2) continue;
		//if(GetClientTeam(i) != 2) continue;
		if(!IsPlayerAlive(i)) continue;
		if(ayilar[i])
			SetEntityHealth(i, 150);
		else
			SetEntityHealth(i, 100);
	}
	
	PrintToChatAll(" \x02[%s] \x04Tüm oyunculara \x10%N \x01tarafından \x07100 HP \x0A(Ayılara 150) \x0Everildi. ", sPluginTagi, client);
	return Plugin_Handled;
}