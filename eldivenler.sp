#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <clientprefs>
#undef REQUIRE_PLUGIN
#include <zombiereloaded>

#define DATA "1.0"

char sConfig[PLATFORM_MAX_PATH];
Handle kv;

Handle armscookie1 = INVALID_HANDLE;
Handle armscookie2 = INVALID_HANDLE;
Handle armscookie3 = INVALID_HANDLE;
Handle armscookie4 = INVALID_HANDLE;

char g_arms[2][4][MAXPLAYERS + 1][256];
Handle clientmenu[MAXPLAYERS + 1][4];

public Plugin myinfo =
{
	name = "Eldiven Menüsü",
	author = "ImPossibLe`",
	description = "",
	version = DATA
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	MarkNativeAsOptional("ZR_IsClientZombie");
	return APLRes_Success;
}

public OnPluginStart()
{
	armscookie1 = RegClientCookie("ArmsTeam1", "ArmsTeam1", CookieAccess_Private);
	armscookie2 = RegClientCookie("ArmsTeam2", "ArmsTeam2", CookieAccess_Private);
	armscookie3 = RegClientCookie("ArmsTeam3", "ArmsTeam3", CookieAccess_Private);
	armscookie4 = RegClientCookie("ArmsTeam4", "ArmsTeam4", CookieAccess_Private);
	
	RegConsoleCmd("sm_eldiven", Command_);
	RegConsoleCmd("sm_eldivenler", Command_);
	RegAdminCmd("sm_eldivenyenile", ReloadSkins, ADMFLAG_ROOT);
	
	HookEvent("player_spawn", PlayerSpawn);
	
	RefreshKV();
	
	for(new client = 1; client <= MaxClients; client++)
	{
		if(IsClientInGame(client))
		{
			OnClientCookiesCached(client);
		}
	}
}

public Action:PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	GiveArms(client);
}

public OnPluginEnd()
{
	for(new client = 1; client <= MaxClients; client++)
	{
		if(IsClientInGame(client))
		{
			OnClientDisconnect(client);
		}
	}
}

public OnClientCookiesCached(client)
{
	GetClientCookie(client, armscookie1, g_arms[0][0][client], 256);
	
	
	if(strlen(g_arms[0][0][client]) < 2 || !KvJumpToKey(kv, g_arms[0][0][client])) 
		Format(g_arms[1][0][client], 256, "none");
	else
		KvGetString(kv, "model", g_arms[1][0][client], 256);

	KvRewind(kv);
	
	
	GetClientCookie(client, armscookie2, g_arms[0][1][client], 256);
	if(strlen(g_arms[0][1][client]) < 2 || !KvJumpToKey(kv, g_arms[0][1][client])) 
		Format(g_arms[1][1][client], 256, "none");
	else
		KvGetString(kv, "model", g_arms[1][1][client], 256);
		
	KvRewind(kv);
	
	GetClientCookie(client, armscookie3, g_arms[0][2][client], 256);
	if(strlen(g_arms[0][2][client]) < 2 || !KvJumpToKey(kv, g_arms[0][2][client])) 
		Format(g_arms[1][2][client], 256, "none");
	else
		KvGetString(kv, "model", g_arms[1][2][client], 256);
		
	KvRewind(kv);
	GetClientCookie(client, armscookie4, g_arms[0][3][client], 256);
	if(strlen(g_arms[0][3][client]) < 2 || !KvJumpToKey(kv, g_arms[0][3][client])) 
		Format(g_arms[1][3][client], 256, "none");
	else
		KvGetString(kv, "model", g_arms[1][3][client], 256);
		
	KvRewind(kv);
}

public OnClientDisconnect(client)
{
	if(AreClientCookiesCached(client))
	{
		SetClientCookie(client, armscookie1, g_arms[0][0][client]);
		SetClientCookie(client, armscookie2, g_arms[0][1][client]);
		SetClientCookie(client, armscookie3, g_arms[0][2][client]);
		SetClientCookie(client, armscookie4, g_arms[0][3][client]);
		
		if(clientmenu[client][0] != INVALID_HANDLE) CloseHandle(clientmenu[client][0]);
		clientmenu[client][0] = INVALID_HANDLE;
		
		if(clientmenu[client][1] != INVALID_HANDLE) CloseHandle(clientmenu[client][1]);
		clientmenu[client][1] = INVALID_HANDLE;
		
		if(clientmenu[client][2] != INVALID_HANDLE) CloseHandle(clientmenu[client][2]);
		clientmenu[client][2] = INVALID_HANDLE;
		
		if(clientmenu[client][3] != INVALID_HANDLE) CloseHandle(clientmenu[client][3]);
		clientmenu[client][3] = INVALID_HANDLE;
	}
}


public Action:ReloadSkins(client, args)
{	
	RefreshKV();
	ReplyToCommand(client, " \x02[DrK # GaminG]\x04 Eldivenler yenilendi");
	
	return Plugin_Handled;
}

public OnMapStart()
{
	Downloads();
	Precache();
}

public void RefreshKV()
{
	BuildPath(Path_SM, sConfig, PLATFORM_MAX_PATH, "configs/eldivenler.txt");
	
	if(kv != INVALID_HANDLE) CloseHandle(kv);
	
	kv = CreateKeyValues("CustomArms");
	FileToKeyValues(kv, sConfig);
}

Precache()
{
	char temp[256];
	if(KvGotoFirstSubKey(kv))
	{
		do
		{
			KvGetString(kv, "model", temp, 256);
			
			PrecacheModel(temp);
			
		} while (KvGotoNextKey(kv));
	}
	KvRewind(kv);	
}

Downloads()
{
	decl String:imFile[PLATFORM_MAX_PATH];
	decl String:line[192];
	
	BuildPath(Path_SM, imFile, sizeof(imFile), "configs/eldiven_downloads.txt");
	
	new Handle:file = OpenFile(imFile, "r");
	
	if(file != INVALID_HANDLE)
	{
		while (!IsEndOfFile(file))
		{
			if (!ReadFileLine(file, line, sizeof(line)))
			{
				break;
			}
			
			TrimString(line);
			if( strlen(line) > 0 && FileExists(line))
			{
				AddFileToDownloadsTable(line);
			}
		}

		CloseHandle(file);
	}
	else
	{
		LogError("[SM] no file found for downloads (configs/eldiven_downloads.txt)");
	}
}

public Action Command_(int client, int args)
{	
	new Handle:menu = CreateMenu(DIDMenuHandler);
	SetMenuTitle(menu, "Eldiveni hangi takım için ayarlamak istiyorsunuz?");
	if(GetFeatureStatus(FeatureType_Native, "ZR_IsClientZombie") == FeatureStatus_Available)
	{
		AddMenuItem(menu, "option3", "Select Zombie arms");
		AddMenuItem(menu, "option4", "Select Human arms");
	}
	else
	{
		AddMenuItem(menu, "option1", "CT eldiveni seç");
		AddMenuItem(menu, "option2", "T eldiveni seç");
	}
	SetMenuExitButton(menu, true);
	DisplayMenu(menu, client, 0);
	
	return Plugin_Handled;
}

public DIDMenuHandler(Handle:menu, MenuAction:action, client, itemNum) 
{
	if ( action == MenuAction_Select ) 
	{
		new String:info[32];
		
		GetMenuItem(menu, itemNum, info, sizeof(info));

		if ( strcmp(info,"option1") == 0 ) 
		{     
			ShowMenuCTs(client, 0);
		}
	   
		else if ( strcmp(info,"option2") == 0 ) 
		{
			ShowMenuTTs(client, 0);
		}
		
		else if ( strcmp(info,"option3") == 0 ) 
		{
			ShowMenuZombies(client, 0);
		}
		
		else if ( strcmp(info,"option4") == 0 ) 
		{
			ShowMenuHumans(client, 0);
		}
	}
	else if (action == MenuAction_End)
	{
		CloseHandle(menu);
	}
}

ShowMenuCTs(client, item)
{
	if(clientmenu[client][3] != INVALID_HANDLE)
	{
		DisplayMenuAtItem(clientmenu[client][3], client, item, 0);
		return;
	}
	
	char temp[256],temp2[64], flags[24], model[256];
	clientmenu[client][3] = new Menu(Menu_HandlerCT);
	SetMenuTitle(clientmenu[client][3], "Eldiven Menüsü\nCT için eldiven seç");
	
	if(KvGotoFirstSubKey(kv))
	{
		do
		{
			KvGetString(kv, "team", temp2, 64, "both");
			
			if (!StrEqual(temp2, "CT", false) && !StrEqual(temp2, "both", false))continue;
			
			KvGetString(kv, "model", model,256);
			if (!FileExists(model) && !FileExists(model, true))continue;
			
			KvGetSectionName(kv, temp, 256);
			KvGetString(kv, "flag", flags, 24, "public");
			if(HasFlag(client, flags))
				AddMenuItem(clientmenu[client][3], temp, temp);
			else
			{
				Format(temp2, 64, "%s (Vip Access)", temp);
				AddMenuItem(clientmenu[client][3], temp, temp2, ITEMDRAW_DISABLED);
			}
			
		} while (KvGotoNextKey(kv));
	}
	KvRewind(kv);
	SetMenuExitBackButton(clientmenu[client][3], true);
	DisplayMenuAtItem(clientmenu[client][3], client, item, 0);
}

public int Menu_HandlerCT(Menu menu, MenuAction action, int client, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			
			char item[256], flags[64];
			GetMenuItem(menu, param2, item, sizeof(item));
			
			KvJumpToKey(kv, item);
			KvGetString(kv, "flag", flags, 24, "public");
			if (!HasFlag(client, flags))return;
			
			ShowMenuCTs(client, GetMenuSelectionPosition());
			
			char model[PLATFORM_MAX_PATH];
			KvGetString(kv, "model", model, PLATFORM_MAX_PATH, "none");
			SetArms(client, item, model, CS_TEAM_CT);
			KvRewind(kv);
			
			if (GetClientTeam(client) == CS_TEAM_CT)GiveArms(client);
		}
		case MenuAction_Cancel:
		{
			if(param2==MenuCancel_ExitBack)
			{
				Command_(client, 0);
			}
		}

	}
}

ShowMenuTTs(client, item)
{
	if(clientmenu[client][2] != INVALID_HANDLE)
	{
		DisplayMenuAtItem(clientmenu[client][2], client, item, 0);
		return;
	}

	char temp[256],temp2[64], flags[24], model[256];
	clientmenu[client][2] = new Menu(Menu_HandlerTT);
	SetMenuTitle(clientmenu[client][2], "Eldiven Menüsü\nT için eldiven seç");
	
	if(KvGotoFirstSubKey(kv))
	{
		do
		{
			KvGetString(kv, "team", temp2, 64, "both");
			
			if (!StrEqual(temp2, "TT", false) && !StrEqual(temp2, "both", false))continue;
			
			KvGetString(kv, "model", model,256);
			if (!FileExists(model) && !FileExists(model, true))continue;
			
			KvGetSectionName(kv, temp, 256);
			KvGetString(kv, "flag", flags, 24, "public");
			if(HasFlag(client, flags))
				AddMenuItem(clientmenu[client][2], temp, temp);
			else
			{
				Format(temp2, 64, "%s (Vip Access)", temp);
				AddMenuItem(clientmenu[client][2], temp, temp2, ITEMDRAW_DISABLED);
			}
			
		} while (KvGotoNextKey(kv));
	}
	KvRewind(kv);
	SetMenuExitBackButton(clientmenu[client][2], true);
	DisplayMenuAtItem(clientmenu[client][2], client, item, 0);
}

public int Menu_HandlerTT(Menu menu, MenuAction action, int client, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			
			
			char item[256], flags[64];
			GetMenuItem(menu, param2, item, sizeof(item));
			
			KvJumpToKey(kv, item);
			KvGetString(kv, "flag", flags, 24, "public");
			if (!HasFlag(client, flags))return;
			
			ShowMenuTTs(client, GetMenuSelectionPosition());
			
			char model[PLATFORM_MAX_PATH];
			KvGetString(kv, "model", model, PLATFORM_MAX_PATH, "none");
			SetArms(client,item, model, CS_TEAM_T);
			KvRewind(kv);
			
			if (GetClientTeam(client) == CS_TEAM_T)GiveArms(client);
		}
		case MenuAction_Cancel:
		{
			if(param2==MenuCancel_ExitBack)
			{
				Command_(client, 0);
			}
		}

	}
}

ShowMenuZombies(client, item)
{
	if(clientmenu[client][0] != INVALID_HANDLE)
	{
		DisplayMenuAtItem(clientmenu[client][0], client, item, 0);
		return;
	}

	char temp[256],temp2[64], flags[24], model[256];
	clientmenu[client][0] = new Menu(Menu_HandlerTT);
	SetMenuTitle(clientmenu[client][0], "Custom Arms Menu v%s\nSelect a arms for Zombie team", DATA);
	
	if(KvGotoFirstSubKey(kv))
	{
		do
		{
			KvGetString(kv, "team", temp2, 64, "both");
			
			if (!StrEqual(temp2, "Zombie", false) && !StrEqual(temp2, "both", false))continue;
			
			KvGetString(kv, "model", model,256);
			if (!FileExists(model) && !FileExists(model, true))continue;
			
			KvGetSectionName(kv, temp, 256);
			KvGetString(kv, "flag", flags, 24, "public");
			if(HasFlag(client, flags))
				AddMenuItem(clientmenu[client][0], temp, temp);
			else
			{
				Format(temp2, 64, "%s (Vip Access)", temp);
				AddMenuItem(clientmenu[client][0], temp, temp2, ITEMDRAW_DISABLED);
			}
			
		} while (KvGotoNextKey(kv));
	}
	KvRewind(kv);
	SetMenuExitBackButton(clientmenu[client][0], true);
	DisplayMenuAtItem(clientmenu[client][0], client, item, 0);
}

public int Menu_HandlerZombie(Menu menu, MenuAction action, int client, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			
			
			char item[256], flags[64];
			GetMenuItem(menu, param2, item, sizeof(item));
			
			KvJumpToKey(kv, item);
			KvGetString(kv, "flag", flags, 24, "public");
			if (!HasFlag(client, flags))return;
			
			
			ShowMenuZombies(client, GetMenuSelectionPosition());
			
			char model[PLATFORM_MAX_PATH];
			KvGetString(kv, "model", model, PLATFORM_MAX_PATH, "none");
			SetArms(client,item, model, 0);
			KvRewind(kv);
			
			if (ZR_IsClientZombie(client)) GiveArms(client);
		}
		case MenuAction_Cancel:
		{
			if(param2==MenuCancel_ExitBack)
			{
				Command_(client, 0);
			}
		}

	}
}

ShowMenuHumans(client, item)
{
	if(clientmenu[client][1] != INVALID_HANDLE)
	{
		DisplayMenuAtItem(clientmenu[client][1], client, item, 0);
		return;
	}

	char temp[256],temp2[64], flags[24], model[256];
	clientmenu[client][1] = new Menu(Menu_HandlerTT);
	SetMenuTitle(clientmenu[client][1], "Custom Arms Menu v%s\nSelect a arms for Human team", DATA);
	
	if(KvGotoFirstSubKey(kv))
	{
		do
		{
			KvGetString(kv, "team", temp2, 64, "both");
			
			if (!StrEqual(temp2, "Human", false) && !StrEqual(temp2, "both", false))continue;
			
			KvGetString(kv, "model", model,256);
			if (!FileExists(model) && !FileExists(model, true))continue;
			
			KvGetSectionName(kv, temp, 256);
			KvGetString(kv, "flag", flags, 24, "public");
			if(HasFlag(client, flags))
				AddMenuItem(clientmenu[client][1], temp, temp);
			else
			{
				Format(temp2, 64, "%s (Vip Access)", temp);
				AddMenuItem(clientmenu[client][1], temp, temp2, ITEMDRAW_DISABLED);
			}
			
		} while (KvGotoNextKey(kv));
	}
	KvRewind(kv);
	SetMenuExitBackButton(clientmenu[client][1], true);
	DisplayMenuAtItem(clientmenu[client][1], client, item, 0);
}

public int Menu_HandlerHuman(Menu menu, MenuAction action, int client, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			
			char item[256], flags[64];
			GetMenuItem(menu, param2, item, sizeof(item));
			
			KvJumpToKey(kv, item);
			KvGetString(kv, "flag", flags, 24, "public");
			if (!HasFlag(client, flags))return;
			
			ShowMenuHumans(client, GetMenuSelectionPosition());
			
			
			char model[PLATFORM_MAX_PATH];
			KvGetString(kv, "model", model, PLATFORM_MAX_PATH, "none");
			SetArms(client,item, model, 1);
			KvRewind(kv);
			
			if (!ZR_IsClientZombie(client))GiveArms(client);
		}
		case MenuAction_Cancel:
		{
			if(param2==MenuCancel_ExitBack)
			{
				Command_(client, 0);
			}
		}

	}
}

void SetArms(client, char name[256], char model[256], team)
{
	Format(g_arms[0][team][client], 256, name);
	Format(g_arms[1][team][client], 256, model);
	
}

void GiveArms(client)
{
	if (!IsPlayerAlive(client))return;
	
	int team;
	if(GetFeatureStatus(FeatureType_Native, "ZR_IsClientZombie") == FeatureStatus_Available)
	{
		if (ZR_IsClientZombie(client))team = 0;
		else team = 1;
	}
	else
		team = GetClientTeam(client);
		
	if(strlen(g_arms[1][team][client]) > 2 && !StrEqual(g_arms[1][team][client], "none", false) && (FileExists(g_arms[1][team][client]) || FileExists(g_arms[1][team][client], true))) 
	{
		SetEntPropString(client, Prop_Send, "m_szArmsModel", g_arms[1][team][client]);
		CreateTimer(0.15, RemoveItemTimer, EntIndexToEntRef(client), TIMER_FLAG_NO_MAPCHANGE);
	}
	//PrintToChat(client, "modelo arms de %s de %s", g_arms[0][team][client], g_arms[1][team][client]);
}

public Action RemoveItemTimer(Handle timer, any ref)
{
	int client = EntRefToEntIndex(ref);
	
	if (client != INVALID_ENT_REFERENCE)
	{
		int item = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
		
		if (item > 0)
		{
			RemovePlayerItem(client, item);
			
			Handle ph=CreateDataPack();
			WritePackCell(ph, EntIndexToEntRef(client));
			WritePackCell(ph, EntIndexToEntRef(item));
			CreateTimer(0.15 , AddItemTimer, ph, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

public Action AddItemTimer(Handle timer, any ph)
{  
	int client, item;
	
	ResetPack(ph);
	
	client = EntRefToEntIndex(ReadPackCell(ph));
	item = EntRefToEntIndex(ReadPackCell(ph));
	
	if (client != INVALID_ENT_REFERENCE && item != INVALID_ENT_REFERENCE)
	{
		EquipPlayerWeapon(client, item);
	}
}

bool:HasFlag(client, String:flags[])
{
	if(StrEqual(flags, "public")) return true;
	
	if (GetUserFlagBits(client) & ADMFLAG_ROOT)
	{
		return true;
	}

	new iFlags = ReadFlagString(flags);

	if ((GetUserFlagBits(client) & iFlags) == iFlags)
	{
		return true;
	}

	return false;
}  