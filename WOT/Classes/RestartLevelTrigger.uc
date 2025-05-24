//=============================================================================
// RestartLevelTrigger.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//
//=============================================================================
class RestartLevelTrigger expands Trigger;

//=============================================================================
// If triggered restarts the current level.
//=============================================================================

var() float RestartLevelDelaySecs;

//=============================================================================

function Trigger( Actor Other, Pawn EventInstigator )
{
	GotoState( 'RestartLevelAfterDelay' );
}

//=============================================================================

state() RestartLevelAfterDelay
{
	function RestartLevel()
	{
		local WOTPlayer WP;

		foreach AllActors( class'WOTPlayer', WP )
		{
			WP.PlayerRestartLevel();
		}
	}

Begin:
	Disable( 'Touch' );
	Disable( 'Trigger' );
	
	Sleep( RestartLevelDelaySecs );
	RestartLevel();
	
	Enable( 'Trigger' );
	Enable( 'Touch' );
}

defaultproperties
{
}
