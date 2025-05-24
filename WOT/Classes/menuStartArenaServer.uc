//=============================================================================
// menuStartArenaServer.uc
//=============================================================================
class menuStartArenaServer expands menuStartGame;

const MENU_SelectArenaMap			= 1; // Arena_<XX>
const MENU_NumberofKillstoWin		= 2; // [ 0 - 100 ]
const MENU_TimeLimit				= 3; // [ 0 - 60 ]
const MENU_CycleArenaLevels			= 4; // [ Yes | No ]
const MENU_PlayerCountLimit			= 5; // [ 1 - 16 ]
const MENU_MaxClientTickRate		= 6; // [ 0, or 10 - 30 ]
const MENU_ServerName				= 7; // string
const MENU_AdminPassword			= 8; // string
const MENU_GamePassword				= 9; // string
const MENU_LaunchDedicatedServer	= 10; //

var int MaxClientTickRate;
var string ServerName;

//=============================================================================

function PostBeginPlay()
{
	Super.PostBeginPlay();
	ServerName = GameType.GameReplicationInfo.ServerName;
}

//=============================================================================

function bool ProcessLeft()
{
	switch( Selection )
	{
	case MENU_SelectArenaMap:
		GameType.PrevMap();
		break;
	case MENU_NumberofKillstoWin:
		giCombatBase(GameType).FragLimit = Max( 0, giCombatBase(GameType).FragLimit - 1 );
		break;
	case MENU_TimeLimit:
		giCombatBase(GameType).TimeLimit = Max( 0, giCombatBase(GameType).TimeLimit - 1 );
		break;
	case MENU_CycleArenaLevels:
		ProcessRight();
		break;
	case MENU_PlayerCountLimit:
		GameType.MaxPlayers = Max( 2, GameType.MaxPlayers - 1 );
		break;
	case MENU_MaxClientTickRate:
		MaxClientTickRate--;
		if( MaxClientTickRate < 10 ) MaxClientTickRate = 0;
		PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.ViewportManager MaxClientTickRate "$MaxClientTickRate );
		break;
	case MENU_AdminPassword:
		GameType.AdminPassword = "_";
		PlayerOwner.Player.Console.GotoState( 'MenuTyping' );
		break;
	case MENU_GamePassword:
		GameType.GamePassword = "_";
		PlayerOwner.Player.Console.GotoState( 'MenuTyping' );
		break;
	case MENU_ServerName:
		ServerName = "_";
		PlayerOwner.Player.Console.GotoState( 'MenuTyping' );
		break;
	default:
		return false;
		break;
	}

	return true;
}

//=============================================================================

function bool ProcessRight()
{
	switch( Selection )
	{
	case MENU_SelectArenaMap:
		GameType.NextMap();
		break;
	case MENU_NumberofKillstoWin:
		giCombatBase(GameType).FragLimit = Min( 100, giCombatBase(GameType).FragLimit + 1 );
		break;
	case MENU_TimeLimit:
		giCombatBase(GameType).TimeLimit = Min( 60, giCombatBase(GameType).TimeLimit + 1 );
		break;
	case MENU_CycleArenaLevels:
		giCombatBase(GameType).bChangeLevels = !giCombatBase(GameType).bChangeLevels;
		break;
	case MENU_PlayerCountLimit:
		GameType.MaxPlayers = Min( 16, GameType.MaxPlayers + 1 );
		break;
	case MENU_MaxClientTickRate:
		MaxClientTickRate++;
		if( MaxClientTickRate == 1 ) MaxClientTickRate = 10;
		else if( MaxClientTickRate > 30 ) MaxClientTickRate = 30;
		PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.ViewportManager MaxClientTickRate "$MaxClientTickRate );
		break;
	case MENU_AdminPassword:
		GameType.AdminPassword = "_";
		PlayerOwner.Player.Console.GotoState( 'MenuTyping' );
		break;
	case MENU_GamePassword:
		GameType.GamePassword = "_";
		PlayerOwner.Player.Console.GotoState( 'MenuTyping' );
		break;
	case MENU_ServerName:
		ServerName = "_";
		PlayerOwner.Player.Console.GotoState( 'MenuTyping' );
		break;
	default:
		return false;
		break;
	}

	return true;
}

//=============================================================================

function bool ProcessSelection()
{
	local string URL;

	switch( Selection )
	{
	case MENU_AdminPassword:
		GameType.AdminPassword = "_";
		PlayerOwner.Player.Console.GotoState( 'MenuTyping' );
		break;
	case MENU_GamePassword:
		GameType.GamePassword = "_";
		PlayerOwner.Player.Console.GotoState( 'MenuTyping' );
		break;
	case MENU_ServerName:
		ServerName = "_";
		PlayerOwner.Player.Console.GotoState( 'MenuTyping' );
		break;
	case MENU_LaunchDedicatedServer:
		GameType.ResetGame();
		SaveConfigs();

		URL = GameType.Map $"?Game="$ GameType.Class;
		PlayerOwner.ConsoleCommand( "RELAUNCH "$URL$" -server log=server.log" );
		break;
	default:
		return false;
		break;
	}

	return true;
}

//=============================================================================

function UpdateValues()
{
	GameType.SetMap();
	
	if( Len( GameType.Map ) > 4 )
		MenuList[MENU_SelectArenaMap]	= Left( GameType.Map, Len( GameType.Map ) - 4 );
	else
		MenuList[MENU_SelectArenaMap]	= "N/A";
	MenuList[MENU_NumberofKillstoWin]	= string(giCombatBase(GameType).FragLimit);
	MenuList[MENU_TimeLimit]			= string(giCombatBase(GameType).TimeLimit);
	MenuList[MENU_CycleArenaLevels]		= string(giCombatBase(GameType).bChangeLevels);
	MenuList[MENU_PlayerCountLimit]		= string(GameType.MaxPlayers);
	MaxClientTickRate = int( PlayerOwner.ConsoleCommand( "get ini:Engine.Engine.ViewportManager MaxClientTickRate" ) );
	MenuList[MENU_MaxClientTickRate]	= string(MaxClientTickRate)$ " fps";
	MenuList[MENU_ServerName]			= ServerName;
	MenuList[MENU_AdminPassword]		= "["$GameType.AdminPassword$"]";
	MenuList[MENU_GamePassword]			= "["$GameType.GamePassword$"]";
	MenuList[MENU_LaunchDedicatedServer]= " ";
}

//=============================================================================

function ProcessMenuInput( coerce string InputString )
{
	switch( Selection )
	{
	case MENU_AdminPassword:
		GameType.AdminPassword = InputString;
		GameType.SaveConfig();
		break;
	case MENU_GamePassword:
		GameType.GamePassword = InputString;
		GameType.SaveConfig();
		break;
	case MENU_ServerName:
		ServerName = InputString;
		GameType.GameReplicationInfo.ServerName = ServerName;
		GameType.SaveConfig();
		break;
	}
}

//=============================================================================

function ProcessMenuEscape()
{
	switch( Selection )
	{
	case MENU_AdminPassword:
		GameType.AdminPassword = "";
		GameType.SaveConfig();
		break;
	case MENU_GamePassword:
		GameType.GamePassword = "";
		GameType.SaveConfig();
		break;
	case MENU_ServerName:
		ServerName = GameType.GameReplicationInfo.ServerName;
		break;
	}
}

//=============================================================================

function ProcessMenuUpdate( coerce string InputString )
{
	switch( Selection )
	{
	case MENU_AdminPassword:
		GameType.AdminPassword = InputString$"_";
		break;
	case MENU_GamePassword:
		GameType.GamePassword = InputString$"_";
		break;
	case MENU_ServerName:
		ServerName = InputString$"_";
		break;
	}
}

defaultproperties
{
     GameClass=Class'WOT.giMPArena'
     bMenuHelp=True
     MenuLength=10
}
