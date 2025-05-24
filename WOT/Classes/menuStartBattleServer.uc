// menuStartBattleServer.uc
//=============================================================================
class menuStartBattleServer expands menuStartGame;

const MENU_NumberofCitadels		= 1;	// [ 2 | 3 | 4 ]
const MENU_SelectBattleMap		= 2;	// Battle<Y>_<XX>
const MENU_TimeLimit			= 3;	// None - 60
const MENU_CycleBattleLevels	= 4;	// [ Yes | No ]
const MENU_NumberofKillstoWin	= 5;	// None - 100
const MENU_NumberofSealstoWin	= 6;	// [ 2 - 4 ]
const MENU_SealBudget			= 7;	// [ 1 - 3 ]
const MENU_AutoTeamSelection	= 8;	// Yes | No
const MENU_PlayerCountLimit		= 9;	// [ 1 - 16 ]
const MENU_MaximumTeamSize		= 10;	// [ 1 - 4 ]
const MENU_MaxClientTickRate	= 11;	// [ 0, or 10 - 30 ]
const MENU_ServerName			= 12;	// string
const MENU_AdminPassword		= 13;	// string
const MENU_GamePassword			= 14;	// string
const MENU_LaunchDedicatedServer= 15;	// 

const MinCitadels = 2;
const MaxCitadels = 4;
var config int NumCitadels;
const Battle2Prefix = "Battle2_";
const Battle3Prefix = "Battle3_";
const Battle4Prefix = "Battle4_";

var int MinSealBudget;
var int MaxSealBudget;

var int MaxClientTickRate;
var string ServerName;

//=============================================================================

function PostBeginPlay()
{
	Super.PostBeginPlay();
	ServerName = GameType.GameReplicationInfo.ServerName;
	UpdateBattleMap();
	UpdateSealGoal( CitadelGameReplicationInfo(GameType.GameReplicationInfo).SealGoal );
	UpdatePlayerLimits();
}

//=============================================================================

function UpdateBattleMap()
{
	NumCitadels = Min( Max( NumCitadels, MinCitadels ), MaxCitadels );
	switch( NumCitadels )
	{
	case 2: GameType.SetMap( Battle2Prefix ); break;
	case 3: GameType.SetMap( Battle3Prefix ); break;
	case 4: GameType.SetMap( Battle4Prefix ); break;
	}

	if( NumCitadels > 2 )
	{
		giCombatBase(GameType).bChangeLevels = false;
	}
}

//=============================================================================

function UpdateSealGoal( int SealGoal )
{
	SealGoal = Max( 2, Min( 4, SealGoal ) );
	CitadelGameReplicationInfo(GameType.GameReplicationInfo).SealGoal = SealGoal;

	MinSealBudget = int( float(SealGoal) / NumCitadels + 0.99 );
	MaxSealBudget = SealGoal - 1;
	giMPBattle(GameType).SealBudget = Min( MaxSealBudget, Max( MinSealBudget, giMPBattle(GameType).SealBudget ) );
}

//=============================================================================

function UpdatePlayerLimits()
{
	if( giMPBattle(GameType).bAutoTeamSelect )
	{
		GameType.MaxPlayers = NumCitadels * giMPBattle(GameType).MaxTeamSize;
	}
	else
	{
		GameType.MaxPlayers = Max( NumCitadels, GameType.MaxPlayers );
	}

	giMPBattle(GameType).MaxTeamSize = Min( Min( 16 / NumCitadels, giMPBattle(GameType).MaxTeamSize ), GameType.MaxPlayers );
}

//=============================================================================

function bool ProcessLeft()
{
	switch( Selection )
	{
	case MENU_NumberofCitadels:
		NumCitadels--;
		UpdateBattleMap();
		UpdateSealGoal( NumCitadels );
		UpdatePlayerLimits();
		break;
	case MENU_SelectBattleMap:
		GameType.PrevMap();
		break;
	case MENU_TimeLimit:
		giCombatBase(GameType).TimeLimit = Max( 0, giCombatBase(GameType).TimeLimit - 1 );
		break;
	case MENU_CycleBattleLevels:
		ProcessRight();
		break;
	case MENU_NumberofKillstoWin:
		giCombatBase(GameType).FragLimit = Max( 0, giCombatBase(GameType).FragLimit - 1 );
		break;
	case MENU_NumberofSealstoWin:
		UpdateSealGoal( Max( 2, CitadelGameReplicationInfo(GameType.GameReplicationInfo).SealGoal - 1 ) );
		break;
	case MENU_SealBudget:
		giMPBattle(GameType).SealBudget = Max( MinSealBudget, giMPBattle(GameType).SealBudget - 1 );
		break;
	case MENU_AutoTeamSelection:
		giMPBattle(GameType).bAutoTeamSelect = !giMPBattle(GameType).bAutoTeamSelect;
		UpdatePlayerLimits();
		break;
	case MENU_PlayerCountLimit:
		GameType.MaxPlayers = Max( NumCitadels, GameType.MaxPlayers - 1 );
		UpdatePlayerLimits();
		break;
	case MENU_MaximumTeamSize:
		giMPBattle(GameType).MaxTeamSize = Max( 1, giMPBattle(GameType).MaxTeamSize - 1 );
		UpdatePlayerLimits();
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
	}

	return true;
}

//=============================================================================

function bool ProcessRight()
{
	switch( Selection )
	{
	case MENU_NumberofCitadels:
		NumCitadels++;
		UpdateBattleMap();
		UpdateSealGoal( NumCitadels );
		UpdatePlayerLimits();
		break;
	case MENU_SelectBattleMap:
		GameType.NextMap();
		break;
	case MENU_TimeLimit:
		giCombatBase(GameType).TimeLimit = Min( 60, giCombatBase(GameType).TimeLimit + 1 );
		break;
	case MENU_CycleBattleLevels:
		giCombatBase(GameType).bChangeLevels = !giCombatBase(GameType).bChangeLevels;
		break;
	case MENU_NumberofKillstoWin:
		giCombatBase(GameType).FragLimit = Min( 100, giCombatBase(GameType).FragLimit + 1 );
		break;
	case MENU_NumberofSealstoWin:
		UpdateSealGoal( Min( 4, CitadelGameReplicationInfo(GameType.GameReplicationInfo).SealGoal + 1 ) );
		break;
	case MENU_SealBudget:
		giMPBattle(GameType).SealBudget = Min( MaxSealBudget, giMPBattle(GameType).SealBudget + 1 );
		break;
	case MENU_AutoTeamSelection:
		giMPBattle(GameType).bAutoTeamSelect = !giMPBattle(GameType).bAutoTeamSelect;
		UpdatePlayerLimits();
		break;
	case MENU_PlayerCountLimit:
		GameType.MaxPlayers = Min( 16, GameType.MaxPlayers + 1 );
		UpdatePlayerLimits();
		break;
	case MENU_MaximumTeamSize:
		giMPBattle(GameType).MaxTeamSize = Min( 16 / NumCitadels, giMPBattle(GameType).MaxTeamSize + 1 );
		UpdatePlayerLimits();
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
	}

	return true;
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

function ProcessMenuEscape()
{
	switch( Selection )
	{
	case MENU_AdminPassword:
		GameType.AdminPassword = "";
		break;
	case MENU_GamePassword:
		GameType.GamePassword = "";
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
		assert( giMPBattle(GameType).SealBudget < CitadelGameReplicationInfo(GameType.GameReplicationInfo).SealGoal );
		assert( giMPBattle(GameType).SealBudget * NumCitadels >= CitadelGameReplicationInfo(GameType.GameReplicationInfo).SealGoal );

		GameType.ResetGame();
		SaveConfigs();

		URL = GameType.Map $"?Game="$ GameType.Class;
		PlayerOwner.ConsoleCommand( "RELAUNCH "$URL$" -server log=server.log" );
		break;
	default:
		return false;
	}

	return true;
}

//=============================================================================

function UpdateValues()
{
	UpdateBattleMap();
	MenuList[MENU_NumberofCitadels]		= string(NumCitadels);
	if( Len( GameType.Map ) > 4 )
		MenuList[MENU_SelectBattleMap]	= Left( GameType.Map, Len( GameType.Map ) - 4 );
	else
		MenuList[MENU_SelectBattleMap]	= "N/A";
	MenuList[MENU_CycleBattleLevels]	= string(giCombatBase(GameType).bChangeLevels);
	MenuList[MENU_TimeLimit]			= string(giCombatBase(GameType).TimeLimit);
	MenuList[MENU_NumberofKillstoWin]	= string(giCombatBase(GameType).FragLimit);
	MenuList[MENU_NumberofSealstoWin]	= string(CitadelGameReplicationInfo(GameType.GameReplicationInfo).SealGoal);
	MenuList[MENU_SealBudget]			= string(giMPBattle(GameType).SealBudget);
	MenuList[MENU_AutoTeamSelection]	= string(giMPBattle(GameType).bAutoTeamSelect);
	MenuList[MENU_PlayerCountLimit]		= string(GameType.MaxPlayers);
	MenuList[MENU_MaximumTeamSize]		= string(giMPBattle(GameType).MaxTeamSize);
	MaxClientTickRate = byte( PlayerOwner.ConsoleCommand( "get ini:Engine.Engine.ViewportManager MaxClientTickRate" ) );
	MenuList[MENU_MaxClientTickRate]	= string(MaxClientTickRate)$ " fps";
	MenuList[MENU_ServerName]			= ServerName;
	MenuList[MENU_AdminPassword]		= "["$GameType.AdminPassword$"]";
	MenuList[MENU_GamePassword]			= "["$GameType.GamePassword$"]";
	MenuList[MENU_LaunchDedicatedServer]= " ";
}

defaultproperties
{
     NumCitadels=2
     GameClass=Class'WOT.giMPBattle'
     bMenuHelp=True
     MenuLength=15
}
