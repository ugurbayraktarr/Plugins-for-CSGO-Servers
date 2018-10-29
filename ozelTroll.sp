#pragma semicolon 1
#include <sdktools>
#include <sdkhooks>
#include <sourcemod>
#include <cstrike>
#include <csgoitems>

public Plugin:myinfo =
{
	name = "Troll Oyunları",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "1.1",
};
#define MAX_WEAPONS 38
new const String:g_weapons[MAX_WEAPONS][] = {
	"weapon_ak47", "weapon_aug", "weapon_bizon", "weapon_deagle", "weapon_decoy", "weapon_elite", "weapon_famas", "weapon_fiveseven", "weapon_flashbang",
	"weapon_g3sg1", "weapon_galilar", "weapon_glock", "weapon_hegrenade", "weapon_hkp2000", "weapon_incgrenade", "weapon_knife", "weapon_m249", "weapon_m4a1",
	"weapon_mac10", "weapon_mag7", "weapon_molotov", "weapon_mp7", "weapon_mp9", "weapon_negev", "weapon_nova", "weapon_p250", "weapon_p90", "weapon_sawedoff",
	"weapon_scar20", "weapon_sg556", "weapon_smokegrenade", "weapon_ssg08", "weapon_taser", "weapon_tec9", "weapon_ump45", "weapon_xm1014", "weapon_awp", "weapon_revolver"
};

bool trollYapilacak = false;
bool trollBasladi = false;
static int silahID = -1;


public OnPluginStart()
{
	trollYapilacak = false;
	trollBasladi = false;
	silahID = -1;
	RegAdminCmd("sm_troll", TrollAyarla, ADMFLAG_RCON, "sm_troll <silah>");
	HookEvent("round_start", Event_Round_Start, EventHookMode_Pre);
	HookEvent("round_end", Event_Round_End);
	CreateTimer(2.0, SurekliTimer, _, TIMER_REPEAT);
}

public OnMapStart()
{
	trollYapilacak = false;
	trollBasladi = false;
	silahID = -1;
}


public Action:TrollAyarla(client, args)
{
	if(!trollYapilacak)
	{
		decl String:sWeaponName[32], String:sWeaponNameTemp[32];
		new iValid;

		GetCmdArg(1, sWeaponName, sizeof(sWeaponName));

		if(StrContains(sWeaponName, "weapon_") == -1)
		{
			FormatEx(sWeaponNameTemp, 31, "weapon_");
			StrCat(sWeaponNameTemp, 31, sWeaponName);
			
			strcopy(sWeaponName, 31, sWeaponNameTemp);
		}
		
		for(new i = 0; i < MAX_WEAPONS; ++i)
		{
			if(StrEqual(sWeaponName, g_weapons[i]))
			{
				iValid = 1;
				silahID = i;
				break;
			}
		}
		
		if(!iValid)
		{
			PrintToChat(client, " \x02[DrK # GaminG] \x10Girdiğiniz silah geçersiz: \x04%s", sWeaponName);
			return Plugin_Handled;
		}
		
		trollYapilacak = true;
		
		PrintToChatAll(" \x02[DrK # GaminG] \x10Bir sonraki el sadece \x04%s \x10oynanacaktır.", sWeaponName);
	}
	else
		PrintToChatAll(" \x02[DrK # GaminG] \x10Bir sonraki el zaten bir troll oynanacaktır.");
		
	
	

	/*for (new i = 0; i < target_count; i++)
	{
		GivePlayerItem(target_list[i], sWeaponName);
	}
	PrintToChatAll(" \x02[DrK # GaminG] \x04Tüm Oyunculara \x10%N tarafından \x07%s \x04verildi.", client, sWeaponName);*/
	
	return Plugin_Handled;
}

public OnEntityCreated(entity, const char[] classname) 
{
	if(trollBasladi)
	{
		if(StrContains(classname, "weapon_", false) != -1)
		{
			if(!((StrEqual(classname, g_weapons[silahID])) || (StrEqual(classname, "weapon_c4")) || (StrEqual(classname, "planted_c4"))))
			{
				AcceptEntityInput(entity, "Kill");
			}
		}
	}
}

public Action:Event_Round_Start(Handle:event, const String:name[], bool:dontBroadcast)
{
	if(trollYapilacak && silahID != -1)
	{
		trollYapilacak = false;
		trollBasladi = true;
		CreateTimer(0.1, SilahlariAl);
		CreateTimer(1.0, SilahlariVer);
	}
}

public Action SilahlariAl(Handle timer)
{
	ServerCommand("sm_strip @all 1234");
}

public Action SilahlariVer(Handle timer)
{
	for (new i = 1; i < MaxClients; i++)
	{
		if(IsClientInGame(i) && IsClientConnected(i) && !IsFakeClient(i))
		{
			if(StrEqual(g_weapons[silahID], "weapon_revolver"))
				CSGOItems_GiveWeapon(i, "weapon_revolver", 100, 8, CS_SLOT_SECONDARY); 
			else if(StrEqual(g_weapons[silahID], "weapon_deagle"))
				CSGOItems_GiveWeapon(i, "weapon_deagle", 100, 7, CS_SLOT_SECONDARY); 
			else
				GivePlayerItem(i, g_weapons[silahID]);
		}
	}
	PrintToChatAll(" \x02[DrK # GaminG] \x04Tüm Oyunculara \x07%s \x04verildi.", g_weapons[silahID]);
}

public Action:Event_Round_End(Handle:event, const String:name[], bool:dontBroadcast)
{
	if(trollBasladi)
		trollBasladi = false;
}

public Action:CS_OnBuyCommand(client, const String:weapon[])
{
	if(trollBasladi)
	{
		PrintToChat(client, " \x02[DrK # GaminG] \x04Özel troll oyunları sırasında silah alamazsınız.");
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public Action SurekliTimer(Handle timer)
{
	if(trollBasladi)
	{
		new silahSayisi[MAXPLAYERS+1], i, silahEnt;
		for(i=1;i<=MaxClients;i++)
		{
			if(!IsClientConnected(i)) continue;
			if(!IsClientInGame(i)) continue;
			if(!IsPlayerAlive(i)) continue;
			if(IsFakeClient(i)) continue;
			silahSayisi[i] = 0;
			silahEnt = GetPlayerWeaponSlot(i, 0);
			decl String:silahIsmi[32];
			if(silahEnt != -1)
			{
				GetEntityClassname(silahEnt, silahIsmi, sizeof(silahIsmi));
				if(StrContains(silahIsmi, "weapon_") != -1)
					silahSayisi[i]++;
			}
			silahEnt = GetPlayerWeaponSlot(i, 1);
			if(silahEnt != -1)
			{
				GetEntityClassname(silahEnt, silahIsmi, sizeof(silahIsmi));
				if(StrContains(silahIsmi, "weapon_") != -1)
					silahSayisi[i]++;
			}
			silahEnt = GetPlayerWeaponSlot(i, 2);
			if(silahEnt != -1)
			{
				GetEntityClassname(silahEnt, silahIsmi, sizeof(silahIsmi));
				if(StrContains(silahIsmi, "weapon_") != -1)
					silahSayisi[i]++;
			}
			silahEnt = GetPlayerWeaponSlot(i, 3);
			if(silahEnt != -1)
			{
				GetEntityClassname(silahEnt, silahIsmi, sizeof(silahIsmi));
				if(StrContains(silahIsmi, "weapon_") != -1)
					silahSayisi[i]++;
			}
			if(silahSayisi[i] == 0)
			{
				if(StrEqual(g_weapons[silahID], "weapon_revolver"))
					CSGOItems_GiveWeapon(i, "weapon_revolver", 8, 16, CS_SLOT_SECONDARY);
				else if(StrEqual(g_weapons[silahID], "weapon_deagle"))
					CSGOItems_GiveWeapon(i, "weapon_deagle", 7, 100, CS_SLOT_SECONDARY); 
				else
					GivePlayerItem(i, g_weapons[silahID]);
			}
		}
	}
}