//=============================================================================
// giCombatBase.uc
//
//=============================================================================
class giCombatBase expands giWOT;

var() config int FragLimit;

const GameRestartDelay=15;
var() config int TimeLimit; // in minutes
var() config bool bChangeLevels;
var	bool bAlreadyChanged;
var	bool bGameEnded;

var bool bSpawnInTeamArea;

var localized string GlobalNameChange;
var localized string NoNameChange;

event InitGame( string Options, out string Error )
{
	Super.InitGame( Options, Error );

	FragLimit = GetIntOption( Options, "FragLimit", FragLimit );
	TimeLimit = GetIntOption( Options, "TimeLimit", TimeLimit );
	bChangeLevels = bool( GetIntOption( Options, "Cycle", int(bChangeLevels) ) );
}

function PostBeginPlay()
{
	Super.PostBeginPlay();

	GameReplicationInfo.RemainingTime = 60 * TimeLimit;
	GameReplicationInfo.bDisplayRemaining = (TimeLimit > 0);
}

function AcceptInventory( pawn PlayerPawn )
{
	local inventory Inv;

	//Arena and MP don't accept inventory
	for( Inv = PlayerPawn.Inventory; Inv != None; Inv = Inv.Inventory )
		Inv.Destroy();
	PlayerPawn.Weapon = None;
	PlayerPawn.SelectedItem = None;

	AddDefaultInventory( PlayerPawn );
}

function ChangeName( pawn Other, coerce string S, bool bNameChange )
{
	local pawn APlayer;

	if( S == "" )
		return;

	if( Other.PlayerReplicationInfo.PlayerName ~= S )
		return;
	
	APlayer = Level.PawnList;
	while( APlayer != None )
	{	
		if( APlayer.bIsPlayer && APlayer.PlayerReplicationInfo.PlayerName ~= S )
		{
			Other.ClientMessage( S$NoNameChange );
			return;
		}
		APlayer = APlayer.NextPawn;
	}

	if( bNameChange )
		BroadcastMessage( Other.PlayerReplicationInfo.PlayerName$GlobalNameChange$S, false );
			
	Other.PlayerReplicationInfo.PlayerName = S;
}

function bool ChangeTeam( Pawn Other, int Team )
{
	local pawn P;

	// ignore team parameter -- find a unique team number for the player
	Team = 0;
	P = Level.PawnList;
	while( P != None )
	{
		if( P != Other && Team == P.PlayerReplicationInfo.Team )
		{
			Team++;
			P = Level.PawnList;
		}
		else
		{
			P = P.NextPawn;
		}
	}
//Log( Self$".ChangeTeam( " $ Other $ ", " $ Team $ " )" );

	Other.PlayerReplicationInfo.Team = Team;
	Other.PlayerReplicationInfo.Teamname = String( Other.Class.Name );
	return true;
}

function NavigationPoint FindPlayerStart( Pawn Player, optional byte InTeam, optional string incomingName )
{
	local int Score, BestScore;
	local int Dist;
	local PlayerStart Start, BestStart;
	local pawn OtherPlayer;

	Log( Self$".FindPlayerStart( "$Player$" ) Team=" $ InTeam );

	// scan all player start points to determine the best start location (bias toward *any* unoccupied point)
	BestScore = -100000;
	BestStart = None;
	foreach AllActors( class 'PlayerStart', Start )
	{
		// find the "best" start point by evaluating the "score" for each location
		Score = RandRange( 1000, 2000 ); // randomize the score for each position

		if( bSpawnInTeamArea )
		{
			if( Start.TeamNumber != InTeam )
			{
				if( Start.TeamNumber == 255 )
				{
					Score -= 4000; // weight heavily against neutral start points
				}
				else
				{
					Score -= 20000;// weight *really* heavily against enemy start points
				}
			}
		}

		// evaluate position relative to other players in the world
		foreach AllActors( class 'Pawn', OtherPlayer )
		{
			if( OtherPlayer != Player )
			{
				Dist = VSize( OtherPlayer.Location - Start.Location );
				Score += Sqrt( Dist ) / 64;
				if( Dist < CollisionRadius + CollisionHeight )
				{
					Score -= 1000000.0; // don't consider start point if player's overlap
				}
				else if( (OtherPlayer.PlayerReplicationInfo == None || OtherPlayer.PlayerReplicationInfo.Team != InTeam ) && OtherPlayer.LineOfSightTo( Start ) )
				{
					Score -= 1000.0; // weight against enemys with line of sight
				}
			}
		}
		
//		Log( "  " $ Start $ " for team "$ Start.TeamNumber $" Score = "$ Score );

		if( Score > BestScore )
		{
			BestScore = Score;
			BestStart = Start;
		}
	}
	Log( "    "$ BestStart$".TeamNumber="$ BestStart.TeamNumber );
	
	return BestStart;
}

function Timer()
{
	Super.Timer();

	if( TimeLimit > 0 )
	{
		if( bGameEnded )
		{
			if( GameReplicationInfo.RemainingTime < -GameRestartDelay )
			{
				RestartGame();
			}
		}
		else if( GameReplicationInfo.RemainingTime <= 0 )
		{
			EndGame( "timelimit" );
		}
	}
}

function Killed( pawn killer, pawn Other, name damageType )
{
	Super.Killed( killer, Other, damageType );

	if( killer == None || Other == None )
		return;

	if( FragLimit > 0 && Class.static.CalcScore( killer.PlayerReplicationInfo ) >= FragLimit )
	{
		EndGame( "fraglimit" );
	}
}	

function bool ShouldRespawn( actor Other )
{
	if( Pawn(Other) != None && Pawn(Other).bIsPlayer )
		return true;

	return Super.ShouldRespawn( Other );
}

function RestartGame()
{
	Log( Self$".RestartGame()" );

	// these server travels should all be relative to the current URL
	if( bChangeLevels && !bAlreadyChanged )
	{
		bAlreadyChanged = true;

		NextMap();
		if( Map != "" )
		{
			Log( "Changing to " $ Map );
			SaveConfig();
			Level.ServerTravel( Map, false );
			return;
		}
	}

	Super.RestartGame();
}

function EndGame( string Reason )
{
	Super.EndGame( Reason );

	bGameEnded = true;
	GameReplicationInfo.RemainingTime = -1; // use timer to force restart
}

//end of giCombatBase.uc

defaultproperties
{
     GlobalNameChange=" changed name to "
     NoNameChange=" is already in use"
}
