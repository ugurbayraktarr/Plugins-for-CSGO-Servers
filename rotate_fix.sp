#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <smlib>

#define PLUGIN_VERSION "0.1"

public Plugin:myinfo = 
{
	name = "Fix func_rotating bad angles bug",
	author = "Zipcore",
	description = "",
	version = PLUGIN_VERSION,
	url = "zipcore#googlemail.com"
}

public OnPluginStart()
{
	CreateTimer(300.0, Timer_FixAngRotation, _, TIMER_REPEAT);
}

public OnMapStart()
{
	FixAngRotation();
}

public Action:Timer_FixAngRotation(Handle:timer)
{
	FixAngRotation();
	return Plugin_Continue;
}

stock FixAngRotation()
{
	new entity;
	while ((entity = FindEntityByClassname(entity, "func_rotating")) != -1)
	{
		new Float:ang[3];
		GetEntPropVector(entity, Prop_Send, "m_angRotation", ang);
		
		if(ang[0] > 360.0 || ang[1] > 360.0 || ang[2] > 360.0 || ang[0] < -360.0 || ang[1] < -360.0 || ang[2] < -360.0)
		{
			ang[0] = float(RoundToFloor(ang[0]) % 60);
			ang[1] = float(RoundToFloor(ang[1]) % 60);
			ang[2] = float(RoundToFloor(ang[2]) % 60);
			
			SetEntPropVector(entity, Prop_Send, "m_angRotation", ang);
		}
	}
}