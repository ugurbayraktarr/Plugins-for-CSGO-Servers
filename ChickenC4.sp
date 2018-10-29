#pragma semicolon 1

#include <sourcemod>
#include <sdktools>

#define PLUGIN_VERSION "1.1.0"

new Handle:hVisibleChick = INVALID_HANDLE;
new bool:visibleChicken = false;

public Plugin:myinfo =
{
	name = "Chicken C4",
	author = "Mitch.",
	description = "CHICKEN C4 WAT.",
	version = PLUGIN_VERSION,
	url = "http://snbx.info/"
};

public OnPluginStart()
{
	hVisibleChick = CreateConVar("sm_chickc4_visible", "0", "Set to 1 for the chicken to be visible.");
	HookConVarChange(hVisibleChick, OnCvarChanged);
	AutoExecConfig();
	
	CreateConVar("sm_chickenc4_version", PLUGIN_VERSION, "Chicken C4 Version", FCVAR_DONTRECORD|FCVAR_NOTIFY);	
	HookEvent("bomb_planted", BomPlanted_Event);
	
	RegAdminCmd("sm_tavuktest", CMD_SpawnChicken, ADMFLAG_GENERIC, "Spawning chicken to the aim position.");
}
public Action:BomPlanted_Event(Handle:event, const String:name[], bool:dontBroadcast)
{
	new c4 = -1;
	c4 = FindEntityByClassname(c4, "planted_c4");
	if(c4 != -1) {
		new chicken = CreateEntityByName("chicken");
		SetEntityRenderColor(chicken, 255, 20, 147, 255);
		if(chicken != -1) {
			new player = GetClientOfUserId(GetEventInt(event, "userid"));
			decl Float:pos[3];
			GetEntPropVector(player, Prop_Data, "m_vecOrigin", pos);
			
			DispatchSpawn(chicken);
			SetEntProp(chicken, Prop_Data, "m_takedamage", 0);
			SetEntProp(chicken, Prop_Send, "m_fEffects", 0);
			pos[2] -= 15.0;
			TeleportEntity(chicken, pos, NULL_VECTOR, NULL_VECTOR);
			TeleportEntity(c4, NULL_VECTOR, Float:{0.0, 0.0, 0.0}, NULL_VECTOR);
			SetVariantString("!activator");
			AcceptEntityInput(c4, "SetParent", chicken, c4, 0);
			if(visibleChicken) {
				pos[2] += 45.0;
				TeleportEntity(chicken, NULL_VECTOR, NULL_VECTOR, NULL_VECTOR);
			} else {
				SetEntityRenderMode(chicken, RENDER_NONE);
			}
		}
	}
	return Plugin_Continue;
}

public OnCvarChanged(Handle:cvar, const String:oldVal[], const String:newVal[]) {
	visibleChicken = !StrEqual(newVal, "0", false);
}

public Action: CMD_SpawnChicken(client, args)
{
	SpawnChicken(client, 0);
	return Plugin_Handled;
}


SpawnChicken(client, zombie)
{
	if(((client > 0) && (client <= MaxClients)) && IsClientInGame(client) && IsClientConnected(client))
	{
		//if(IsPlayerAlive(client))
		{
			new Float: eye_pos[3],
				Float: eye_ang[3];
			
			GetClientEyePosition(client, eye_pos);
			GetClientEyeAngles(client, eye_ang);
			
			new Handle: trace = TR_TraceRayFilterEx(eye_pos, eye_ang, MASK_SOLID, RayType_Infinite, Dont_Hit_Players);
			if(TR_DidHit(trace))
			{
				if(TR_GetEntityIndex(trace) == 0)
				{
					new chicken = CreateEntityByName("chicken"); //The Chicken
					if(IsValidEntity(chicken))
					{
						new Float: end_pos[3];
						TR_GetEndPosition(end_pos, trace);
						end_pos[2] = (end_pos[2] + 10.0);
						
						new String: skin[16];
						Format(skin, sizeof(skin), "%i", GetRandomInt(0, 1));
						
						DispatchKeyValue(chicken, "glowenabled", "1"); //Glowing (0-off, 1-on)
						DispatchKeyValue(chicken, "glowcolor", "0 255 0"); //Glowing color (R, G, B)
						DispatchKeyValue(chicken, "rendercolor", "255 20 147"); //Chickens model color (R, G, B)
						DispatchKeyValue(chicken, "modelscale", "3"); //Chickens model scale (0.5 smaller, 1.5 bigger chicken, min: 0.1, max: -)
						DispatchKeyValue(chicken, "skin", skin); //Chickens model skin(default white 0, brown is 1)
						//DispatchKeyValue(chicken, "spawnflags", "1");
						DispatchSpawn(chicken);
						
						TeleportEntity(chicken, end_pos, NULL_VECTOR, NULL_VECTOR);
						
						if(zombie == 0)
						{
							CreateParticle(chicken, 0);
						}
						else if(zombie == 1)
						{
							CreateParticle(chicken, 1);
							//SetEntityModel(chicken, MODEL_CHICKEN_ZOMBIE);
							HookSingleEntityOutput(chicken, "OnBreak", OnZombieChickenKill);
						}
						//EmitSoundToAll(SOUND_CHICKEN_SPAWN, chicken);
						
					}
				}
				else
				{
				}
			}
			else
			{
			}
		}
		/*else
		{
			ReplyToCommand(client, "%t", "OnlyAlive");
		}*/
	}
}


CreateParticle(entity, zombie)
{	
	new particle = CreateEntityByName("info_particle_system");
	if(IsValidEntity(particle))
	{
		new Float: pos[3];
		GetEntPropVector(entity, Prop_Send, "m_vecOrigin", pos);
		TeleportEntity(particle, pos, NULL_VECTOR, NULL_VECTOR);
		
		if(zombie == 0)
		{
			DispatchKeyValue(particle, "effect_name", "chicken_gone_feathers");
		}
		else if(zombie == 1)
		{
			DispatchKeyValue(particle, "effect_name", "chicken_gone_feathers_zombie");
		}
		
		DispatchKeyValue(particle, "angles", "-90 0 0");
		DispatchSpawn(particle);
		ActivateEntity(particle);
		
		AcceptEntityInput(particle, "Start");
		
		CreateTimer(5.0, KillEntity, particle);
	}
}



//-----SINGLEOUTPUTS-----//
public OnZombieChickenKill(const String: output[], caller, activator, Float: delay)
{
	CreateParticle(caller, 1);
}

//-----TIMERS-----//
public Action: KillEntity(Handle: timer, any: entity)
{
	AcceptEntityInput(entity, "Kill");
}

//-----FILTERS-----//
public bool: Dont_Hit_Players(entity, contentsMask, any: data)
{
	return !((entity > 0) && (entity <= MaxClients));
}