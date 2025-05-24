//=============================================================================
// giMPBattle.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 31 $
//=============================================================================
class giMPBattle expands giMP;

#exec AUDIO IMPORT FILE=Sounds\Notification\WinGame.wav		GROUP=EndGameSounds
#exec AUDIO IMPORT FILE=Sounds\Notification\LoseGame.wav	GROUP=EndGameSounds

var config bool bAutoTeamSelect;
var config int SealBudget;
var config bool bHoldNewPlayers;
var config int MaxTeamSize;
var config float FriendlyFireScale;	// scale friendly fire damage by this value
var	config int MaxSpectatorPeriod;	// maximum time allowed as a spectator

var int RemainingEditTime;			// in seconds

var BattleInfo Battle;				// loaded from the Battle map during startup

var byte WinningTeam;				// Set by SealAltar when last seal is placed on altar.

var localized String BattleBeginStr;
var localized String TeamIsYoursStr;
var localized String TeamIsFilledStr;
var localized String PlayerJoinTeamStr;
var localized String PlayerLeaveTeamStr;

var String AngrealSet1[3];
var String AngrealSet2[3];

function RestartGame()
{
	ResetBattle();
	Super.RestartGame();
}

function PostBeginPlay()
{
	local BattleInfo B;

	Super.PostBeginPlay();

	// identify the battle configuration data for this game
	foreach AllActors( class'BattleInfo', B )
	{
		Battle = B;
		Battle.MaxTeamSize = MaxTeamSize;
		break;
	}
	if( Battle == None )
	{
		warn( Self$".PostBeginPlay() unable to locate BattleInfo object within this level." );
	}

	ResetBattle();
}

function string GetRules()
{
	local string ResultSet;

	ResultSet = Super.GetRules();

	// Team selection.
	ResultSet = ResultSet$"\\balanceteams\\"		$bAutoTeamSelect;
	ResultSet = ResultSet$"\\numcitadels\\"			$Battle.NumTeams;
	ResultSet = ResultSet$"\\sealgoal\\"			$CitadelGameReplicationInfo(GameReplicationInfo).SealGoal;
	ResultSet = ResultSet$"\\holdnewplayers\\"		$bHoldNewPlayers;
	ResultSet = ResultSet$"\\maxteamsize\\"			$MaxTeamSize;
	ResultSet = ResultSet$"\\friendlyfire\\"		$string(int(FriendlyFireScale*100))$"%";
//#if 0 //NEW
//	ResultSet = ResultSet$"\\remainingedittime\\"	$RemainingEditTime;
//#endif
	ResultSet = ResultSet$"\\winningteam\\"			$WinningTeam;
	ResultSet = ResultSet$"\\gamebegun\\"			$!Battle.bTeleportersDisabled;

	return ResultSet;
}

function ResetBattle()
{
	local SealAltar A;
	local Budgetinfo B;
	local Seal S;

	// update all altars to match the server configuration
	foreach AllActors( class'SealAltar', A )
	{
		A.Reset( CitadelGameReplicationInfo(GameReplicationInfo).SealGoal );
	}

	// update all budgets to match the server configuration
	foreach AllActors( class'BudgetInfo', B )
	{
		B.Reset( SealBudget );
	}

	// remove all seals from the level
	foreach AllActors( class'Seal', S )
	{
		S.Destroy();
	}

	// eliminate access to teleporters until seals have been placed
	DisableTeleporters();
}

function SetEditing( int Team, bool bOn )
{
	if( bOn )	Battle.bEditing[ Team ]=1;
	else		Battle.bEditing[ Team ]=0;
}

function bool IsEditing( int Team )
{
	return Battle.bEditing[ Team ]==1;
}

function EnableTeamReady( int Team )
{
	Battle.bEditingComplete[ Team ]=1;
}

function string GetTeamStatus( int Team )
{
	return Battle.GetTeamStatus( Team );
}

function DisableTeleporters()
{
	local Pawn P;
	
	for( P = Level.PawnList; P != None; P = P.NextPawn )
	{
		if( WOTPlayer(P) != None )
		{
			WOTPlayer(P).bTeleportingDisabled = true;
		}
	}

	Battle.bTeleportersDisabled = true;
	GameReplicationInfo.bStopCountDown = true;
}

function Sound GetBeginBattleSound()
{
	return Sound( DynamicLoadObject( "AmbientA.ConchShell2", class'Sound', true ) );
}

function EnableTeleporters()
{
	local Pawn P;
	local WOTPlayer Player;
	
	Battle.bTeleportersDisabled = false;
	GameReplicationInfo.bStopCountDown = false;

	for( P = Level.PawnList; P != None; P = P.NextPawn )
	{
		Player = WOTPlayer(P);
		if( Player != None )
		{
			if( Player.PlayerReplicationInfo.Team != 255 )
			{
				Player.bTeleportingDisabled = false;
				Player.bShowOverview = false;
				AddDefaultInventory( Player );
			}
			Player.JoinTeamTimeout = MaxSpectatorPeriod;
			Player.CenterMessage( BattleBeginStr );
			Player.ClientPlaySound( GetBeginBattleSound() );
		}
	}
}

function bool CanTeleport()
{
	return !Battle.bTeleportersDisabled;
}

function AddDefaultInventory( pawn PlayerPawn )
{
	if( !Battle.bTeleportersDisabled )
	{
		GivePawnAngreal( PlayerPawn, "Angreal.AngrealInvDart", 25 );
		GivePawnAngreal( PlayerPawn, AngrealSet1[ FRand() * ( ArrayCount(AngrealSet1) - 0.001 ) ] );
		GivePawnAngreal( PlayerPawn, AngrealSet2[ FRand() * ( ArrayCount(AngrealSet2) - 0.001 ) ] );
		Super.AddDefaultInventory( PlayerPawn );
	}
}

function bool IsBattlefieldClear()
{
	local int i;

	for( i = 0; i < Battle.NumTeams; i++ )
	{
		if( Battle.bEditingComplete[ i ] != 0 )
		{
			return false;
		}
	}

	return true;
}

function Timer()
{
	local Pawn P;
	local WOTPlayer Player;
	local int PlayerCount;

	Super.Timer();

	// if play has begun and the player has not selected a team, auto select team for the player
	if( CanTeleport() )
	{
		for( P = Level.PawnList; P != None; P = P.NextPawn )
		{
			Player = WOTPlayer(P);
			if( Player != None && Player.PlayerReplicationInfo.Team == 255 && Player.JoinTeamTimeout > 0 )
			{
				Player.JoinTeamTimeout--;
				if( Player.JoinTeamTimeout == 0 )
				{
					Player.ServerChangeTeam( GetSmallestTeam() );
				}
			}
		}
	}

	if( !IsBattlefieldClear() )
	{
		// if the game has been disrupted (traps placed, etc.) and no one is here, reset the server
		for( P = Level.PawnList; P != None; P = P.NextPawn )
		{
			if( WOTPlayer(P) != None )
			{
				PlayerCount++;
			}
		}
		if( PlayerCount == 0 )
		{
			log( "Server empty, restarting game to clear the battlefield..." );
			RestartGame();
		}
	}
}

function JoinTeam( WOTPlayer Other, int Team )
{
//Log( "Calling ServerChangeClass() with "$ Battle.TeamClass[ Team ] );
	Other.ServerChangeClass( Battle.TeamClass[ Team ] );
	Other.EnterCitadel();

	// enable teleporters for team members if game-play has started
	Other.bTeleportingDisabled = Battle.bTeleportersDisabled;
	if( Battle.bTeleportersDisabled )
	{
		// automatically bring up the overview scoreboard
		Other.OverviewType = Class'WOT.CitadelTeamOverview';
		Other.bShowOverview = true;
	}
	else
	{
		Other.bShowOverview = false;
		AddDefaultInventory( Other );
	}

	// bring the player to the real world
	Other.SetCollision( true, true, true );
	Other.Style = ERenderStyle.STY_Normal;

	log( Other.PlayerReplicationInfo.PlayerName $ " joined team " $ Other.PlayerReplicationInfo.Team );
}

function LeaveTeam( WOTPlayer Other )
{
	log( Other.PlayerReplicationInfo.PlayerName $ " leaving team " $ Other.PlayerReplicationInfo.Team );

	Other.LeaveCitadel();

	// disable teleporters for neutral players
	Other.bTeleportingDisabled = true;

	// automatically bring up the overview scoreboard
	Other.OverviewType = Class'WOT.CitadelTeamOverview';
	Other.bShowOverview = true;

	// make the player a ghost (no interaction with world)
	Other.SetCollision( true, false, false );
	Other.Style = ERenderStyle.STY_Modulated;

	// if gameplay has begun, encourage players to join a team!
	if( CanTeleport() )
	{
		Other.JoinTeamTimeout = MaxSpectatorPeriod;
	}
}

function bool ChangeTeam( Pawn Other, int Team )
{
	local WOTPlayer Player;

	assert( Battle != None );

//log( Self$".ChangeTeam( "$Other$", "$Team$" )" );
	Player = WOTPlayer(Other);
	if( Player == None )
	{
		warn( Other $" is not a WOTPlayer." );
		return true;
	}

	// if desired team is not neutral
	if( Team != 255 )
	{
		if( Team < 0 || Team >= Battle.NumTeams )
		{
			warn( "( "$ Player $", "$ Team $" ) Team is out of range." );
			return true;
		}

		// reject change request if team is already set
		if( Team == Player.PlayerReplicationInfo.Team )
		{
			Player.LeftMessage( TeamIsYoursStr $ Team );
			return true;
		}

		// reject if no room remains on the requested team
		if( Battle.NumPlayers[ Team ] >= MaxTeamSize )
		{
			Player.LeftMessage( TeamIsFilledStr $ Team );
			return false;
		}
	}

	// remove the player from their previous team (if they had one)
	if( Player.PlayerReplicationInfo.Team < Battle.NumTeams )
	{
//Log( Player$" Leaving Team "$ Player.PlayerReplicationInfo.Team );
		Battle.NumPlayers[ Player.PlayerReplicationInfo.Team ]--;
	}

	// make the player an official member of the team
	Player.PlayerReplicationInfo.Team = Team;

//Log( Player$" Joining Team "$ Player.PlayerReplicationInfo.Team );
	if( Team != 255 )
	{
		Battle.NumPlayers[ Team ]++;
		JoinTeam( Player, Team );
		Player.BroadcastLeftMessage( Player.PlayerReplicationInfo.PlayerName $ PlayerJoinTeamStr $ Player.TeamDescription );
	}
	else
	{
		LeaveTeam( Player );
		Player.BroadcastLeftMessage( Player.PlayerReplicationInfo.PlayerName $ PlayerLeaveTeamStr );
	}

	return true;
}

function int GetSmallestTeam()
{
	local int i, MinTeam, MinCount;

	assert( Battle != None );

	MinTeam = 0;
	MinCount = Battle.NumPlayers[0];
	for( i = 1; i < Battle.NumTeams; i++ )
	{
		if( Battle.NumPlayers[i] < MinCount )
		{
			MinTeam = i;
			MinCount = Battle.NumPlayers[i];
		}
	}

	return MinTeam;
}

function PlayerPawn Login
(
	string Portal,
	string Options,
	out string Error,
	class<PlayerPawn> SpawnClass
)
{
	local PlayerPawn NewPlayer;
	local string InName, InPassword;

	assert( Battle != None );

//Log( Self$".Login() Options = "$ Options );
	// Get URL options.
	InName     = Left( ParseOption( Options, "Name" ), 20 );
	InPassword = ParseOption( Options, "Password" );
	Options = "?Name="$InName;
	if( bAutoTeamSelect )
	{
		Options = Options$"?Team="$ GetSmallestTeam();
	}
	if( InPassword != "" )
	{
		Options = Options$"?Password="$InPassword;
	}
//Log( "  Options = "$Options );
	NewPlayer = Super.Login( Portal, Options, Error, SpawnClass );

	if( WOTPlayer(NewPlayer) != None && NewPlayer.PlayerReplicationInfo.Team == 255 )
	{
		LeaveTeam( WOTPlayer(NewPlayer) );
	}

	return NewPlayer;
}

function Logout( Pawn ExitingPawn )
{
	assert( Battle != None );

	Super.Logout( ExitingPawn );

	if( !ExitingPawn.IsA( 'Spectator' )
		&& Battle != None 
		&& ExitingPawn.PlayerReplicationInfo.Team < Battle.NumTeams )
	{
		Battle.NumPlayers[ ExitingPawn.PlayerReplicationInfo.Team ]--;
		ExitingPawn.PlayerReplicationInfo.Team = 255;
	}
}

function int ReduceDamage( int Damage, Name DamageType, Pawn injured, Pawn instigatedBy )
{
	// disable damage due to other pawns or players until play begins
	if( Battle.bTeleportersDisabled && instigatedBy != None )
	{
		return 0;
	}

	// neutral players may not injure or be injured by others (assumes they're "safe" in the world level)
	if( injured.PlayerReplicationInfo.Team == 255 || instigatedBy != None && instigatedBy.PlayerReplicationInfo.Team == 255 )
	{
		return 0;
	}

	// neutral zones may be designated within the world to inhibit damage (not implemented)
	if( injured.Region.Zone.bNeutralZone )
	{
		return 0;
	}
	
	// friendly fire damage scaling (not implemented)
	if( instigatedBy != None && injured.PlayerReplicationInfo.Team == instigatedBy.PlayerReplicationInfo.Team )
	{
		return float(Damage) * FriendlyFireScale;
	}
	
	return Damage;
}

function bool CanEditCitadel()
{
	return true;
}

function bool PickupQuery( Pawn Other, Inventory Item )
{
	// disable pickups for:
	// - neutral players (to avoid accumulation of Angreal before joining the game)
	// - editing players (to avoid confusion about seal pickups)
	// - all players until teleporters are enabled (enable pickups after editing is complete)
	if( Other.PlayerReplicationInfo.Team == 255 || WOTPlayer(Other) != None && WOTPlayer(Other).bEditing || Battle.bTeleportersDisabled )
	{
		return false;
	}

	return Super.PickupQuery( Other, Item );
}

function EndGame( string Reason )
{
	local Pawn IterP;

	if( Reason ~= "AltarFilled" )
	{
		for( IterP = Level.PawnList; IterP != None; IterP = IterP.NextPawn )
		{
			if( PlayerPawn(IterP) != None && IterP.PlayerReplicationInfo != None )
			{
				if( IterP.PlayerReplicationInfo.Team == WinningTeam )
				{
					PlayerPawn(IterP).ClientPlaySound( Sound'WOT.EndGameSounds.WinGame' );
				}
				else
				{
					PlayerPawn(IterP).ClientPlaySound( Sound'WOT.EndGameSounds.LoseGame' );
				}
			}
		}
	}

	Super.EndGame( Reason );
}
	
//end of giMPBattle.uc

defaultproperties
{
     SealBudget=3
     MaxTeamSize=3
     FriendlyFireScale=1.000000
     MaxSpectatorPeriod=30
     WinningTeam=255
     AngrealSet1(0)="Angreal.AngrealInvFireball"
     AngrealSet1(1)="Angreal.AngrealInvLightning"
     AngrealSet1(2)="Angreal.AngrealInvSoulBarb"
     AngrealSet2(0)="Angreal.AngrealInvShift"
     AngrealSet2(1)="Angreal.AngrealInvFork"
     AngrealSet2(2)="Angreal.AngrealInvWallOfAir"
     bChangeLevels=True
     bSpawnInTeamArea=True
     Map="Battle2_01.wot"
     bRestartLevel=False
     bTeamGame=True
     ScoreBoardType=Class'WOT.CitadelScoreBoard'
     HUDType=Class'WOT.BattleHUD'
     MapPrefix="Battle2_"
     GameReplicationInfoClass=Class'WOT.CitadelGameReplicationInfo'
}
