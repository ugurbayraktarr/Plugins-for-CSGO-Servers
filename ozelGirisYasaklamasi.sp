#pragma semicolon 1
#include <sourcemod>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Özel Giriş Yasaklamaları",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

char steamID[MAXPLAYERS+1][24];
char nickler[MAXPLAYERS+1][100];

public OnClientPutInServer(client)
{
	decl String:authid[32];
	GetClientAuthString(client, authid, sizeof(authid));
	
	if(StrEqual(authid, "STEAM_1:0:117849611", false))
	{
		PrintToChatAll(" \x02[DrK # GaminG] \x10%N \x04oyuna girmeye çalıştı, ancak \x02kalıcı olarak \04yasaklandığı için atıldı.", client);
		KickClient(client, "Bu sunucuya girişiniz ImPossibLe` tarafından kalıcı olarak yasaklanmıştır.");
	}
	else if(StrEqual(authid, "STEAM_1:1:2615226", false))
	{
		PrintToChatAll(" \x02[DrK # GaminG] \x10%N \x04oyuna girmeye çalıştı, ancak \x02kalıcı olarak \04yasaklandığı için atıldı.", client);
		KickClient(client, "Bu sunucuya girişiniz ImPossibLe` tarafından kalıcı olarak yasaklanmıştır.");
	}
	else if(StrEqual(authid, "STEAM_1:0:160152779", false))
	{
		PrintToChatAll(" \x02[DrK # GaminG] \x10%N \x04oyuna girmeye çalıştı, ancak \x02kalıcı olarak \04yasaklandığı için atıldı.", client);
		KickClient(client, "Bu sunucuya girişiniz ImPossibLe` tarafından kalıcı olarak yasaklanmıştır.");
	}
	else if(StrEqual(authid, "STEAM_1:0:86522392", false))
	{
		PrintToChatAll(" \x02[DrK # GaminG] \x10%N \x04oyuna girmeye çalıştı, ancak \x02kalıcı olarak \04yasaklandığı için atıldı.", client);
		KickClient(client, "Bu sunucuya girişiniz ImPossibLe` tarafından kalıcı olarak yasaklanmıştır.");
	}
	else if(StrEqual(authid, "STEAM_1:0:102436443", false))
	{
		PrintToChatAll(" \x02[DrK # GaminG] \x10%N \x04oyuna girmeye çalıştı, ancak \x02kalıcı olarak \04yasaklandığı için atıldı.", client);
		KickClient(client, "Bu sunucuya girişiniz ImPossibLe` tarafından kalıcı olarak yasaklanmıştır.");
	}
	else if(StrEqual(authid, "STEAM_1:0:89471313", false))
	{
		PrintToChatAll(" \x02[DrK # GaminG] \x10%N \x04oyuna girmeye çalıştı, ancak \x02kalıcı olarak \04yasaklandığı için atıldı.", client);
		KickClient(client, "Bu sunucuya girişiniz ImPossibLe` tarafından kalıcı olarak yasaklanmıştır.");
	}
	else if(StrEqual(authid, "STEAM_1:0:160285685", false))
	{
		PrintToChatAll(" \x02[DrK # GaminG] \x10%N \x04oyuna girmeye çalıştı, ancak \x02kalıcı olarak \04yasaklandığı için atıldı.", client);
		KickClient(client, "Bu sunucuya girişiniz ImPossibLe` tarafından kalıcı olarak yasaklanmıştır.");
	}
	else if(StrEqual(authid, "STEAM_1:0:72323140", false))
	{
		PrintToChatAll(" \x02[DrK # GaminG] \x10%N \x04oyuna girmeye çalıştı, ancak \x02kalıcı olarak \04yasaklandığı için atıldı.", client);
		KickClient(client, "Bu sunucuya girişiniz ImPossibLe` tarafından kalıcı olarak yasaklanmıştır.");
	}
	else if(StrEqual(authid, "STEAM_1:0:75952273", false))
	{
		PrintToChatAll(" \x02[DrK # GaminG] \x10%N \x04oyuna girmeye çalıştı, ancak \x02kalıcı olarak \04yasaklandığı için atıldı.", client);
		KickClient(client, "Bu sunucuya girişiniz ImPossibLe` tarafından kalıcı olarak yasaklanmıştır.");
	}
	else if(StrEqual(authid, "STEAM_1:0:162615479", false))
	{
		PrintToChatAll(" \x02[DrK # GaminG] \x10%N \x04oyuna girmeye çalıştı, ancak \x02kalıcı olarak \04yasaklandığı için atıldı.", client);
		KickClient(client, "Bu sunucuya girişiniz ImPossibLe` tarafından kalıcı olarak yasaklanmıştır.");
	}
	else if(StrEqual(authid, "STEAM_1:0:459111", false))
	{
		PrintToChatAll(" \x02[DrK # GaminG] \x10%N \x04oyuna girmeye çalıştı, ancak \x02kalıcı olarak \04yasaklandığı için atıldı.", client);
		KickClient(client, "Bu sunucuya girişiniz ImPossibLe` tarafından kalıcı olarak yasaklanmıştır.");
	}
	else
	{
		PrintToChatAll(" \x02[DrK # GaminG] \x10%N \x04oyuna girdi.", client);
		PrintToChatAll(" \x10%N\x04'nin \x0BSteamID: \x0E%s", client, authid);
		
		GetClientAuthString(client, steamID[client], sizeof(steamID));
		GetClientName(client, nickler[client], sizeof(nickler));
		
	}
}

public OnClientDisconnect(client)
{	
	if(client > 0 && client < MaxClients)
	{
		PrintToChatAll(" \x02[DrK # GaminG] \x04%s \x10oyundan çıktı.", nickler[client]);
		PrintToChatAll(" \x10%s\x04'nin \x0ESteamID: \x0B%s", nickler[client], steamID[client]);
	}
}