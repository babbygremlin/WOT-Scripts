//------------------------------------------------------------------------------
// DefaultHealthReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//
// Description:	Adds Health to a player.  Takes care of all checking for 
//				deadness, full health, etc.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Install in a WOTPlayer or WOTPawn at start-up using the Install() function.
//------------------------------------------------------------------------------
class DefaultHealthReflector expands Reflector;

/////////////////////////
// Overriden Functions //
/////////////////////////

//-----------------------------------------------------------------------------
// Increases the health of the pawn by the given amount.
//-----------------------------------------------------------------------------
function IncreaseHealth( int Amount )
{
	// If our host is still alive.
	if( Pawn(Owner).Health > 0 )
	{
		// Add the health.
		Pawn(Owner).Health += Amount;

		// Limit it to 100.
		Pawn(Owner).Health = Min( Pawn(Owner).Health, 100 );
	}

	// The buck stops here, don't call any other reflectors.
}

defaultproperties
{
     bRemovable=False
     bDisplayIcon=False
}
