#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <clientprefs>

public Plugin:myinfo =
{
	name        = "TEST",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = "1.0",
};

public OnPluginStart() 
{
	RegConsoleCmd("sm_test", TEST, "TEST");
	RegConsoleCmd("sm_test2", TEST2, "TEST");
}

public Action TEST(int client, int args)
{
	/*new a;
	a = GetClientAimTarget(client, false);
	PrintToChatAll(" TEST: %d", a);*/
	
	new i;
	for(i=1; i<=2048; i++)
	{
		if(IsValidEntity(i))
		{
			decl String:entityIsmi[128];
			GetEntityClassname(i, entityIsmi, sizeof(entityIsmi));
			if(StrEqual(entityIsmi, "func_physbox", false))
			{
				PrintToChat(client, "%s - %d", entityIsmi, i);
			}
		}
	}
}

public Action TEST2(int client, int args)
{
	new String:TESTT[10];
	GetCmdArg(1, TESTT, sizeof(TESTT));
	new iTEST = StringToInt(TESTT);
	
	AcceptEntityInput(iTEST, "Kill");
}
