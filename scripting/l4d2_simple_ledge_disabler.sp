#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_VERSION "0.0.1"

bool g_bLedgeEnabled;

public Plugin myinfo = 
{
    name = "[L4D2] Simple ledge disabler",
    author = "faketuna",
    description = "Control ledge with convar",
    version = PLUGIN_VERSION,
    url = "https://short.f2a.dev/s/github"
};

public void OnPluginStart()
{
    ConVar cvLedge;
    cvLedge       = CreateConVar("sm_ledge_enable", "1", "Toggle ledge", FCVAR_NONE, true, 0.0, true , 1.0);
    cvLedge.AddChangeHook(OnCvarChanged);
    g_bLedgeEnabled = cvLedge.BoolValue;
    HookEvent("player_ledge_grab", OnPlayerLedgeGrab, EventHookMode_Pre);
    delete cvLedge;
}

public void OnCvarChanged(ConVar convar, const char[] oldValue, const char[] newValue) {
    g_bLedgeEnabled = convar.BoolValue;
}

public Action OnPlayerLedgeGrab(Handle event, char[] name, bool dontBroadcast) {
    if(!g_bLedgeEnabled) {
        int client = GetClientOfUserId(GetEventInt(event, "userid", 0));
        if(client == 0) {
            return Plugin_Continue;
        }
        AcceptEntityInput(client, "DisableLedgeHang");
        
        SetEntProp(client, Prop_Send, "m_isIncapacitated", 0);
        SetEntProp(client, Prop_Send, "m_isHangingFromLedge", 0);
        SetEntProp(client, Prop_Send, "m_isFallingFromLedge", 0);
        return Plugin_Handled;
    }
    return Plugin_Continue;
}