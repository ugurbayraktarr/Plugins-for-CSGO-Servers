#include <sourcemod>
#include <sdktools>
#include <cstrike>
#include <clientprefs>

#define		PREFIX			" \x02[DrK # GaminG]\x01"

#define		VALVE_TOTAL_GLOVES	24

#define 	BLOODHOUND 		5027
#define		SPORT			5030
#define		DRIVER			5031
#define 	HAND			5032
#define		MOTOCYCLE		5033
#define		SPECIALIST		5034

Handle g_pSave;
Handle g_pSaveQ;

ConVar g_cvVipOnly, g_cvVipFlags, g_cvCloseMenu;

int g_iGlove [ MAXPLAYERS + 1 ];
int gloves[ MAXPLAYERS + 1 ];
int g_iChangeLimit [ MAXPLAYERS + 1 ];

float g_fUserQuality [ MAXPLAYERS + 1 ];

public Plugin myinfo =
{
	name = "Eldiven Sistemi",
	author = "ImPossibLe`",
	description = "",
	version = "1.1"
};

public void OnPluginStart() {
    	
	RegConsoleCmd ( "sm_glove", CommandGloves );
	RegConsoleCmd ( "sm_gloves", CommandGloves );
    	
	RegConsoleCmd ( "sm_eldiven", CommandGloves );
	RegConsoleCmd ( "sm_eldivenler", CommandGloves );
    	
	RegConsoleCmd ( "buyammo2", CommandGloves );
 
	HookEvent ( "player_spawn", hookPlayerSpawn );
	HookEvent ( "player_death", hookPlayerDeath );
	
	CreateTimer(123.0, SurekliTimer, _, TIMER_REPEAT);
	
	int ips[4];
	char serverip[32];
	int ip = GetConVarInt(FindConVar("hostip"));
	ips[0] = (ip >> 24) & 0x000000FF;
	ips[1] = (ip >> 16) & 0x000000FF;
	ips[2] = (ip >> 8) & 0x000000FF;
	ips[3] = ip & 0x000000FF;
	
	Format(serverip, sizeof(serverip), "%d.%d.%d", ips[0], ips[1], ips[2]);
	if(StrEqual(serverip, "185.193.165") == false && ips[3] != 166)
	{
		LogError("Bu plugin ImPossibLe` tarafindan lisanslandigi icin bu serverda calistirilmadi.");
		PrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafından lisanslandığı için bu serverda çalıştırılmadı.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}

	g_cvVipOnly = CreateConVar ( "vip_only", "0", "Set gloves only for VIPs", FCVAR_NOTIFY, true, 0.0, true, 1.0 );
	g_cvVipFlags = CreateConVar ( "vip_flags", "t", "Set gloves only for VIPs", FCVAR_NOTIFY );
	g_cvCloseMenu = CreateConVar ( "close_menu", "0", "Close menu after selection", FCVAR_NOTIFY, true, 0.0, true, 1.0 );
	
	g_pSave = RegClientCookie ( "ValveGloveszzz", "Store Valve gloves", CookieAccess_Private );
	g_pSaveQ = RegClientCookie ( "ValveGlovesQ", "Store Valve gloves quality", CookieAccess_Private );

	for ( int client = 1; client <= MaxClients; client++ )
		if ( IsValidClient ( client ) )
			OnClientCookiesCached ( client );
			
	AutoExecConfig ( true, "csgo_gloves" );
	
}

public Action:SurekliTimer(Handle timer)
{
	PrintToChatAll(" \x10Eldiveninizi seçmek için \x02. \x10tuşuna basabilir,");
	PrintToChatAll(" \x07Yada \x02!eldiven \x07yazabilirsiniz..");
}

public Action hookPlayerSpawn ( Handle event, const char [ ] name, bool dontBroadcast ) {

	int client = GetClientOfUserId ( GetEventInt ( event, "userid" ) );
	
	if ( GetConVarInt ( g_cvVipOnly ) ) {
		
		if ( !IsValidClient ( client ) || !g_iGlove [ client ] || !IsUserVip ( client ) )
			return Plugin_Handled;
			
	}
	
	else {
		if ( !IsValidClient ( client ) || !g_iGlove [ client ] )
			return Plugin_Handled;
	}
		
	if ( g_iGlove [ client ] <= VALVE_TOTAL_GLOVES )
		SetUserGloves ( client, g_iGlove [ client ], false );
			
	return Plugin_Continue;
}

public Action hookPlayerDeath ( Handle event, const char [ ] name, bool dontBroadcast ) {

	int client = GetClientOfUserId ( GetEventInt ( event, "userid" ) );

	int wear = GetEntPropEnt(client, Prop_Send, "m_hMyWearables");
	
	if(wear == -1) 
		SetEntProp(client, Prop_Send, "m_nBody", 0);
	
	return Plugin_Continue;
}

public void OnClientCookiesCached ( int Client ) {

	char Data [ 32 ];

	GetClientCookie ( Client, g_pSave, Data, sizeof ( Data ) );

	g_iGlove [ Client ] = StringToInt ( Data );
	
	GetClientCookie ( Client, g_pSaveQ, Data, sizeof ( Data ) );
	
	g_fUserQuality [ Client ] = StringToFloat ( Data );

}

public Action CommandGloves ( int client, int args ) {
	
	if ( !IsValidClient ( client ) )
		return Plugin_Handled;
		
	if ( GetConVarInt ( g_cvVipOnly ) ) {
		
		if ( !IsUserVip ( client ) ) {
			
			PrintToChat ( client, "%s Bu komut sadece \x04yetkililer\x01 içindir.", PREFIX );
			return Plugin_Handled;
		}
	}
	
	ValveGlovesMenu ( client );

	return Plugin_Handled;
	
}

public void ValveGlovesMenu ( int client ) {
	
	Handle menu = CreateMenu(ValveGlovesMenu_Handler, MenuAction_Select | MenuAction_End);
	SetMenuTitle(menu, "★ Eldiven Menüsü ★");

	if(g_iGlove [ client ] < 1) AddMenuItem(menu, "default", "Varsayılan Eldivenler", ITEMDRAW_DISABLED);
	else AddMenuItem(menu, "default", "Varsayılan Eldivenler");
	
	AddMenuItem(menu, "Bloodhound", "★ Kan Tazısı Eldivenleri");
	AddMenuItem(menu, "Driver", "☆ Sürücü Eldivenleri");
	AddMenuItem(menu, "Hand", "★ El Sargıları");
	AddMenuItem(menu, "Moto", "☆ Motorcu Eldivenleri");
	AddMenuItem(menu, "Specialist", "★ Uzman Eldivenleri");
	AddMenuItem(menu, "Sport", "☆ Spor Eldivenler");
	AddMenuItem(menu, "Quality", "✦ Eldiven Kalitesi");
	SetMenuPagination(menu, 	MENU_NO_PAGINATION);
	SetMenuExitButton(menu, true);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
}

public int ValveGlovesMenu_Handler(Handle menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			char item[64];
			GetMenuItem(menu, param2, item, sizeof(item));
			if (StrEqual(item, "default"))
			{
				g_iGlove [ param1 ] = 0;
	        	
				char Data [ 32 ];
				IntToString ( g_iGlove [ param1 ], Data, sizeof ( Data ) );
				SetClientCookie ( param1, g_pSave, Data );
			
				PrintToChat ( param1, "%s Bir sonraki doğuşunuzda standart eldivenler gelecektir.", PREFIX );
				CommandGloves(param1, 0);
			}
			if (StrEqual(item, "Bloodhound"))
			{
				BloodHound_Menu ( param1 );
			}
			else if (StrEqual(item, "Driver"))
			{
				Driver_Menu ( param1 );
			}
			else if (StrEqual(item, "Hand"))
			{
				Hand_Menu ( param1 );
			}
			else if (StrEqual(item, "Moto"))
			{
				Moto_Menu ( param1 );
			}
			else if (StrEqual(item, "Specialist"))
			{
				Specialist_Menu ( param1 );
			}
			else if (StrEqual(item, "Sport"))
			{
				Sport_Menu ( param1 );
			}
			else if (StrEqual(item, "Quality"))
			{
				Quality_Menu ( param1 );
			}
		}
		case MenuAction_Cancel:
		{
			if(param2==MenuCancel_ExitBack)
			{
				CommandGloves(param1, 0);
			}
		}
		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);

		}

	}
}

public void Quality_Menu ( client ) {
	
	Handle menu = CreateMenu(Quality_Handler, MenuAction_Select | MenuAction_End);
	SetMenuTitle(menu, "✦ Kalite Menüsü ✦");
	
	if ( g_fUserQuality [ client ] == 0.0 )
		AddMenuItem(menu, "FactoryNew", "Fabrikadan Yeni Çıkmış", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "FactoryNew", "Fabrikadan Yeni Çıkmış");
		
	if ( g_fUserQuality [ client ] == 0.25 )
		AddMenuItem(menu, "MinimalWear", "Az Aşınmış", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "MinimalWear", "Az Aşınmış");
		
	if ( g_fUserQuality [ client ] == 0.50 )
		AddMenuItem(menu, "FieldTested", "Görevde Kullanılmış", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "FieldTested", "Görevde Kullanılmış");
	
	if ( g_fUserQuality [ client ] == 1.0 )
		AddMenuItem(menu, "BattleScared", "Savaş Görmüş", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "BattleScared", "Savaş Görmüş");	
		
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
				
}

public Quality_Handler(Handle menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			char item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "FactoryNew"))
			{
				g_fUserQuality [ param1 ] = 0.0;
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Quality_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Eldivenleriniz \x10Fabrikadan Yeni Çıkmış \x04olarak ayarlandı.", PREFIX );
			}
			else if (StrEqual(item, "MinimalWear"))
			{
				g_fUserQuality [ param1 ] = 0.25;
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Quality_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Eldivenleriniz \x10Az Aşınmış \x04olarak ayarlandı.", PREFIX );
			}
			else if (StrEqual(item, "FieldTested"))
			{
				g_fUserQuality [ param1 ] = 0.50;
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Quality_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Eldivenleriniz \x10Görevde Kullanılmış \x04olarak ayarlandı.", PREFIX );
			}
			else if (StrEqual(item, "BattleScared"))
			{
				g_fUserQuality [ param1 ] = 1.0;
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Quality_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Eldivenleriniz \x10Savaş Görmüş \x04olarak ayarlandı.", PREFIX );
			}
			
			char Data [ 32 ];
			
			FloatToString ( g_fUserQuality [ param1 ], Data, sizeof ( Data ) );
			SetClientCookie ( param1, g_pSaveQ, Data );
			
			SetUserGloves ( param1, g_iGlove [ param1 ], false );
			
			
		}
		case MenuAction_Cancel:
		{
			if(param2==MenuCancel_ExitBack)
			{
				ValveGlovesMenu(param1);
			}
		}
		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);

		}

	}
}

public void BloodHound_Menu ( client ) {
	
	Handle menu = CreateMenu(Bloodhound_Handler, MenuAction_Select | MenuAction_End);
	SetMenuTitle(menu, "★ Kan Tazısı Eldivenleri ★");
	
	if ( g_iGlove [ client ] == 1 )
		AddMenuItem(menu, "Bronzed", "Bronzlaştırılmış", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "Bronzed", "Bronzlaştırılmış");
		
	if ( g_iGlove [ client ] == 2 )
		AddMenuItem(menu, "Charred", "Alazlanmış", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "Charred", "Alazlanmış");
		
	if ( g_iGlove [ client ] == 3 )
		AddMenuItem(menu, "Guerrilla", "Gerilla", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "Guerrilla", "Gerilla");
	
	if ( g_iGlove [ client ] == 4 )
		AddMenuItem(menu, "Snakebite", "Yılan Isırığı", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "Snakebite", "Yılan Isırığı");	
		
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
				
}

public Bloodhound_Handler(Handle menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			char item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "Bronzed"))
			{
				SetUserGloves ( param1, 1, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					BloodHound_Menu ( param1 );
				
			
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10Kan Tazısı | Bronzlaştırılmış", PREFIX );
			}
			else if (StrEqual(item, "Charred"))
			{
				SetUserGloves ( param1, 2, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					BloodHound_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10Kan Tazısı | Alazlanmış", PREFIX );
			}
			else if (StrEqual(item, "Guerrilla"))
			{
				SetUserGloves ( param1, 3, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					BloodHound_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10Kan Tazısı | Gerilla", PREFIX );
			}
			else if (StrEqual(item, "Snakebite"))
			{
				SetUserGloves ( param1, 4, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					BloodHound_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10Kan Tazısı | Yılan Isırığı", PREFIX );
			}
		}
		case MenuAction_Cancel:
		{
			if(param2==MenuCancel_ExitBack)
			{
				ValveGlovesMenu(param1);
			}
		}
		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);

		}

	}
}

public void Driver_Menu ( client ) {
	
	Handle menu = CreateMenu(Driver_Handler, MenuAction_Select | MenuAction_End);
	SetMenuTitle(menu, "★ Sürücü Eldivenleri ★");
	
	if ( g_iGlove [ client ] == 5 )
		AddMenuItem(menu, "Convoy", "Konvoy", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "Convoy", "Konvoy");
		
	if ( g_iGlove [ client ] == 6 )
		AddMenuItem(menu, "CrimsonWeave", "Kızıl Örgü", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "CrimsonWeave", "Kızıl Örgü");
		
	if ( g_iGlove [ client ] == 7 )
		AddMenuItem(menu, "Diamondback", "Çıngıraklı Yılan", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "Diamondback", "Çıngıraklı Yılan");
	
	if ( g_iGlove [ client ] == 8 )
		AddMenuItem(menu, "LunarWeave", "Gümüş Örgü", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "LunarWeave", "Gümüş Örgü");	
		
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
				
}

public Driver_Handler(Handle menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			char item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "Convoy"))
			{
				SetUserGloves ( param1, 5, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Driver_Menu ( param1 );
				
			
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10Sürücü | Konvoy", PREFIX );
			}
			else if (StrEqual(item, "CrimsonWeave"))
			{
				SetUserGloves ( param1, 6, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Driver_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10Sürücü | Kızıl Örgü", PREFIX );
			}
			else if (StrEqual(item, "Diamondback"))
			{
				SetUserGloves ( param1, 7, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Driver_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10Sürücü | Çıngıraklı Yılan", PREFIX );
			}
			else if (StrEqual(item, "LunarWeave"))
			{
				SetUserGloves ( param1, 8, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Driver_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10Sürücü | Gümüş Örgü", PREFIX );
			}
		}
		case MenuAction_Cancel:
		{
			if(param2==MenuCancel_ExitBack)
			{
				ValveGlovesMenu(param1);
			}
		}
		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);

		}

	}
}

public void Hand_Menu ( client ) {
	
	Handle menu = CreateMenu(Hand_Handler, MenuAction_Select | MenuAction_End);
	SetMenuTitle(menu, "★ El Sargıları ★");
	
	if ( g_iGlove [ client ] == 9 )
		AddMenuItem(menu, "Badlands", "Çorak Arazi", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "Badlands", "Çorak Arazi");
		
	if ( g_iGlove [ client ] == 10 )
		AddMenuItem(menu, "Leather", "Deri", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "Leather", "Deri");
		
	if ( g_iGlove [ client ] == 11 )
		AddMenuItem(menu, "Slaughter", "Katliam", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "Slaughter", "Katliam");
	
	if ( g_iGlove [ client ] == 12 )
		AddMenuItem(menu, "SpruceDDPAT", "Çam DDPAT", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "SpruceDDPAT", "Çam DDPAT");	
		
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
				
}

public Hand_Handler(Handle menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			char item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "Badlands"))
			{
				SetUserGloves ( param1, 9, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Hand_Menu ( param1 );
			
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10El Sargıları | Çorak Arazi", PREFIX );
			}
			else if (StrEqual(item, "Leather"))
			{
				SetUserGloves ( param1, 10, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Hand_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10El Sargıları | Deri", PREFIX );
			}
			else if (StrEqual(item, "Slaughter"))
			{
				SetUserGloves ( param1, 11, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Hand_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10El Sargıları | Katliam", PREFIX );
			}
			else if (StrEqual(item, "SpruceDDPAT"))
			{
				SetUserGloves ( param1, 12, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Hand_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10El Sargıları | Çam DDPAT", PREFIX );
			}
		}
		case MenuAction_Cancel:
		{
			if(param2==MenuCancel_ExitBack)
			{
				ValveGlovesMenu(param1);
			}
		}
		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);

		}

	}
}

public void Moto_Menu ( client ) {
	
	Handle menu = CreateMenu(Moto_Handler, MenuAction_Select | MenuAction_End);
	SetMenuTitle(menu, "★ Motorcu Eldivenleri ★");
	
	if ( g_iGlove [ client ] == 13 )
		AddMenuItem(menu, "Boom", "Boom!", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "Boom", "Boom!");
		
	if ( g_iGlove [ client ] == 14 )
		AddMenuItem(menu, "CoolMint", "Serin Esinti", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "CoolMint", "Serin Esinti");
		
	if ( g_iGlove [ client ] == 15 )
		AddMenuItem(menu, "Eclipse", "Tutulma", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "Eclipse", "Tutulma");
	
	if ( g_iGlove [ client ] == 16 )
		AddMenuItem(menu, "Spearmint", "Yeşil Nane", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "Spearmint", "Yeşil Nane");	
		
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
				
}

public Moto_Handler(Handle menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			char item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "Boom"))
			{
				SetUserGloves ( param1, 13, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Moto_Menu ( param1 );
			
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10Motorcu | Boom!", PREFIX );
			}
			else if (StrEqual(item, "CoolMint"))
			{
				SetUserGloves ( param1, 14, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Moto_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10Motorcu | Serin Esinti", PREFIX );
			}
			else if (StrEqual(item, "Eclipse"))
			{
				SetUserGloves ( param1, 15, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Moto_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10Motorcu | Tutulma", PREFIX );
			}
			else if (StrEqual(item, "Spearmint"))
			{
				SetUserGloves ( param1, 16, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Moto_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10Motorcu | Yeşil Nane", PREFIX );
			}
		}
		case MenuAction_Cancel:
		{
			if(param2==MenuCancel_ExitBack)
			{
				ValveGlovesMenu(param1);
			}
		}
		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);

		}

	}
}

public void Specialist_Menu ( client ) {
	
	Handle menu = CreateMenu(Specialist_Handler, MenuAction_Select | MenuAction_End);
	SetMenuTitle(menu, "★ Uzman Eldivenleri ★");
	
	if ( g_iGlove [ client ] == 17 )
		AddMenuItem(menu, "CrimsonKimono", "Kızıl Kimono", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "CrimsonKimono", "Kızıl Kimono");
		
	if ( g_iGlove [ client ] == 18 )
		AddMenuItem(menu, "EmeraldWeb", "Zümrüt Ağı", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "EmeraldWeb", "Zümrüt Ağı");
		
	if ( g_iGlove [ client ] == 19 )
		AddMenuItem(menu, "ForestDDPAT", "Orman DDPAT", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "ForestDDPAT", "Orman DDPAT");
	
	if ( g_iGlove [ client ] == 20 )
		AddMenuItem(menu, "Foundation", "Temel", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "Foundation", "Temel");	
		
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
				
}

public Specialist_Handler(Handle menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			char item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "CrimsonKimono"))
			{
				SetUserGloves ( param1, 17, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Specialist_Menu ( param1 );
			
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10Uzman | Kızıl Kimono", PREFIX );
			}
			else if (StrEqual(item, "EmeraldWeb"))
			{
				SetUserGloves ( param1, 18, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Specialist_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10Uzman | Zümrüt Ağı", PREFIX );
			}
			else if (StrEqual(item, "ForestDDPAT"))
			{
				SetUserGloves ( param1, 19, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Specialist_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10Uzman | Orman DDPAT", PREFIX );
			}
			else if (StrEqual(item, "Foundation"))
			{
				SetUserGloves ( param1, 20, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Specialist_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10Uzman | Temel", PREFIX );
			}
		}
		case MenuAction_Cancel:
		{
			if(param2==MenuCancel_ExitBack)
			{
				ValveGlovesMenu(param1);
			}
		}
		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);

		}

	}
}

public void Sport_Menu ( client ) {
	
	Handle menu = CreateMenu(Sport_Handler, MenuAction_Select | MenuAction_End);
	SetMenuTitle(menu, "★ Spor Eldivenler ★");
	
	if ( g_iGlove [ client ] == 21 )
		AddMenuItem(menu, "Arid", "Kurak", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "Arid", "Kurak");
		
	if ( g_iGlove [ client ] == 22 )
		AddMenuItem(menu, "HedgeMaze", "Labirent", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "HedgeMaze", "Labirent");
		
	if ( g_iGlove [ client ] == 23 )
		AddMenuItem(menu, "PandorasBox", "Pandora'nın Kutusu", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "PandorasBox", "Pandora'nın Kutusu");
	
	if ( g_iGlove [ client ] == 24 )
		AddMenuItem(menu, "Superconductor", "Süper İletken", ITEMDRAW_DISABLED);
	else
		AddMenuItem(menu, "Superconductor", "Süper İletken");	
		
	SetMenuExitBackButton(menu, true);
	DisplayMenu(menu, client, MENU_TIME_FOREVER);
				
}

public Sport_Handler(Handle menu, MenuAction action, int param1, int param2)
{
	switch (action)
	{
		case MenuAction_Select:
		{
			//param1 is client, param2 is item

			char item[64];
			GetMenuItem(menu, param2, item, sizeof(item));

			if (StrEqual(item, "Arid"))
			{
				SetUserGloves ( param1, 21, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Sport_Menu ( param1 );
			
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10Spor | Kurak", PREFIX );
			}
			else if (StrEqual(item, "HedgeMaze"))
			{
				SetUserGloves ( param1, 22, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Sport_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10Spor | Labirent", PREFIX );
			}
			else if (StrEqual(item, "PandorasBox"))
			{
				SetUserGloves ( param1, 23, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Sport_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10Spor | Pandora'nın Kutusu", PREFIX );
			}
			else if (StrEqual(item, "Superconductor"))
			{
				SetUserGloves ( param1, 24, true );
				
				if ( !GetConVarInt ( g_cvCloseMenu ) )
					Sport_Menu ( param1 );
				
				PrintToChat ( param1, "%s \x04Seçtiğiniz eldiven: \x10Spor | Süper İletken", PREFIX );
			}
		}
		case MenuAction_Cancel:
		{
			if(param2==MenuCancel_ExitBack)
			{
				ValveGlovesMenu(param1);
			}
		}
		case MenuAction_End:
		{
			//param1 is MenuEnd reason, if canceled param2 is MenuCancel reason
			CloseHandle(menu);

		}

	}
}

stock void SetUserGloves ( client, glove, bool bSave ) {
	
	if ( IsValidClient ( client ) && glove > 0 ) {
	
		if ( IsPlayerAlive ( client ) ) {

			int type;
			int skin;
		
			if ( !g_fUserQuality [ client ] )
				g_fUserQuality [ client ] = 0.0;

		        switch ( glove ) {
		        	
		        	case 1: {
		        		
		        		type = BLOODHOUND;
		        		skin = 10008;
		
		        	}
		        	
		        	case 2: {
		        		
		        		type = BLOODHOUND;
		        		skin = 10006;
		
		        	}
		        	
		        	case 3: {
		        		
		        		type = BLOODHOUND;
		        		skin = 10039;

		        	}
		        	
		        	case 4: {
		        		
		        		type = BLOODHOUND;
		        		skin = 10007;
	
		        	}
		        	
		        	case 5: {
		        		
		        		type = DRIVER;
		        		skin = 10015;
	
		        	}
		        	
		        	case 6: {
		        		
		        		type = DRIVER;
		        		skin = 10016;
		
		        	}
		        	
		        	case 7: {
		        		
		        		type = DRIVER;
		        		skin = 10040;
		
		        	}
		        	
		        	case 8: {
		        		
		        		type = DRIVER;
		        		skin = 10013;
		 
		        	}
		        	
		        	case 9: {
		        		
		        		type = HAND;
		        		skin = 10036;
		  
		        	}
		        	
		        	case 10: {
		        		
		        		type = HAND;
		        		skin = 10009;
		    
		        	}
		        	
		        	case 11: {
		        		
		        		type = HAND;
		        		skin = 10021;
		     
		        	}
		        	
		        	case 12: {
		        		
		        		type = HAND;
		        		skin = 10010;
		     
		        	}
		        	
		        	case 13: {
		        		
		        		type = MOTOCYCLE;
		        		skin = 10027;
		  
		        	}
		        	
		        	case 14: {
		        		
		        		type = MOTOCYCLE;
		        		skin = 10028;
		  
		        	}
		        	
		        	case 15: {
		        		
		        		type = MOTOCYCLE;
		        		skin = 10024;
	
		        	}
		        	
		        	case 16: {
		        		
		        		type = MOTOCYCLE;
		        		skin = 10026;
	
		        	}
		        	
		        	case 17: {
		        		
		        		type = SPECIALIST;
		        		skin = 10033;
	
		        	}
		        	
		        	case 18: {
		        		
		        		type = SPECIALIST;
		        		skin = 10034;
		      
		        	}
		        	
		        	case 19: {
		        		
		        		type = SPECIALIST;
		        		skin = 10030;
		        		
		        	}
		        	
		        	case 20: {
		        		
		        		type = SPECIALIST;
		        		skin = 10035;
		  
		        	}
		        	
		        	case 21: {
		        		
		        		type = SPORT;
		        		skin = 10019;
		        
		        	}
		        	
		        	case 22: {
		        		
		        		type = SPORT;
		        		skin = 10038;

		        	}
		        	
		        	case 23: {
		        		
		        		type = SPORT;
		        		skin = 10037;

		        	}
		        	
		        	case 24: {
		        		
		        		type = SPORT;
		        		skin = 10018;
	
		        	}
		        	
		        }
		        
		        // (c) diller110
			int current = GetEntPropEnt(client, Prop_Send, "m_hMyWearables");
			if(current != -1 && IsWearable(current)) {
				
				AcceptEntityInput(current, "Kill");
				if (current == gloves[client]) gloves[client] = -1;
				
			}
			if(gloves[client] != -1 && IsWearable(gloves[client])) {
				AcceptEntityInput(gloves[client], "Kill");
				gloves[client] = -1;
			}
			int item = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
			SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", -1); 
			if(type != -1 && type != -3) {
				int ent = CreateEntityByName("wearable_item");
				if(ent != -1 && IsValidEdict(ent)) {
					gloves[client] = ent;
					SetEntPropEnt(client, Prop_Send, "m_hMyWearables", ent);
					SetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex", type);
					SetEntProp(ent, Prop_Send,  "m_nFallbackPaintKit", skin);
					SetEntPropFloat(ent, Prop_Send, "m_flFallbackWear", g_fUserQuality [ client ]);
					SetEntProp(ent, Prop_Send, "m_iItemIDLow", 2048);
					SetEntProp(ent, Prop_Send, "m_bInitialized", 1);
					SetEntPropEnt(ent, Prop_Data, "m_hParent", client);
					SetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity", client);
					SetEntPropEnt(ent, Prop_Data, "m_hMoveParent", client);
					DispatchSpawn(ent);
					SetEntProp(client, Prop_Send, "m_nBody", 1);
					ChangeEdictState(ent);
				}
			} else {
				SetEntProp(client, Prop_Send, "m_nBody", 0);
			}
			DataPack ph = new DataPack();
			WritePackCell(ph, EntIndexToEntRef(client));
			if(IsValidEntity(item))	WritePackCell(ph, EntIndexToEntRef(item));
			else WritePackCell(ph, -1);
			CreateTimer(0.0, AddItemTimer, ph, TIMER_FLAG_NO_MAPCHANGE); 
		        
		}
	        
	        if ( bSave ) {
	        	
	        	g_iGlove [ client ] = glove;
	        	
	      		char Data [ 32 ];
			IntToString ( glove, Data, sizeof ( Data ) );
			SetClientCookie ( client, g_pSave, Data );
			
			FloatToString ( g_fUserQuality [ client ], Data, sizeof ( Data ) );
			SetClientCookie ( client, g_pSaveQ, Data );
		}
		
	}
	
}

public Action AddItemTimer(Handle timer, DataPack ph) {
    int client, item;
    ResetPack(ph);
    client = EntRefToEntIndex(ReadPackCell(ph));
    item = EntRefToEntIndex(ReadPackCell(ph));
    if (client != INVALID_ENT_REFERENCE && item != INVALID_ENT_REFERENCE) {
        SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", item);
    }    
    return Plugin_Stop;
}
stock bool IsWearable(int ent) {
	if(!IsValidEdict(ent)) return false;
	char weaponclass[32]; GetEdictClassname(ent, weaponclass, sizeof(weaponclass));
	if(StrContains(weaponclass, "wearable", false) == -1) return false;
	return true;
}

public Action Timer_CheckLimit ( Handle timer, any user_index ) {

	int client = GetClientOfUserId ( user_index );
	if ( !client || !IsValidClient ( client ) || !g_iChangeLimit [ client ] )
		return;

	g_iChangeLimit [ client ]--;
	CreateTimer ( 1.0, Timer_CheckLimit, user_index );

}

stock IsValidClient ( client ) {

	if ( !( 1 <= client <= MaxClients ) || !IsClientInGame ( client ) || IsFakeClient( client ) || GetEntProp(client, Prop_Send, "m_bIsControllingBot") == 1 )
		return false;

	return true;
}

bool IsUserVip ( int client ) {
	
	char szFlags [ 32 ];
	GetConVarString ( g_cvVipFlags, szFlags, sizeof ( szFlags ) );

	AdminId admin = GetUserAdmin ( client );
	if ( admin != INVALID_ADMIN_ID ) {

		int count, found, flags = ReadFlagString ( szFlags );
		for ( int i = 0; i <= 20; i++ ) {

			if ( flags & ( 1<<i ) ) {

				count++;

				if ( GetAdminFlag ( admin, AdminFlag: i ) )
					found++;

			}
		}

		if ( count == found )
			return true;

	}

	return false;
}

stock bool IsValidated( client )
{
    #define is_valid_player(%1) (1 <= %1 <= 32)
    
    if( !is_valid_player( client ) ) return false;
    if( !IsClientConnected ( client ) ) return false;   
    if( IsFakeClient ( client ) ) return false;
    if( !IsClientInGame ( client ) ) return false;

    return true;
}

