//=============================================================================
// giMission_NoInv.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//=============================================================================
class giMission_NoInv expands giMission;

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

function AddDefaultInventory( pawn PlayerPawn )
{
	local BagHolding Bag;

	// Bypass normal default inventory giving.
	Super(GameInfo).AddDefaultInventory( PlayerPawn );

	// Search for bag of extra stuff to give to player.
	foreach AllActors( class'BagHolding', Bag, 'AdditionalInitialInventory' ) 
		Bag.GiveTo( PlayerPawn );
}

// end of giMission_NoInv.uc

defaultproperties
{
}
