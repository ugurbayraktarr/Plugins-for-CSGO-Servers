#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR ""
#define PLUGIN_VERSION "0.00"

#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <smlib>
#include <sdkhooks>
#include <multicolors>
#include <adminmenu>

public Plugin myinfo = 
{
	name = "",
	author = PLUGIN_AUTHOR,
	description = "",
	version = PLUGIN_VERSION,
	url = ""
};

public void OnPluginStart()
{
	RegAdminCmd("sm_ffmenu", ffmenu, ADMFLAG_BAN);
}

public Action:ffmenu(client,args)
{
FF(client);
}

public Action:FF(clientId) 
{
	new Handle:menu = CreateMenu(ZombiDevam);
	SetMenuTitle(menu, "FF Menu - Winchester");
	decl String:opcionmenu[124];
	
	Format(opcionmenu, 124, "FF AÇ");
	AddMenuItem(menu, "option2", opcionmenu);
	
	Format(opcionmenu, 124, "FF KAPAT");
	AddMenuItem(menu, "option3", opcionmenu);
	
	Format(opcionmenu, 124, "30 Saniye sonra FF aç");
	AddMenuItem(menu, "option4", opcionmenu);
	
	Format(opcionmenu, 124, "40 Saniye sonra FF aç");
	AddMenuItem(menu, "option5", opcionmenu);
	
	Format(opcionmenu, 124, "50 Saniye sonra FF aç");
	AddMenuItem(menu, "option6", opcionmenu);
	
	Format(opcionmenu, 124, "60 Saniye sonra FF aç");
	AddMenuItem(menu, "option7", opcionmenu);
	
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, clientId, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

public ZombiDevam(Handle:menu, MenuAction:action, client, itemNum)
{
	
	if ( action == MenuAction_Select ) 
	{
		new String:info[32];
		
		GetMenuItem(menu, itemNum, info, sizeof(info));
		
		if ( strcmp(info,"option2") == 0 ) 
		{
			{
				for (int i = 1; i <= MaxClients; i++)
				{
			          ServerCommand("sm_ffac");  {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10Dost ateşi {lightgreen}açıldı!");
						{
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
					ServerCommand("sm_ffkapat");
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10Dost ateşi {lightgreen}kapatıldı!");
						{
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
					ServerCommand("sm_ffzaman 30");
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10Dost ateşi {lightgreen}30 saniye sonra açılacak !");
						if(GetClientTeam(i) == 3)
						{
						} else {
							ZombiSilah(i);
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
					ServerCommand("sm_ffzaman 40");
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10Dost ateşi {lightgreen}40 saniye sonra açılacak !");
						if(GetClientTeam(i) == 3)
						{
						} else {
							ZombiSilah(i);
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
					ServerCommand("sm_ffzaman 50");
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10Dost ateşi {lightgreen}50 saniye sonra açılacak !");
						if(GetClientTeam(i) == 3)
						{
						} else {
							ZombiSilah(i);
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
					ServerCommand("sm_ffzaman 60");
					if(i && IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))   {
						CPrintToChatAll("{darkred}[Winchester Fun #] \x01\x0B\x10Dost ateşi {lightgreen}60 saniye sonra açılacak !");
						if(GetClientTeam(i) == 3)
						{
						} else {
							ZombiSilah(i);
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
	SetMenuTitle(menu, "Silahınızı Seçin");
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
	
	Format(opcionmenu, 124, "SSG08 ");
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
					ZombiSilah2(client);
				}
				
			}
		}
		else if ( strcmp(info,"option3") == 0 ) 
		{
			{
				if(GetClientTeam(client) == 2)
				{
					GivePlayerItem(client, "weapon_m4a1_silencer");
					ZombiSilah2(client);					
				}
			}
		}
		else if ( strcmp(info,"option4") == 0 ) 
		{
			{
				if(GetClientTeam(client) == 2)
				{
					GivePlayerItem(client, "weapon_ak47");
					ZombiSilah2(client);
				}
			}
		}
		else if ( strcmp(info,"option5") == 0 ) 
		{
			{
				if(GetClientTeam(client) == 2)
				{
					GivePlayerItem(client, "weapon_aug");
					ZombiSilah2(client);
				}
			}
		}
		else if ( strcmp(info,"option6") == 0 ) 
		{
			{
				if(GetClientTeam(client) == 2)
				{
					GivePlayerItem(client, "weapon_awp");
					ZombiSilah2(client);
				}
			}
		}
		else if ( strcmp(info,"option7") == 0 ) 
		{
			{
				if(GetClientTeam(client) == 2)
				{
					GivePlayerItem(client, "weapon_ssg08");
					ZombiSilah2(client);
				}
			}
		}
		else if ( strcmp(info,"option8") == 0 ) 
		{
			{
				if(GetClientTeam(client) == 2)
				{
					GivePlayerItem(client, "weapon_nova");
					ZombiSilah2(client);
				}
			}
		}
	}	
}

public Action:ZombiSilah2(clientId) 
{
	new Handle:menu = CreateMenu(ZombiSilahDevam2);
	SetMenuTitle(menu, "Tabancanızı Seçiniz");
	decl String:opcionmenu[124];
	
	Format(opcionmenu, 124, "USP");
	AddMenuItem(menu, "option2", opcionmenu);
	
	Format(opcionmenu, 124, "FIVESEVEN");
	AddMenuItem(menu, "option3", opcionmenu);
	
	Format(opcionmenu, 124, "TEC9");
	AddMenuItem(menu, "option4", opcionmenu);
	
	Format(opcionmenu, 124, "DEAGLE");
	AddMenuItem(menu, "option5", opcionmenu);
	
    Format(opcionmenu, 124, "GLOCK");
	AddMenuItem(menu, "option6", opcionmenu);
	
	
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, clientId, MENU_TIME_FOREVER);
	
	return Plugin_Handled;
}

public ZombiSilahDevam2(Handle:menu, MenuAction:action, client, itemNum)
{
	
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
				}
				
			}
		}
		else if ( strcmp(info,"option3") == 0 ) 
		{
			{
				if(GetClientTeam(client) == 2)
				{
					GivePlayerItem(client, "weapon_fiveseven");
				}
			}
		}
		else if ( strcmp(info,"option4") == 0 ) 
		{
			{
				if(GetClientTeam(client) == 2)
				{
					GivePlayerItem(client, "weapon_tec9");
				}
			}
		}
		else if ( strcmp(info,"option5") == 0 ) 
		{
			{
				if(GetClientTeam(client) == 2)
				{
					GivePlayerItem(client, "weapon_deagle");
				}
				
			}
		
		}
		else if ( strcmp(info,"option6") == 0 )
		{	
			{
				
				if(GetClientTeam(client) == 2)
				{
					 GivePlayerItem(client, "weapon_glock");
				}
			}
		}
	}	
}