#pragma semicolon 1
#include <sourcemod>
#include <sdktools>
#include <cstrike>

#define PLUGIN_VERSION "1.0"

public Plugin:myinfo =
{
	name        = "Yeni Yazı Testi",
	author      = "ImPossibLe`",
	description = "DrK # GaminG",
	version     = PLUGIN_VERSION,
};

public OnPluginStart() 
{
	RegConsoleCmd("sm_yenitest", YeniTest);	
}


public Action YeniTest(client, args) 
{
	FakeClientCommand(client, "gameinstructor_enable 1");
	DisplayInstructorHint(client, 5.0, 0.1, 0.1, true, false, "icon_run", "icon_run", "", true, {255, 255, 0}, "TESTING");
	PrintToChat(client, "TEST"); // show chat debug
	
	return Plugin_Handled; 
} 

stock void DisplayInstructorHint(int iTargetEntity, float fTime, float fHeight, float fRange, bool bFollow, bool bShowOffScreen, char[] sIconOnScreen, char[] sIconOffScreen, char[] sCmd, bool bShowTextAlways, int iColor[3], char sText[100])  
{  
    int iEntity = CreateEntityByName("env_instructor_hint");  
      
    if(iEntity <= 0)  
        return;  
          
    char sBuffer[32];  
    FormatEx(sBuffer, sizeof(sBuffer), "%d", iTargetEntity);  
      
    // Target  
    DispatchKeyValue(iTargetEntity, "targetname", sBuffer);  
    DispatchKeyValue(iEntity, "hint_target", sBuffer);  
      
    // Static  
    FormatEx(sBuffer, sizeof(sBuffer), "%d", !bFollow);  
    DispatchKeyValue(iEntity, "hint_static", sBuffer);  
      
    // Timeout  
    FormatEx(sBuffer, sizeof(sBuffer), "%d", RoundToFloor(fTime));  
    DispatchKeyValue(iEntity, "hint_timeout", sBuffer);  
    if(fTime > 0.0)  
        RemoveEntity(iEntity, fTime);  
      
    // Height  
    FormatEx(sBuffer, sizeof(sBuffer), "%d", RoundToFloor(fHeight));  
    DispatchKeyValue(iEntity, "hint_icon_offset", sBuffer);  
      
    // Range  
    FormatEx(sBuffer, sizeof(sBuffer), "%d", RoundToFloor(fRange));  
    DispatchKeyValue(iEntity, "hint_range", sBuffer);  
      
    // Show off screen  
    FormatEx(sBuffer, sizeof(sBuffer), "%d", !bShowOffScreen);  
    DispatchKeyValue(iEntity, "hint_nooffscreen", sBuffer);  
      
    // Icons  
    DispatchKeyValue(iEntity, "hint_icon_onscreen", sIconOnScreen);  
    DispatchKeyValue(iEntity, "hint_icon_onscreen", sIconOffScreen);  
      
    // Command binding  
    DispatchKeyValue(iEntity, "hint_binding", sCmd);  
      
    // Show text behind walls  
    FormatEx(sBuffer, sizeof(sBuffer), "%d", bShowTextAlways);  
    DispatchKeyValue(iEntity, "hint_forcecaption", sBuffer);  
      
    // Text color  
    FormatEx(sBuffer, sizeof(sBuffer), "%d %d %d", iColor[0], iColor[1], iColor[2]);  
    DispatchKeyValue(iEntity, "hint_color", sBuffer);  
      
    //Text  
    ReplaceString(sText, sizeof(sText), "\n", " ");  
    DispatchKeyValue(iEntity, "hint_caption", sText);  
      
    DispatchSpawn(iEntity);  
    AcceptEntityInput(iEntity, "ShowHint");  
}  

stock void RemoveEntity(entity, float time = 0.0)  
{  
    if (time == 0.0)  
    {  
        if (IsValidEntity(entity))  
        {  
            char edictname[32];  
            GetEdictClassname(entity, edictname, 32);  

            if (!StrEqual(edictname, "player"))  
                AcceptEntityInput(entity, "kill");  
        }  
    }  
    else if(time > 0.0)  
        CreateTimer(time, RemoveEntityTimer, EntIndexToEntRef(entity), TIMER_FLAG_NO_MAPCHANGE);  
}  

public Action RemoveEntityTimer(Handle Timer, any entityRef)  
{  
    int entity = EntRefToEntIndex(entityRef);  
    if (entity != INVALID_ENT_REFERENCE)  
        RemoveEntity(entity); // RemoveEntity(...) is capable of handling references  
      
    return (Plugin_Stop);  
}  