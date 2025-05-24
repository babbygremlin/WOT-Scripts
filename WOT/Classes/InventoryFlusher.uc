//------------------------------------------------------------------------------
// InventoryFlusher.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//
// Description:	Used to clear the Instigator's Inventory.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Just trigger it.  The Instigator's Inventory will all be removed.
//------------------------------------------------------------------------------
class InventoryFlusher expands KeyPoint;

var() name NonRemoveableTypes[16];
var() name RemoveableTypes[16];
var() bool bRemoveAll;	// Removes all except those that are non-removable.

//------------------------------------------------------------------------------
function Trigger( Actor Other, Pawn EventInstigator )
{
	local Inventory Inv, NextInv;

	Inv = EventInstigator.Inventory;
	while( Inv != None )
	{
		NextInv = Inv.Inventory;

		if( IsRemoveable( Inv ) || (bRemoveAll && !IsNonRemoveable( Inv )) )
		{
			EventInstigator.DeleteInventory( Inv );
			if( AngrealInventory(Inv) != None && AngrealInventory(Inv).bPuzzleRespawn )
			{
				AngrealInventory(Inv).PuzzleRespawn();
			}
		}

		Inv = NextInv;
	}
}

//------------------------------------------------------------------------------
function bool IsRemoveable( Inventory Inv )
{
	local int i;

	for( i = 0; i < ArrayCount(RemoveableTypes); i++ )
		if( RemoveableTypes[i] != '' && Inv.IsA( RemoveableTypes[i] ) )
			return true;

	return false;
}

//------------------------------------------------------------------------------
function bool IsNonRemoveable( Inventory Inv )
{
	local int i;

	for( i = 0; i < ArrayCount(NonRemoveableTypes); i++ )
		if( NonRemoveableTypes[i] != '' && Inv.IsA( NonRemoveableTypes[i] ) )
			return true;

	return false;
}

defaultproperties
{
     NonRemoveableTypes(0)=AngrealInvAirBurst
     bRemoveAll=True
     bStatic=False
}
