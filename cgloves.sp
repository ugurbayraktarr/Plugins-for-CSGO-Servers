#include <sourcemod> 
#include <sdktools> 
#include <cstrike> 
#include <multicolors> 

int gloves[100]; 

public void OnPluginStart() { 

    RegConsoleCmd("sm_gloves", ShowProps); // type !test13 in chat if you have root access. 
    HookEvent("player_spawn", ps); 
} 

ShowPropss(client) 
{ 
    new Handle:menu = CreateMenu(DID, MenuAction_Select | MenuAction_Cancel | MenuAction_End | MenuAction_DisplayItem); 
    SetMenuTitle(menu, "Gloves"); 

    AddMenuItem(menu, "bloodhound_black_silver", "bloodhound_black_silver"); 
    AddMenuItem(menu, "bloodhound_snakeskin_brass", "bloodhound_snakeskin_brass"); 
    AddMenuItem(menu, "bloodhound_guerrilla", "bloodhound_guerrilla"); 
    AddMenuItem(menu, "handwrap_leathery", "handwrap_leathery"); 
    AddMenuItem(menu, "slick_military", "slick_military"); 
    AddMenuItem(menu, " handwrap_red_slaughter", " handwrap_red_slaughter"); 
    AddMenuItem(menu, "motorcycle_mono_boom", "motorcycle_mono_boom"); 
    AddMenuItem(menu, "specialist_kimono_diamonds_red", "specialist_kimono_diamonds_red"); 
    AddMenuItem(menu, "specialist_emerald_web", "specialist_emerald_web"); 

    DisplayMenu(menu, client, MENU_TIME_FOREVER); 
} 

public Action ShowProps(client, args) 
{     
    if(IsValidated(client)&& IsPlayerAlive(client))  
    { 
        ShowPropss(client); 
    } 
    else 
    { 
        PrintToChat(client, "[\x02WTFCS\x01]You need to be alive to set !gloves"); 
    } 
     
    return Plugin_Handled; 
} 


public DID(Handle:menu, MenuAction:action, param1, param2) 
{ 
    switch (action) 
    { 
        case MenuAction_Select: 
        { 
            //param1 is client, param2 is item 

            new String:item[64]; 
            GetMenuItem(menu, param2, item, sizeof(item)); 

            if (StrEqual(item, "bloodhound_black_silver")) 
            { 
                if(IsValidated(param1))  
                { 
                    gloves[param1] = 1; 
                     
                    int item = GetEntPropEnt(param1, Prop_Send, "m_hActiveWeapon"); 
                     
                    SetEntPropEnt(param1, Prop_Send, "m_hActiveWeapon", -1); 
                     
                    new ent = GivePlayerItem(param1, "wearable_item"); 
                     
                    if (ent != -1) 
                    { 
                        int m_iItemIDHigh = GetEntProp( ent, Prop_Send, "m_iItemIDHigh" ); 
                        int m_iItemIDLow = GetEntProp( ent, Prop_Send, "m_iItemIDLow" ); 
                         
                        SetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex", 5027); 
                        SetEntProp(ent, Prop_Send, "m_iItemIDLow", 8192+param1); 
                        SetEntProp(ent, Prop_Send, "m_iItemIDHigh", 0); 
                        SetEntProp(ent, Prop_Send, "m_iEntityQuality", 4); 
                         
                        SetEntPropFloat(ent, Prop_Send, "m_flFallbackWear", 0.00000001); 
                         
                        SetEntProp(ent, Prop_Send,  "m_iAccountID", GetSteamAccountID(param1)); 
                         
                        SetEntProp(ent, Prop_Send,  "m_nFallbackSeed", 0); 
                        SetEntProp(ent, Prop_Send,  "m_nFallbackStatTrak", GetSteamAccountID(param1)); 
                        SetEntProp(ent, Prop_Send,  "m_nFallbackPaintKit", 10006); 
                         
                        if (!IsModelPrecached("models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl")) PrecacheModel("models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl"); 
                         
                        SetEntProp(ent, Prop_Send, "m_nModelIndex", PrecacheModel("models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl")); 
                        SetEntityModel(ent, "models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl"); 
                         
                        SetEntPropEnt(param1, Prop_Send, "m_hMyWearables", ent); 
                         
                        Handle ph1 = CreateDataPack(); 
                        CreateTimer(2.0, AddItemTimer1, ph1, TIMER_FLAG_NO_MAPCHANGE); 
                         
                        WritePackCell(ph1, EntIndexToEntRef(param1)); 
                        WritePackCell(ph1, EntIndexToEntRef(item)); 
                        WritePackCell(ph1, EntIndexToEntRef(ent)); 
                        WritePackCell(ph1, m_iItemIDHigh ); 
                        WritePackCell(ph1, m_iItemIDLow ); 
                         
                        Handle ph2 = CreateDataPack(); 
                        CreateTimer(0.0, AddItemTimer2, ph2, TIMER_FLAG_NO_MAPCHANGE); 
                         
                        WritePackCell(ph2, EntIndexToEntRef(param1)); 
                        WritePackCell(ph2, EntIndexToEntRef(item)); 
                         
                        char weaponclass[ 64 ]; GetEdictClassname( ent, weaponclass, sizeof( weaponclass ) ); 
                        CPrintToChat(param1, "%s", weaponclass); 
                    } 
         
                    return Plugin_Handled; 
                } 
            } 
            else if (StrEqual(item, "bloodhound_snakeskin_brass")) 
            { 
                 
                if(IsValidated(param1))  
                { 
                    gloves[param1] = 2; 
                     
                    int item = GetEntPropEnt(param1, Prop_Send, "m_hActiveWeapon"); 
                     
                    SetEntPropEnt(param1, Prop_Send, "m_hActiveWeapon", -1); 
                     
                    new ent = GivePlayerItem(param1, "wearable_item"); 
                     
                    if (ent != -1) 
                    { 
                        int m_iItemIDHigh = GetEntProp( ent, Prop_Send, "m_iItemIDHigh" ); 
                        int m_iItemIDLow = GetEntProp( ent, Prop_Send, "m_iItemIDLow" ); 
                         
                        SetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex", 5027); 
                        SetEntProp(ent, Prop_Send, "m_iItemIDLow", 8192+param1); 
                        SetEntProp(ent, Prop_Send, "m_iItemIDHigh", 0); 
                        SetEntProp(ent, Prop_Send, "m_iEntityQuality", 4); 
                         
                        SetEntPropFloat(ent, Prop_Send, "m_flFallbackWear", 0.00000001); 
                         
                        SetEntProp(ent, Prop_Send,  "m_iAccountID", GetSteamAccountID(param1)); 
                         
                        SetEntProp(ent, Prop_Send,  "m_nFallbackSeed", 0); 
                        SetEntProp(ent, Prop_Send,  "m_nFallbackStatTrak", GetSteamAccountID(param1)); 
                        SetEntProp(ent, Prop_Send,  "m_nFallbackPaintKit", 10007); 
                         
                        if (!IsModelPrecached("models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl")) PrecacheModel("models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl"); 
                         
                        SetEntProp(ent, Prop_Send, "m_nModelIndex", PrecacheModel("models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl")); 
                        SetEntityModel(ent, "models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl"); 
                         
                        SetEntPropEnt(param1, Prop_Send, "m_hMyWearables", ent); 
                         
                        Handle ph1 = CreateDataPack(); 
                        CreateTimer(2.0, AddItemTimer1, ph1, TIMER_FLAG_NO_MAPCHANGE); 
                         
                        WritePackCell(ph1, EntIndexToEntRef(param1)); 
                        WritePackCell(ph1, EntIndexToEntRef(item)); 
                        WritePackCell(ph1, EntIndexToEntRef(ent)); 
                        WritePackCell(ph1, m_iItemIDHigh ); 
                        WritePackCell(ph1, m_iItemIDLow ); 
                         
                        Handle ph2 = CreateDataPack(); 
                        CreateTimer(0.0, AddItemTimer2, ph2, TIMER_FLAG_NO_MAPCHANGE); 
                         
                        WritePackCell(ph2, EntIndexToEntRef(param1)); 
                        WritePackCell(ph2, EntIndexToEntRef(item)); 
                         
                        char weaponclass[ 64 ]; GetEdictClassname( ent, weaponclass, sizeof( weaponclass ) ); 
                        CPrintToChat(param1, "%s", weaponclass); 
                    } 
         
                    return Plugin_Handled; 
                } 
            } 
            else if (StrEqual(item, "bloodhound_guerrilla")) 
            { 
                if(IsValidated(param1))  
                { 
                    gloves[param1] = 3; 
                     
                    int item = GetEntPropEnt(param1, Prop_Send, "m_hActiveWeapon"); 
                     
                    SetEntPropEnt(param1, Prop_Send, "m_hActiveWeapon", -1); 
                     
                    new ent = GivePlayerItem(param1, "wearable_item"); 
                     
                    if (ent != -1) 
                    { 
                        int m_iItemIDHigh = GetEntProp( ent, Prop_Send, "m_iItemIDHigh" ); 
                        int m_iItemIDLow = GetEntProp( ent, Prop_Send, "m_iItemIDLow" ); 
                         
                        SetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex", 5027); 
                        SetEntProp(ent, Prop_Send, "m_iItemIDLow", 8192+param1); 
                        SetEntProp(ent, Prop_Send, "m_iItemIDHigh", 0); 
                        SetEntProp(ent, Prop_Send, "m_iEntityQuality", 4); 
                         
                        SetEntPropFloat(ent, Prop_Send, "m_flFallbackWear", 0.00000001); 
                         
                        SetEntProp(ent, Prop_Send,  "m_iAccountID", GetSteamAccountID(param1)); 
                         
                        SetEntProp(ent, Prop_Send,  "m_nFallbackSeed", 0); 
                        SetEntProp(ent, Prop_Send,  "m_nFallbackStatTrak", GetSteamAccountID(param1)); 
                        SetEntProp(ent, Prop_Send,  "m_nFallbackPaintKit", 10039); 
                         
                        if (!IsModelPrecached("models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl")) PrecacheModel("models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl"); 
                         
                        SetEntProp(ent, Prop_Send, "m_nModelIndex", PrecacheModel("models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl")); 
                        SetEntityModel(ent, "models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl"); 
                         
                        SetEntPropEnt(param1, Prop_Send, "m_hMyWearables", ent); 
                         
                        Handle ph1 = CreateDataPack(); 
                        CreateTimer(2.0, AddItemTimer1, ph1, TIMER_FLAG_NO_MAPCHANGE); 
                         
                        WritePackCell(ph1, EntIndexToEntRef(param1)); 
                        WritePackCell(ph1, EntIndexToEntRef(item)); 
                        WritePackCell(ph1, EntIndexToEntRef(ent)); 
                        WritePackCell(ph1, m_iItemIDHigh ); 
                        WritePackCell(ph1, m_iItemIDLow ); 
                         
                        Handle ph2 = CreateDataPack(); 
                        CreateTimer(0.0, AddItemTimer2, ph2, TIMER_FLAG_NO_MAPCHANGE); 
                         
                        WritePackCell(ph2, EntIndexToEntRef(param1)); 
                        WritePackCell(ph2, EntIndexToEntRef(item)); 
                         
                        char weaponclass[ 64 ]; GetEdictClassname( ent, weaponclass, sizeof( weaponclass ) ); 
                        CPrintToChat(param1, "%s", weaponclass); 
                    } 
         
                    return Plugin_Handled; 
                } 
            } 
            else if (StrEqual(item, "handwrap_leathery")) 
            { 
                if(IsValidated(param1))  
                { 
                    gloves[param1] = 4; 
                    int item = GetEntPropEnt(param1, Prop_Send, "m_hActiveWeapon"); 
                     
                    SetEntPropEnt(param1, Prop_Send, "m_hActiveWeapon", -1); 
                     
                    new ent = GivePlayerItem(param1, "wearable_item"); 
                     
                    if (ent != -1) 
                    { 
                        int m_iItemIDHigh = GetEntProp( ent, Prop_Send, "m_iItemIDHigh" ); 
                        int m_iItemIDLow = GetEntProp( ent, Prop_Send, "m_iItemIDLow" ); 
                         
                        SetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex", 5032); 
                        SetEntProp(ent, Prop_Send, "m_iItemIDLow", 8192+param1); 
                        SetEntProp(ent, Prop_Send, "m_iItemIDHigh", 0); 
                        SetEntProp(ent, Prop_Send, "m_iEntityQuality", 4); 
                         
                        SetEntPropFloat(ent, Prop_Send, "m_flFallbackWear", 0.00000001); 
                         
                        SetEntProp(ent, Prop_Send,  "m_iAccountID", GetSteamAccountID(param1)); 
                         
                        SetEntProp(ent, Prop_Send,  "m_nFallbackSeed", 0); 
                        SetEntProp(ent, Prop_Send,  "m_nFallbackStatTrak", GetSteamAccountID(param1)); 
                        SetEntProp(ent, Prop_Send,  "m_nFallbackPaintKit", 10009); 
                         
                        if (!IsModelPrecached("models/weapons/v_models/arms/glove_handwrap_leathery/v_glove_handwrap_leathery.mdl")) PrecacheModel("models/weapons/v_models/arms/glove_handwrap_leathery/v_glove_handwrap_leathery.mdl"); 
                         
                        SetEntProp(ent, Prop_Send, "m_nModelIndex", PrecacheModel("models/weapons/v_models/arms/glove_handwrap_leathery/v_glove_handwrap_leathery.mdl")); 
                        SetEntityModel(ent, "models/weapons/v_models/arms/glove_handwrap_leathery/v_glove_handwrap_leathery.mdl"); 
                         
                        SetEntPropEnt(param1, Prop_Send, "m_hMyWearables", ent); 
                         
                        Handle ph1 = CreateDataPack(); 
                        CreateTimer(2.0, AddItemTimer1, ph1, TIMER_FLAG_NO_MAPCHANGE); 
                         
                        WritePackCell(ph1, EntIndexToEntRef(param1)); 
                        WritePackCell(ph1, EntIndexToEntRef(item)); 
                        WritePackCell(ph1, EntIndexToEntRef(ent)); 
                        WritePackCell(ph1, m_iItemIDHigh ); 
                        WritePackCell(ph1, m_iItemIDLow ); 
                         
                        Handle ph2 = CreateDataPack(); 
                        CreateTimer(0.0, AddItemTimer2, ph2, TIMER_FLAG_NO_MAPCHANGE); 
                         
                        WritePackCell(ph2, EntIndexToEntRef(param1)); 
                        WritePackCell(ph2, EntIndexToEntRef(item)); 
                         
                        char weaponclass[ 64 ]; GetEdictClassname( ent, weaponclass, sizeof( weaponclass ) ); 
                        CPrintToChat(param1, "%s", weaponclass); 
                    } 
         
                    return Plugin_Handled; 
                } 
            } 
            else if (StrEqual(item, "slick_military")) 
            { 
                if(IsValidated(param1))  
                { 
                    gloves[param1] = 5; 
                    int item = GetEntPropEnt(param1, Prop_Send, "m_hActiveWeapon"); 
                     
                    SetEntPropEnt(param1, Prop_Send, "m_hActiveWeapon", -1); 
                     
                    new ent = GivePlayerItem(param1, "wearable_item"); 
                     
                    if (ent != -1) 
                    { 
                        int m_iItemIDHigh = GetEntProp( ent, Prop_Send, "m_iItemIDHigh" ); 
                        int m_iItemIDLow = GetEntProp( ent, Prop_Send, "m_iItemIDLow" ); 
                         
                        SetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex", 5031); 
                        SetEntProp(ent, Prop_Send, "m_iItemIDLow", 8192+param1); 
                        SetEntProp(ent, Prop_Send, "m_iItemIDHigh", 0); 
                        SetEntProp(ent, Prop_Send, "m_iEntityQuality", 4); 
                         
                        SetEntPropFloat(ent, Prop_Send, "m_flFallbackWear", 0.00000001); 
                         
                        SetEntProp(ent, Prop_Send,  "m_iAccountID", GetSteamAccountID(param1)); 
                         
                        SetEntProp(ent, Prop_Send,  "m_nFallbackSeed", 0); 
                        SetEntProp(ent, Prop_Send,  "m_nFallbackStatTrak", GetSteamAccountID(param1)); 
                        SetEntProp(ent, Prop_Send,  "m_nFallbackPaintKit", 10015); 
                         
                        if (!IsModelPrecached("models/weapons/v_models/arms/glove_slick/v_glove_slick.mdl")) PrecacheModel("models/weapons/v_models/arms/glove_slick/v_glove_slick.mdl"); 
                         
                        SetEntProp(ent, Prop_Send, "m_nModelIndex", PrecacheModel("models/weapons/v_models/arms/glove_slick/v_glove_slick.mdl")); 
                        SetEntityModel(ent, "models/weapons/v_models/arms/glove_slick/v_glove_slick.mdl"); 
                         
                        SetEntPropEnt(param1, Prop_Send, "m_hMyWearables", ent); 
                         
                        Handle ph1 = CreateDataPack(); 
                        CreateTimer(2.0, AddItemTimer1, ph1, TIMER_FLAG_NO_MAPCHANGE); 
                         
                        WritePackCell(ph1, EntIndexToEntRef(param1)); 
                        WritePackCell(ph1, EntIndexToEntRef(item)); 
                        WritePackCell(ph1, EntIndexToEntRef(ent)); 
                        WritePackCell(ph1, m_iItemIDHigh ); 
                        WritePackCell(ph1, m_iItemIDLow ); 
                         
                        Handle ph2 = CreateDataPack(); 
                        CreateTimer(0.0, AddItemTimer2, ph2, TIMER_FLAG_NO_MAPCHANGE); 
                         
                        WritePackCell(ph2, EntIndexToEntRef(param1)); 
                        WritePackCell(ph2, EntIndexToEntRef(item)); 
                         
                        char weaponclass[ 64 ]; GetEdictClassname( ent, weaponclass, sizeof( weaponclass ) ); 
                        CPrintToChat(param1, "%s", weaponclass); 
                    } 
         
                    return Plugin_Handled; 
                } 
            } 
            else if (StrEqual(item, " handwrap_red_slaughter")) 
            { 
                if(IsValidated(param1))  
                { 
                    gloves[param1] = 6; 
                    int item = GetEntPropEnt(param1, Prop_Send, "m_hActiveWeapon"); 
                     
                    SetEntPropEnt(param1, Prop_Send, "m_hActiveWeapon", -1); 
                     
                    new ent = GivePlayerItem(param1, "wearable_item"); 
                     
                    if (ent != -1) 
                    { 
                        int m_iItemIDHigh = GetEntProp( ent, Prop_Send, "m_iItemIDHigh" ); 
                        int m_iItemIDLow = GetEntProp( ent, Prop_Send, "m_iItemIDLow" ); 
                         
                        SetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex", 5032); 
                        SetEntProp(ent, Prop_Send, "m_iItemIDLow", 8192+param1); 
                        SetEntProp(ent, Prop_Send, "m_iItemIDHigh", 0); 
                        SetEntProp(ent, Prop_Send, "m_iEntityQuality", 4); 
                         
                        SetEntPropFloat(ent, Prop_Send, "m_flFallbackWear", 0.00000001); 
                         
                        SetEntProp(ent, Prop_Send,  "m_iAccountID", GetSteamAccountID(param1)); 
                         
                        SetEntProp(ent, Prop_Send,  "m_nFallbackSeed", 0); 
                        SetEntProp(ent, Prop_Send,  "m_nFallbackStatTrak", GetSteamAccountID(param1)); 
                        SetEntProp(ent, Prop_Send,  "m_nFallbackPaintKit", 10021); 
                         
                        if (!IsModelPrecached("models/weapons/v_models/arms/glove_handwrap_leathery/v_glove_handwrap_leathery.mdl")) PrecacheModel("models/weapons/v_models/arms/glove_handwrap_leathery/v_glove_handwrap_leathery.mdl"); 
                         
                        SetEntProp(ent, Prop_Send, "m_nModelIndex", PrecacheModel("models/weapons/v_models/arms/glove_handwrap_leathery/v_glove_handwrap_leathery.mdl")); 
                        SetEntityModel(ent, "models/weapons/v_models/arms/glove_handwrap_leathery/v_glove_handwrap_leathery.mdl"); 
                         
                        SetEntPropEnt(param1, Prop_Send, "m_hMyWearables", ent); 
                         
                        Handle ph1 = CreateDataPack(); 
                        CreateTimer(2.0, AddItemTimer1, ph1, TIMER_FLAG_NO_MAPCHANGE); 
                         
                        WritePackCell(ph1, EntIndexToEntRef(param1)); 
                        WritePackCell(ph1, EntIndexToEntRef(item)); 
                        WritePackCell(ph1, EntIndexToEntRef(ent)); 
                        WritePackCell(ph1, m_iItemIDHigh ); 
                        WritePackCell(ph1, m_iItemIDLow ); 
                         
                        Handle ph2 = CreateDataPack(); 
                        CreateTimer(0.0, AddItemTimer2, ph2, TIMER_FLAG_NO_MAPCHANGE); 
                         
                        WritePackCell(ph2, EntIndexToEntRef(param1)); 
                        WritePackCell(ph2, EntIndexToEntRef(item)); 
                         
                        char weaponclass[ 64 ]; GetEdictClassname( ent, weaponclass, sizeof( weaponclass ) ); 
                        CPrintToChat(param1, "%s", weaponclass); 
                    } 
         
                    return Plugin_Handled; 
                } 
            } 
            else if (StrEqual(item, "motorcycle_mono_boom")) 
            { 
                if(IsValidated(param1))  
                { 
                    gloves[param1] = 7; 
                    int item = GetEntPropEnt(param1, Prop_Send, "m_hActiveWeapon"); 
                     
                    SetEntPropEnt(param1, Prop_Send, "m_hActiveWeapon", -1); 
                     
                    new ent = GivePlayerItem(param1, "wearable_item"); 
                     
                    if (ent != -1) 
                    { 
                        int m_iItemIDHigh = GetEntProp( ent, Prop_Send, "m_iItemIDHigh" ); 
                        int m_iItemIDLow = GetEntProp( ent, Prop_Send, "m_iItemIDLow" ); 
                         
                        SetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex", 5033); 
                        SetEntProp(ent, Prop_Send, "m_iItemIDLow", 8192+param1); 
                        SetEntProp(ent, Prop_Send, "m_iItemIDHigh", 0); 
                        SetEntProp(ent, Prop_Send, "m_iEntityQuality", 4); 
                         
                        SetEntPropFloat(ent, Prop_Send, "m_flFallbackWear", 0.00000001); 
                         
                        SetEntProp(ent, Prop_Send,  "m_iAccountID", GetSteamAccountID(param1)); 
                         
                        SetEntProp(ent, Prop_Send,  "m_nFallbackSeed", 0); 
                        SetEntProp(ent, Prop_Send,  "m_nFallbackStatTrak", GetSteamAccountID(param1)); 
                        SetEntProp(ent, Prop_Send,  "m_nFallbackPaintKit", 10027); 
                         
                        if (!IsModelPrecached("models/weapons/v_models/arms/glove_motorcycle/v_glove_motorcycle.mdl")) PrecacheModel("models/weapons/v_models/arms/glove_motorcycle/v_glove_motorcycle.mdl"); 
                         
                        SetEntProp(ent, Prop_Send, "m_nModelIndex", PrecacheModel("models/weapons/v_models/arms/glove_motorcycle/v_glove_motorcycle.mdl")); 
                        SetEntityModel(ent, "models/weapons/v_models/arms/glove_motorcycle/v_glove_motorcycle.mdl"); 
                         
                        SetEntPropEnt(param1, Prop_Send, "m_hMyWearables", ent); 
                         
                        Handle ph1 = CreateDataPack(); 
                        CreateTimer(2.0, AddItemTimer1, ph1, TIMER_FLAG_NO_MAPCHANGE); 
                         
                        WritePackCell(ph1, EntIndexToEntRef(param1)); 
                        WritePackCell(ph1, EntIndexToEntRef(item)); 
                        WritePackCell(ph1, EntIndexToEntRef(ent)); 
                        WritePackCell(ph1, m_iItemIDHigh ); 
                        WritePackCell(ph1, m_iItemIDLow ); 
                         
                        Handle ph2 = CreateDataPack(); 
                        CreateTimer(0.0, AddItemTimer2, ph2, TIMER_FLAG_NO_MAPCHANGE); 
                         
                        WritePackCell(ph2, EntIndexToEntRef(param1)); 
                        WritePackCell(ph2, EntIndexToEntRef(item)); 
                         
                        char weaponclass[ 64 ]; GetEdictClassname( ent, weaponclass, sizeof( weaponclass ) ); 
                        CPrintToChat(param1, "%s", weaponclass); 
                    } 
         
                    return Plugin_Handled; 
                } 
            } 
            else if (StrEqual(item, "specialist_kimono_diamonds_red")) 
            { 
                if(IsValidated(param1))  
                { 
                    gloves[param1] = 8; 
                    int item = GetEntPropEnt(param1, Prop_Send, "m_hActiveWeapon"); 
                     
                    SetEntPropEnt(param1, Prop_Send, "m_hActiveWeapon", -1); 
                     
                    new ent = GivePlayerItem(param1, "wearable_item"); 
                     
                    if (ent != -1) 
                    { 
                        int m_iItemIDHigh = GetEntProp( ent, Prop_Send, "m_iItemIDHigh" ); 
                        int m_iItemIDLow = GetEntProp( ent, Prop_Send, "m_iItemIDLow" ); 
                         
                        SetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex", 5028); 
                        SetEntProp(ent, Prop_Send, "m_iItemIDLow", 8192+param1); 
                        SetEntProp(ent, Prop_Send, "m_iItemIDHigh", 0); 
                        SetEntProp(ent, Prop_Send, "m_iEntityQuality", 4); 
                         
                        SetEntPropFloat(ent, Prop_Send, "m_flFallbackWear", 0.00000001); 
                         
                        SetEntProp(ent, Prop_Send,  "m_iAccountID", GetSteamAccountID(param1)); 
                         
                        SetEntProp(ent, Prop_Send,  "m_nFallbackSeed", 0); 
                        SetEntProp(ent, Prop_Send,  "m_nFallbackStatTrak", GetSteamAccountID(param1)); 
                        SetEntProp(ent, Prop_Send,  "m_nFallbackPaintKit", 10033); 
                         
                        if (!IsModelPrecached("models/weapons/v_models/arms/glove_specialist/v_glove_specialist.mdl")) PrecacheModel("models/weapons/v_models/arms/glove_specialist/v_glove_specialist.mdl"); 
                         
                        SetEntProp(ent, Prop_Send, "m_nModelIndex", PrecacheModel("models/weapons/v_models/arms/glove_specialist/v_glove_specialist.mdl")); 
                        SetEntityModel(ent, "models/weapons/v_models/arms/glove_specialist/v_glove_specialist.mdl"); 
                         
                        SetEntPropEnt(param1, Prop_Send, "m_hMyWearables", ent); 
                         
                        Handle ph1 = CreateDataPack(); 
                        CreateTimer(2.0, AddItemTimer1, ph1, TIMER_FLAG_NO_MAPCHANGE); 
                         
                        WritePackCell(ph1, EntIndexToEntRef(param1)); 
                        WritePackCell(ph1, EntIndexToEntRef(item)); 
                        WritePackCell(ph1, EntIndexToEntRef(ent)); 
                        WritePackCell(ph1, m_iItemIDHigh ); 
                        WritePackCell(ph1, m_iItemIDLow ); 
                         
                        Handle ph2 = CreateDataPack(); 
                        CreateTimer(0.0, AddItemTimer2, ph2, TIMER_FLAG_NO_MAPCHANGE); 
                         
                        WritePackCell(ph2, EntIndexToEntRef(param1)); 
                        WritePackCell(ph2, EntIndexToEntRef(item)); 
                         
                        char weaponclass[ 64 ]; GetEdictClassname( ent, weaponclass, sizeof( weaponclass ) ); 
                        CPrintToChat(param1, "%s", weaponclass); 
                    } 
         
                    return Plugin_Handled; 
                } 
            } 
            else if (StrEqual(item, "specialist_emerald_web")) 
            { 
                if(IsValidated(param1))  
                { 
                    gloves[param1] = 9; 
                    int item = GetEntPropEnt(param1, Prop_Send, "m_hActiveWeapon"); 
                     
                    SetEntPropEnt(param1, Prop_Send, "m_hActiveWeapon", -1); 
                     
                    new ent = GivePlayerItem(param1, "wearable_item"); 
                     
                    if (ent != -1) 
                    { 
                        int m_iItemIDHigh = GetEntProp( ent, Prop_Send, "m_iItemIDHigh" ); 
                        int m_iItemIDLow = GetEntProp( ent, Prop_Send, "m_iItemIDLow" ); 
                         
                        SetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex", 5028); 
                        SetEntProp(ent, Prop_Send, "m_iItemIDLow", 8192+param1); 
                        SetEntProp(ent, Prop_Send, "m_iItemIDHigh", 0); 
                        SetEntProp(ent, Prop_Send, "m_iEntityQuality", 4); 
                         
                        SetEntPropFloat(ent, Prop_Send, "m_flFallbackWear", 0.00000001); 
                         
                        SetEntProp(ent, Prop_Send,  "m_iAccountID", GetSteamAccountID(param1)); 
                         
                        SetEntProp(ent, Prop_Send,  "m_nFallbackSeed", 0); 
                        SetEntProp(ent, Prop_Send,  "m_nFallbackStatTrak", GetSteamAccountID(param1)); 
                        SetEntProp(ent, Prop_Send,  "m_nFallbackPaintKit", 10034); 
                         
                        if (!IsModelPrecached("models/weapons/v_models/arms/glove_specialist/v_glove_specialist.mdl")) PrecacheModel("models/weapons/v_models/arms/glove_specialist/v_glove_specialist.mdl"); 
                         
                        SetEntProp(ent, Prop_Send, "m_nModelIndex", PrecacheModel("models/weapons/v_models/arms/glove_specialist/v_glove_specialist.mdl")); 
                        SetEntityModel(ent, "models/weapons/v_models/arms/glove_specialist/v_glove_specialist.mdl"); 
                         
                        SetEntPropEnt(param1, Prop_Send, "m_hMyWearables", ent); 
                         
                        Handle ph1 = CreateDataPack(); 
                        CreateTimer(2.0, AddItemTimer1, ph1, TIMER_FLAG_NO_MAPCHANGE); 
                         
                        WritePackCell(ph1, EntIndexToEntRef(param1)); 
                        WritePackCell(ph1, EntIndexToEntRef(item)); 
                        WritePackCell(ph1, EntIndexToEntRef(ent)); 
                        WritePackCell(ph1, m_iItemIDHigh ); 
                        WritePackCell(ph1, m_iItemIDLow ); 
                         
                        Handle ph2 = CreateDataPack(); 
                        CreateTimer(0.0, AddItemTimer2, ph2, TIMER_FLAG_NO_MAPCHANGE); 
                         
                        WritePackCell(ph2, EntIndexToEntRef(param1)); 
                        WritePackCell(ph2, EntIndexToEntRef(item)); 
                         
                        char weaponclass[ 64 ]; GetEdictClassname( ent, weaponclass, sizeof( weaponclass ) ); 
                        CPrintToChat(param1, "%s", weaponclass); 
                    } 
         
                    return Plugin_Handled; 
                } 
            } 
        } 

        case MenuAction_Cancel: 
        { 
            //param1 is client, param2 is cancel reason (see MenuCancel types) 
            CloseHandle(menu); 
        } 

        case MenuAction_End: 
        { 
            //param1 is MenuEnd reason, if canceled param2 is MenuCancel reason 
            CloseHandle(menu); 

        } 

        case MenuAction_DisplayItem: 
        { 
            //param1 is client, param2 is item 

            new String:item[64]; 
            GetMenuItem(menu, param2, item, sizeof(item)); 

            if (StrEqual(item, "bloodhound_black_silver")) 
            { 
                new String:translation[128]; 
                Format(translation, sizeof(translation), "%T", "bloodhound_black_silver", param1); 
                return RedrawMenuItem(translation); 
            } 
            else if (StrEqual(item, "bloodhound_snakeskin_brass")) 
            { 
                new String:translation[128]; 
                Format(translation, sizeof(translation), "%T", "bloodhound_snakeskin_brass", param1); 
                return RedrawMenuItem(translation); 
            } 
            else if (StrEqual(item, "bloodhound_guerrilla")) 
            { 
                new String:translation[128]; 
                Format(translation, sizeof(translation), "%T", "bloodhound_guerrilla", param1); 
                return RedrawMenuItem(translation); 
            } 
            else if (StrEqual(item, "handwrap_leathery")) 
            { 
                new String:translation[128]; 
                Format(translation, sizeof(translation), "%T", "handwrap_leathery", param1); 
                return RedrawMenuItem(translation); 
            } 
            else if (StrEqual(item, "slick_military")) 
            { 
                new String:translation[128]; 
                Format(translation, sizeof(translation), "%T", "slick_military", param1); 
                return RedrawMenuItem(translation); 
            } 
            else if (StrEqual(item, " handwrap_red_slaughter")) 
            { 
                new String:translation[128]; 
                Format(translation, sizeof(translation), "%T", " handwrap_red_slaughter", param1); 
                return RedrawMenuItem(translation); 
            } 
            else if (StrEqual(item, "motorcycle_mono_boom")) 
            { 
                new String:translation[128]; 
                Format(translation, sizeof(translation), "%T", "motorcycle_mono_boom", param1); 
                return RedrawMenuItem(translation); 
            } 
            else if (StrEqual(item, "specialist_kimono_diamonds_red")) 
            { 
                new String:translation[128]; 
                Format(translation, sizeof(translation), "%T", "specialist_kimono_diamonds_red", param1); 
                return RedrawMenuItem(translation); 
            } 
            else if (StrEqual(item, "specialist_emerald_web")) 
            { 
                new String:translation[128]; 
                Format(translation, sizeof(translation), "%T", "specialist_emerald_web", param1); 
                return RedrawMenuItem(translation); 
            } 
        } 

    } 
    return 0; 
} 

public Action ps(Handle event, const char[] name, bool dontBroadcast) 
{ 
    new client_id = GetEventInt(event, "userid"); 
    new client = GetClientOfUserId(client_id); 
    if(gloves[client] == 1){ 
        gloves[client] = 1; 
                     
        int item = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon"); 
                     
        SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", -1); 
                     
        new ent = GivePlayerItem(client, "wearable_item"); 
                     
        if (ent != -1) 
        { 
            int m_iItemIDHigh = GetEntProp( ent, Prop_Send, "m_iItemIDHigh" ); 
            int m_iItemIDLow = GetEntProp( ent, Prop_Send, "m_iItemIDLow" ); 
                         
            SetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex", 5027); 
            SetEntProp(ent, Prop_Send, "m_iItemIDLow", 8192+client); 
            SetEntProp(ent, Prop_Send, "m_iItemIDHigh", 0); 
            SetEntProp(ent, Prop_Send, "m_iEntityQuality", 4); 
                         
            SetEntPropFloat(ent, Prop_Send, "m_flFallbackWear", 0.00000001); 
                         
            SetEntProp(ent, Prop_Send,  "m_iAccountID", GetSteamAccountID(client)); 
                         
            SetEntProp(ent, Prop_Send,  "m_nFallbackSeed", 0); 
            SetEntProp(ent, Prop_Send,  "m_nFallbackStatTrak", GetSteamAccountID(client)); 
            SetEntProp(ent, Prop_Send,  "m_nFallbackPaintKit", 10006); 
                         
            if (!IsModelPrecached("models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl")) PrecacheModel("models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl"); 
                         
            SetEntProp(ent, Prop_Send, "m_nModelIndex", PrecacheModel("models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl")); 
            SetEntityModel(ent, "models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl");         
            SetEntPropEnt(client, Prop_Send, "m_hMyWearables", ent); 
                         
            Handle ph1 = CreateDataPack(); 
            CreateTimer(2.0, AddItemTimer1, ph1, TIMER_FLAG_NO_MAPCHANGE); 
                         
            WritePackCell(ph1, EntIndexToEntRef(client)); 
            WritePackCell(ph1, EntIndexToEntRef(item)); 
            WritePackCell(ph1, EntIndexToEntRef(ent)); 
            WritePackCell(ph1, m_iItemIDHigh ); 
            WritePackCell(ph1, m_iItemIDLow ); 
                         
            Handle ph2 = CreateDataPack(); 
            CreateTimer(0.0, AddItemTimer2, ph2, TIMER_FLAG_NO_MAPCHANGE); 
                         
            WritePackCell(ph2, EntIndexToEntRef(client)); 
            WritePackCell(ph2, EntIndexToEntRef(item)); 
                         
            char weaponclass[ 64 ]; GetEdictClassname( ent, weaponclass, sizeof( weaponclass ) ); 
        } 
    } 
    else 
    if(gloves[client] == 2){ 
        gloves[client] = 2; 
                     
        int item = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon"); 
         
        SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", -1); 
         
        new ent = GivePlayerItem(client, "wearable_item"); 
         
        if (ent != -1) 
        { 
            int m_iItemIDHigh = GetEntProp( ent, Prop_Send, "m_iItemIDHigh" ); 
            int m_iItemIDLow = GetEntProp( ent, Prop_Send, "m_iItemIDLow" ); 

            SetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex", 5027); 
            SetEntProp(ent, Prop_Send, "m_iItemIDLow", 8192+client); 
            SetEntProp(ent, Prop_Send, "m_iItemIDHigh", 0); 
            SetEntProp(ent, Prop_Send, "m_iEntityQuality", 4); 
             
            SetEntPropFloat(ent, Prop_Send, "m_flFallbackWear", 0.00000001); 

            SetEntProp(ent, Prop_Send,  "m_iAccountID", GetSteamAccountID(client)); 

            SetEntProp(ent, Prop_Send,  "m_nFallbackSeed", 0); 
            SetEntProp(ent, Prop_Send,  "m_nFallbackStatTrak", GetSteamAccountID(client)); 
            SetEntProp(ent, Prop_Send,  "m_nFallbackPaintKit", 10007); 

            if (!IsModelPrecached("models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl")) PrecacheModel("models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl"); 

            SetEntProp(ent, Prop_Send, "m_nModelIndex", PrecacheModel("models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl")); 
            SetEntityModel(ent, "models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl"); 
             
            SetEntPropEnt(client, Prop_Send, "m_hMyWearables", ent); 

            Handle ph1 = CreateDataPack(); 
            CreateTimer(2.0, AddItemTimer1, ph1, TIMER_FLAG_NO_MAPCHANGE); 

            WritePackCell(ph1, EntIndexToEntRef(client)); 
            WritePackCell(ph1, EntIndexToEntRef(item)); 
            WritePackCell(ph1, EntIndexToEntRef(ent)); 
            WritePackCell(ph1, m_iItemIDHigh ); 
            WritePackCell(ph1, m_iItemIDLow ); 

            Handle ph2 = CreateDataPack(); 
            CreateTimer(0.0, AddItemTimer2, ph2, TIMER_FLAG_NO_MAPCHANGE); 

            WritePackCell(ph2, EntIndexToEntRef(client)); 
            WritePackCell(ph2, EntIndexToEntRef(item)); 

            char weaponclass[ 64 ]; GetEdictClassname( ent, weaponclass, sizeof( weaponclass ) ); 
        } 
     
    } 
    else 
    if(gloves[client] == 3){ 
        gloves[client] = 3; 
                     
        int item = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon"); 
                     
        SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", -1); 
                     
        new ent = GivePlayerItem(client, "wearable_item"); 
                     
        if (ent != -1) 
        { 
            int m_iItemIDHigh = GetEntProp( ent, Prop_Send, "m_iItemIDHigh" ); 
            int m_iItemIDLow = GetEntProp( ent, Prop_Send, "m_iItemIDLow" ); 
                         
            SetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex", 5027); 
            SetEntProp(ent, Prop_Send, "m_iItemIDLow", 8192+client); 
            SetEntProp(ent, Prop_Send, "m_iItemIDHigh", 0); 
            SetEntProp(ent, Prop_Send, "m_iEntityQuality", 4); 
                         
            SetEntPropFloat(ent, Prop_Send, "m_flFallbackWear", 0.00000001); 
                         
            SetEntProp(ent, Prop_Send,  "m_iAccountID", GetSteamAccountID(client)); 
                         
            SetEntProp(ent, Prop_Send,  "m_nFallbackSeed", 0); 
            SetEntProp(ent, Prop_Send,  "m_nFallbackStatTrak", GetSteamAccountID(client)); 
            SetEntProp(ent, Prop_Send,  "m_nFallbackPaintKit", 10039); 
                         
            if (!IsModelPrecached("models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl")) PrecacheModel("models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl"); 
                         
            SetEntProp(ent, Prop_Send, "m_nModelIndex", PrecacheModel("models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl")); 
            SetEntityModel(ent, "models/weapons/v_models/arms/glove_bloodhound/v_glove_bloodhound.mdl"); 
                         
            SetEntPropEnt(client, Prop_Send, "m_hMyWearables", ent); 
                         
            Handle ph1 = CreateDataPack(); 
            CreateTimer(2.0, AddItemTimer1, ph1, TIMER_FLAG_NO_MAPCHANGE); 
                         
            WritePackCell(ph1, EntIndexToEntRef(client)); 
            WritePackCell(ph1, EntIndexToEntRef(item)); 
            WritePackCell(ph1, EntIndexToEntRef(ent)); 
            WritePackCell(ph1, m_iItemIDHigh ); 
            WritePackCell(ph1, m_iItemIDLow ); 
                         
            Handle ph2 = CreateDataPack(); 
            CreateTimer(0.0, AddItemTimer2, ph2, TIMER_FLAG_NO_MAPCHANGE); 
                         
            WritePackCell(ph2, EntIndexToEntRef(client)); 
            WritePackCell(ph2, EntIndexToEntRef(item)); 
                         
            char weaponclass[ 64 ]; GetEdictClassname( ent, weaponclass, sizeof( weaponclass ) ); 
        } 
     
    } 
    else 
    if(gloves[client] == 4){ 
        gloves[client] = 4; 
        int item = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon"); 
                     
        SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", -1); 
                     
        new ent = GivePlayerItem(client, "wearable_item"); 
                     
        if (ent != -1) 
        { 
            int m_iItemIDHigh = GetEntProp( ent, Prop_Send, "m_iItemIDHigh" ); 
            int m_iItemIDLow = GetEntProp( ent, Prop_Send, "m_iItemIDLow" ); 
                         
            SetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex", 5029); 
            SetEntProp(ent, Prop_Send, "m_iItemIDLow", 8192+client); 
            SetEntProp(ent, Prop_Send, "m_iItemIDHigh", 0); 
            SetEntProp(ent, Prop_Send, "m_iEntityQuality", 4); 
                         
            SetEntPropFloat(ent, Prop_Send, "m_flFallbackWear", 0.00000001); 
                         
            SetEntProp(ent, Prop_Send,  "m_iAccountID", GetSteamAccountID(client)); 
                         
            SetEntProp(ent, Prop_Send,  "m_nFallbackSeed", 0); 
            SetEntProp(ent, Prop_Send,  "m_nFallbackStatTrak", GetSteamAccountID(client)); 
            SetEntProp(ent, Prop_Send,  "m_nFallbackPaintKit", 10009); 
                         
            if (!IsModelPrecached("models/weapons/v_models/arms/glove_handwrap_leathery/v_glove_handwrap_leathery.mdl")) PrecacheModel("models/weapons/v_models/arms/glove_handwrap_leathery/v_glove_handwrap_leathery.mdl"); 
                         
            SetEntProp(ent, Prop_Send, "m_nModelIndex", PrecacheModel("models/weapons/v_models/arms/glove_handwrap_leathery/v_glove_handwrap_leathery.mdl")); 
            SetEntityModel(ent, "models/weapons/v_models/arms/glove_handwrap_leathery/v_glove_handwrap_leathery.mdl"); 
                         
            SetEntPropEnt(client, Prop_Send, "m_hMyWearables", ent); 
                         
            Handle ph1 = CreateDataPack(); 
            CreateTimer(2.0, AddItemTimer1, ph1, TIMER_FLAG_NO_MAPCHANGE); 
                         
            WritePackCell(ph1, EntIndexToEntRef(client)); 
            WritePackCell(ph1, EntIndexToEntRef(item)); 
            WritePackCell(ph1, EntIndexToEntRef(ent)); 
            WritePackCell(ph1, m_iItemIDHigh ); 
            WritePackCell(ph1, m_iItemIDLow ); 
                         
            Handle ph2 = CreateDataPack(); 
            CreateTimer(0.0, AddItemTimer2, ph2, TIMER_FLAG_NO_MAPCHANGE); 
                         
            WritePackCell(ph2, EntIndexToEntRef(client)); 
            WritePackCell(ph2, EntIndexToEntRef(item)); 
                         
            char weaponclass[ 64 ]; GetEdictClassname( ent, weaponclass, sizeof( weaponclass ) ); 
        } 
     
    } 
    else 
    if(gloves[client] == 5){ 
        gloves[client] = 5; 
        int item = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon"); 
                     
        SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", -1); 
                     
        new ent = GivePlayerItem(client, "wearable_item"); 
                     
        if (ent != -1) 
        { 
            int m_iItemIDHigh = GetEntProp( ent, Prop_Send, "m_iItemIDHigh" ); 
            int m_iItemIDLow = GetEntProp( ent, Prop_Send, "m_iItemIDLow" ); 
                         
            SetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex", 5031); 
            SetEntProp(ent, Prop_Send, "m_iItemIDLow", 8192+client); 
            SetEntProp(ent, Prop_Send, "m_iItemIDHigh", 0); 
            SetEntProp(ent, Prop_Send, "m_iEntityQuality", 4); 
                         
            SetEntPropFloat(ent, Prop_Send, "m_flFallbackWear", 0.00000001); 
                         
            SetEntProp(ent, Prop_Send,  "m_iAccountID", GetSteamAccountID(client)); 
                         
            SetEntProp(ent, Prop_Send,  "m_nFallbackSeed", 0); 
            SetEntProp(ent, Prop_Send,  "m_nFallbackStatTrak", GetSteamAccountID(client)); 
            SetEntProp(ent, Prop_Send,  "m_nFallbackPaintKit", 10015); 
                         
            if (!IsModelPrecached("models/weapons/v_models/arms/glove_slick/v_glove_slick.mdl")) PrecacheModel("models/weapons/v_models/arms/glove_slick/v_glove_slick.mdl"); 
                         
            SetEntProp(ent, Prop_Send, "m_nModelIndex", PrecacheModel("models/weapons/v_models/arms/glove_slick/v_glove_slick.mdl")); 
            SetEntityModel(ent, "models/weapons/v_models/arms/glove_slick/v_glove_slick.mdl"); 
                         
            SetEntPropEnt(client, Prop_Send, "m_hMyWearables", ent); 
                         
            Handle ph1 = CreateDataPack(); 
            CreateTimer(2.0, AddItemTimer1, ph1, TIMER_FLAG_NO_MAPCHANGE); 
                         
            WritePackCell(ph1, EntIndexToEntRef(client)); 
            WritePackCell(ph1, EntIndexToEntRef(item)); 
            WritePackCell(ph1, EntIndexToEntRef(ent)); 
            WritePackCell(ph1, m_iItemIDHigh ); 
            WritePackCell(ph1, m_iItemIDLow ); 
                         
            Handle ph2 = CreateDataPack(); 
            CreateTimer(0.0, AddItemTimer2, ph2, TIMER_FLAG_NO_MAPCHANGE); 
                         
            WritePackCell(ph2, EntIndexToEntRef(client)); 
            WritePackCell(ph2, EntIndexToEntRef(item)); 
                         
            char weaponclass[ 64 ]; GetEdictClassname( ent, weaponclass, sizeof( weaponclass ) ); 
        } 
    } 
    else 
    if(gloves[client] == 6){ 
        gloves[client] = 6; 
        int item = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon"); 
                     
        SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", -1); 
                     
        new ent = GivePlayerItem(client, "wearable_item"); 
                     
        if (ent != -1) 
        { 
            int m_iItemIDHigh = GetEntProp( ent, Prop_Send, "m_iItemIDHigh" ); 
            int m_iItemIDLow = GetEntProp( ent, Prop_Send, "m_iItemIDLow" ); 
                         
            SetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex", 5032); 
            SetEntProp(ent, Prop_Send, "m_iItemIDLow", 8192+client); 
            SetEntProp(ent, Prop_Send, "m_iItemIDHigh", 0); 
            SetEntProp(ent, Prop_Send, "m_iEntityQuality", 4); 
                         
            SetEntPropFloat(ent, Prop_Send, "m_flFallbackWear", 0.00000001); 
                         
            SetEntProp(ent, Prop_Send,  "m_iAccountID", GetSteamAccountID(client)); 
                         
            SetEntProp(ent, Prop_Send,  "m_nFallbackSeed", 0); 
            SetEntProp(ent, Prop_Send,  "m_nFallbackStatTrak", GetSteamAccountID(client)); 
            SetEntProp(ent, Prop_Send,  "m_nFallbackPaintKit", 10021); 
                         
            if (!IsModelPrecached("models/weapons/v_models/arms/glove_handwrap_leathery/v_glove_handwrap_leathery.mdl")) PrecacheModel("models/weapons/v_models/arms/glove_handwrap_leathery/v_glove_handwrap_leathery.mdl"); 
                         
            SetEntProp(ent, Prop_Send, "m_nModelIndex", PrecacheModel("models/weapons/v_models/arms/glove_handwrap_leathery/v_glove_handwrap_leathery.mdl")); 
            SetEntityModel(ent, "models/weapons/v_models/arms/glove_handwrap_leathery/v_glove_handwrap_leathery.mdl"); 
                         
            SetEntPropEnt(client, Prop_Send, "m_hMyWearables", ent); 
                         
            Handle ph1 = CreateDataPack(); 
            CreateTimer(2.0, AddItemTimer1, ph1, TIMER_FLAG_NO_MAPCHANGE); 
                 
            WritePackCell(ph1, EntIndexToEntRef(client)); 
            WritePackCell(ph1, EntIndexToEntRef(item)); 
            WritePackCell(ph1, EntIndexToEntRef(ent)); 
            WritePackCell(ph1, m_iItemIDHigh ); 
            WritePackCell(ph1, m_iItemIDLow ); 
                         
            Handle ph2 = CreateDataPack(); 
            CreateTimer(0.0, AddItemTimer2, ph2, TIMER_FLAG_NO_MAPCHANGE); 
                         
            WritePackCell(ph2, EntIndexToEntRef(client)); 
            WritePackCell(ph2, EntIndexToEntRef(item)); 
                         
            char weaponclass[ 64 ]; GetEdictClassname( ent, weaponclass, sizeof( weaponclass ) ); 
        } 
    } 
    else 
    if(gloves[client] == 7){ 
        gloves[client] = 7; 
        int item = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon"); 
                     
        SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", -1); 
                     
        new ent = GivePlayerItem(client, "wearable_item"); 
                     
        if (ent != -1) 
        { 
            int m_iItemIDHigh = GetEntProp( ent, Prop_Send, "m_iItemIDHigh" ); 
            int m_iItemIDLow = GetEntProp( ent, Prop_Send, "m_iItemIDLow" ); 
                         
            SetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex", 5033); 
            SetEntProp(ent, Prop_Send, "m_iItemIDLow", 8192+client); 
            SetEntProp(ent, Prop_Send, "m_iItemIDHigh", 0); 
            SetEntProp(ent, Prop_Send, "m_iEntityQuality", 4); 
                         
            SetEntPropFloat(ent, Prop_Send, "m_flFallbackWear", 0.00000001); 
                         
            SetEntProp(ent, Prop_Send,  "m_iAccountID", GetSteamAccountID(client)); 
                         
            SetEntProp(ent, Prop_Send,  "m_nFallbackSeed", 0); 
            SetEntProp(ent, Prop_Send,  "m_nFallbackStatTrak", GetSteamAccountID(client)); 
            SetEntProp(ent, Prop_Send,  "m_nFallbackPaintKit", 10027); 
                         
            if (!IsModelPrecached("models/weapons/v_models/arms/glove_motorcycle/v_glove_motorcycle.mdl")) PrecacheModel("models/weapons/v_models/arms/glove_motorcycle/v_glove_motorcycle.mdl"); 
                         
            SetEntProp(ent, Prop_Send, "m_nModelIndex", PrecacheModel("models/weapons/v_models/arms/glove_motorcycle/v_glove_motorcycle.mdl")); 
            SetEntityModel(ent, "models/weapons/v_models/arms/glove_motorcycle/v_glove_motorcycle.mdl"); 
                         
            SetEntPropEnt(client, Prop_Send, "m_hMyWearables", ent); 
                         
            Handle ph1 = CreateDataPack(); 
            CreateTimer(2.0, AddItemTimer1, ph1, TIMER_FLAG_NO_MAPCHANGE); 
                         
            WritePackCell(ph1, EntIndexToEntRef(client)); 
            WritePackCell(ph1, EntIndexToEntRef(item)); 
            WritePackCell(ph1, EntIndexToEntRef(ent)); 
            WritePackCell(ph1, m_iItemIDHigh ); 
            WritePackCell(ph1, m_iItemIDLow ); 
                         
            Handle ph2 = CreateDataPack(); 
            CreateTimer(0.0, AddItemTimer2, ph2, TIMER_FLAG_NO_MAPCHANGE); 
                         
            WritePackCell(ph2, EntIndexToEntRef(client)); 
            WritePackCell(ph2, EntIndexToEntRef(item)); 
                         
            char weaponclass[ 64 ]; GetEdictClassname( ent, weaponclass, sizeof( weaponclass ) ); 
        } 
    } 
    else 
    if(gloves[client] == 8){ 
        gloves[client] = 8; 
        int item = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon"); 
                     
        SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", -1); 
                     
        new ent = GivePlayerItem(client, "wearable_item"); 
                     
        if (ent != -1) 
        { 
            int m_iItemIDHigh = GetEntProp( ent, Prop_Send, "m_iItemIDHigh" ); 
            int m_iItemIDLow = GetEntProp( ent, Prop_Send, "m_iItemIDLow" ); 
                         
            SetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex", 5028); 
            SetEntProp(ent, Prop_Send, "m_iItemIDLow", 8192+client); 
            SetEntProp(ent, Prop_Send, "m_iItemIDHigh", 0); 
            SetEntProp(ent, Prop_Send, "m_iEntityQuality", 4); 
                         
            SetEntPropFloat(ent, Prop_Send, "m_flFallbackWear", 0.00000001); 
                         
            SetEntProp(ent, Prop_Send,  "m_iAccountID", GetSteamAccountID(client)); 
                         
            SetEntProp(ent, Prop_Send,  "m_nFallbackSeed", 0); 
            SetEntProp(ent, Prop_Send,  "m_nFallbackStatTrak", GetSteamAccountID(client)); 
            SetEntProp(ent, Prop_Send,  "m_nFallbackPaintKit", 10033); 
                         
            if (!IsModelPrecached("models/weapons/v_models/arms/glove_specialist/v_glove_specialist.mdl")) PrecacheModel("models/weapons/v_models/arms/glove_specialist/v_glove_specialist.mdl"); 
                         
            SetEntProp(ent, Prop_Send, "m_nModelIndex", PrecacheModel("models/weapons/v_models/arms/glove_specialist/v_glove_specialist.mdl")); 
            SetEntityModel(ent, "models/weapons/v_models/arms/glove_specialist/v_glove_specialist.mdl"); 
                         
            SetEntPropEnt(client, Prop_Send, "m_hMyWearables", ent); 
                         
            Handle ph1 = CreateDataPack(); 
            CreateTimer(2.0, AddItemTimer1, ph1, TIMER_FLAG_NO_MAPCHANGE); 
                         
            WritePackCell(ph1, EntIndexToEntRef(client)); 
            WritePackCell(ph1, EntIndexToEntRef(item)); 
            WritePackCell(ph1, EntIndexToEntRef(ent)); 
            WritePackCell(ph1, m_iItemIDHigh ); 
            WritePackCell(ph1, m_iItemIDLow ); 
                         
            Handle ph2 = CreateDataPack(); 
            CreateTimer(0.0, AddItemTimer2, ph2, TIMER_FLAG_NO_MAPCHANGE); 
                         
            WritePackCell(ph2, EntIndexToEntRef(client)); 
            WritePackCell(ph2, EntIndexToEntRef(item)); 
                         
            char weaponclass[ 64 ]; GetEdictClassname( ent, weaponclass, sizeof( weaponclass ) ); 
        } 
    } 
    else 
    if(gloves[client] == 9){ 
        gloves[client] = 9; 
        int item = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon"); 
                     
        SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", -1); 
                     
        new ent = GivePlayerItem(client, "wearable_item"); 
                     
        if (ent != -1) 
        { 
            int m_iItemIDHigh = GetEntProp( ent, Prop_Send, "m_iItemIDHigh" ); 
            int m_iItemIDLow = GetEntProp( ent, Prop_Send, "m_iItemIDLow" ); 
                         
            SetEntProp(ent, Prop_Send, "m_iItemDefinitionIndex", 5028); 
            SetEntProp(ent, Prop_Send, "m_iItemIDLow", 8192+client); 
            SetEntProp(ent, Prop_Send, "m_iItemIDHigh", 0); 
            SetEntProp(ent, Prop_Send, "m_iEntityQuality", 4); 
                         
            SetEntPropFloat(ent, Prop_Send, "m_flFallbackWear", 0.00000001); 
                         
            SetEntProp(ent, Prop_Send,  "m_iAccountID", GetSteamAccountID(client)); 
                         
            SetEntProp(ent, Prop_Send,  "m_nFallbackSeed", 0); 
            SetEntProp(ent, Prop_Send,  "m_nFallbackStatTrak", GetSteamAccountID(client)); 
            SetEntProp(ent, Prop_Send,  "m_nFallbackPaintKit", 10034); 
                         
            if (!IsModelPrecached("models/weapons/v_models/arms/glove_specialist/v_glove_specialist.mdl")) PrecacheModel("models/weapons/v_models/arms/glove_specialist/v_glove_specialist.mdl"); 
                         
            SetEntProp(ent, Prop_Send, "m_nModelIndex", PrecacheModel("models/weapons/v_models/arms/glove_specialist/v_glove_specialist.mdl")); 
            SetEntityModel(ent, "models/weapons/v_models/arms/glove_specialist/v_glove_specialist.mdl"); 
                         
            SetEntPropEnt(client, Prop_Send, "m_hMyWearables", ent); 
                         
            Handle ph1 = CreateDataPack(); 
            CreateTimer(2.0, AddItemTimer1, ph1, TIMER_FLAG_NO_MAPCHANGE); 
                         
            WritePackCell(ph1, EntIndexToEntRef(client)); 
            WritePackCell(ph1, EntIndexToEntRef(item)); 
            WritePackCell(ph1, EntIndexToEntRef(ent)); 
            WritePackCell(ph1, m_iItemIDHigh ); 
            WritePackCell(ph1, m_iItemIDLow ); 
                         
            Handle ph2 = CreateDataPack(); 
            CreateTimer(0.0, AddItemTimer2, ph2, TIMER_FLAG_NO_MAPCHANGE); 
                         
            WritePackCell(ph2, EntIndexToEntRef(client)); 
            WritePackCell(ph2, EntIndexToEntRef(item)); 
                         
            char weaponclass[ 64 ]; GetEdictClassname( ent, weaponclass, sizeof( weaponclass ) ); 
        } 
    } 
         
} 

public Action AddItemTimer1(Handle timer, any ph) 
{ 
    int client; 
    int item; 
    int ent; 
    int m_iItemIDHigh; 
    int m_iItemIDLow; 

    ResetPack(ph); 

    client = EntRefToEntIndex(ReadPackCell(ph)); 
    item = EntRefToEntIndex(ReadPackCell(ph)); 
    ent = EntRefToEntIndex(ReadPackCell(ph)); 
    m_iItemIDHigh = ReadPackCell( ph ); 
    m_iItemIDLow = ReadPackCell( ph ); 
     
    if (client != INVALID_ENT_REFERENCE && item != INVALID_ENT_REFERENCE) 
    { 
        SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", item); 
        SetEntProp( item, Prop_Send, "m_iItemIDHigh", m_iItemIDHigh ); 
        SetEntProp( item, Prop_Send, "m_iItemIDLow", m_iItemIDLow ); 
    } 
     
    //int maxEntities = GetMaxEntities(); 
    if(IsValidEdict(ent)) 
    { 
        char weaponclass[ 64 ]; 
        GetEdictClassname( ent, weaponclass, sizeof( weaponclass ) ); 
        CPrintToChat(client, "After: %s", weaponclass); 
        AcceptEntityInput(ent, "Kill") 
    } 
     
    /*for( int i = MaxClients + 1; i <= maxEntities; i++) 
    { 
        if( IsValidEdict( i ) ) 
        { 
            GetEdictClassname( i, weaponclass, sizeof( weaponclass ) ); 
            PrintToServer("%s", weaponclass); 
            //if(StrContains(weaponclass, "illusionary", false) || StrContains(weaponclass, "areaportal", false)) 
                //AcceptEntityInput(i, "Kill"); 
        } 
    }*/ 
     
    return Plugin_Stop 
} 

public Action AddItemTimer2(Handle timer, any ph) 
{ 
    int client; 
    int item; 

    ResetPack(ph); 

    client = EntRefToEntIndex(ReadPackCell(ph)); 
    item = EntRefToEntIndex(ReadPackCell(ph)); 
     
    if (client != INVALID_ENT_REFERENCE && item != INVALID_ENT_REFERENCE) 
    { 
        SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", item); 
    } 
     
    return Plugin_Stop 
} 

public void OnClientDisconnect(int iClient) 
{ 
    if(gloves[iClient] != 0){ 
        gloves[iClient] = 0; 
    } 
} 

bool IsValidated(int iClient) 
{ 
    return (1 <= iClient <= MaxClients && IsClientInGame(iClient)) ? true : false; 
}  