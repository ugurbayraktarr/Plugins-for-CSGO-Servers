#include <sourcemod>

public Plugin:myinfo =
{
    name = "Bot Ayarı",
    author = "ImPossibLe`",
    description = "DrK # GaminG",
    version = "1.0"
}

public OnMapStart()
{
	CreateTimer(10.0, LoadStuff, _, TIMER_REPEAT);
}

public Action LoadStuff(Handle timer)
{
	ServerCommand("bot_quota 0");
}