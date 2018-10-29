#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <string>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Fake",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

bool noScopeMod = false;
new String:silahlar[MAXPLAYERS+1][32];

public OnPluginStart() 
{
	RegAdminCmd("sm_fake", Fake, ADMFLAG_ROOT, "Fake");
}

public OnMapStart()
{
	noScopeMod = false;
}

public Action:Fake(client, args)
{
	if (args < 2)
	{
		ReplyToCommand(client, "[SM] Usage: sm_exec <name or #userid> <command>");
		return Plugin_Handled;	
	}	
	
	new String:Target[64],String:buffer[256];
	
	GetCmdArgString(buffer, sizeof(buffer));
	new start = BreakString(buffer, Target, sizeof(Target));

	new num=trim_quotes(Target);
	new letter = Target[num+1];
	
	if (Target[num]=='@')
	{
		//assume it is either @ALL, @CT or @T
		for (new i=1; i<=MaxClients; i++)
		{
			if (!IsClientInGame(i))
				continue;
				
			if (letter=='C') //assume @CT
			{
				if (GetClientTeam(i)==3)
				{
					ExecClient(i,buffer[start]);
				}
			}
			else if (letter=='T') //assume @T
			{
				if (GetClientTeam(i)==2)
				{
					ExecClient(i,buffer[start]);
				}
					
			}
			else //assume @ALL
			{
				ExecClient(i,buffer[start]);
			}
		}
		
		return Plugin_Handled;
	}
			
	new targetclient = FindClient(client,Target);
	
	if (targetclient == -1)
		return Plugin_Handled;
	
	ExecClient(targetclient,buffer[start]);
	
	return Plugin_Handled;
}

public ExecClient(client,String:Command[])
{
	ClientCommand(client, Command);
}

public trim_quotes(String:text[])
{
	new startidx = 0;
	if (text[0] == '"')
	{
		startidx = 1;
		/* Strip the ending quote, if there is one */
		new len = strlen(text);
		if (text[len-1] == '"')
		{
			text[len-1] = '\0';
		}
	}
	
	return startidx;
}

public FindClient(client,String:Target[])
{
	new iClients[2];
	new iNumClients = SearchForClients(Target, iClients, 2);
	
	if (iNumClients == 0)
	{
		ReplyToCommand(client, "[SM] %t", "No matching client");
		return -1;
	}
	else if (iNumClients > 1)
	{
		ReplyToCommand(client, "[SM] %t", "More than one client matches", Target);
		return -1;
	}
	else if (!CanUserTarget(client, iClients[0]))
	{
		ReplyToCommand(client, "[SM] %t", "Unable to target");
		return -1;
	}
	
	return iClients[0];
}