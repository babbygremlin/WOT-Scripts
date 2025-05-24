//------------------------------------------------------------------------------
// DecreaseUncommonChargesLeech.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	Decreases the victim's uncommon angreal charges over time.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Since just one charge is used per iteration, make sure you set its
//   AffectResolution to how often you want that one charge taken away.
//------------------------------------------------------------------------------
class DecreaseUncommonChargesLeech expands Leech;

function AffectHost( optional int Iterations )
{
	local Inventory Inv;

	if( Owner != None && Pawn(Owner).Health > 0 )
	{
		// Iterate through all its inventory.
		for( Inv = Pawn(Owner).Inventory;
			 Inv != None;
			 Inv = Inv.Inventory )
		{
			// If you find a ter'angreal and it is uncommon.
			if( AngrealInventory(Inv) != None && AngrealInventory(Inv).bUncommon )
			{
				//AngrealInventory(Inv).UseCharge();
				AngrealInventory(Inv).CurCharges -= 1;
				if( AngrealInventory(Inv).CurCharges <= 0 )
				{
					AngrealInventory(Inv).UnCast();
					AngrealInventory(Inv).GoEmpty();
				}
			}
		}
	}
	else
	{
		Unattach();
	}
}

defaultproperties
{
    AffectResolution=3.00
    bDeleterious=True
}
