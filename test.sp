public PlVers:__version =
{
	version = 5,
	filevers = "1.7.3-dev+5283",
	date = "04/09/2016",
	time = "15:04:13"
};
new Float:NULL_VECTOR[3];
new String:NULL_STRING[4];
public Extension:__ext_core =
{
	name = "Core",
	file = "core",
	autoload = 0,
	required = 0,
};
new MaxClients;
public Extension:__ext_sdkhooks =
{
	name = "SDKHooks",
	file = "sdkhooks.ext",
	autoload = 1,
	required = 1,
};
public Extension:__ext_sdktools =
{
	name = "SDKTools",
	file = "sdktools.ext",
	autoload = 1,
	required = 1,
};
new String:CTag[12][0];
new String:CTagCode[12][16] =
{
	"\x01",
	"\x02",
	"\x04",
	"\x03",
	"\x03",
	"\x03",
	"\x05",
	"",
	"\x07",
	"\x03",
	"\x08",
	"	"
};
new bool:CTagReqSayText2[12] =
{
	0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0
};
new bool:CEventIsHooked;
new bool:CSkipList[66];
new bool:CProfile_Colors[12] =
{
	1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0
};
new CProfile_TeamIndex[10] =
{
	-1, ...
};
new bool:CProfile_SayText2;
new Handle:sm_show_activity = 1635151433;
public Extension:__ext_cstrike =
{
	name = "cstrike",
	file = "games/game.cstrike.ext",
	autoload = 0,
	required = 1,
};
public SharedPlugin:__pl_sodstats =
{
	name = "sodstats",
	file = "sodstats.smx",
	required = 1,
};
new Handle:stats_db;
new String:g_sql_saveplayer[196] = "UPDATE players SET score = %i, kills = %i, deaths = %i, shots = %i, hits = %i, name = '%s', time_played = time_played + %i, headshots = %i, last_connect = current_timestamp WHERE steamid = '%s'";
new String:g_sql_createplayer[172] = "INSERT INTO players (score, kills, deaths, shots, hits, steamid, name, time_played, headshots, last_connect) VALUES (0, 0, 0, 0, 0, '%s', '%s', 0, 0, current_timestamp)";
new String:g_sqlite_createtable_players[460] = "CREATE TABLE IF NOT EXISTS players (rank INTEGER PRIMARY KEY AUTOINCREMENT,score int(12) NOT NULL default 0,steamid varchar(255) NOT NULL default '',kills int(12) NOT NULL default 0,deaths int(12) NOT NULL default 0,shots int(12) NOT NULL default 0,hits int(12) NOT NULL default 0,name varchar(255) NOT NULL default '',time_played int(11) NOT NULL default 0, headshots int(12) NOT NULL default 0, last_connect timestamp NOT NULL default CURRENT_TIMESTAMP);";
new String:g_mysql_createtable_players[460] = "CREATE TABLE IF NOT EXISTS players (rank INTEGER PRIMARY KEY AUTO_INCREMENT,score int(12) NOT NULL default 0,steamid varchar(255) NOT NULL default '',kills int(12) NOT NULL default 0,deaths int(12) NOT NULL default 0,shots int(12) NOT NULL default 0,hits int(12) NOT NULL default 0,name varchar(255) NOT NULL default '',time_played int(11) NOT NULL default 0, headshots int(12) NOT NULL default 0, last_connect timestamp NOT NULL default CURRENT_TIMESTAMP);";
new String:g_sql_droptable_players[40] = "DROP TABLE IF EXISTS 'players'; VACUUM;";
new String:g_sql_playercount[24] = "SELECT * FROM players";
new String:g_sql_addheadshots[68] = "ALTER TABLE players ADD COLUMN headshots int(12) NOT NULL default 0";
new String:g_sql_addtimestamp[68] = "ALTER TABLE players ADD COLUMN last_connect timestamp DEFAULT NULL;";
new String:g_safename[66][32];
new String:g_steamid[66][128];
new g_start_points = 1000;
new String:g_ident[16];
new g_dbtype;
new g_kills[66];
new g_deaths[66];
new g_shots[66];
new g_hits[66];
new g_score[66];
new g_time_joined[66];
new g_time_played[66];
new g_last_saved_time[66];
new g_headshots[66];
new g_session_kills[66];
new g_session_deaths[66];
new g_session_shots[66];
new g_session_hits[66];
new g_session_score[66];
new g_session_headshots[66];
new Float:g_fSpamPrevention[66];
new bool:g_initialized[66];
new g_player_count;
new g_gameid;
new Handle:g_henabled;
new Handle:g_hstartpoints;
new g_enabled;
new iRank[66];
new iCoin[66];
new String:g_sql_loadplayer[116] = "SELECT name, steamid, score, kills, deaths, shots, hits, time_played, headshots FROM players WHERE steamid = '%s'";
new String:g_sql_top[132] = "SELECT name, steamid, score, kills, deaths, shots, hits, time_played, headshots FROM players ORDER BY score DESC LIMIT %i OFFSET %i";
new String:g_sql_rank[76] = "SELECT DISTINCT score FROM players WHERE score >= %i ORDER BY score ASC;";
public Plugin:myinfo =
{
	name = "Rank içerikli top10 sistemi",
	description = "DrK # GaminG",
	author = "ImPossibLe`",
	version = "2.0",
	url = ""
};
public __ext_core_SetNTVOptional()
{
	MarkNativeAsOptional("GetFeatureStatus");
	MarkNativeAsOptional("RequireFeature");
	MarkNativeAsOptional("AddCommandListener");
	MarkNativeAsOptional("RemoveCommandListener");
	MarkNativeAsOptional("BfWriteBool");
	MarkNativeAsOptional("BfWriteByte");
	MarkNativeAsOptional("BfWriteChar");
	MarkNativeAsOptional("BfWriteShort");
	MarkNativeAsOptional("BfWriteWord");
	MarkNativeAsOptional("BfWriteNum");
	MarkNativeAsOptional("BfWriteFloat");
	MarkNativeAsOptional("BfWriteString");
	MarkNativeAsOptional("BfWriteEntity");
	MarkNativeAsOptional("BfWriteAngle");
	MarkNativeAsOptional("BfWriteCoord");
	MarkNativeAsOptional("BfWriteVecCoord");
	MarkNativeAsOptional("BfWriteVecNormal");
	MarkNativeAsOptional("BfWriteAngles");
	MarkNativeAsOptional("BfReadBool");
	MarkNativeAsOptional("BfReadByte");
	MarkNativeAsOptional("BfReadChar");
	MarkNativeAsOptional("BfReadShort");
	MarkNativeAsOptional("BfReadWord");
	MarkNativeAsOptional("BfReadNum");
	MarkNativeAsOptional("BfReadFloat");
	MarkNativeAsOptional("BfReadString");
	MarkNativeAsOptional("BfReadEntity");
	MarkNativeAsOptional("BfReadAngle");
	MarkNativeAsOptional("BfReadCoord");
	MarkNativeAsOptional("BfReadVecCoord");
	MarkNativeAsOptional("BfReadVecNormal");
	MarkNativeAsOptional("BfReadAngles");
	MarkNativeAsOptional("BfGetNumBytesLeft");
	MarkNativeAsOptional("BfWrite.WriteBool");
	MarkNativeAsOptional("BfWrite.WriteByte");
	MarkNativeAsOptional("BfWrite.WriteChar");
	MarkNativeAsOptional("BfWrite.WriteShort");
	MarkNativeAsOptional("BfWrite.WriteWord");
	MarkNativeAsOptional("BfWrite.WriteNum");
	MarkNativeAsOptional("BfWrite.WriteFloat");
	MarkNativeAsOptional("BfWrite.WriteString");
	MarkNativeAsOptional("BfWrite.WriteEntity");
	MarkNativeAsOptional("BfWrite.WriteAngle");
	MarkNativeAsOptional("BfWrite.WriteCoord");
	MarkNativeAsOptional("BfWrite.WriteVecCoord");
	MarkNativeAsOptional("BfWrite.WriteVecNormal");
	MarkNativeAsOptional("BfWrite.WriteAngles");
	MarkNativeAsOptional("BfRead.ReadBool");
	MarkNativeAsOptional("BfRead.ReadByte");
	MarkNativeAsOptional("BfRead.ReadChar");
	MarkNativeAsOptional("BfRead.ReadShort");
	MarkNativeAsOptional("BfRead.ReadWord");
	MarkNativeAsOptional("BfRead.ReadNum");
	MarkNativeAsOptional("BfRead.ReadFloat");
	MarkNativeAsOptional("BfRead.ReadString");
	MarkNativeAsOptional("BfRead.ReadEntity");
	MarkNativeAsOptional("BfRead.ReadAngle");
	MarkNativeAsOptional("BfRead.ReadCoord");
	MarkNativeAsOptional("BfRead.ReadVecCoord");
	MarkNativeAsOptional("BfRead.ReadVecNormal");
	MarkNativeAsOptional("BfRead.ReadAngles");
	MarkNativeAsOptional("BfRead.GetNumBytesLeft");
	MarkNativeAsOptional("PbReadInt");
	MarkNativeAsOptional("PbReadFloat");
	MarkNativeAsOptional("PbReadBool");
	MarkNativeAsOptional("PbReadString");
	MarkNativeAsOptional("PbReadColor");
	MarkNativeAsOptional("PbReadAngle");
	MarkNativeAsOptional("PbReadVector");
	MarkNativeAsOptional("PbReadVector2D");
	MarkNativeAsOptional("PbGetRepeatedFieldCount");
	MarkNativeAsOptional("PbSetInt");
	MarkNativeAsOptional("PbSetFloat");
	MarkNativeAsOptional("PbSetBool");
	MarkNativeAsOptional("PbSetString");
	MarkNativeAsOptional("PbSetColor");
	MarkNativeAsOptional("PbSetAngle");
	MarkNativeAsOptional("PbSetVector");
	MarkNativeAsOptional("PbSetVector2D");
	MarkNativeAsOptional("PbAddInt");
	MarkNativeAsOptional("PbAddFloat");
	MarkNativeAsOptional("PbAddBool");
	MarkNativeAsOptional("PbAddString");
	MarkNativeAsOptional("PbAddColor");
	MarkNativeAsOptional("PbAddAngle");
	MarkNativeAsOptional("PbAddVector");
	MarkNativeAsOptional("PbAddVector2D");
	MarkNativeAsOptional("PbRemoveRepeatedFieldValue");
	MarkNativeAsOptional("PbReadMessage");
	MarkNativeAsOptional("PbReadRepeatedMessage");
	MarkNativeAsOptional("PbAddMessage");
	MarkNativeAsOptional("Protobuf.ReadInt");
	MarkNativeAsOptional("Protobuf.ReadFloat");
	MarkNativeAsOptional("Protobuf.ReadBool");
	MarkNativeAsOptional("Protobuf.ReadString");
	MarkNativeAsOptional("Protobuf.ReadColor");
	MarkNativeAsOptional("Protobuf.ReadAngle");
	MarkNativeAsOptional("Protobuf.ReadVector");
	MarkNativeAsOptional("Protobuf.ReadVector2D");
	MarkNativeAsOptional("Protobuf.GetRepeatedFieldCount");
	MarkNativeAsOptional("Protobuf.SetInt");
	MarkNativeAsOptional("Protobuf.SetFloat");
	MarkNativeAsOptional("Protobuf.SetBool");
	MarkNativeAsOptional("Protobuf.SetString");
	MarkNativeAsOptional("Protobuf.SetColor");
	MarkNativeAsOptional("Protobuf.SetAngle");
	MarkNativeAsOptional("Protobuf.SetVector");
	MarkNativeAsOptional("Protobuf.SetVector2D");
	MarkNativeAsOptional("Protobuf.AddInt");
	MarkNativeAsOptional("Protobuf.AddFloat");
	MarkNativeAsOptional("Protobuf.AddBool");
	MarkNativeAsOptional("Protobuf.AddString");
	MarkNativeAsOptional("Protobuf.AddColor");
	MarkNativeAsOptional("Protobuf.AddAngle");
	MarkNativeAsOptional("Protobuf.AddVector");
	MarkNativeAsOptional("Protobuf.AddVector2D");
	MarkNativeAsOptional("Protobuf.RemoveRepeatedFieldValue");
	MarkNativeAsOptional("Protobuf.ReadMessage");
	MarkNativeAsOptional("Protobuf.ReadRepeatedMessage");
	MarkNativeAsOptional("Protobuf.AddMessage");
	VerifyCoreVersion();
	return 0;
}

bool:operator>(Float:,_:)(Float:oper1, oper2)
{
	return oper1 > float(oper2);
}

bool:StrEqual(String:str1[], String:str2[], bool:caseSensitive)
{
	return strcmp(str1, str2, caseSensitive) == 0;
}

Handle:StartMessageOne(String:msgname[], client, flags)
{
	new players[1];
	players[0] = client;
	return StartMessage(msgname, players, 1, flags);
}

SetEntDataArray(entity, offset, array[], arraySize, dataSize, bool:changeState)
{
	new i;
	while (i < arraySize)
	{
		SetEntData(entity, dataSize * i + offset, array[i], dataSize, changeState);
		i++;
	}
	return 0;
}

CPrintToChat(client, String:szMessage[])
{
	new var1;
	if (client <= 0 || client > MaxClients)
	{
		ThrowError(sm_show_activity, client);
	}
	if (!IsClientInGame(client))
	{
		ThrowError("Client %d is not in game", client);
	}
	new var2;
	decl String:szBuffer[252];
	SetGlobalTransTarget(client);
	Format(szBuffer, 250, "\x01%s", szMessage);
	VFormat(var2, 250, szBuffer, 3);
	var2 = CFormat(var2, 250, -1);
	if (var2 == -1)
	{
		PrintToChat(client, "%s", var2);
	}
	else
	{
		CSayText2(client, var2, var2);
	}
	return 0;
}

CPrintToChatAll(String:szMessage[])
{
	decl String:szBuffer[252];
	new i = 1;
	while (i <= MaxClients)
	{
		new var1;
		if (IsClientInGame(i) && !IsFakeClient(i) && !CSkipList[i])
		{
			SetGlobalTransTarget(i);
			VFormat(szBuffer, 250, szMessage, 2);
			CPrintToChat(i, "%s", szBuffer);
		}
		CSkipList[i] = 0;
		i++;
	}
	return 0;
}

CFormat(String:szMessage[], maxlength, author)
{
	decl String:szGameName[32];
	GetGameFolderName(szGameName, 30);
	if (!CEventIsHooked)
	{
		CSetupProfile();
		HookEvent("server_spawn", CEvent_MapStart, EventHookMode:2);
		CEventIsHooked = true;
	}
	new iRandomPlayer = -1;
	if (StrEqual(szGameName, "csgo", false))
	{
		Format(szMessage, maxlength, " \x01\x01%s", szMessage);
	}
	if (author != -1)
	{
		if (CProfile_SayText2)
		{
			ReplaceString(szMessage, maxlength, "{teamcolor}", "\x03", false);
			iRandomPlayer = author;
		}
		else
		{
			ReplaceString(szMessage, maxlength, "{teamcolor}", CTagCode[2], false);
		}
	}
	else
	{
		ReplaceString(szMessage, maxlength, "{teamcolor}", "", false);
	}
	new i;
	while (i < 12)
	{
		if (!(StrContains(szMessage, CTag[i], false) == -1))
		{
			if (!CProfile_Colors[i])
			{
				ReplaceString(szMessage, maxlength, CTag[i], CTagCode[2], false);
			}
			else
			{
				if (!CTagReqSayText2[i])
				{
					ReplaceString(szMessage, maxlength, CTag[i], CTagCode[i], false);
				}
				if (!CProfile_SayText2)
				{
					ReplaceString(szMessage, maxlength, CTag[i], CTagCode[2], false);
				}
				if (iRandomPlayer == -1)
				{
					iRandomPlayer = CFindRandomPlayerByTeam(CProfile_TeamIndex[i]);
					if (iRandomPlayer == -2)
					{
						ReplaceString(szMessage, maxlength, CTag[i], CTagCode[2], false);
					}
					else
					{
						ReplaceString(szMessage, maxlength, CTag[i], CTagCode[i], false);
					}
				}
				ThrowError("Using two team colors in one message is not allowed");
			}
		}
		i++;
	}
	return iRandomPlayer;
}

CFindRandomPlayerByTeam(color_team)
{
	if (color_team)
	{
		new i = 1;
		while (i <= MaxClients)
		{
			new var1;
			if (IsClientInGame(i) && color_team == GetClientTeam(i))
			{
				return i;
			}
			i++;
		}
		return -2;
	}
	return 0;
}

CSayText2(client, author, String:szMessage[])
{
	new Handle:hBuffer = StartMessageOne("SayText2", client, 132);
	new var1;
	if (GetFeatureStatus(FeatureType:0, "GetUserMessageType") && GetUserMessageType() == 1)
	{
		PbSetInt(hBuffer, "ent_idx", author, -1);
		PbSetBool(hBuffer, "chat", true, -1);
		PbSetString(hBuffer, "msg_name", szMessage, -1);
		PbAddString(hBuffer, "params", "");
		PbAddString(hBuffer, "params", "");
		PbAddString(hBuffer, "params", "");
		PbAddString(hBuffer, "params", "");
	}
	else
	{
		BfWriteByte(hBuffer, author);
		BfWriteByte(hBuffer, 1);
		BfWriteString(hBuffer, szMessage);
	}
	EndMessage();
	return 0;
}

CSetupProfile()
{
	decl String:szGameName[32];
	GetGameFolderName(szGameName, 30);
	if (StrEqual(szGameName, "cstrike", false))
	{
		CProfile_Colors[3] = 1;
		CProfile_Colors[4] = 1;
		CProfile_Colors[5] = 1;
		CProfile_Colors[6] = 1;
		CProfile_TeamIndex[3] = 0;
		CProfile_TeamIndex[4] = 2;
		CProfile_TeamIndex[5] = 3;
		CProfile_SayText2 = true;
	}
	else
	{
		if (StrEqual(szGameName, "csgo", false))
		{
			CProfile_Colors[4] = 1;
			CProfile_Colors[5] = 1;
			CProfile_Colors[6] = 1;
			CProfile_Colors[1] = 1;
			CProfile_Colors[7] = 1;
			CProfile_Colors[8] = 1;
			CProfile_Colors[9] = 1;
			CProfile_Colors[10] = 1;
			CProfile_Colors[11] = 1;
			CProfile_TeamIndex[4] = 2;
			CProfile_TeamIndex[5] = 3;
			CProfile_SayText2 = true;
		}
		if (StrEqual(szGameName, "tf", false))
		{
			CProfile_Colors[3] = 1;
			CProfile_Colors[4] = 1;
			CProfile_Colors[5] = 1;
			CProfile_Colors[6] = 1;
			CProfile_TeamIndex[3] = 0;
			CProfile_TeamIndex[4] = 2;
			CProfile_TeamIndex[5] = 3;
			CProfile_SayText2 = true;
		}
		new var1;
		if (StrEqual(szGameName, "left4dead", false) || StrEqual(szGameName, "left4dead2", false))
		{
			CProfile_Colors[3] = 1;
			CProfile_Colors[4] = 1;
			CProfile_Colors[5] = 1;
			CProfile_Colors[6] = 1;
			CProfile_TeamIndex[3] = 0;
			CProfile_TeamIndex[4] = 3;
			CProfile_TeamIndex[5] = 2;
			CProfile_SayText2 = true;
		}
		if (StrEqual(szGameName, "hl2mp", false))
		{
			if (GetConVarBool(FindConVar("mp_teamplay")))
			{
				CProfile_Colors[4] = 1;
				CProfile_Colors[5] = 1;
				CProfile_Colors[6] = 1;
				CProfile_TeamIndex[4] = 3;
				CProfile_TeamIndex[5] = 2;
				CProfile_SayText2 = true;
			}
			else
			{
				CProfile_SayText2 = false;
				CProfile_Colors[6] = 1;
			}
		}
		if (StrEqual(szGameName, "dod", false))
		{
			CProfile_Colors[6] = 1;
			CProfile_SayText2 = false;
		}
		if (GetUserMessageId("SayText2") == -1)
		{
			CProfile_SayText2 = false;
		}
		CProfile_Colors[4] = 1;
		CProfile_Colors[5] = 1;
		CProfile_TeamIndex[4] = 2;
		CProfile_TeamIndex[5] = 3;
		CProfile_SayText2 = true;
	}
	return 0;
}

public Action:CEvent_MapStart(Handle:event, String:name[], bool:dontBroadcast)
{
	CSetupProfile();
	new i = 1;
	while (i <= MaxClients)
	{
		CSkipList[i] = 0;
		i++;
	}
	return Action:0;
}

public __pl_sodstats_SetNTVOptional()
{
	MarkNativeAsOptional("Stats_ReadPlayerSession");
	MarkNativeAsOptional("Stats_ReadPlayersByRank");
	MarkNativeAsOptional("Stats_ReadPlayerById");
	MarkNativeAsOptional("Stats_ReadPlayerBySteamId");
	MarkNativeAsOptional("Stats_Reset");
	return 0;
}

public Native_Stats_GetPlayerSession(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new StatsCallback:callback = GetNativeCell(2);
	new any:data = GetNativeCell(3);
	new stats[7];
	stats[1] = g_session_kills[client];
	stats[2] = g_session_deaths[client];
	stats[3] = g_session_hits[client];
	stats[4] = g_session_shots[client];
	stats[0] = g_session_score[client];
	stats[6] = g_session_headshots[client];
	stats[5] = GetTime({0,0}) - g_time_joined[client];
	CallStatsCallback(g_safename[client], g_steamid[client], stats, callback, data, 0);
	return 0;
}

public Native_Stats_GetPlayersByRank(Handle:plugin, numParams)
{
	new rank = GetNativeCell(1);
	new count = GetNativeCell(2);
	new StatsCallback:callback = GetNativeCell(3);
	new any:data = GetNativeCell(4);
	new Handle:pack = CreateDataPack();
	WritePackCell(pack, callback);
	WritePackCell(pack, data);
	new String:query[192];
	Format(query, 192, g_sql_top, count, rank + -1);
	SQL_TQuery(stats_db, SQL_TopCallback, query, pack, DBPriority:1);
	return 0;
}

public SQL_TopCallback(Handle:owner, Handle:hndl, String:error[], any:data)
{
	new Handle:pack = data;
	ResetPack(pack, false);
	new StatsCallback:callback = ReadPackCell(pack);
	new any:args = ReadPackCell(pack);
	CloseHandle(pack);
	decl String:name[32];
	decl String:steamid[128];
	new stats[7];
	new index;
	if (SQL_HasResultSet(hndl))
	{
		while (SQL_FetchRow(hndl))
		{
			index++;
			SQL_FetchString(hndl, 0, name, 32, 0);
			SQL_FetchString(hndl, 1, steamid, 128, 0);
			stats[0] = SQL_FetchInt(hndl, 2, 0);
			stats[1] = SQL_FetchInt(hndl, 3, 0);
			stats[2] = SQL_FetchInt(hndl, 4, 0);
			stats[4] = SQL_FetchInt(hndl, 5, 0);
			stats[3] = SQL_FetchInt(hndl, 6, 0);
			stats[5] = SQL_FetchInt(hndl, 7, 0);
			stats[6] = SQL_FetchInt(hndl, 8, 0);
			CallStatsCallback(name, steamid, stats, callback, args, index);
		}
	}
	CallStatsCallback("", "", stats, callback, args, 0);
	return 0;
}

public Native_Stats_GetPlayerById(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new StatsCallback:callback = GetNativeCell(2);
	new any:data = GetNativeCell(3);
	new stats[7];
	stats[1] = g_kills[client];
	stats[2] = g_deaths[client];
	stats[3] = g_hits[client];
	stats[4] = g_shots[client];
	stats[0] = g_score[client];
	stats[5] = g_time_played[client][GetTime({0,0}) - g_time_joined[client]];
	stats[6] = g_headshots[client];
	CallStatsCallback(g_safename[client], g_steamid[client], stats, callback, data, 0);
	return 0;
}

public Native_Stats_GetPlayerBySteamId(Handle:plugin, numParams)
{
	decl String:steamid[128];
	GetNativeString(1, steamid, 128, 0);
	new StatsCallback:callback = GetNativeCell(2);
	new any:data = GetNativeCell(3);
	GetPlayerBySteamId(steamid, callback, data);
	return 0;
}

public SQL_LoadPlayerCallback(Handle:owner, Handle:hndl, String:error[], any:data)
{
	new Handle:pack = data;
	ResetPack(pack, false);
	new StatsCallback:callback = ReadPackCell(pack);
	new any:args = ReadPackCell(pack);
	CloseHandle(pack);
	if (hndl)
	{
		new stats[7];
		new String:name[32];
		new String:steamid[128];
		new callback_error = 1;
		new var1;
		if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		{
			SQL_FetchString(hndl, 0, name, 32, 0);
			SQL_FetchString(hndl, 1, steamid, 128, 0);
			stats[0] = SQL_FetchInt(hndl, 2, 0);
			stats[1] = SQL_FetchInt(hndl, 3, 0);
			stats[2] = SQL_FetchInt(hndl, 4, 0);
			stats[4] = SQL_FetchInt(hndl, 5, 0);
			stats[3] = SQL_FetchInt(hndl, 6, 0);
			stats[5] = SQL_FetchInt(hndl, 7, 0);
			stats[6] = SQL_FetchInt(hndl, 8, 0);
			callback_error = 0;
		}
		CallStatsCallback(name, steamid, stats, callback, args, callback_error);
		return 0;
	}
	LogError("[SoD-Stats] SQL_LoadPlayerCallback failure: %s", error);
	return 0;
}

public Native_Stats_GetPlayerRank(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new StatsCallback:callback = GetNativeCell(2);
	new any:data = GetNativeCell(3);
	new Handle:pack = CreateDataPack();
	WritePackCell(pack, callback);
	WritePackCell(pack, data);
	new String:query[192];
	Format(query, 192, g_sql_rank, g_score[client]);
	SQL_TQuery(stats_db, SQL_RankCallback, query, pack, DBPriority:1);
	return 0;
}

public SQL_RankCallback(Handle:owner, Handle:hndl, String:error[], any:data)
{
	new Handle:pack = data;
	ResetPack(pack, false);
	new StatsCallback:callback = ReadPackCell(pack);
	new any:args = ReadPackCell(pack);
	CloseHandle(pack);
	if (hndl)
	{
		new rank = SQL_GetRowCount(hndl);
		new current_score;
		new next_score;
		new var1;
		if (SQL_HasResultSet(hndl) && SQL_FetchRow(hndl))
		{
			current_score = SQL_FetchInt(hndl, 0, 0);
			if (SQL_FetchRow(hndl))
			{
				next_score = SQL_FetchInt(hndl, 0, 0);
				CallRankCallback(rank, next_score - current_score, callback, args, 0);
				return 0;
			}
		}
		CallRankCallback(rank, 0, callback, args, 0);
		return 0;
	}
	LogError("[SoD-Stats] SQL_LoadPlayerCallback failure: %s", error);
	CallRankCallback(0, 0, callback, args, 1);
	return 0;
}

public Native_Stats_GetPlayerCount(Handle:plugin, numParams)
{
	return g_player_count;
}

public Native_Stats_Reset(Handle:plugin, numParams)
{
	ResetStats();
	return 0;
}

ResetStats()
{
	if (stats_db)
	{
		SQL_LockDatabase(stats_db);
		SQL_FastQuery(stats_db, g_sql_droptable_players, -1);
		switch (g_dbtype)
		{
			case 1:
			{
				SQL_FastQuery(stats_db, g_mysql_createtable_players, -1);
			}
			case 2:
			{
				SQL_FastQuery(stats_db, g_sqlite_createtable_players, -1);
			}
			default:
			{
			}
		}
		g_player_count = 0;
		SQL_UnlockDatabase(stats_db);
		new max_clients = 66;
		new i = 1;
		while (i < max_clients)
		{
			if (g_initialized[i])
			{
				g_kills[i] = 0;
				g_deaths[i] = 0;
				g_shots[i] = 0;
				g_hits[i] = 0;
				g_score[i] = 0;
				g_time_played[i] = 0;
				g_headshots[i] = 0;
				g_session_score[i] = 0;
				g_session_kills[i] = 0;
				g_session_deaths[i] = 0;
				g_session_hits[i] = 0;
				g_session_shots[i] = 0;
				g_session_headshots[i] = 0;
				g_time_joined[i] = GetTime({0,0});
				CreatePlayer(i, g_steamid[i]);
			}
			i++;
		}
		return 0;
	}
	LogError("[SoD-Stats] Error: Invalid database handle");
	return 0;
}

CallStatsCallback(String:name[], String:steamid[], stats[], StatsCallback:callback, any:data, retval)
{
	Call_StartFunction(Handle:0, callback);
	Call_PushString(name);
	Call_PushString(steamid);
	Call_PushArray(stats, 7);
	Call_PushCell(data);
	Call_PushCell(retval);
	Call_Finish(0);
	return 0;
}

CallRankCallback(rank, delta, StatsCallback:callback, any:data, error)
{
	Call_StartFunction(Handle:0, callback);
	Call_PushCell(rank);
	Call_PushCell(delta);
	Call_PushCell(data);
	Call_PushCell(error);
	Call_Finish(0);
	return 0;
}

GetPlayerBySteamId(String:steamid[], StatsCallback:callback, any:data)
{
	new String:query[192];
	new Handle:pack = CreateDataPack();
	WritePackCell(pack, callback);
	WritePackCell(pack, data);
	Format(query, 192, g_sql_loadplayer, steamid);
	SQL_TQuery(stats_db, SQL_LoadPlayerCallback, query, pack, DBPriority:1);
	return 0;
}

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	CreateNative("Stats_GetPlayerCount", Native_Stats_GetPlayerCount);
	CreateNative("Stats_GetPlayerSession", Native_Stats_GetPlayerSession);
	CreateNative("Stats_GetPlayersByRank", Native_Stats_GetPlayersByRank);
	CreateNative("Stats_GetPlayerById", Native_Stats_GetPlayerById);
	CreateNative("Stats_GetPlayerBySteamId", Native_Stats_GetPlayerBySteamId);
	CreateNative("Stats_GetPlayerRank", Native_Stats_GetPlayerRank);
	CreateNative("Stats_Reset", Native_Stats_Reset);
	return APLRes:0;
}

HookEventsCSS()
{
	HookEvent("player_death", Event_CSS_PlayerDeath, EventHookMode:1);
	HookEvent("player_hurt", Event_CSS_PlayerHurt, EventHookMode:1);
	HookEvent("weapon_fire", Event_CSS_WeaponFire, EventHookMode:1);
	return 0;
}

public Event_CSS_PlayerDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new headshot = GetEventBool(event, "headshot", false);
	new var1;
	if (g_initialized[attacker] && g_initialized[userid] && IsClientInGame(attacker) && IsClientInGame(userid))
	{
		new user_team = GetClientTeam(userid);
		new attacker_team = GetClientTeam(attacker);
		if (attacker == userid)
		{
			g_deaths[userid]++;
			g_session_deaths[userid]++;
		}
		else
		{
			if (attacker_team != user_team)
			{
				g_kills[attacker]++;
				g_deaths[userid]++;
				g_session_kills[attacker]++;
				g_session_deaths[userid]++;
				new score_dif = g_score[userid] - g_score[attacker];
				if (0 > score_dif)
				{
					score_dif = 2;
				}
				else
				{
					score_dif = g_score[userid] - g_score[attacker] / 100 + 2;
				}
				new var2 = g_score[attacker];
				var2 = var2[score_dif + 1];
				new var3 = g_session_score[attacker];
				var3 = var3[score_dif + 1];
				g_score[userid] -= score_dif;
				g_session_score[userid] -= score_dif;
				if (headshot)
				{
					g_headshots[attacker]++;
					g_session_headshots[attacker]++;
					g_score[attacker] += 1;
					g_session_score[attacker] += 1;
				}
				SavePlayer(attacker);
				SavePlayer(userid);
			}
		}
	}
	return 0;
}

public Event_CSS_PlayerHurt(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new var1;
	if (g_initialized[userid] && g_initialized[attacker])
	{
		new user_team = GetClientTeam(userid);
		new attacker_team = GetClientTeam(attacker);
		if (attacker_team != user_team)
		{
			g_hits[attacker]++;
			g_session_hits[attacker]++;
		}
	}
	return 0;
}

public Event_CSS_WeaponFire(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetClientOfUserId(GetEventInt(event, "userid", 0));
	g_shots[userid]++;
	g_session_shots[userid]++;
	return 0;
}

HookEventsTF2()
{
	HookEvent("player_death", Event_TF2_PlayerDeath, EventHookMode:1);
	return 0;
}

public Event_TF2_PlayerDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new var1;
	if (g_initialized[attacker] && g_initialized[userid] && IsClientInGame(attacker) && IsClientInGame(userid))
	{
		new user_team = GetClientTeam(userid);
		new attacker_team = GetClientTeam(attacker);
		if (attacker == userid)
		{
			g_deaths[userid]++;
			g_session_deaths[userid]++;
		}
		else
		{
			if (attacker_team != user_team)
			{
				g_kills[attacker]++;
				g_deaths[userid]++;
				g_session_kills[attacker]++;
				g_session_deaths[userid]++;
				new score_dif = g_score[userid] - g_score[attacker];
				if (0 > score_dif)
				{
					score_dif = 2;
				}
				else
				{
					score_dif = g_score[userid] - g_score[attacker] / 100 + 2;
				}
				new var2 = g_score[attacker];
				var2 = var2[score_dif + 1];
				new var3 = g_session_score[attacker];
				var3 = var3[score_dif + 1];
				g_score[userid] -= score_dif;
				g_session_score[userid] -= score_dif;
				SavePlayer(attacker);
				SavePlayer(userid);
			}
		}
	}
	return 0;
}

HookEventsDOD()
{
	HookEvent("player_hurt", Event_DOD_PlayerHurt, EventHookMode:1);
	HookEvent("dod_stats_weapon_attack", Event_DOD_WeaponFire, EventHookMode:1);
	return 0;
}

public Event_DOD_PlayerHurt(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new health = GetEventInt(event, "health", 0);
	decl headshot;
	new var1;
	headshot = health && GetEventInt(event, "hitgroup", 0) == 1;
	new var2;
	if (g_initialized[attacker] && g_initialized[userid] && IsClientInGame(attacker) && IsClientInGame(userid))
	{
		new user_team = GetClientTeam(userid);
		new attacker_team = GetClientTeam(attacker);
		new var3;
		if (attacker == userid && health)
		{
			g_deaths[userid]++;
			g_session_deaths[userid]++;
		}
		if (attacker_team != user_team)
		{
			g_hits[attacker]++;
			g_session_hits[attacker]++;
			if (!health)
			{
				g_kills[attacker]++;
				g_deaths[userid]++;
				g_session_kills[attacker]++;
				g_session_deaths[userid]++;
				new score_dif = g_score[userid] - g_score[attacker];
				if (0 > score_dif)
				{
					score_dif = 2;
				}
				else
				{
					score_dif = g_score[userid] - g_score[attacker] / 100 + 2;
				}
				new var4 = g_score[attacker];
				var4 = var4[score_dif + 1];
				new var5 = g_session_score[attacker];
				var5 = var5[score_dif + 1];
				g_score[userid] -= score_dif;
				g_session_score[userid] -= score_dif;
				if (headshot)
				{
					g_headshots[attacker]++;
					g_session_headshots[attacker]++;
					g_score[attacker] += 1;
					g_session_score[attacker] += 1;
				}
				SavePlayer(attacker);
				SavePlayer(userid);
			}
		}
	}
	return 0;
}

public Event_DOD_WeaponFire(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	g_shots[userid]++;
	g_session_shots[userid]++;
	return 0;
}

HookEventsEmpires()
{
	HookEvent("player_death", Event_Empires_PlayerDeath, EventHookMode:1);
	return 0;
}

public Event_Empires_PlayerDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new var1;
	if (g_initialized[attacker] && g_initialized[userid] && IsClientInGame(attacker) && IsClientInGame(userid))
	{
		new user_team = GetClientTeam(userid);
		new attacker_team = GetClientTeam(attacker);
		if (attacker == userid)
		{
			g_deaths[userid]++;
			g_session_deaths[userid]++;
		}
		else
		{
			if (attacker_team != user_team)
			{
				g_kills[attacker]++;
				g_deaths[userid]++;
				g_session_kills[attacker]++;
				g_session_deaths[userid]++;
				new score_dif = g_score[userid] - g_score[attacker];
				if (0 > score_dif)
				{
					score_dif = 2;
				}
				else
				{
					score_dif = g_score[userid] - g_score[attacker] / 100 + 2;
				}
				new var2 = g_score[attacker];
				var2 = var2[score_dif + 1];
				new var3 = g_session_score[attacker];
				var3 = var3[score_dif + 1];
				g_score[userid] -= score_dif;
				g_session_score[userid] -= score_dif;
				SavePlayer(attacker);
				SavePlayer(userid);
			}
		}
	}
	return 0;
}

HookEventsDefault()
{
	HookEvent("player_death", Event_PlayerDeath, EventHookMode:1);
	return 0;
}

public Event_PlayerDeath(Handle:event, String:name[], bool:dontBroadcast)
{
	new userid = GetClientOfUserId(GetEventInt(event, "userid", 0));
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker", 0));
	new var1;
	if (g_initialized[attacker] && g_initialized[userid] && IsClientInGame(attacker) && IsClientInGame(userid))
	{
		new user_team = GetClientTeam(userid);
		new attacker_team = GetClientTeam(attacker);
		if (attacker == userid)
		{
			g_deaths[userid]++;
			g_session_deaths[userid]++;
		}
		else
		{
			if (attacker_team != user_team)
			{
				g_kills[attacker]++;
				g_deaths[userid]++;
				g_session_kills[attacker]++;
				g_session_deaths[userid]++;
				new score_dif = g_score[userid] - g_score[attacker];
				if (0 > score_dif)
				{
					score_dif = 2;
				}
				else
				{
					score_dif = g_score[userid] - g_score[attacker] / 100 + 2;
				}
				new var2 = g_score[attacker];
				var2 = var2[score_dif + 1];
				new var3 = g_session_score[attacker];
				var3 = var3[score_dif + 1];
				g_score[userid] -= score_dif;
				g_session_score[userid] -= score_dif;
				SavePlayer(attacker);
				SavePlayer(userid);
			}
		}
	}
	return 0;
}

RankYazdir(client)
{
	Stats_GetPlayerRank(client, StatsCallback:65, client);
	return 0;
}

public Rank_Callback(rank, delta, any:data, error)
{
	new client = data;
	new Handle:pack = CreateDataPack();
	WritePackCell(pack, rank);
	WritePackCell(pack, delta);
	WritePackCell(pack, client);
	Stats_GetPlayerById(client, StatsCallback:67, pack);
	return 0;
}

public Rank_PlayerIdCallback(String:name[], String:steamid[], any:stats[], any:data, error)
{
	if (error == 1)
	{
		LogError("[DrK # GaminG] RankCallback: Player not found");
		return 0;
	}
	new Handle:pack = data;
	ResetPack(pack, false);
	new rank = ReadPackCell(pack);
	new delta = ReadPackCell(pack);
	new client = ReadPackCell(pack);
	new var2;
	decl String:text[256];
	new bool:isAlive = IsPlayerAlive(client);
	new var1;
	if (stats[2])
	{
		var1 = float(stats[2]);
	}
	else
	{
		var1 = 1.0;
	}
	Format(text, 256, " \x02[DrK # GaminG] \x04%s\x01'ýn sýralamasý %i/%i\x01, puaný \x04%i\x01 (Sýradaki kiþiyi geçmek için %i puan gerekiyor), \x04%i\x01 Leþ ve \x04%i\x01 ölüm,  %.2f KD", name, rank, g_player_count, stats[0] + g_start_points, delta, stats[1], stats[2], float(stats[1]) / var1);
	PrintToChat(client, "%s", text);
	if (iRank[client] == 1)
	{
		Format(var2, 256, " Sýradaki rütbe için \x02%d puan gerekiyor.", 1010 - stats[0] + g_start_points);
		PrintToChat(client, "%s", var2);
		Format(var2, 256, " Sýradaki rütbe:\x04 Silver 2");
		PrintToChat(client, "%s", var2);
	}
	else
	{
		if (iRank[client] == 2)
		{
			Format(var2, 256, " Sýradaki rütbe için \x02%d puan gerekiyor.", 1025 - stats[0] + g_start_points);
			PrintToChat(client, "%s", var2);
			Format(var2, 256, " Sýradaki rütbe:\x04 Silver 3");
			PrintToChat(client, "%s", var2);
		}
		if (iRank[client] == 3)
		{
			Format(var2, 256, " Sýradaki rütbe için \x02%d puan gerekiyor.", 1045 - stats[0] + g_start_points);
			PrintToChat(client, "%s", var2);
			Format(var2, 256, " Sýradaki rütbe:\x04 Silver 4");
			PrintToChat(client, "%s", var2);
		}
		if (iRank[client] == 4)
		{
			Format(var2, 256, " Sýradaki rütbe için \x02%d puan gerekiyor.", 1065 - stats[0] + g_start_points);
			PrintToChat(client, "%s", var2);
			Format(var2, 256, " Sýradaki rütbe:\x04 Silver 5");
			PrintToChat(client, "%s", var2);
		}
		if (iRank[client] == 5)
		{
			Format(var2, 256, " Sýradaki rütbe için \x02%d puan gerekiyor.", 1085 - stats[0] + g_start_points);
			PrintToChat(client, "%s", var2);
			Format(var2, 256, " Sýradaki rütbe:\x04 Silver 6");
			PrintToChat(client, "%s", var2);
		}
		if (iRank[client] == 6)
		{
			Format(var2, 256, " Sýradaki rütbe için \x02%d puan gerekiyor.", 1110 - stats[0] + g_start_points);
			PrintToChat(client, "%s", var2);
			Format(var2, 256, " Sýradaki rütbe:\x04 Nova 1");
			PrintToChat(client, "%s", var2);
		}
		if (iRank[client] == 7)
		{
			Format(var2, 256, " Sýradaki rütbe için \x02%d puan gerekiyor.", 1135 - stats[0] + g_start_points);
			PrintToChat(client, "%s", var2);
			Format(var2, 256, " Sýradaki rütbe:\x04 Nova 2");
			PrintToChat(client, "%s", var2);
		}
		if (iRank[client] == 8)
		{
			Format(var2, 256, " Sýradaki rütbe için \x02%d puan gerekiyor.", 1160 - stats[0] + g_start_points);
			PrintToChat(client, "%s", var2);
			Format(var2, 256, " Sýradaki rütbe:\x04 Nova 3");
			PrintToChat(client, "%s", var2);
		}
		if (iRank[client] == 9)
		{
			Format(var2, 256, " Sýradaki rütbe için \x02%d puan gerekiyor.", 1190 - stats[0] + g_start_points);
			PrintToChat(client, "%s", var2);
			Format(var2, 256, " Sýradaki rütbe:\x04 Nova 4");
			PrintToChat(client, "%s", var2);
		}
		if (iRank[client] == 10)
		{
			Format(var2, 256, " Sýradaki rütbe için \x02%d puan gerekiyor.", 1220 - stats[0] + g_start_points);
			PrintToChat(client, "%s", var2);
			Format(var2, 256, " Sýradaki rütbe:\x04 MG1 (Keleþ 1)");
			PrintToChat(client, "%s", var2);
		}
		if (iRank[client] == 11)
		{
			Format(var2, 256, " Sýradaki rütbe için \x02%d puan gerekiyor.", 1250 - stats[0] + g_start_points);
			PrintToChat(client, "%s", var2);
			Format(var2, 256, " Sýradaki rütbe:\x04 MG2 (Keleþ 2)");
			PrintToChat(client, "%s", var2);
		}
		if (iRank[client] == 12)
		{
			Format(var2, 256, " Sýradaki rütbe için \x02%d puan gerekiyor.", 1300 - stats[0] + g_start_points);
			PrintToChat(client, "%s", var2);
			Format(var2, 256, " Sýradaki rütbe:\x04 MGE (Çift Keleþ)");
			PrintToChat(client, "%s", var2);
		}
		if (iRank[client] == 13)
		{
			Format(var2, 256, " Sýradaki rütbe için \x02%d puan gerekiyor.", 1350 - stats[0] + g_start_points);
			PrintToChat(client, "%s", var2);
			Format(var2, 256, " Sýradaki rütbe:\x04 DMG (Güzide)");
			PrintToChat(client, "%s", var2);
		}
		if (iRank[client] == 14)
		{
			Format(var2, 256, " Sýradaki rütbe için \x02%d puan gerekiyor.", 1425 - stats[0] + g_start_points);
			PrintToChat(client, "%s", var2);
			Format(var2, 256, " Sýradaki rütbe:\x04 LE (Kartal)");
			PrintToChat(client, "%s", var2);
		}
		if (iRank[client] == 15)
		{
			Format(var2, 256, " Sýradaki rütbe için \x02%d puan gerekiyor.", 1500 - stats[0] + g_start_points);
			PrintToChat(client, "%s", var2);
			Format(var2, 256, " Sýradaki rütbe:\x04 LEM (Usta Kartal)");
			PrintToChat(client, "%s", var2);
		}
		if (iRank[client] == 16)
		{
			Format(var2, 256, " Sýradaki rütbe için \x02%d puan gerekiyor.", 1600 - stats[0] + g_start_points);
			PrintToChat(client, "%s", var2);
			Format(var2, 256, " Sýradaki rütbe:\x04 Supreme");
			PrintToChat(client, "%s", var2);
		}
		if (iRank[client] == 17)
		{
			Format(var2, 256, " Sýradaki rütbe için \x02%d puan gerekiyor.", 1750 - stats[0] + g_start_points);
			PrintToChat(client, "%s", var2);
			Format(var2, 256, " Sýradaki rütbe:\x04 Global Elite");
			PrintToChat(client, "%s", var2);
		}
		if (iRank[client] == 18)
		{
			Format(var2, 256, " \x04En üst rütbedesiniz.");
			PrintToChat(client, "%s", var2);
		}
	}
	return 0;
}

public SayText2(to, from, String:message[])
{
	new Handle:hMsg = StartMessageOne("SayText2", to, 0);
	if (GetUserMessageType() == 1)
	{
		PbSetInt(hMsg, "ent_idx", from, -1);
		PbSetBool(hMsg, "chat", true, -1);
		PbSetString(hMsg, "msg_name", message, -1);
		PbAddString(hMsg, "params", "");
		PbAddString(hMsg, "params", "");
		PbAddString(hMsg, "params", "");
		PbAddString(hMsg, "params", "");
	}
	else
	{
		BfWriteByte(hMsg, from);
		BfWriteByte(hMsg, 1);
		BfWriteString(hMsg, message);
	}
	EndMessage();
	return 0;
}

PrintSession(client)
{
	Stats_GetPlayerSession(client, StatsCallback:83, client);
	return 0;
}

public SessionCallback(String:name[], String:steamid[], any:stats[], any:data, error)
{
	if (error == 1)
	{
		LogError("[DrK # GaminG] SessionCallback: Player not found");
		return 0;
	}
	new client = data;
	decl String:text[256];
	new Handle:panel = CreatePanel(Handle:0);
	DrawPanelText(panel, "[DrK # GaminG] Player Session Stats");
	DrawPanelItem(panel, "Name", 0);
	Format(text, 256, "%s", name);
	DrawPanelText(panel, text);
	DrawPanelItem(panel, "Score", 0);
	new var1;
	if (stats[0] < any:0)
	{
		var1[0] = 24092;
	}
	else
	{
		var1[0] = 24096;
	}
	Format(text, 256, "%s%i", var1, stats);
	DrawPanelText(panel, text);
	DrawPanelItem(panel, "Time played", 0);
	Format(text, 256, "%id %ih %im", stats[5] / 86400, stats[5] % 86400 / 3600, stats[5] % 3600 / 60);
	DrawPanelText(panel, text);
	DrawPanelItem(panel, "Kills/Deaths", 0);
	new var2;
	if (stats[2] > any:0)
	{
		var2 = float(stats[2]);
	}
	else
	{
		var2 = 1.0;
	}
	Format(text, 256, "%i/%i - %.2f KD", stats[1], stats[2], float(stats[1]) / var2);
	DrawPanelText(panel, text);
	new var3;
	if (stats[6] > any:0 && stats[1])
	{
		DrawPanelItem(panel, "Headshots", 0);
		Format(text, 256, "%i (%i%%)", stats[6], stats[6] * 100 / stats[1]);
		DrawPanelText(panel, text);
	}
	if (any:0 < stats[4])
	{
		DrawPanelItem(panel, "Hits/Shots", 0);
		Format(text, 256, "%i/%i - %.2f%%", stats[3], stats[4], float(stats[3]) * 100.0 / float(stats[4]));
		DrawPanelText(panel, text);
	}
	SendPanelToClient(panel, client, SessionHandler, 10);
	CloseHandle(panel);
	return 0;
}

public SessionHandler(Handle:menu, MenuAction:action, param1, param2)
{
	return 0;
}

PrintStats(client)
{
	Stats_GetPlayerById(client, StatsCallback:89, client);
	return 0;
}

public StatsMeCallback(String:name[], String:steamid[], any:stats[], any:data, error)
{
	if (error == 1)
	{
		LogError("[DrK # GaminG] StatsMeCallback: Player not found");
		return 0;
	}
	new client = data;
	decl String:text[256];
	new Handle:panel = CreatePanel(Handle:0);
	DrawPanelText(panel, "[DrK # GaminG] Player Stats");
	DrawPanelItem(panel, "Name", 0);
	Format(text, 256, "%s", name);
	DrawPanelText(panel, text);
	DrawPanelItem(panel, "Score", 0);
	Format(text, 256, "%i", stats[0] + g_start_points);
	DrawPanelText(panel, text);
	DrawPanelItem(panel, "Time played", 0);
	Format(text, 256, "%id %ih %im", stats[5] / 86400, stats[5] % 86400 / 3600, stats[5] % 3600 / 60);
	DrawPanelText(panel, text);
	DrawPanelItem(panel, "Kills/Deaths", 0);
	new var1;
	if (float(stats[2]) > 0)
	{
		var1 = float(stats[2]);
	}
	else
	{
		var1 = 1.0;
	}
	Format(text, 256, "%i/%i - %.2f KD", stats[1], stats[2], float(stats[1]) / var1);
	DrawPanelText(panel, text);
	if (any:0 < stats[6])
	{
		DrawPanelItem(panel, "Headshots", 0);
		Format(text, 256, "%i (%i%%)", stats[6], stats[6] * 100 / stats[1]);
		DrawPanelText(panel, text);
	}
	if (any:0 < stats[4])
	{
		DrawPanelItem(panel, "Hits/Shots", 0);
		Format(text, 256, "%i/%i - %.2f%%", stats[3], stats[4], float(stats[3]) * 100.0 / float(stats[4]));
		DrawPanelText(panel, text);
	}
	SendPanelToClient(panel, client, StatsMeHandler, 10);
	CloseHandle(panel);
	return 0;
}

public StatsMeHandler(Handle:menu, MenuAction:action, param1, param2)
{
	return 0;
}

PrintTop(client, start, offset)
{
	new Handle:panel = CreatePanel(Handle:0);
	DrawPanelText(panel, "[DrK # GaminG] En iyi 10 oyuncu:");
	new Handle:pack = CreateDataPack();
	WritePackCell(pack, panel);
	WritePackCell(pack, client);
	Stats_GetPlayersByRank(start, offset, StatsCallback:93, pack);
	return 0;
}

public TopCallback(String:name[], String:steamid[], any:stats[], any:data, index)
{
	new Handle:pack = data;
	ResetPack(pack, false);
	new Handle:panel = ReadPackCell(pack);
	new client = ReadPackCell(pack);
	if (steamid[0])
	{
		decl String:text[256];
		if (index > 3)
		{
			new var1;
			if (stats[2])
			{
				var1 = float(stats[2]);
			}
			else
			{
				var1 = 1.0;
			}
			Format(text, 256, "%i. %s - %.2f KD - %i points ", index, name, float(stats[1]) / var1, stats[0] + g_start_points);
			DrawPanelText(panel, text);
		}
		else
		{
			new var2;
			if (stats[2])
			{
				var2 = float(stats[2]);
			}
			else
			{
				var2 = 1.0;
			}
			Format(text, 256, "%s - %.2f KD - %i points ", name, float(stats[1]) / var2, stats[0] + g_start_points);
			DrawPanelItem(panel, text, 0);
		}
	}
	else
	{
		CloseHandle(pack);
		SendPanelToClient(panel, client, TopHandler, 10);
		CloseHandle(panel);
	}
	return 0;
}

public TopHandler(Handle:menu, MenuAction:action, param1, param2)
{
	return 0;
}

public void:OnPluginStart()
{
	new ips[4];
	new String:serverip[32];
	new ip = GetConVarInt(FindConVar("hostip"));
	new port = GetConVarInt(FindConVar("hostport"));
	ips[0] = ip >>> 24 & 255;
	ips[1] = ip >>> 16 & 255;
	ips[2] = ip >>> 8 & 255;
	ips[3] = ip & 255;
	Format(serverip, 32, "%d.%d.%d.%d:%d", ips, ips[1], ips[2], ips[3], port);
	if (!(StrEqual(serverip, "95.173.166.55:27015", true)))
	{
		LogError("Bu plugin ImPossibLe` tarafýndan lisanslandýðý için bu serverda çalýþtýrýlmadý.");
		CPrintToChatAll(" \x04Bu plugin \x02ImPossibLe` \x04tarafýndan lisanslandýðý için bu serverda çalýþtýrýlmadý.");
		SetFailState("Plugin Copyright by ImPossibLe`");
	}
	decl String:error[256];
	stats_db = SQL_Connect("storage-local", false, error, 256);
	if (stats_db)
	{
		SQL_ReadDriver(stats_db, g_ident, 16);
		if (strcmp(g_ident, "mysql", false))
		{
			if (strcmp(g_ident, "sqlite", false))
			{
				LogError("[DrK # GaminG] Invalid DB-Type");
				return void:0;
			}
			g_dbtype = 2;
		}
		else
		{
			g_dbtype = 1;
		}
		SQL_LockDatabase(stats_db);
		new var1;
		if ((g_dbtype == 1 && !SQL_FastQuery(stats_db, g_mysql_createtable_players, -1)) || (g_dbtype == 2 && !SQL_FastQuery(stats_db, g_sqlite_createtable_players, -1)))
		{
			LogError("[DrK # GaminG] Could not create players table.");
			return void:0;
		}
		SQL_FastQuery(stats_db, g_sql_addheadshots, -1);
		SQL_FastQuery(stats_db, g_sql_addtimestamp, -1);
		g_player_count = GetPlayerCount();
		SQL_UnlockDatabase(stats_db);
		g_gameid = GetGameId();
		if (!HookEvents(g_gameid))
		{
			LogError("[DrK # GaminG] Unable to hook events.");
			return void:0;
		}
		g_henabled = CreateConVar("sm_stats_enabled", "1", "Sets whether or not to record stats", 256, true, 0.0, true, 1.0);
		g_hstartpoints = CreateConVar("sm_stats_startpoints", "1000", "Sets the starting points for a new player", 256, true, 0.0, true, 10000.0);
		HookConVarChange(g_henabled, EnabledCallback);
		HookConVarChange(g_hstartpoints, StartPointsCallback);
		g_enabled = GetConVarInt(g_henabled);
		g_start_points = GetConVarInt(g_hstartpoints);
		if (g_henabled)
		{
			RegAdminCmd("sm_drk_rank_resle", AdminCmd_ResetStats, 16384, "Top10'u sýfýrlar", "", 0);
			RegAdminCmd("sm_stats_purge", AdminCmd_Purge, 16384, "sm_stats_purge [days] - Purge players who haven't connected for [days] days.", "", 0);
			RegConsoleCmd("say", ConCmd_Say, "", 0);
			RegConsoleCmd("say_team", ConCmd_Say, "", 0);
			RegConsoleCmd("sm_rank", CommandRank, "", 0);
			RegConsoleCmd("sm_top", CommandTop, "", 0);
			RegAdminCmd("sm_brostest", BrosTest, 16384, "Broþ Testi", "", 0);
			RegPluginLibrary("sodstats");
			HookEvent("player_spawn", OnPlayerSpawn, EventHookMode:1);
			return void:0;
		}
		LogError("[DrK # GaminG] Could not create stats_enabled cvar.");
		return void:0;
	}
	LogError("[DrK # GaminG] Unable to connect to database (%s)", error);
	return void:0;
}

public Action:BrosTest(client, args)
{
	if (args != 1)
	{
		PrintToChat(client, "Hatalý Giriþ.");
		return Action:3;
	}
	decl String:sCoinSayisi[12];
	GetCmdArg(1, sCoinSayisi, 10);
	new iCoinSayisi = StringToInt(sCoinSayisi, 10);
	iCoin[client] = iCoinSayisi;
	return Action:3;
}

public Action:CommandRank(client, args)
{
	RankYazdir(client);
	return Action:0;
}

public Action:CommandTop(client, args)
{
	PrintTop(client, 1, 10);
	return Action:0;
}

public Action:OnPlayerSpawn(Handle:event, any:stats[], bool:dontBroadcast)
{
	new i = GetClientOfUserId(GetEventInt(event, "userid", 0));
	if (g_score[i][250] < 1010)
	{
		iRank[i] = 1;
	}
	else
	{
		new var1;
		if (g_score[i][250] >= 1010 && g_score[i][250] < 1025)
		{
			iRank[i] = 2;
		}
		new var2;
		if (g_score[i][250] >= 1025 && g_score[i][250] < 1045)
		{
			iRank[i] = 3;
		}
		new var3;
		if (g_score[i][250] >= 1045 && g_score[i][250] < 1065)
		{
			iRank[i] = 4;
		}
		new var4;
		if (g_score[i][250] >= 1065 && g_score[i][250] < 1085)
		{
			iRank[i] = 5;
		}
		new var5;
		if (g_score[i][250] >= 1085 && g_score[i][250] < 1110)
		{
			iRank[i] = 6;
		}
		new var6;
		if (g_score[i][250] >= 1110 && g_score[i][250] < 1135)
		{
			iRank[i] = 7;
		}
		new var7;
		if (g_score[i][250] >= 1135 && g_score[i][250] < 1160)
		{
			iRank[i] = 8;
		}
		new var8;
		if (g_score[i][250] >= 1160 && g_score[i][250] < 1190)
		{
			iRank[i] = 9;
		}
		new var9;
		if (g_score[i][250] >= 1190 && g_score[i][250] < 1220)
		{
			iRank[i] = 10;
		}
		new var10;
		if (g_score[i][250] >= 1220 && g_score[i][250] < 1250)
		{
			iRank[i] = 11;
		}
		new var11;
		if (g_score[i][250] >= 1250 && g_score[i][250] < 1300)
		{
			iRank[i] = 12;
		}
		new var12;
		if (g_score[i][250] >= 1300 && g_score[i][250] < 1350)
		{
			iRank[i] = 13;
		}
		new var13;
		if (g_score[i][250] >= 1350 && g_score[i][250] < 1425)
		{
			iRank[i] = 14;
		}
		new var14;
		if (g_score[i][250] >= 1425 && g_score[i][250] < 1500)
		{
			iRank[i] = 15;
		}
		new var15;
		if (g_score[i][250] >= 1500 && g_score[i][250] < 1600)
		{
			iRank[i] = 16;
		}
		new var16;
		if (g_score[i][250] >= 1600 && g_score[i][250] < 1750)
		{
			iRank[i] = 17;
		}
		if (g_score[i][250] >= 1750)
		{
			iRank[i] = 18;
		}
	}
	decl String:authid[32];
	GetClientAuthString(i, authid, 32, true);
	decl String:sClientName[40];
	GetClientName(i, sClientName, 40);
	if (StrEqual(authid, "STEAM_1:1:104585403", false))
	{
		iRank[i] = 18;
		if (iCoin[i])
		{
		}
		else
		{
			iCoin[i] = 6002;
		}
	}
	else
	{
		if (StrEqual(authid, "STEAM_1:1:150784409", false))
		{
			iRank[i] = 18;
			if (iCoin[i])
			{
			}
			else
			{
				iCoin[i] = 6002;
			}
		}
		if (StrEqual(authid, "STEAM_1:0:47889108", false))
		{
			iCoin[i] = 6006;
		}
		if (StrEqual(authid, "STEAM_1:1:54499769", false))
		{
			iCoin[i] = 6006;
		}
		if (IsPlayerGenericAdmin(i))
		{
			if (iCoin[i])
			{
			}
			else
			{
				iCoin[i] = 6010;
			}
		}
		if (0 < CS_GetMVPCount(i))
		{
			if (iCoin[i])
			{
			}
			else
			{
				new coinler[45] = {874,875,876,877,878,879,880,881,882,883,884,885,886,887,888,889,890,891,892,893,894,895,896,897,898,899,900,901,902,903,1001,1002,1003,1013,1014,1015,1024,1025,1026,1028,1029,1030,1316,1317,1318};
				iCoin[i] = coinler[GetRandomInt(0, 44)];
				CPrintToChatAll(" \x02[DrK # GaminG] %s EDO kazandýðý için broþ aldý.", sClientName);
			}
		}
		if (!(CS_GetMVPCount(i)))
		{
			iCoin[i] = 0;
		}
	}
	return Action:0;
}

bool:IsPlayerGenericAdmin(client)
{
	if (CheckCommandAccess(client, "generic_admin", 2, false))
	{
		return true;
	}
	return false;
}

public void:OnMapStart()
{
	new iIndex = FindEntityByClassname(MaxClients + 1, "cs_player_manager");
	if (iIndex == -1)
	{
		SetFailState("Unable to find cs_player_manager entity");
	}
	SDKHook(iIndex, SDKHookType:21, Hook_OnThinkPost);
	return void:0;
}

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)
{
	if (buttons & 65536 == 65536)
	{
		new Handle:hBuffer = StartMessageOne("ServerRankRevealAll", client, 0);
		if (hBuffer)
		{
			EndMessage();
		}
		else
		{
			PrintToChat(client, " \x04[DrK # GaminG] \x02Hatalý komut!");
		}
	}
	return Action:0;
}

public Hook_OnThinkPost(iEnt)
{
	static iRankOffset = -1;
	if (iRankOffset == -1)
	{
		iRankOffset = FindSendPropInfo("CCSPlayerResource", "m_iCompetitiveRanking", 0, 0, 0);
	}
	SetEntDataArray(iEnt, iRankOffset, iRank, 66, 4, true);
	static iCoinOffset = -1;
	if (iCoinOffset == -1)
	{
		iCoinOffset = FindSendPropInfo("CCSPlayerResource", "m_nActiveCoinRank", 0, 0, 0);
	}
	SetEntDataArray(iEnt, iCoinOffset, iCoin, 66, 4, true);
	return 0;
}

public void:OnClientDisconnect(userid)
{
	iCoin[userid] = 0;
	iRank[userid] = 0;
	if (g_initialized[userid] == true)
	{
		SavePlayer(userid);
		g_initialized[userid] = 0;
	}
	g_fSpamPrevention[userid] = 0;
	return void:0;
}

public void:OnClientAuthorized(client, String:steamid[])
{
	if (!IsFakeClient(client))
	{
		strcopy(g_steamid[client], 128, steamid);
		decl String:szName[32];
		GetClientName(client, szName, 32);
		SQL_EscapeString(stats_db, szName, g_safename[client], 32, 0);
		GetPlayerBySteamId(steamid, StatsCallback:37, client);
	}
	return void:0;
}

public EnabledCallback(Handle:convar, String:oldValue[], String:newValue[])
{
	if (strcmp(newValue, "0", true))
	{
		g_enabled = 1;
	}
	else
	{
		g_enabled = 0;
	}
	return 0;
}

public StartPointsCallback(Handle:convar, String:oldValue[], String:newValue[])
{
	g_start_points = StringToInt(newValue, 10);
	return 0;
}

public Action:ConCmd_Say(userid, args)
{
	new koruma = GetTime({0,0});
	if (GetTime({0,0}) < koruma + 3)
	{
		return Action:0;
	}
	new var1;
	if (!userid || g_enabled)
	{
		return Action:0;
	}
	new client = GetClientOfUserId(userid);
	decl String:text[192];
	if (!GetCmdArgString(text, 192))
	{
		return Action:0;
	}
	new startidx;
	if (text[strlen(text) + -1] == '"')
	{
		text[strlen(text) + -1] = MissingTAG:0;
		startidx = 1;
	}
	if (g_fSpamPrevention[userid][2.0] > GetGameTime())
	{
		return Action:0;
	}
	g_fSpamPrevention[userid] = GetGameTime();
	if (strcmp(text[startidx], "rank", false))
	{
		new var2;
		if (strcmp(text[startidx], "top", false) && strcmp(text[startidx], "top10", false))
		{
			PrintTop(client, 1, 10);
		}
		if (g_gameid != 216)
		{
			if (strcmp(text[startidx], "statsme", false))
			{
				if (!(strcmp(text[startidx], "session", false)))
				{
					PrintSession(client);
				}
			}
			PrintStats(client);
		}
		return Action:0;
	}
	RankYazdir(client);
	return Action:0;
}

public LoadPlayerCallback(String:name[], String:steamid[], any:stats[], any:data, error)
{
	new client = data;
	g_session_deaths[client] = 0;
	g_session_kills[client] = 0;
	g_session_hits[client] = 0;
	g_session_shots[client] = 0;
	g_session_score[client] = 0;
	g_session_headshots[client] = 0;
	g_time_joined[client] = GetTime({0,0});
	g_last_saved_time[client] = g_time_joined[client];
	if (error == 1)
	{
		CreatePlayer(client, g_steamid[client]);
		return 0;
	}
	strcopy(g_safename[client], 32, name);
	g_kills[client] = stats[1];
	g_deaths[client] = stats[2];
	g_shots[client] = stats[4];
	g_hits[client] = stats[3];
	g_score[client] = stats[0];
	g_time_played[client] = stats[5];
	g_headshots[client] = stats[6];
	g_initialized[client] = 1;
	return 0;
}

public Action:AdminCmd_ResetStats(client, args)
{
	ResetStats();
	decl String:mapName[64];
	GetCurrentMap(mapName, 64);
	ServerCommand("changelevel %s", mapName);
	return Action:3;
}

public Action:AdminCmd_Purge(client, args)
{
	new argCount = GetCmdArgs();
	if (argCount != 1)
	{
		PrintToConsole(client, "SoD-Stats: Invalid number of arguments for command 'sm_stats_purge'");
		return Action:3;
	}
	decl String:svDays[192];
	if (!GetCmdArg(1, svDays, 192))
	{
		PrintToConsole(client, "SoD-Stats: Invalid arguments for sm_stats_purge.");
		return Action:3;
	}
	new days = StringToInt(svDays, 10);
	if (0 >= days)
	{
		PrintToConsole(client, "SoD-Stats: Invalid number of days.");
		return Action:3;
	}
	decl String:query[128];
	switch (g_dbtype)
	{
		case 1:
		{
			Format(query, 128, "DELETE FROM players WHERE last_connect < current_timestamp - interval %i day;", days);
		}
		case 2:
		{
			Format(query, 128, "DELETE FROM players WHERE last_connect < datetime('now', '-%i days');", days);
		}
		default:
		{
		}
	}
	SQL_TQuery(stats_db, SQL_PurgeCallback, query, client, DBPriority:1);
	return Action:3;
}

public SQL_PurgeCallback(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (hndl)
	{
		PrintToConsole(data, "SoD-Stats: Purge successful");
	}
	else
	{
		LogError("SQL_PurgeCallback: Invalid query (%s).", error);
	}
	return 0;
}

GetPlayerCount()
{
	new Handle:hquery = SQL_Query(stats_db, g_sql_playercount, -1);
	if (hquery)
	{
		new rows = SQL_GetRowCount(hquery);
		CloseHandle(hquery);
		return rows;
	}
	LogError("[SoD-Stats] Error getting player count.");
	return 0;
}

GetGameId()
{
	new String:fldr[64];
	GetGameFolderName(fldr, 64);
	if (strcmp(fldr, "tf", true))
	{
		new var1;
		if (StrEqual(fldr, "cstrike", true) || StrEqual(fldr, "csgo", true))
		{
			return 240;
		}
		if (strcmp(fldr, "dod", true))
		{
			if (strcmp(fldr, "FortressForever", true))
			{
				if (strcmp(fldr, "empires", true))
				{
					return 1337;
				}
				return 216;
			}
			return 215;
		}
		return 300;
	}
	return 440;
}

bool:HookEvents(gameid)
{
	switch (gameid)
	{
		case 215:
		{
			HookEventsTF2();
		}
		case 216:
		{
			HookEventsEmpires();
		}
		case 240:
		{
			HookEventsCSS();
		}
		case 300:
		{
			HookEventsDOD();
		}
		case 440:
		{
			HookEventsTF2();
		}
		case 1337:
		{
			HookEventsDefault();
		}
		default:
		{
			LogError("[DrK # GaminG] Invalid gameid (%i).", g_gameid);
			return false;
		}
	}
	return true;
}

SavePlayer(userid)
{
	new var1;
	if (stats_db && g_enabled)
	{
		return 0;
	}
	new String:name[32];
	new String:safe_name[68];
	GetClientName(userid, name, 32);
	SQL_EscapeString(stats_db, name, safe_name, 65, 0);
	safe_name[0] = GetTime({0,0});
	Format(safe_name, 512, g_sql_saveplayer, g_score[userid], g_kills[userid], g_deaths[userid], g_shots[userid], g_hits[userid], safe_name, safe_name[0] - g_last_saved_time[userid], g_headshots[userid], g_steamid[userid]);
	g_last_saved_time[userid] = safe_name[0];
	SQL_TQuery(stats_db, SQL_SavePlayerCallback, safe_name, any:0, DBPriority:1);
	return 0;
}

public SQL_SavePlayerCallback(Handle:owner, Handle:hndl, String:error[], any:data)
{
	if (!hndl)
	{
		LogError("[DrK # GaminG] Error saving player (%s)", error);
	}
	return 0;
}

CreatePlayer(userid, String:steamid[])
{
	decl String:query[256];
	new String:name[32];
	new String:safe_name[68];
	GetClientName(userid, name, 32);
	SQL_EscapeString(stats_db, name, safe_name, 65, 0);
	Format(query, 256, g_sql_createplayer, steamid, safe_name);
	SQL_TQuery(stats_db, SQL_CreatePlayerCallback, query, userid, DBPriority:1);
	return 0;
}

public SQL_CreatePlayerCallback(Handle:owner, Handle:hndl, String:error[], any:data)
{
	new client = data;
	if (hndl)
	{
		if (IsClientConnected(client))
		{
			decl String:szName[32];
			GetClientName(client, szName, 32);
			SQL_EscapeString(stats_db, szName, g_safename[client], 32, 0);
		}
		g_kills[client] = 0;
		g_deaths[client] = 0;
		g_shots[client] = 0;
		g_hits[client] = 0;
		g_score[client] = 0;
		g_time_played[client] = 0;
		g_headshots[client] = 0;
		g_session_deaths[client] = 0;
		g_session_kills[client] = 0;
		g_session_hits[client] = 0;
		g_session_shots[client] = 0;
		g_session_score[client] = 0;
		g_session_headshots[client] = 0;
		g_time_joined[client] = GetTime({0,0});
		g_initialized[client] = 1;
		g_player_count += 1;
	}
	else
	{
		LogError("[SoD-Stats] SQL_CreatePlayerCallback failure: %s", error);
	}
	return 0;
}

