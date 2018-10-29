#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
	name = "Adminlerin !! komutuyla yazması",
	description = "DrK # GaminG",
	author = "ImPossibLe`",
	version = "1.0"
};

public void OnPluginStart()
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
	RegAdminCmd("sm_!", test, ADMFLAG_GENERIC);
}

public Action test(int client, int args)
{
	if (args < 1)
	{
		ReplyToCommand(client, "[DrK # GaminG] Kullanım: sm_! <mesaj>");
		return Plugin_Handled;
	}
	char text[192];
	GetCmdArgString(text, 192);
	char nameBuf[32];
	GetClientName(client, nameBuf, 32);
	PrintCenterTextAll("<font color='#FF0000'>%s:<font color='#00FF00'> %s</font>", nameBuf, text);
	return Plugin_Continue;
}

