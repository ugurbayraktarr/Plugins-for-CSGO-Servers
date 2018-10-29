#pragma semicolon 1
#include <sourcemod>

#define VER "13.0"

#define TOKEN2 "F1ECF961982C057D66442732B6C5FE7D"
#define TOKEN3 "02441790FBDFC036ACDED7AEF893368D"
#define TOKEN4 "D7ABCD59AE301D1F1D62896F874ACEFA"
#define TOKEN5 "814268FD5361FDF07DDD318F1B8E539A"
#define TOKEN6 "AEB5FA6BC429826C47268E3F2A4A9E60"
#define TOKEN7 "5DD5CEEC503A23BE6EC87C18FF7098F8"
#define TOKEN8 "D1E429CC7127AA531D47F98AEC1DCE88"
#define TOKEN9 "0D22C476AD6356CEFB884AF1966574CF"
#define TOKEN10 "F816CB5D74A48E8C3023001ECE8F6ED1"
#define TOKEN11 "93D1379285F834DDA4E70A38CF0ADDB4"
#define TOKEN12 "0C459EA3CE41F1DA5F0591D39CD0E2A6"
#define TOKEN13 "890DE8D4081AB79CF37E488E352D0101"
#define TOKEN14 "2F84FBCA15AE9E8EEFDF754F1294D445"
#define TOKEN15 "2A50822DC2E8534E5BD9FFD8DF56E5EE"
#define TOKEN16 "1B4919599089E193653808AAE41ED0F2"
#define TOKEN17 "911B2F6B83D2E86090D03645CD4A9E53"
#define TOKEN18 "EBED246DE9365B02323BF4112C061351"
#define TOKEN19 "63465A536512C7CC07C06BDBE42DF00E"
#define TOKEN20 "179924F7DA00E5DCC61E832A3E479545"
#define TOKEN21 "A0DCEE4180BBB88ADDE2CC3B9BDEE09B"
#define TOKEN22 "779C0D128175E3351F158D64AFB771C2"
#define TOKEN23 "536AAB6024B3198574E7E0EA5078A9FE"
#define TOKEN24 "289465277DA46C8D05BA1E2766BC0852"
#define TOKEN25 "12E769E301D070B910A7C8FDA7A56282"
#define TOKEN26 "4162178A276B51D487352D50582CF277"

public Plugin:myinfo =
{
	name        = "GSLT Ayarı",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = VER,
};

new String:Tokenler[31][128];

public OnPluginStart() 
{
	int ips[4];

	int ip = GetConVarInt(FindConVar("hostip"));
	ips[0] = (ip >> 24) & 0x000000FF;
	ips[1] = (ip >> 16) & 0x000000FF;
	ips[2] = (ip >> 8) & 0x000000FF;
	ips[3] = ip & 0x000000FF;
	char serverip[32];
	Format(serverip, sizeof(serverip), "%d.%d.%d.%d", ips[0], ips[1], ips[2], ips[3]);
	
	Tokenler[2] = TOKEN2;
	Tokenler[3] = TOKEN3;
	Tokenler[4] = TOKEN4;
	Tokenler[5] = TOKEN5;
	Tokenler[6] = TOKEN6;
	Tokenler[7] = TOKEN7;
	Tokenler[8] = TOKEN8;
	Tokenler[9] = TOKEN9;
	Tokenler[10] = TOKEN10;
	Tokenler[11] = TOKEN11;
	Tokenler[12] = TOKEN12;
	Tokenler[13] = TOKEN13;
	Tokenler[14] = TOKEN14;
	Tokenler[15] = TOKEN15;
	Tokenler[16] = TOKEN16;
	Tokenler[17] = TOKEN17;
	Tokenler[18] = TOKEN18;
	Tokenler[19] = TOKEN19;
	Tokenler[20] = TOKEN20;
	Tokenler[21] = TOKEN21;
	Tokenler[22] = TOKEN22;
	Tokenler[23] = TOKEN23;
	Tokenler[24] = TOKEN24;
	Tokenler[25] = TOKEN25;
	Tokenler[26] = TOKEN26;
	
	if(StrEqual(serverip, "185.122.202.2"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[2]);
	if(StrEqual(serverip, "185.122.202.3"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[3]);
	if(StrEqual(serverip, "185.122.202.4"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[4]);
	if(StrEqual(serverip, "185.122.202.5"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[5]);
	if(StrEqual(serverip, "185.122.202.6"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[6]);
	if(StrEqual(serverip, "185.122.202.7"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[7]);
	if(StrEqual(serverip, "185.122.202.8"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[8]);
	if(StrEqual(serverip, "185.122.202.9"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[9]);
	if(StrEqual(serverip, "185.122.202.10"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[10]);
	if(StrEqual(serverip, "185.122.202.11"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[11]);
	if(StrEqual(serverip, "185.122.202.12"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[12]);
	if(StrEqual(serverip, "185.122.202.13"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[13]);
	if(StrEqual(serverip, "185.122.202.14"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[14]);
	if(StrEqual(serverip, "185.122.202.15"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[15]);
	if(StrEqual(serverip, "185.122.202.16"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[16]);
	if(StrEqual(serverip, "185.122.202.17"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[17]);
	if(StrEqual(serverip, "185.122.202.18"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[18]);
	if(StrEqual(serverip, "185.122.202.19"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[19]);
	if(StrEqual(serverip, "185.122.202.20"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[20]);
	if(StrEqual(serverip, "185.122.202.21"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[21]);
	if(StrEqual(serverip, "185.122.202.22"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[22]);
	if(StrEqual(serverip, "185.122.202.23"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[23]);
	if(StrEqual(serverip, "185.122.202.24"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[24]);
	if(StrEqual(serverip, "185.122.202.25"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[25]);
	if(StrEqual(serverip, "185.122.202.26"))
		ServerCommand("sv_setsteamaccount %s", Tokenler[26]);
}