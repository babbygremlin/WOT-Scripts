//------------------------------------------------------------------------------
// DefaultWOTPawnCastReflector
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//
// Description:	Handles calls to UseAngreal and CeaseUsingAngreal in the
//				default manner for WOTPawns.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Install in a WOTPawn at start-up using the Install() function.
//------------------------------------------------------------------------------
class DefaultWOTPawnCastReflector expands Reflector;

/////////////////////////
// Overriden Functions //
/////////////////////////

const DONT_USE_THIS_CLASS = false;

//-----------------------------------------------------------------------------
function Install( Pawn NewHost )
{
	assert(DONT_USE_THIS_CLASS);	// Use DefaultCastReflector instead.
}

//-----------------------------------------------------------------------------
// Turn the currently selected angreal on.
//-----------------------------------------------------------------------------
function UseAngreal()
{
	if( AngrealInventory(WOTPawn(Owner).SelectedItem) != None )
	{
		AngrealInventory(WOTPawn(Owner).SelectedItem).Cast();
		WOTPawn(Owner).PlayFiring();
	}

	// Pass control off to next reflector.
	Super.UseAngreal();
}

//-----------------------------------------------------------------------------
// Turn the currently selected angreal off.
//-----------------------------------------------------------------------------
function CeaseUsingAngreal()
{
	if( AngrealInventory(WOTPawn(Owner).SelectedItem) != None )
	{
		AngrealInventory(WOTPawn(Owner).SelectedItem).UnCast();
	}

	// Pass control off to next reflector.
	Super.CeaseUsingAngreal();
}

defaultproperties
{
     bRemovable=False
     bDisplayIcon=False
}
