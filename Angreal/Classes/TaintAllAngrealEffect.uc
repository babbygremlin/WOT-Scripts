//------------------------------------------------------------------------------
// TaintAllAngrealEffect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	Taints all the given Pawn's angreal.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Create it.
// + Set the Victim.
// + Hand it off to the Victim for processing via ProcessEffect().
//------------------------------------------------------------------------------
class TaintAllAngrealEffect expands SingleVictimEffect;

//------------------------------------------------------------------------------
// TakeDamage on my Victim.
//------------------------------------------------------------------------------
function Invoke()
{
	local Inventory Inv;

	if( Victim != None )
	{
		// Iterate through all the Victim's angreal and set their bTainted
		// flag to true.
		for( Inv = Victim.Inventory; Inv != None; Inv = Inv.Inventory )
		{
			if( AngrealInventory(Inv) != None )
			{
				AngrealInventory(Inv).bTainted = True;
				AngrealInventory(Inv).TaintInstigator = Instigator;
			}
		}
	}
}

defaultproperties
{
     bDeleterious=True
}
