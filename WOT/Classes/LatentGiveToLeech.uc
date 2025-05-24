//------------------------------------------------------------------------------
// LatentGiveToLeech.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//
// Description:	Allows you to give the specified item to our owner after an
//				alloted period of time.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Spawn (do all your funky Leech related stuff - AttachTo, etc).
//   (Call to SetSourceAngreal *not* required.)
// + Set Inventory item to give to owner.
// + Set AffectResolution to the delay time.
//
//------------------------------------------------------------------------------
class LatentGiveToLeech expands Leech;

var() class<Inventory> ItemType;	// May be none.
var Inventory Item;					// If set, overrides use of ItemType.

//------------------------------------------------------------------------------
function AffectHost( optional int Iterations )
{
	if( Pawn(Owner) != None && (Item != None || ItemType != None) )
	{
		if( Item == None )
		{
			Item = Spawn( ItemType );
		}

		if( Level.Game.PickupQuery( Pawn(Owner), Item ) )
		{
			Item.GiveTo( Pawn(Owner) );
		}
		else
		{
			Item.Destroy();
		}
	}

	UnAttach();
	Destroy();
}

defaultproperties
{
     AffectResolution=15.000000
     bRemovable=False
     LifeSpan=10000.000000
}
