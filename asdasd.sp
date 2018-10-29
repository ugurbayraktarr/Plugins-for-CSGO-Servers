#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <smlib>
#include <sdkhooks>
#include <multicolors>
#include <adminmenu>

new Handle:hAdminMenu = INVALID_HANDLE;
Handle CountdownTimer;
bool:CountdownActive = false;
bool:ffAktif = false;
ConVar g_cvFriendlyFire;

public Plugin:myinfo = 
{
	name = "Oyun Menu",
	author = "Hardy",
	description = "Oyunları kolaylastırır.",
	version = "1.0",
	url = "steamcommunity.com/id/kHardy"
}

public OnPluginStart()
{
	RegConsoleCmd("sm_oyunmenu", TRCT);
	HookEvent("round_end", ElSonu);
	g_cvFriendlyFire = FindConVar("mp_teammates_are_enemies");
}

public Action:ElSonu(Handle:event, const String:name[], bool:dontBroadcast)
{
	if(ffAktif || CountdownActive)
	{
		CloseHandle(CountdownTimer);
		CountdownTimer = null;
		g_cvFriendlyFire.IntValue = 0;
		ffAktif = false;
		CountdownActive = false;
		ServerCommand("sm_cvar mp_teammates_are_enemies 0");
	}
	ServerCommand("sv_gravity 800");
	ServerCommand("sv_airaccelerate 99999");
	ServerCommand("sm_parachute_enabled 1");
	ServerCommand("sv_infinite_ammo 0");
	ServerCommand("mp_teammates_are_enemies 0");
	ServerCommand("mp_friendlyfire 0");
	ServerCommand("sm_hosties_noblock_enable 1");
	ServerCommand("mp_solid_teammates 0");
	ServerCommand("sm_strip @t");
	ServerCommand("sm_god @ct 0");
	ServerCommand("sv_infinite_ammo 0");
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
			SDKUnhook(i, SDKHook_Touch, OnTouch);
			SetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue", 1.0);
			SDKUnhook(i, SDKHook_SetTransmit, Hook_SetTransmit);
			new can = (GetClientHealth(i), 100);
			SetEntityHealth(i, can);
			SetEntityRenderColor(i, 255, 255, 255, 255);
		}
	}
}

public Action:TRCT(client,args)
{
	
	if(GetClientTeam(client) == 3)
	{
		CTMenu(client);
		
	}
	else
	{
	CPrintToChat(client,"{darkred}[Winchester Fun #] \x01\x0B\x10Bu komut sadece {green}CT'ler\x01\x0B\x10 içindir.");
		return;
	}
}

public Action:CTMenu(clientId) 
{
	new Handle:menu = CreateMenu(CTMenuHandler);
	SetMenuTitle(menu, "OYUN MENÜ");
	decl String:opcionmenu[124];
	
	Format(opcionmenu, 124, "CT God ver");
	AddMenuItem(menu, "option2", opcionmenu);	
	
	Format(opcionmenu, 124, "Tüm ayarları sıfırla");
	AddMenuItem(menu, "option3", opcionmenu);
	
	Format(opcionmenu, 124, "Oyun Menü");
	AddMenuItem(menu, "option4", opcionmenu);

	
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, clientId, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

public CTMenuHandler(Handle:menu, MenuAction:action, client, itemNum)
{
	decl String:isim[32];
	GetClientName(client, isim, sizeof(isim));
	
	if ( action == MenuAction_Select ) 
	{
		new String:info[32];
		
		GetMenuItem(menu, itemNum, info, sizeof(info));
		
		if ( strcmp(info,"option1") == 0 ) 
		{
			{
				CTMenu(client);
			}
		}
		
		else if ( strcmp(info,"option2") == 0 ) 
		{
			{
				ServerCommand("sm_god @ct 1");
				for (int i = 1; i <= MaxClients; i++) 
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10CT'ye {lightgreen}god verildi.",isim);
						if(GetClientTeam(i) == 3)
						{
							new can = (GetClientHealth(i), 25000);
							SetEntityHealth(i, can);
							
						}
						
					}
				}
			}
		}
		else if ( strcmp(info,"option3") == 0 ) 
		{
			{
				ServerCommand("sv_gravity 800");
				ServerCommand("sv_airaccelerate 99999");
				ServerCommand("sm_parachute_enabled 1");
				ServerCommand("sv_infinite_ammo 0");
				ServerCommand("mp_teammates_are_enemies 0");
				ServerCommand("mp_friendlyfire 0");
				ServerCommand("sm_hosties_noblock_enable 1");
				ServerCommand("mp_solid_teammates 0");
				ServerCommand("sm_strip @t");
				ServerCommand("sm_god @ct 0");
				ServerCommand("sv_infinite_ammo 0");
				
				for (int i = 1; i <= MaxClients; i++) 
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						SDKUnhook(i, SDKHook_Touch, OnTouch);
						SetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue", 1.0);
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10tüm ayarlar {lightgreen}sıfırlandı.",isim); 
						SDKUnhook(i, SDKHook_SetTransmit, Hook_SetTransmit);
						new can = (GetClientHealth(i), 100);
						SetEntityHealth(i, can);
						SetEntityRenderColor(i, 255, 255, 255, 255);
					}
				}
			}
		}
		else if ( strcmp(info,"option4") == 0 ) 
		{
			{
				OyunMenu(client);
			}
		}
		
	}
}


public Action:OyunMenu(clientId) 
{
	new Handle:menu = CreateMenu(OMenuDevam);
	SetMenuTitle(menu, "Winchester - Oyun Menu");
	decl String:opcionmenu[124];
	
	Format(opcionmenu, 124, "Kuşavı");
	AddMenuItem(menu, "option2", opcionmenu);	
	
	Format(opcionmenu, 124, "Zombi");
	AddMenuItem(menu, "option3", opcionmenu);
	
	Format(opcionmenu, 124, "KamiKZ");
	AddMenuItem(menu, "option4", opcionmenu);
	
	Format(opcionmenu, 124, "KörFF");
	AddMenuItem(menu, "option5", opcionmenu);
	
	Format(opcionmenu, 124, "Bombacı Mülayim");
	AddMenuItem(menu, "option6", opcionmenu);
	
	Format(opcionmenu, 124, "Körebe");
	AddMenuItem(menu, "option7", opcionmenu);
	
	Format(opcionmenu, 124, "Dost Ateşi");
	AddMenuItem(menu, "option8", opcionmenu);
	
	Format(opcionmenu, 124, "Görünmez Savaş");
	AddMenuItem(menu, "option10", opcionmenu);
	
	Format(opcionmenu, 124, "Gömülen Ölür");
	AddMenuItem(menu, "option11", opcionmenu);
	
	Format(opcionmenu, 124, "Kovalamaca");
	AddMenuItem(menu, "option9", opcionmenu);
	
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, clientId, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

public OMenuDevam(Handle:menu, MenuAction:action, client, itemNum)
{
	decl String:isim[32];
	GetClientName(client, isim, sizeof(isim));
	
	if ( action == MenuAction_Select ) 
	{
		new String:info[32];
		
		GetMenuItem(menu, itemNum, info, sizeof(info));
		
		if ( strcmp(info,"option1") == 0 ) 
		{
			{
				CTMenu(client);
			}
		}
		
		else if ( strcmp(info,"option2") == 0 ) 
		{
			{
				ServerCommand("sv_gravity 200");
				KusAvi(client);
				for (int i = 1; i <= MaxClients; i++) 
				{ 
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						if(GetClientTeam(i) == 3)
						{
							SetEntityRenderColor(i, 255, 0, 0, 255);
							new can = (GetClientHealth(i) , 25000);
							SetEntityHealth(i, can);
							
						} else {
							SetEntityRenderColor(i, 0, 0, 255, 255);
							new can = (GetClientHealth(i) , 35);
							SetEntityHealth(i, can);
						}
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10Kuşavı {lightgreen}açıldı.",isim);
					}
				}
			}
		}
		else if ( strcmp(info,"option3") == 0 ) 
		{
			{
				CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10Zombi Oyunu {lightgreen}açılıyor.",isim);
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						if(GetClientTeam(client) == 3)
						{
							Zombi(client);
							
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option4") == 0 ) 
		{
			{
				ServerCommand("sv_airaccelerate -50");
				ServerCommand("sm_parachute_enabled 0");
				for (int i = 1; i <= MaxClients; i++)
				{ 
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						if(GetClientTeam(i) == 3)
						{
							new can = (GetClientHealth(i), 25000);
							SetEntityHealth(i, can);
							
						}
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10KamiKZ Oyunu {lightgreen}açıldı.",isim);
					}
				}
				
			}
		}
		else if ( strcmp(info,"option5") == 0 ) 
		{
			{
				ServerCommand("sv_infinite_ammo 1");
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10Kör FF Oyunu {lightgreen}açıldı.",isim);
						if(GetClientTeam(i) == 3)
						{
							new can = (GetClientHealth(i), 25000);
							SetEntityHealth(i, can);
							
						} else {
							SDKHook(i, SDKHook_SetTransmit, Hook_SetTransmit);
							SetEntityRenderColor(i, 255, 255, 255, 20);
							GivePlayerItem(i, "weapon_deagle");
							Client_GiveWeaponAndAmmo(i, "weapon_deagle", _, 0, _, 30);
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option6") == 0 ) 
		{
			{
				ServerCommand("sv_infinite_ammo 1");
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10Bombacı Mülayim Oyunu {lightgreen}açıldı.",isim);
						if(GetClientTeam(i) == 3)
						{
							new can = (GetClientHealth(i), 25000);
							SetEntityHealth(i, can);	
						}
						BombaciCan(client);
					}
				}
			}
		}
		else if ( strcmp(info,"option7") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					ServerCommand("sv_infinite_ammo 1");
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10Körebe {lightgreen}açıldı.",isim);
						if(GetClientTeam(i) == 3)
						{
							SDKHook(i, SDKHook_SetTransmit, Hook_SetTransmit);
							SetEntityRenderColor(i, 255, 255, 255, 0);
							KorebeCan(client);	
						} else {
							ZombiSilah2(i);
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option8") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						if(GetClientTeam(i) == 3)
						{
							new can = (GetClientHealth(i), 25000);
							SetEntityHealth(i, can);	
							ff(client);
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option9") == 0 ) 
		{
			{
				
				CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10Kovalamaca oyunu {lightgreen}açıldı.",isim);
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						if(GetClientTeam(i) == 3)
						{
							SDKHook(i, SDKHook_Touch, OnTouch);
							SetEntPropFloat(i, Prop_Data, "m_flLaggedMovementValue", 3.0);
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option10") == 0 ) 
		{
			{
				catismash(client);
				CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10Kör savaş oyunu {lightgreen}açıldı.",isim);
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						ZombiSilah2(i);
					}
				}
			}
		}
		else if ( strcmp(info,"option11") == 0 ) 
		{
			{
				gomulenhs(client);
			}
		}
	}
} 

public Action:KusAvi(clientId) 
{
	new Handle:menu = CreateMenu(KusDevam);
	SetMenuTitle(menu, "Kusavi için Silah Seciniz");
	decl String:opcionmenu[124];
	
	Format(opcionmenu, 124, "AWP");
	AddMenuItem(menu, "option2", opcionmenu);
	
	Format(opcionmenu, 124, "SCAR-20");
	AddMenuItem(menu, "option3", opcionmenu);
	
	Format(opcionmenu, 124, "SSG 08");
	AddMenuItem(menu, "option4", opcionmenu);
	
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, clientId, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

public KusDevam(Handle:menu, MenuAction:action, client, itemNum)
{
	decl String:isim[32];
	GetClientName(client, isim, sizeof(isim));
	
	if ( action == MenuAction_Select ) 
	{
		new String:info[32];
		
		GetMenuItem(menu, itemNum, info, sizeof(info));
		
		if ( strcmp(info,"option2") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						if(GetClientTeam(i) == 3)
						{
							GivePlayerItem(i, "weapon_awp");
							Client_GiveWeaponAndAmmo(i, "weapon_awp", _, 0, _, 30);
						}
					}
				}
				
			}
		}
		else if ( strcmp(info,"option3") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						if(GetClientTeam(i) == 3)
						{
							GivePlayerItem(i, "weapon_scar20");
							Client_GiveWeaponAndAmmo(i, "weapon_scar20", _, 0, _, 30);
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option4") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						if(GetClientTeam(i) == 3)
						{
							GivePlayerItem(i, "weapon_ssg08");
							Client_GiveWeaponAndAmmo(i, "weapon_ssg08", _, 0, _, 30); 
						}
					}
				}
			}
		}
		
	}
} 

public Action:Zombi(clientId) 
{
	new Handle:menu = CreateMenu(ZombiDevam);
	SetMenuTitle(menu, "Zombi icin HP Seciniz");
	decl String:opcionmenu[124];
	
	Format(opcionmenu, 124, "5.000 HP");
	AddMenuItem(menu, "option2", opcionmenu);
	
	Format(opcionmenu, 124, "6.000 HP");
	AddMenuItem(menu, "option3", opcionmenu);
	
	Format(opcionmenu, 124, "7.000 HP");
	AddMenuItem(menu, "option4", opcionmenu);
	
	Format(opcionmenu, 124, "8.000 HP");
	AddMenuItem(menu, "option5", opcionmenu);
	
	Format(opcionmenu, 124, "9.000 HP");
	AddMenuItem(menu, "option6", opcionmenu);
	
	Format(opcionmenu, 124, "10.000 HP");
	AddMenuItem(menu, "option7", opcionmenu);
	
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, clientId, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

public ZombiDevam(Handle:menu, MenuAction:action, client, itemNum)
{
	decl String:isim[32];
	GetClientName(client, isim, sizeof(isim));
	
	if ( action == MenuAction_Select ) 
	{
		new String:info[32];
		
		GetMenuItem(menu, itemNum, info, sizeof(info));
		
		if ( strcmp(info,"option2") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					ServerCommand("sv_infinite_ammo 1");
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10CT'lere zombi için 5.000 HP {lightgreen}verildi.",isim);
						if(GetClientTeam(i) == 3)
						{
							SetEntityRenderColor(i, 255, 0, 0, 255);
							new can = (GetClientHealth(i) , 5000);
							SetEntityHealth(i, can);
						} else {
							ZombiSilah2(i);
						}
					}
				}
				
			}
		}
		else if ( strcmp(info,"option3") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					ServerCommand("sv_infinite_ammo 1");
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10CT'lere zombi için 6.000 HP {lightgreen}verildi.",isim);
						if(GetClientTeam(i) == 3)
						{
							SetEntityRenderColor(i, 255, 0, 0, 255);
							new can = (GetClientHealth(i) , 6000);
							SetEntityHealth(i, can);
						} else {
							ZombiSilah2(i);
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option4") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					ServerCommand("sv_infinite_ammo 1");
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10CT'lere zombi için 7.000 HP {lightgreen}verildi.",isim);
						if(GetClientTeam(i) == 3)
						{
							SetEntityRenderColor(i, 255, 0, 0, 255);
							new can = (GetClientHealth(i) , 7000);
							SetEntityHealth(i, can);
						} else {
							ZombiSilah2(i);
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option5") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					ServerCommand("sv_infinite_ammo 1");
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10CT'lere zombi için 8.000 HP {lightgreen}verildi.",isim);
						if(GetClientTeam(i) == 3)
						{
							SetEntityRenderColor(i, 255, 0, 0, 255);
							new can = (GetClientHealth(i) , 8000);
							SetEntityHealth(i, can);
						} else {
							ZombiSilah2(i);
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option6") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					ServerCommand("sv_infinite_ammo 1");
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10CT'lere zombi için 9.000 HP {lightgreen}verildi.",isim);
						if(GetClientTeam(i) == 3)
						{
							SetEntityRenderColor(i, 255, 0, 0, 255);
							new can = (GetClientHealth(i) , 9000);
							SetEntityHealth(i, can);
						} else {
							ZombiSilah2(i);
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option7") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					ServerCommand("sv_infinite_ammo 1");
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10CT'lere zombi için 10.000 HP {lightgreen}verildi.",isim);
						if(GetClientTeam(i) == 3)
						{
							SetEntityRenderColor(i, 255, 0, 0, 255);
							new can = (GetClientHealth(i) , 10000);
							SetEntityHealth(i, can);
						} else {
							ZombiSilah2(i);
						}
					}
				}
			}
		}
		
	}
} 

public Action:ZombiSilah(clientId) 
{
	new Handle:menu = CreateMenu(ZombiSilahDevam);
	SetMenuTitle(menu, "Zombi icin Silah Seciniz");
	decl String:opcionmenu[124];
	
	Format(opcionmenu, 124, "M4A4");
	AddMenuItem(menu, "option2", opcionmenu);
	
	Format(opcionmenu, 124, "M4A1-S ");
	AddMenuItem(menu, "option3", opcionmenu);
	
	Format(opcionmenu, 124, "AK47 ");
	AddMenuItem(menu, "option4", opcionmenu);
	
	Format(opcionmenu, 124, "AUG ");
	AddMenuItem(menu, "option5", opcionmenu);
	
	Format(opcionmenu, 124, "AWP ");
	AddMenuItem(menu, "option6", opcionmenu);
	
	Format(opcionmenu, 124, "OTOAWP ");
	AddMenuItem(menu, "option7", opcionmenu);
	
	Format(opcionmenu, 124, "NOVA ");
	AddMenuItem(menu, "option8", opcionmenu);
	
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, clientId, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

public ZombiSilahDevam(Handle:menu, MenuAction:action, client, itemNum)
{
	decl String:isim[32];
	GetClientName(client, isim, sizeof(isim));
	
	if ( action == MenuAction_Select ) 
	{
		new String:info[32];
		
		GetMenuItem(menu, itemNum, info, sizeof(info));
		
		if ( strcmp(info,"option2") == 0 ) 
		{
			{
				if(GetClientTeam(client) == 2)
				{
					GivePlayerItem(client, "weapon_m4a1");
					Client_GiveWeaponAndAmmo(client, "weapon_m4a1", _, 0, _, 30);
				}
				
			}
		}
		else if ( strcmp(info,"option3") == 0 ) 
		{
			{
				if(GetClientTeam(client) == 2)
				{
					GivePlayerItem(client, "weapon_m4a1_silencer");
					Client_GiveWeaponAndAmmo(client, "weapon_m4a1_silencer", _, 0, _, 30);
				}
			}
		}
		else if ( strcmp(info,"option4") == 0 ) 
		{
			{
				if(GetClientTeam(client) == 2)
				{
					GivePlayerItem(client, "weapon_ak47");
					Client_GiveWeaponAndAmmo(client, "weapon_ak47",_, 0, _, 30); 
				}
			}
		}
		else if ( strcmp(info,"option5") == 0 ) 
		{
			{
				if(GetClientTeam(client) == 2)
				{
					GivePlayerItem(client, "weapon_aug");
					Client_GiveWeaponAndAmmo(client, "weapon_aug", _, 0, _, 30); 
				}
			}
		}
		else if ( strcmp(info,"option6") == 0 ) 
		{
			{
				if(GetClientTeam(client) == 2)
				{
					GivePlayerItem(client, "weapon_awp");
					Client_GiveWeaponAndAmmo(client, "weapon_awp", _, 0, _, 30);
				}
			}
		}
		else if ( strcmp(info,"option7") == 0 ) 
		{
			{
				if(GetClientTeam(client) == 2)
				{
					GivePlayerItem(client, "weapon_scar20");
					Client_GiveWeaponAndAmmo(client, "weapon_scar20", _, 0, _, 30); 
				}
			}
		}
		else if ( strcmp(info,"option8") == 0 ) 
		{
			{
				if(GetClientTeam(client) == 2)
				{
					GivePlayerItem(client, "weapon_nova");
					Client_GiveWeaponAndAmmo(client, "weapon_nova", _, 0, _, 30);
				}
			}
		}
	}	
}

public Action:ZombiSilah2(clientId) 
{
	new Handle:menu = CreateMenu(ZombiSilahDevam2);
	SetMenuTitle(menu, "Zombi İcin Tabanca Seciniz");
	decl String:opcionmenu[124];
	
	Format(opcionmenu, 124, "USP");
	AddMenuItem(menu, "option2", opcionmenu);
	
	Format(opcionmenu, 124, "FIVESEVEN");
	AddMenuItem(menu, "option3", opcionmenu);
	
	Format(opcionmenu, 124, "TEC9");
	AddMenuItem(menu, "option4", opcionmenu);
	
	Format(opcionmenu, 124, "DEAGLE");
	AddMenuItem(menu, "option5", opcionmenu);
	
	
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, clientId, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

public ZombiSilahDevam2(Handle:menu, MenuAction:action, client, itemNum)
{
	decl String:isim[32];
	GetClientName(client, isim, sizeof(isim));
	
	if ( action == MenuAction_Select ) 
	{
		new String:info[32];
		
		GetMenuItem(menu, itemNum, info, sizeof(info));
		
		if ( strcmp(info,"option2") == 0 ) 
		{
			{
				if(GetClientTeam(client) == 2)
				{
					GivePlayerItem(client, "weapon_usp_silencer");
					Client_GiveWeaponAndAmmo(client, "weapon_usp_silencer", _, 0, _, 30);
					ZombiSilah(client);
				}
				
			}
		}
		else if ( strcmp(info,"option3") == 0 ) 
		{
			{
				if(GetClientTeam(client) == 2)
				{
					GivePlayerItem(client, "weapon_fiveseven");
					Client_GiveWeaponAndAmmo(client, "weapon_fiveseven", _, 0, _, 30);
					ZombiSilah(client);
				}
			}
		}
		else if ( strcmp(info,"option4") == 0 ) 
		{
			{
				if(GetClientTeam(client) == 2)
				{
					GivePlayerItem(client, "weapon_tec9");
					Client_GiveWeaponAndAmmo(client, "weapon_tec9", _, 0, _, 30); 
					ZombiSilah(client);
				}
			}
		}
		else if ( strcmp(info,"option5") == 0 ) 
		{
			{
				if(GetClientTeam(client) == 2)
				{
					GivePlayerItem(client, "weapon_deagle");
					Client_GiveWeaponAndAmmo(client, "weapon_deagle", _, 0, _, 30);
					ZombiSilah(client);
				}
			}
		}
	}	
}	

public Action:BombaciCan(clientId) 
{
	new Handle:menu = CreateMenu(BombaciDevam);
	SetMenuTitle(menu, "Bombaci Mulayim icin HP Seciniz");
	decl String:opcionmenu[124];
	
	Format(opcionmenu, 124, "150 HP");
	AddMenuItem(menu, "option2", opcionmenu);
	
	Format(opcionmenu, 124, "300 HP");
	AddMenuItem(menu, "option3", opcionmenu);
	
	Format(opcionmenu, 124, "500 HP");
	AddMenuItem(menu, "option4", opcionmenu);
	
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, clientId, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

public BombaciDevam(Handle:menu, MenuAction:action, client, itemNum)
{
	decl String:isim[32];
	GetClientName(client, isim, sizeof(isim));
	
	if ( action == MenuAction_Select ) 
	{
		new String:info[32];
		
		GetMenuItem(menu, itemNum, info, sizeof(info));
		
		if ( strcmp(info,"option2") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						if(GetClientTeam(i) == 3)
						{
							GivePlayerItem(i, "weapon_hegrenade");
						} else {
							new can = (GetClientHealth(i) , 150);
							SetEntityHealth(i, can);
						}
					}
				}
				
			}
		}
		else if ( strcmp(info,"option3") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						if(GetClientTeam(i) == 3)
						{
							GivePlayerItem(i, "weapon_hegrenade");
						} else {
							new can = (GetClientHealth(i) , 300);
							SetEntityHealth(i, can);
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option4") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						if(GetClientTeam(i) == 3)
						{
							GivePlayerItem(i, "weapon_hegrenade");
						} else {
							new can = (GetClientHealth(i) , 500);
							SetEntityHealth(i, can);
						}
					}
				}
			}
		}
		
		
	}	
}

public Action:KorebeCan(clientId) 
{
	new Handle:menu = CreateMenu(KorebeDevam);
	SetMenuTitle(menu, "Korebe CT icin Can Seciniz");
	decl String:opcionmenu[124];
	
	Format(opcionmenu, 124, "150 HP");
	AddMenuItem(menu, "option2", opcionmenu);
	
	Format(opcionmenu, 124, "300 HP");
	AddMenuItem(menu, "option3", opcionmenu);
	
	Format(opcionmenu, 124, "500 HP");
	AddMenuItem(menu, "option4", opcionmenu);
	
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, clientId, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

public KorebeDevam(Handle:menu, MenuAction:action, client, itemNum)
{
	decl String:isim[32];
	GetClientName(client, isim, sizeof(isim));
	
	if ( action == MenuAction_Select ) 
	{
		new String:info[32];
		
		GetMenuItem(menu, itemNum, info, sizeof(info));
		
		if ( strcmp(info,"option2") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						if(GetClientTeam(i) == 3)
						{
							new can = (GetClientHealth(i) , 150);
							SetEntityHealth(i, can);
						}
					}
				}
				
			}
		}
		else if ( strcmp(info,"option3") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						if(GetClientTeam(i) == 3)
						{
							new can = (GetClientHealth(i) , 300);
							SetEntityHealth(i, can);
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option4") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						if(GetClientTeam(i) == 3)
						{
							new can = (GetClientHealth(i) , 500);
							SetEntityHealth(i, can);
						}
					}
				}
			}
		}
		
		
	}	
}

public Action:ff(clientId) 
{
	new Handle:menu = CreateMenu(ffDevam);
	SetMenuTitle(menu, "FF Menu");
	decl String:opcionmenu[124];
	
	Format(opcionmenu, 124, "M4A4 FF");
	AddMenuItem(menu, "option2", opcionmenu);
	
	Format(opcionmenu, 124, "M4A1-S FF");
	AddMenuItem(menu, "option3", opcionmenu);
	
	Format(opcionmenu, 124, "AK47 FF");
	AddMenuItem(menu, "option4", opcionmenu);
	
	Format(opcionmenu, 124, "AWP FF");
	AddMenuItem(menu, "option5", opcionmenu);
	
	Format(opcionmenu, 124, "DEAGLE FF");
	AddMenuItem(menu, "option6", opcionmenu);
	
	Format(opcionmenu, 124, "NOVA FF");
	AddMenuItem(menu, "option7", opcionmenu);
	
	Format(opcionmenu, 124, "BIZON FF");
	AddMenuItem(menu, "option8", opcionmenu);
	
	Format(opcionmenu, 124, "ZEUS FF");
	AddMenuItem(menu, "option9", opcionmenu);
	
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, clientId, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

public ffDevam(Handle:menu, MenuAction:action, client, itemNum)
{
	decl String:isim[32];
	GetClientName(client, isim, sizeof(isim));
	
	if ( action == MenuAction_Select ) 
	{
		new String:info[32];
		
		GetMenuItem(menu, itemNum, info, sizeof(info));
		
		if ( strcmp(info,"option2") == 0 ) 
		{
			{
				CountdownActive = true;
				CountdownTimer = CreateTimer(1.0, Countdown, _, TIMER_REPEAT);
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10M4A4 FF {lightgreen}açıldı.",isim);
						if(GetClientTeam(i) == 2)
						{
							GivePlayerItem(i, "weapon_m4a1");
							Client_GiveWeaponAndAmmo(i, "weapon_m4a1", _, 0, _, 30);
						}
					}
				}
				
			}
		}
		else if ( strcmp(info,"option3") == 0 ) 
		{
			{
				CountdownActive = true;
				CountdownTimer = CreateTimer(1.0, Countdown, _, TIMER_REPEAT);
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10M4A1-S FF {lightgreen}açıldı.",isim);
						if(GetClientTeam(i) == 2)
						{
							GivePlayerItem(i, "weapon_m4a1_silencer");
							Client_GiveWeaponAndAmmo(i, "weapon_m4a1_silencer", _, 0, _, 30);
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option4") == 0 ) 
		{
			{
				CountdownActive = true;
				CountdownTimer = CreateTimer(1.0, Countdown, _, TIMER_REPEAT);
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10AK47 FF {lightgreen}açıldı.",isim);
						if(GetClientTeam(i) == 2)
						{
							GivePlayerItem(i, "weapon_ak47");
							Client_GiveWeaponAndAmmo(i, "weapon_ak47", _, 0, _, 30);
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option5") == 0 ) 
		{
			{
				CountdownActive = true;
				CountdownTimer = CreateTimer(1.0, Countdown, _, TIMER_REPEAT);
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10AWP FF {lightgreen}açıldı.",isim);
						if(GetClientTeam(i) == 2)
						{
							GivePlayerItem(i, "weapon_awp");
							Client_GiveWeaponAndAmmo(i, "weapon_awp", _, 0, _, 30);
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option6") == 0 ) 
		{
			{
				CountdownActive = true;
				CountdownTimer = CreateTimer(1.0, Countdown, _, TIMER_REPEAT);
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10DEAGLE FF {lightgreen}açıldı.",isim);
						if(GetClientTeam(i) == 2)
						{
							GivePlayerItem(i, "weapon_deagle");
							Client_GiveWeaponAndAmmo(i, "weapon_deagle", _, 0, _, 30);
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option7") == 0 ) 
		{
			{
				CountdownActive = true;
				CountdownTimer = CreateTimer(1.0, Countdown, _, TIMER_REPEAT);
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10NOVA FF {lightgreen}açıldı.",isim);
						if(GetClientTeam(i) == 2)
						{
							GivePlayerItem(i, "weapon_nova");
							Client_GiveWeaponAndAmmo(i, "weapon_nova", _, 0, _, 30);
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option8") == 0 ) 
		{
			{
				CountdownActive = true;
				CountdownTimer = CreateTimer(1.0, Countdown, _, TIMER_REPEAT);
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10PP-BİZON FF {lightgreen}açıldı.",isim);
						if(GetClientTeam(i) == 2)
						{
							GivePlayerItem(i, "weapon_bizon");
							Client_GiveWeaponAndAmmo(i, "weapon_bizon", _, 0, _, 30);
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option9") == 0 ) 
		{
			{
				CountdownActive = true;
				CountdownTimer = CreateTimer(1.0, Countdown, _, TIMER_REPEAT);
				for (int i = 1; i <= MaxClients; i++)
				{
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {default}tarafından \x01\x0B\x10ZEUS FF {lightgreen}açıldı.",isim);
						if(GetClientTeam(i) == 2)
						{
							GivePlayerItem(i, "weapon_taser");
							Client_GiveWeaponAndAmmo(i, "weapon_taser", _, 0, _, 1);
						}
					}
				}
			}
		}
		
		
	}	
}



public Action:Hook_SetTransmit(entity, i)  
{  
	if (entity != i)  
		return Plugin_Handled; 
	
	return Plugin_Continue;  
}

public Action:Countdown(Handle timer)
{
	static int numPrinted = 0;
	int timeleft = 10 - numPrinted;
	
	PrintHintTextToAll("<b><font size='19' color='#FFFFFF'>Dost Ateşinin Açılmasına</font> <font color='#00ff45'>%i</font> <font color='#FFFFFF'>Saniye</b>",timeleft);
	
	if(timeleft == 0)
	{
		numPrinted = 0;
		FFBaslat();
		return Plugin_Stop;
	}
	
	numPrinted++;
	
	return Plugin_Continue;
}

public FFBaslat()
{
	g_cvFriendlyFire.IntValue = 1;
	PrintHintTextToAll("<b><font size='19' color='#FFFFFF'>!!! </font> <font color='#00ff45'>DOST ATEŞİ AÇILMIŞTIR </font> <font color='#FFFFFF'>!!!</b>");
	CountdownActive = false;
	ffAktif = true;
	CountdownTimer = null;
}

public OnTouch(i, other)
{
	decl String:isim[32];
	GetClientName(i, isim, sizeof(isim));
	decl String:isim2[32];
	GetClientName(other, isim2, sizeof(isim2));
	
	if( i > 0 && i < MaxClients + 1 &&  other > 0 && other < MaxClients + 1 )
	{
		if(GetClientTeam(i) == 2 && GetClientTeam(other) == 3)
		{
			ForcePlayerSuicide(i);
			PrintToChatAll("Degen Kisi: %s | Olen Kisi: %s", isim2, isim);
		}
	}
}

public Action:catismash(clientId) 
{
	new Handle:menu = CreateMenu(CatismaDevam);
	SetMenuTitle(menu, "Catisma icin HP Seciniz");
	decl String:opcionmenu[124];
	
	Format(opcionmenu, 124, "300 HP");
	AddMenuItem(menu, "option2", opcionmenu);
	
	Format(opcionmenu, 124, "500 HP");
	AddMenuItem(menu, "option3", opcionmenu);
	
	Format(opcionmenu, 124, "700 HP");
	AddMenuItem(menu, "option4", opcionmenu);
	
	Format(opcionmenu, 124, "1000 HP");
	AddMenuItem(menu, "option5", opcionmenu);
	
	Format(opcionmenu, 124, "2000 HP");
	AddMenuItem(menu, "option6", opcionmenu);
	
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, clientId, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}


public Action:gomulenhs(Handle timer) {
	
	for (int i = 1; i <= MaxClients; i++)
	{
		if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
			if(GetClientTeam(i) == 2 && BilgiAl(i))
			{
				ForcePlayerSuicide(i);
			}
			
		}
	}
	
}

public CatismaDevam(Handle:menu, MenuAction:action, client, itemNum)
{
	decl String:isim[32];
	GetClientName(client, isim, sizeof(isim));
	
	if ( action == MenuAction_Select ) 
	{
		new String:info[32];
		
		GetMenuItem(menu, itemNum, info, sizeof(info));
		
		if ( strcmp(info,"option2") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					ServerCommand("sv_infinite_ammo 1");
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {lightgreen}catışma oyunu için CT'lere \x01\x0B\x10 300HP  {lightgreen}verildi.",isim);
						if(GetClientTeam(i) == 3)
						{
							new can = (GetClientHealth(i) , 300);
							SetEntityHealth(i, can);
						}
					}
				}
				
			}
		}
		else if ( strcmp(info,"option3") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					ServerCommand("sv_infinite_ammo 1");
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {lightgreen}catışma oyunu için CT'lere\x01\x0B\x10 500HP  {lightgreen}verildi.",isim);
						if(GetClientTeam(i) == 3)
						{
							new can = (GetClientHealth(i) , 500);
							SetEntityHealth(i, can);
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option4") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					ServerCommand("sv_infinite_ammo 1");
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {lightgreen}catışma oyunu için CT'lere\x01\x0B\x10 700HP  {lightgreen}verildi.",isim);
						if(GetClientTeam(i) == 3)
						{
							new can = (GetClientHealth(i) , 700);
							SetEntityHealth(i, can);
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option5") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					ServerCommand("sv_infinite_ammo 1");
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {lightgreen}catışma oyunu için CT'lere\x01\x0B\x10 1000HP  {lightgreen}verildi.",isim);
						if(GetClientTeam(i) == 3)
						{
							new can = (GetClientHealth(i) , 1000);
							SetEntityHealth(i, can);
						}
					}
				}
			}
		}
		else if ( strcmp(info,"option6") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
					ServerCommand("sv_infinite_ammo 1");
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10%s {lightgreen}catışma oyunu için CT'lere\x01\x0B\x10 2000HP  {lightgreen}verildi.",isim);
						if(GetClientTeam(i) == 3)
						
						{
							new can = (GetClientHealth(i) , 2000);
							SetEntityHealth(i, can);
						}
					}
				}
			}
		}
	}
}


stock bool:BilgiAl(iClient)
{
	decl Float:vecMin[3], Float:vecMax[3], Float:vecOrigin[3];
	
	GetClientMins(iClient, vecMin);
	GetClientMaxs(iClient, vecMax);
	GetClientAbsOrigin(iClient, vecOrigin);
	
	TR_TraceHullFilter(vecOrigin, vecOrigin, vecMin, vecMax, MASK_SOLID, TraceEntityFilterSolid);
	return TR_DidHit();	// head in wall ?
}


public bool:TraceEntityFilterSolid(entity, contentsMask) 
{
	return entity > 1;
}