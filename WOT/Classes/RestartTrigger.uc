//=============================================================================
// RestartTrigger.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//=============================================================================
class RestartTrigger expands Trigger;

var() float RestartDelay;					// this value should be half the desired resart delay
var() bool bIgnoreProximity;				// are we allowed to restart while near a playerstart?

const RESTART_TRIGGER_RESET_PERIOD = 1;		// reset the RestartTrigger after this many seconds
const RESTART_INHIBIT_RADIUS = 320;			// don't restart the level if the player is close to the start

var vector LastPlayerLocation;
var rotator LastPlayerRotation;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	ResetTimer();
}

function ResetTimer()
{
	SetTimer( RestartDelay, false );
}

function bool IsPlayerInactive( PlayerPawn P )
{
	local bool bActive;
	local PlayerStart S;

	// if menu is displayed, don't restart
	if( P.bShowMenu )
	{
		bActive = true;
	}

	// don't restart when the player is in proximity to the PlayerStart
	if( !bIgnoreProximity )
	{
		foreach RadiusActors( class'PlayerStart', S, RESTART_INHIBIT_RADIUS, P.Location )
		{
			bActive = true;
		}
	}

	// if player moved, don't restart
	if( LastPlayerLocation != P.Location || LastPlayerRotation != P.ViewRotation )
	{
		bActive = true;
	}
	LastPlayerLocation = P.Location;
	LastPlayerRotation = P.ViewRotation;

	return !bActive;
}

function Timer()
{
	local PlayerPawn P;

	foreach AllActors( class'PlayerPawn', P )
	{
		if( IsPlayerInactive( P ) )
			Trigger( P, P );
		else
			ResetTimer();
		break;
	}
}

state() RestartTrigger
{
	function Trigger( actor Other, pawn Instigator )
	{
		//assert( PlayerPawn(Instigator) != None );
		Self.Instigator = Instigator;
		GotoState( 'RestartTrigger', 'Restart' );
	}

Restart:
	WOTPlayer(Instigator).LeftMessage( "Restarting..." );
	Sleep( 3 );
	WOTPlayer(Instigator).ServerRestartPlayer();
}

// end of RestartTrigger.uc

defaultproperties
{
     RestartDelay=6.000000
     InitialState=RestartTrigger
     CollisionRadius=80.000000
}
