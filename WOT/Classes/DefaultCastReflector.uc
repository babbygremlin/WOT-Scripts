//------------------------------------------------------------------------------
// DefaultCastReflector
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 9 $
//
// Description:	Handles calls to UseAngreal and CeaseUsingAngreal in the
//				default manner for Pawns.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Install in a WOTPlayer at start-up using the Install() function.
//------------------------------------------------------------------------------
class DefaultCastReflector expands Reflector;

var float NextFireTime;	// When we are allowed to fire next.
var AngrealInventory LastCastAngrealInventory;

var bool bLastCastSuccess;

/////////////////////////
// Overriden Functions //
/////////////////////////

//-----------------------------------------------------------------------------
// Turn the currently selected angreal on / "apply" the currently selected item.
//-----------------------------------------------------------------------------
function UseAngreal()
{
	if( AngrealInventory(Pawn(Owner).SelectedItem) != None && Level.TimeSeconds > NextFireTime )
	{
		// Make sure that we aren't currently firing something.
		CeaseUsingAngreal();

		LastCastAngrealInventory = AngrealInventory(Pawn(Owner).SelectedItem);	

		if( LastCastAngrealInventory != None )
		{
			bLastCastSuccess = true;	// Invalidate.

			LastCastAngrealInventory.Cast();
			Pawn(Owner).PlayFiring();

			// Only restrict usage if successfully fired.
			if( bLastCastSuccess )
			{
				NextFireTime = Level.TimeSeconds;	// Don't allow firing again this tick.
				if( LastCastAngrealInventory.bRestrictsUsage )
				{
					NextFireTime += (60.0 / LastCastAngrealInventory.RoundsPerMinute);
				}
			}
		}
	}
	else if( WOTPlayer(Owner) != None && Seal(WOTPlayer(Owner).SelectedItem) != None )
	{
		WOTPlayer(Owner).Drop();
	}

	// Pass control off to next reflector.
	Super.UseAngreal();
}

//-----------------------------------------------------------------------------
function NotifyCastFailed( AngrealInventory FailedArtifact )
{
	bLastCastSuccess = false;

	// Pass control off to next reflector.
	Super.NotifyCastFailed( FailedArtifact );
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
     bLastCastSuccess=True
     bRemovable=False
     bDisplayIcon=False
}
