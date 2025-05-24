//=============================================================================
// giTutorial.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 5 $
//=============================================================================
class giTutorial expands giMission;

/*=============================================================================
Each time the player picks up a type of inventory for the first time, show the
inventory information screen for that inventory item.
=============================================================================*/

function bool CanEditCitadel()
{
	return true;
}

function bool PickupQuery( Pawn Other, Inventory Item )
{
	// don't allow pickups while editing (to avoid confusion about seal pickups)
	if( WOTPlayer(Other) != None && WOTPlayer(Other).bEditing )
	{
		return false;
	}

	return Super.PickupQuery( Other, Item );
}

// Note: Same as giMission_NoInv.uc	
function AcceptInventory( pawn PlayerPawn )
{
	local inventory Inv;

	if( WOTPlayer(PlayerPawn) != None && !WOTPlayer(PlayerPawn).bAcceptedInventory )
	{	
		// Don't accept inventory.
		for( Inv = PlayerPawn.Inventory; Inv != None; Inv = Inv.Inventory )
			Inv.Destroy();
		PlayerPawn.Weapon = None;
		PlayerPawn.SelectedItem = None;

		AddDefaultInventory( PlayerPawn );

		// Mark as accepted (this will *not* carry over into the next level... just saved games).
		WOTPlayer(PlayerPawn).bAcceptedInventory = true;
	}
}

// Note: Same as giMission_NoInv.uc
function AddDefaultInventory( pawn PlayerPawn )
{
	local BagHolding Bag;

	// Bypass normal default inventory giving.
	Super(GameInfo).AddDefaultInventory( PlayerPawn );

	// Search for bag of extra stuff to give to player.
	foreach AllActors( class'BagHolding', Bag, 'AdditionalInitialInventory' ) 
		Bag.GiveTo( PlayerPawn );
}

// end of giTutorial.uc

defaultproperties
{
     bShouldRestartLevel=True
}
