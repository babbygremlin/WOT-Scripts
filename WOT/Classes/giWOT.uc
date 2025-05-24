//=============================================================================
// giWOT.uc
// $Author: Mfox $
// $Date: 1/12/00 9:52p $
// $Revision: 18 $
//=============================================================================
class giWOT expands GameInfo;

const MinVotingEngineVersion = 333;

var config string Map; //last mapped selected

var() float SuicideInstigationRelevance;	// How long ago a SuicideInstigator can have touched a player that hari-kari'ed, and still have it count as their kill.
var() bool bShowInventoryHints;				// if set info screen is shown for flagged picked up new items
var() bool bHintOnly;						// if bAutoResearch, show hint that info is available
var() bool bShouldRestartLevel;				// if true, level will be restarted when player dies (e.g. tutorial)
var() class<ScoreBoard> OverviewType;		// type of overview scoreboard to use

var() float VoteRequestTimeout;				// number of seconds a vote request is good for.

struct VoteData
{
	var string Request;
	var string Voters;
	var float  ExpireTime;
};

var VoteData Votes[12];

var config string AuthorizedVoteRequests[16];	// Must be in all caps.

var localized string	VoteStr001,
						VoteStr002,
						VoteStr003,
						VoteStr004,
						VoteStr005,
						VoteStr006,
						VoteStr007,
						VoteStr008,
						VoteStr009;

var localized string DeathConjunction;
var localized string SuicideConjunctionMale;
var localized string SuicideConjunctionFemale;
var localized string AccidentConjunctionMale;
var localized string AccidentConjunctionFemale;

const InternalPauserString = "   WOT   ";	// Level.Pauser set to this to indicate "internal request for pause"

//=============================================================================
function SetMap( optional string Prefix )
{
	if( Prefix != "" )
	{
		MapPrefix = Prefix;
	}
	Map = GetMapName( MapPrefix, Map, 0 );
}

//=============================================================================
function PrevMap()
{
	Map = GetMapName( MapPrefix, Map, -1 );
}

//=============================================================================
function NextMap()
{
	Map = GetMapName( MapPrefix, Map, 1 );
}

//=============================================================================
// Spawn the default angreal for the player.
function AddDefaultInventory( pawn PlayerPawn )
{
	local class<AngrealInventory> DefaultAngrealClass;
	local AngrealInventory A;

	Super.AddDefaultInventory( PlayerPawn );

	if( WOTPlayer(PlayerPawn) != None )
	{
		DefaultAngrealClass = WOTPlayer(PlayerPawn).DefaultAngrealInventory;
		if( DefaultAngrealClass != None && PlayerPawn.FindInventoryType( DefaultAngrealClass ) == None )
		{
			A = Spawn( DefaultAngrealClass );
			if( A != None && Level.Game.PickupQuery( PlayerPawn, A ) )
			{
				A.GiveTo( PlayerPawn );
			}
			else
			{
				A.Destroy();
			}
		}
	}
}

//=============================================================================
function ScoreKill( Pawn Killer, Pawn Other )
{
	local string Temp;

	// Validate input.
	if( Other == None )
	{
		return;
	}

	// Account for SuicideInstigators.
	if( Killer == None )
	{
		if( WOTPlayer(Other) != None && WOTPlayer(Other).SuicideInstigationTime + SuicideInstigationRelevance > Level.TimeSeconds )
		{
			Killer = WOTPlayer(Other).SuicideInstigator;
		}
		else if( WOTPawn(Other) != None && WOTPawn(Other).SuicideInstigationTime + SuicideInstigationRelevance > Level.TimeSeconds )
		{
			Killer = WOTPawn(Other).SuicideInstigator;
		}
	}

	if( Killer == Other )
	{
		Other.PlayerReplicationInfo.Suicides += 1;
		if( Other.PlayerReplicationInfo.bIsFemale )
			BroadcastMessage( FormatMessage( Other.PlayerReplicationInfo.PlayerName $ SuicideConjunctionFemale $ "." ), false, 'WOTDeathMessage' );
		else
			BroadcastMessage( FormatMessage( Other.PlayerReplicationInfo.PlayerName $ SuicideConjunctionMale $ "." ), false, 'WOTDeathMessage' );
	}
	else if( Killer == None )
	{
		Other.PlayerReplicationInfo.Suicides += 1;
		if( Other.PlayerReplicationInfo.bIsFemale )
			BroadcastMessage( FormatMessage( Other.PlayerReplicationInfo.PlayerName $ AccidentConjunctionFemale $ "." ), false, 'WOTDeathMessage' );
		else
			BroadcastMessage( FormatMessage( Other.PlayerReplicationInfo.PlayerName $ AccidentConjunctionMale $ "." ), false, 'WOTDeathMessage' );
	}
	else if( Other.PlayerReplicationInfo != None )
	{
		if( !OnSameTeam( Killer, Other ) )											// Don't give points for killing your own team members (including NPCs).
		{
			if( Pawn(Killer.Owner) != None && Pawn(Killer.Owner).PlayerReplicationInfo != None && OnSameTeam( Killer, Killer.Owner ) )	// Give points to owner of NPC if on the same team.
			{
				Pawn(Killer.Owner).killCount++;
				Pawn(Killer.Owner).PlayerReplicationInfo.Kills += 1;
				BroadcastMessage( FormatMessage( Other.PlayerReplicationInfo.PlayerName $ DeathConjunction $ Killer.PlayerReplicationInfo.PlayerName $ "." ), false, 'WOTDeathMessage' );
			}
			else
			{
				Killer.killCount++;
				Killer.PlayerReplicationInfo.Kills += 1;
				BroadcastMessage( FormatMessage( Other.PlayerReplicationInfo.PlayerName $ DeathConjunction $ Killer.PlayerReplicationInfo.PlayerName $ "." ), false, 'WOTDeathMessage' );
			}
		}
		else
		{
			BroadcastMessage( FormatMessage( Other.PlayerReplicationInfo.PlayerName $ DeathConjunction $ Killer.PlayerReplicationInfo.PlayerName $ "." ), false, 'WOTDeathMessage' );
		}

		Other.PlayerReplicationInfo.Deaths += 1;
	}
}

function string FormatMessage( coerce string Message )
{
	local int i;
	local string FirstChar;

	// Hack off leading white-space.
	for( i = InStr( Message, " " ); i == 0; i = InStr( Message, " " ) )
		Message = Mid( Message, i+1 );
	
	// Capitalize first character.
	FirstChar = Caps( Left( Message, 1 ) );
	
	return FirstChar $ Mid( Message, 1 );
}

//=============================================================================
function bool OnSameTeam( Actor P1, Actor P2 )
{
	if( Pawn(P1) != None && Pawn(P2) != None )
	{
		if( Pawn(P1).PlayerReplicationInfo != None && Pawn(P2).PlayerReplicationInfo != None )
		{
			return Pawn(P1).PlayerReplicationInfo.Team == Pawn(P2).PlayerReplicationInfo.Team;
		}
	}

	return false;
}

//=============================================================================
static function int CalcScore( PlayerReplicationInfo PRI )
{
	if( PRI != None )	return PRI.Kills - PRI.Suicides;
	else				return 0;
}

//=============================================================================
function bool CanEditCitadel()
{
	return false;
}

//=============================================================================
function bool PickupQuery( Pawn Other, Inventory Item )
{
	if( bShowInventoryHints )	
	{
		if( WOTPlayer(Other) != None && Item.IsA('WOTInventory') && WOTInventory(Item).bShowInfoHint )
		{
			if( bHintOnly )
			{
				WOTPlayer(Other).DoInfoHint();
			}
			else
			{
				WOTPlayer(Other).DoShowInventoryInfo( Item, true );
			}
		}
	}

	return Super.PickupQuery( Other, Item );
}
		
//=============================================================================
// Make sure that if the game was paused with InternalPause that player can not
// unpause it manually.
function bool SetPause( bool bPause, PlayerPawn P )
{
	local bool bRetVal;

	if( Level.Pauser != InternalPauserString )
	{
		// only InternalPause(false) can unpause an InternalPause(true)
		bRetVal = Super.SetPause( bPause, P );
		Level.bDisableAmbientSound = ( Level.Pauser != "" );
	}
	else
	{
		// return true to indicate that pausing is allowed
		bRetVal = true;
	}

	return bRetVal;
}

//=============================================================================
// Pause the game (and, optionally, ambient sounds) "internally". Only a call
// to InternalPause( false, ...) can unpause a game paused with InternalPause.
function InternalPause( bool bPause, bool bPauseAmbientSounds, PlayerPawn P )
{
	if( bPauseable || Level.Netmode==NM_Standalone )
	{
		if( bPause )
		{
			Level.bDisableAmbientSound = bPauseAmbientSounds;
			Level.Pauser = InternalPauserString;
			if( P != None && P.Player != None && P.Player.Console != None )
			{
				P.Player.Console.PausedMessage="";
			}
		}
		else
		{
			Level.bDisableAmbientSound = false;
			Level.Pauser = "";
			if( P != None && P.Player != None && P.Player.Console != None )
			{
				P.Player.Console.PausedMessage=class'Console'.default.PausedMessage;
			}
		}
	}
}

//=============================================================================
function SendPlayer( PlayerPawn aPlayer, string URL )
{
	WOTPlayer(aPlayer).SetTransitionType( TRT_EndOfLevel );

	Super.SendPlayer( aPlayer, URL );
}

//=============================================================================
function bool ShouldRestartLevel()
{
	return bShouldRestartLevel;
}

//=============================================================================
function VoteRequest( WOTPlayer Player, string Request )
{
	local int A, B;
	local int i;
	local int NumPlayers, NumVotes;
	local Pawn P;
	local bool bAdmin;

	// Normalize requests.
	Request = caps(Request);

	// Validate input.
	for( i = 0; i < ArrayCount(AuthorizedVoteRequests); i++ )
		if( AuthorizedVoteRequests[i] != "" )
			if( InStr( Request, AuthorizedVoteRequests[i]	) >= 0 )
				goto ValidRequest;

	Player.CenterMessage( VoteStr001 );
	return;

ValidRequest:	// Bad coder?

	// First try to find existing vote.
	for( i = 0; i < ArrayCount(Votes); i++ )
	{
		if( Votes[i].Request == Request )
		{
			Votes[i].Voters = Votes[i].Voters$"/"$string(Player);
			break;
		}
	}

	// If not found, then add new in empty slot.
	if( i == ArrayCount(Votes) )
	{
		for( i = 0; i < ArrayCount(Votes); i++ )
		{
			if( Votes[i].Request == "" )
			{
				A = int(VoteRequestTimeout/60.0);
				B = int(VoteRequestTimeout/6.0) - A*10;

				Player.BroadcastCenterMessage( VoteStr002$A$"."$B$VoteStr003 );
				
				Votes[i].Request = Request;
				Votes[i].Voters = "/"$string(Player);
				Votes[i].ExpireTime = Level.TimeSeconds + VoteRequestTimeout;

				break;
			}
		}
	}

	// If we ran out of room.
	if( i == ArrayCount(Votes) )
	{
		Player.BroadcastCenterMessage( VoteStr004 );
		Player.BroadcastCenterMessage( VoteStr005 );

		return;
	}

	// Check totals.
	for( P = Level.PawnList; P != None; P = P.NextPawn )
	{
		if( (WOTPlayer(P) != None) && (WOTPlayer(P).Player.ClientEngineVersion >= MinVotingEngineVersion) )
			NumPlayers++;
		if( InStr( Votes[i].Voters, string(P) ) >= 0 )
			NumVotes++;
	}

	Player.BroadcastCenterMessage( VoteStr006$Request$VoteStr007$Player.PlayerReplicationInfo.PlayerName$" ("$NumVotes$"/"$NumPlayers$")" );

	// If we have majority, then execute and reset request (0 = vote in singleplayer?)
	if( (NumPlayers == 0) || ((float(NumVotes) / float(NumPlayers)) >= 2.0/3.0) )
	{
		// Execute request.
		if( Request ~= "RESTARTSERVER" )
		{
			RestartGame();
		}
		else if( Left(Request, 4) ~= "OPEN" )
		{
			Level.ServerTravel( Mid(Request, 5), false );
		}
		else if( NumPlayers > 1 ) // So you can't cheat and do stuff like VOTE AllAngreal 1 or Kick when you're the only one on the server.  Plus, you shouldn't need to be able to kick yourself from a server.
		{
			bAdmin = Player.bAdmin;
			Player.bAdmin = true;
			Player.ConsoleCommand( Request );
			Player.bAdmin = bAdmin;
		}

		ResetRequest( i );
	}
}

//=============================================================================
function ResetRequest( int i )
{
	Votes[i].Request = "";
	Votes[i].Voters = "";
	Votes[i].ExpireTime = 0.0;
}

//=============================================================================
function Tick( float DeltaTime )
{
	local int i;
	local Pawn P;

	Super.Tick( DeltaTime );

	for( i = 0; i < ArrayCount(Votes); i++ )
	{
		if( Votes[i].Request != "" )
		{
			Votes[i].ExpireTime -= DeltaTime;
			if( Votes[i].ExpireTime <= 0.0 )
			{
				for( P = Level.PawnList; P != None; P = P.NextPawn )
				{
					if( WOTPlayer(P) != None )
					{
						WOTPlayer(P).BroadcastCenterMessage( VoteStr008$Votes[i].Request$VoteStr009 );
						break;
					}
				}

				ResetRequest( i );
			}
		}
	}
}

// end of giWOT.uc

defaultproperties
{
     SuicideInstigationRelevance=3.000000
     bShowInventoryHints=True
     bHintOnly=True
     VoteRequestTimeout=90.000000
     AuthorizedVoteRequests(0)="RESTARTSERVER"
     AuthorizedVoteRequests(1)="KICK"
     AuthorizedVoteRequests(2)="KICKBAN"
     AuthorizedVoteRequests(3)="OPEN"
     VoteStr001="Invalid Vote Request."
     VoteStr002="(expires in "
     VoteStr003=" minutes)"
     VoteStr004="(wait for other requests to time out first before re-requesting)"
     VoteStr005="VOTE REQUEST LIMIT EXCEEDED"
     VoteStr006="VOTE REQUEST: "
     VoteStr007=" by "
     VoteStr008="VOTE REQUEST: "
     VoteStr009=" EXPIRED"
     HUDType=Class'WOT.MainHUD'
}
