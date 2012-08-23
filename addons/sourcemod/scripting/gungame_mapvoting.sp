#pragma semicolon 1

#include <sourcemod>
#include <gungame_const>
#include <gungame>
#include "gungame/stock.sp"

public Plugin:myinfo = {
    name = "GunGame:SM Map Vote Starter",
    author = GUNGAME_AUTHOR,
    description = "Start the map voting for next map",
    version = GUNGAME_VERSION,
    url = GUNGAME_URL
};

new String:ConfigDir[PLATFORM_MAX_PATH];
new GameName:g_GameName = GameName:None;

public GG_OnStartMapVote() {
    InsertServerCommand("exec \\%s\\gungame.mapvote.cfg", ConfigDir);
}

public GG_OnDisableRtv() {
    InsertServerCommand("exec \\%s\\gungame.disable_rtv.cfg", ConfigDir);
}

public OnConfigsExecuted() {
    new Handle:Cvar_CfgDirName;
    Cvar_CfgDirName = FindConVar("sm_gg_cfgdirname");

    if ( Cvar_CfgDirName == INVALID_HANDLE ) {
        LogError("Cvar sm_gg_cfgdirname not found. Does gungame_config.smx plugin loaded?");
    } else {
        decl String:ConfigDirName[PLATFORM_MAX_PATH];
        GetConVarString(Cvar_CfgDirName, ConfigDirName, sizeof(ConfigDirName));

        if (g_GameName == GameName:Css) {
            FormatEx(ConfigDir, sizeof(ConfigDir), "%s\\css", ConfigDirName);
        } else if (g_GameName == GameName:Csgo) {
            FormatEx(ConfigDir, sizeof(ConfigDir), "%s\\csgo", ConfigDirName);
        }
    }
}

public OnPluginStart() {
    g_GameName = DetectGame();
    if (g_GameName == GameName:None) {
        SetFailState("ERROR: Unsupported game. Please contact the author.");
    }
}
