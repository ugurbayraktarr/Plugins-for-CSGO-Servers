#include <sdktools>
#include <cstrike>
#include <datapack>

#pragma semicolon 1

public Plugin:myinfo = 
{
	name = "Crash Fix",
	author = "ImPossibLe`",
	description = "DrK # GaminG",
	version = "1.0"
}

public Action CS_OnCSWeaponDrop(int client, int weaponIndex){
    float pos[3];
    GetClientAbsOrigin(client, pos);
    DataPack dp_info = new DataPack();
    dp_info.WriteCell(weaponIndex);
    dp_info.WriteFloat(pos[0]);
    dp_info.WriteFloat(pos[1]);
    dp_info.WriteFloat(pos[2]);
    CreateTimer(0.0, teleport_weapon, dp_info);
}

public Action teleport_weapon(Handle timer, DataPack dp_info){
    dp_info.Reset();
    float pos[3];
    int weaponIndex;
    weaponIndex = dp_info.ReadCell();
    pos[0] = dp_info.ReadFloat();
    pos[1] = dp_info.ReadFloat();
    pos[2] = dp_info.ReadFloat();
    TeleportEntity(weaponIndex, pos, NULL_VECTOR, NULL_VECTOR);
}