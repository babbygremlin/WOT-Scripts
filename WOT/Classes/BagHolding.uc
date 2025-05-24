//------------------------------------------------------------------------------
// BagHolding.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 13 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//------------------------------------------------------------------------------
class BagHolding expands Inventory;

#exec MESH IMPORT MESH=BagHolding ANIVFILE=MODELS\BagHolding_a.3d DATAFILE=MODELS\BagHolding_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=BagHolding X=0 Y=0 Z=320

#exec MESH SEQUENCE MESH=BagHolding SEQ=All        STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JBagHolding1 FILE=MODELS\BagHolding1.PCX GROUP=Skins FLAGS=2 // BAG

#exec MESHMAP NEW   MESHMAP=BagHolding MESH=BagHolding
#exec MESHMAP SCALE MESHMAP=BagHolding X=0.02 Y=0.02 Z=0.04

#exec MESHMAP SETTEXTURE MESHMAP=BagHolding NUM=1 TEXTURE=JBagHolding1

var() class<Inventory> Contents[40];
var Inventory Items[40];

var bool bInitialized;

var Pawn WaitingPawn;	// The Pawn that is waiting to receive this bag.

//------------------------------------------------------------------------------
function Tick( float DeltaTime )
{
	if( !bInitialized )
	{
		bInitialized = true;

		// We have to wait until the first tick before collecting items 
		// to ensure that items placed in the level by LDs have their 
		// initial state set first.
		CollectItems();
	}

	if( WaitingPawn != None )
	{
		GiveTo( WaitingPawn );
		WaitingPawn = None;
	}
}

//------------------------------------------------------------------------------
function CollectItems()
{
	local Inventory Inv;

	Super.BeginPlay();

	if( Event != '' )
		foreach AllActors( class'Inventory', Inv, Event )
			AddItem( Inv );
}

//------------------------------------------------------------------------------
// Add an item to the contents of this bag.
// If the bag is full, it returns false indicating failure to add item to contents.
//------------------------------------------------------------------------------
function bool AddContent( class<Inventory> Content )
{
	local int i;
	local bool bAdded;
	
	for( i = 0; i < ArrayCount(Contents); i++ )
	{
		if( Contents[i] == None )
		{
			Contents[i] = Content;
			bAdded = true;
			break;
		}
	}

	return bAdded;
}

//------------------------------------------------------------------------------
// Same as AddContent, but takes and actual instance instead of a class.
//------------------------------------------------------------------------------
function bool AddItem( Inventory Item )
{
	local int i;
	local bool bAdded;
	
	for( i = 0; i < ArrayCount(Items); i++ )
	{
		if( Items[i] == None )
		{
			Item.BecomeItem();
			Items[i] = Item;
			if( AngrealInventory(Item) != None )
			{
				AngrealInventory(Item).NotifyPutInBag( Self );
			}
			bAdded = true;
			break;
		}
	}

	return bAdded;
}

//------------------------------------------------------------------------------
// If we are touched by a pawn, give our contents to him/her and destroy ourself.
//------------------------------------------------------------------------------
function GiveTo( Pawn Other )
{
	local int i;
	local Inventory Item;

	if( !bInitialized )
	{
		if( WaitingPawn != None )
		{
			warn( WaitingPawn$" was bumped in favor of "$Other );
		}
		WaitingPawn = Other;
		return;	// Wait until we are initialized.
	}

	for( i = 0; i < ArrayCount(Contents); i++ )
	{
		if( Contents[i] != None )
		{
			Item = Spawn( Contents[i] );
			if( Level.Game.PickupQuery( Other, Item ) )
			{
				Item.GiveTo( Other );
			}
			else
			{
				Item.Destroy();
			}
			Contents[i] = None;
		}
	}
	for( i = 0; i < ArrayCount(Items); i++ )
	{
		if( Items[i] != None )
		{
			if( Level.Game.PickupQuery( Other, Items[i] ) )
			{
				Items[i].GiveTo( Other );
			}
			else
			{
				Items[i].Destroy();
			}
			Items[i] = None;
		}
	}

	bHidden = true;
	GotoState( 'DestroyBag' );
}



state DestroyBag
{
	Ignores Touch;
	
Begin:
	Sleep( 0.2 );
	Destroy();
}

defaultproperties
{
     PickupMessage="You found a bag."
     PickupViewMesh=Mesh'WOT.BagHolding'
     PickupViewScale=2.500000
     PickupSound=Sound'WOT.Player.Pickup'
     bCanTeleport=True
     Mesh=Mesh'WOT.BagHolding'
     DrawScale=2.500000
}
