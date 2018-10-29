#include <sourcemod>
#include <smlib>
#include <sdkhooks>

#define MAX_FILE_LEN 80
new Handle:g_CvarSesismi = INVALID_HANDLE;
new String:g_Sesismi[MAX_FILE_LEN];
bool yazildi = false;

public Plugin:myinfo = 
{
	name = "İsyan Sesi",
	author = "ImPossibLe`",
	description = "Mahkumlar isyan baslattiginda belirlediginiz ses calar.",
	version = "1.0"
}

public OnPluginStart()
{
	g_CvarSesismi = CreateConVar("sm_isyan_sesi", "misc/drkozelses/isyan.mp3", "Isyan Sesi");
	HookEvent("round_start", Event_RoundStart);
}

public Event_RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	yazildi = false;
}

public OnClientPostAdminCheck(iClient) 
{ 
    SDKHook(iClient, SDKHook_OnTakeDamage, OnTakeDamage); 
} 

public OnMapStart()
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
	
	GetConVarString(g_CvarSesismi, g_Sesismi, MAX_FILE_LEN);
	decl String:buffer[MAX_FILE_LEN];
	PrecacheSound(g_Sesismi, true);
	Format(buffer, sizeof(buffer), "sound/%s", g_Sesismi);
	AddFileToDownloadsTable(buffer);
	
	decl String:mapName[64];
	GetCurrentMap(mapName, sizeof(mapName));
	
	if(!((StrContains(mapName, "jb_", false) != -1) || (StrContains(mapName, "jail_", false)!= -1)))
	{
		SetFailState("Bu plugin sadece jail maplarinda calismaktadir..");
	}
}

public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype) 
{
	new iAttacker;
	if(attacker>64)
		iAttacker = GetClientOfUserId(attacker);
	else
		iAttacker = attacker;
	
	if(iAttacker > 0)
	{	
		decl String:isim[32];
		GetClientName(iAttacker, isim, sizeof(isim));
		
		if(GetClientTeam(iAttacker) == 2 && GetClientTeam(victim) == 3) 
		{
			new i;
			for(i=1;i<=MaxClients;i++)
			{
				if(!IsClientConnected(i)) continue;
				if(!IsClientInGame(i)) continue;
				if(!yazildi)
				{
					PrintToChat(i," \x02[DrK # GaminG] \x04%s \x10isimli MAHKUM isyan başlattı.",isim);
					yazildi = true
					ClientCommand(i,"play *%s", g_Sesismi)
				}
			}
		}
	}
}