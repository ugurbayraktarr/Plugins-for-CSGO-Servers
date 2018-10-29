#pragma semicolon 1
#include <sourcemod>

public Plugin myinfo =
{
	name = "GSLT Ayari",
	description = "DrK # GaminG",
	author = "ImPossibLe`",
	version = "1.0",
	url = ""
};

public void OnPluginStart()
{
	int ips[4];
	int ip = GetConVarInt(FindConVar("hostip"));
	ips[0] = (ip >> 24) & 0x000000FF;
	ips[1] = (ip >> 16) & 0x000000FF;
	ips[2] = (ip >> 8) & 0x000000FF;
	ips[3] = ip & 0x000000FF;
	char serverip[32];
	Format(serverip, sizeof(serverip), "%d.%d.%d.%d", ips[0], ips[1], ips[2], ips[3]);
	if (StrEqual(serverip, "185.122.202.2", true))
	{
		ServerCommand("sv_setsteamaccount D758EFD0E7BD589EE7634F908F856743");
	}
	else
	{
		if (StrEqual(serverip, "185.188.144.3", true))
		{
			ServerCommand("sv_setsteamaccount CFEF98ABF2926D83EB865034C0AAAE50");
		}
		if (StrEqual(serverip, "185.188.144.4", true))
		{
			ServerCommand("sv_setsteamaccount 643868BCAF9D4CB132F2917E57AF3CBA");
		}
		if (StrEqual(serverip, "185.188.144.5", true))
		{
			ServerCommand("sv_setsteamaccount D039AC95D3E95F3215024FE1B7C7E517");
		}
		if (StrEqual(serverip, "185.188.144.6", true))
		{
			ServerCommand("sv_setsteamaccount 015A6F1E5B0481F10CB519B632CC8167");
		}
		if (StrEqual(serverip, "185.188.144.7", true))
		{
			ServerCommand("sv_setsteamaccount FD2945A44865563A264C9A3B4DFD61F2");
		}
		if (StrEqual(serverip, "185.188.144.8", true))
		{
			ServerCommand("sv_setsteamaccount 92699B87AE9E8EF72EFDA4C29DF90AA7");
		}
		if (StrEqual(serverip, "185.188.144.9", true))
		{
			ServerCommand("sv_setsteamaccount E1E660763E9641E1A85E588CA7B52F52");
		}
		if (StrEqual(serverip, "185.188.144.10", true))
		{
			ServerCommand("sv_setsteamaccount FB8D860E04B4BB66245E809406CF2C51");
		}
		if (StrEqual(serverip, "185.188.144.11", true))
		{
			ServerCommand("sv_setsteamaccount 756A50413670F17BB34596480D1BEEA9");
		}
		if (StrEqual(serverip, "185.188.144.12", true))
		{
			ServerCommand("sv_setsteamaccount 2B6FCA84E379704D8CDDA399421C013C");
		}
		if (StrEqual(serverip, "185.188.144.13", true))
		{
			ServerCommand("sv_setsteamaccount 7A6902C27BC1A9240CA99586CB126634");
		}
		if (StrEqual(serverip, "185.188.144.14", true))
		{
			ServerCommand("sv_setsteamaccount 1AEF04097BFEB9FF06B3F2AC771E422C");
		}
		if (StrEqual(serverip, "185.188.144.15", true))
		{
			ServerCommand("sv_setsteamaccount 1876FAA8CC3951BA795A49DA4BBC136F");
		}
		if (StrEqual(serverip, "185.188.144.16", true))
		{
			ServerCommand("sv_setsteamaccount 4827AF5FDFA5EB7313BF11461D70BAC8");
		}
		if (StrEqual(serverip, "185.188.144.17", true))
		{
			ServerCommand("sv_setsteamaccount C69D83E6E79DD61FEBBC41C5052EED42");
		}
		if (StrEqual(serverip, "185.188.144.18", true))
		{
			ServerCommand("sv_setsteamaccount BEA459E64F4E0D238709F6D90FA59E54");
		}
		if (StrEqual(serverip, "185.188.144.19", true))
		{
			ServerCommand("sv_setsteamaccount 6A9691E485C3874BA8563EF0E66E226C");
		}
		if (StrEqual(serverip, "185.188.144.60", true))
		{
			ServerCommand("sv_setsteamaccount B59B68FE8E60AFD0517647FC3894BAFD");
		}
		if (StrEqual(serverip, "185.188.144.61", true))
		{
			ServerCommand("sv_setsteamaccount 3DDD024A03826F1DB5A47A1FF3BCE6A2");
		}
		if (StrEqual(serverip, "185.188.144.62", true))
		{
			ServerCommand("sv_setsteamaccount 745D0D124B54A287D5E6B4239A3B9A65");
		}
		if (StrEqual(serverip, "185.188.144.63", true))
		{
			ServerCommand("sv_setsteamaccount 44A92AE1EA9766D66B1594EA3153CF24");
		}
		if (StrEqual(serverip, "185.188.144.64", true))
		{
			ServerCommand("sv_setsteamaccount 3C1DAF2DC6B325536572C6C68AD706D6");
		}
		if (StrEqual(serverip, "185.188.144.65", true))
		{
			ServerCommand("sv_setsteamaccount 18E88538E1940369F0D8C6B684398244");
		}
		if (StrEqual(serverip, "185.188.144.66", true))
		{
			ServerCommand("sv_setsteamaccount 621C45C6CE05817123EA88E35F52749E");
		}
		if (StrEqual(serverip, "185.188.144.67", true))
		{
			ServerCommand("sv_setsteamaccount 2641395F73B7C325A40C85C304DE9863");
		}
		if (StrEqual(serverip, "185.188.144.68", true))
		{
			ServerCommand("sv_setsteamaccount 260B3B59805DFE73E68C95B33E804D6B");
		}
		if (StrEqual(serverip, "185.188.144.69", true))
		{
			ServerCommand("sv_setsteamaccount 18E65957D4D0FB39514B236D66DF860A");
		}
		if (StrEqual(serverip, "185.188.144.90", true))
		{
			ServerCommand("sv_setsteamaccount 576FE6213FCB0F98DF8C260C54E8F11D");
		}
		if (StrEqual(serverip, "185.188.144.91", true))
		{
			ServerCommand("sv_setsteamaccount 78CF01255E866757D2D43D95B22E657E");
		}
		if (StrEqual(serverip, "185.188.144.92", true))
		{
			ServerCommand("sv_setsteamaccount A4C6276C042F6F5D7B99311938560E29");
		}
		if (StrEqual(serverip, "185.188.144.93", true))
		{
			ServerCommand("sv_setsteamaccount 26CFD075070D56324E7AC2AE41BDB8F9");
		}
		if (StrEqual(serverip, "185.188.144.94", true))
		{
			ServerCommand("sv_setsteamaccount 24523CC83FDBD7C9AE5619F0C3F4C7C3");
		}
		if (StrEqual(serverip, "185.188.144.95", true))
		{
			ServerCommand("sv_setsteamaccount 61230EC8CA6CE1BF5B8B1FA76864EFDA");
		}
		if (StrEqual(serverip, "185.188.144.96", true))
		{
			ServerCommand("sv_setsteamaccount 72CED7C1B142AE7085F9D26E506FD58C");
		}
		if (StrEqual(serverip, "185.188.144.97", true))
		{
			ServerCommand("sv_setsteamaccount E179F61102F91A326D41B2B5672DF52C");
		}
		if (StrEqual(serverip, "185.188.144.98", true))
		{
			ServerCommand("sv_setsteamaccount 66ED5E93E71074EFE642B3E7BA78F37B");
		}
		if (StrEqual(serverip, "185.188.144.99", true))
		{
			ServerCommand("sv_setsteamaccount 8DF9D35F834046BDD486CF400B7097FA");
		}
	}
}

