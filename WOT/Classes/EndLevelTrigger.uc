//=============================================================================
// EndLevelTrigger.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//
//=============================================================================
class EndLevelTrigger expands Trigger;

//=============================================================================
// If triggered ends the current level.
//=============================================================================

function EndLevel( WOTPlayer WP )
{
	WP.PlayerEndLevel();
}

//=============================================================================

function Trigger( Actor Other, Pawn EventInstigator )
{
	local WOTPlayer WP;

	foreach AllActors( class'WOTPlayer', WP )
	{
		if( WP.Health > 0 )
		{
			EndLevel( WP );
		}
	}
}

defaultproperties
{
}
