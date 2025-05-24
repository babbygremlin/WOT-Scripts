//------------------------------------------------------------------------------
// DefaultWOTPlayerCastReflector
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//
// Description:	Handles calls to UseAngreal and CeaseUsingAngreal in the
//				default manner for WOTPlayers.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Install in a WOTPlayer at start-up using the Install() function.
//------------------------------------------------------------------------------
class DefaultWOTPlayerCastReflector expands Reflector;

var float LastFiredTime;		// last time an angreal was successfully fired
var AngrealInventory LastCastAngrealInventory;

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
	if( AngrealInventory(WOTPlayer(Owner).SelectedItem) != None && Level.TimeSeconds > LastFiredTime )
	{
		// make sure that we aren't currently firing something
		CeaseUsingAngreal();

		LastCastAngrealInventory = AngrealInventory(WOTPlayer(Owner).SelectedItem);	

		if( LastCastAngrealInventory != None )
		{
			LastCastAngrealInventory.Cast();
			WOTPlayer(Owner).PlayFiring();
			LastFiredTime = Level.TimeSeconds;
		}
	}

	// Pass control off to next reflector.
	Super.UseAngreal();
}

//-----------------------------------------------------------------------------
// Turn the currently selected angreal off.
//-----------------------------------------------------------------------------
function CeaseUsingAngreal()
{
	if( LastCastAngrealInventory != None )
	{
		LastCastAngrealInventory.UnCast();
	}

	// Pass control off to next reflector.
	Super.CeaseUsingAngreal();
}

defaultproperties
{
     bRemovable=False
     bDisplayIcon=False
}
