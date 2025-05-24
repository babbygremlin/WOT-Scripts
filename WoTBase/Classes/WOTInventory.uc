//------------------------------------------------------------------------------
// WOTInventory.uc
// $Author: Mpoesch $
// $Date: 10/16/99 3:59a $
// $Revision: 9 $
//
// Description:	Supports display of inventory in HUDs
//
//------------------------------------------------------------------------------
class WOTInventory expands Inventory
	abstract;

#exec TEXTURE IMPORT FILE=Icons\I.pcx          GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\S.pcx          GROUP=Icons MIPS=Off FLAGS=2
#exec TEXTURE IMPORT FILE=Icons\M.pcx          GROUP=Icons MIPS=Off FLAGS=2

var() localized string		Title;			// Inventory UI title
var() localized string		Description;	// Inventory UI description text
var() localized string		Quote;			// Inventory UI "experience" quote describing the Angreal effect

var() texture StatusIconSelected;			// Icon used for large inventory when selected
var() texture StatusIconFrame;				// Icon used for large (or small) inventory
var() bool bShowInfoHint;					// If set, when inventory item is picked up, info screen will pop up for that inventory item

var class<Actor> ResourceClass;		// the concrete class contained in this adapter
var name BaseResourceType;			// the base class name (Grunt, Captain, Champion) for all pawn resources -- not all Champions derive from Champion

var bool SpawnTempResource;
var int Count;

replication
{
	// Data the server should send the client player -- this fixes the citadel editor hand replication (resource counts)
	reliable if( Role==ROLE_Authority && bNetOwner )
		StatusIconFrame, Count;
}

// This function call was taking up a lot of time, and since we never use it,
// there is no reason to have continue to slow us down.
function int ReduceDamage( int Damage, name DamageType, vector HitLocation )
{
	if( Damage<0 )
		return 0;
	else
		return Damage;
}

// keep items spawned by Angreal using NPCs from entering the Inventory.uc "auto Pickup" state
simulated event SetInitialState()
{
	if( !bHeldItem )
	{
		Super.SetInitialState();
	}
}

simulated function DrawStatusIconAt( Canvas C, int X, int Y, optional float Scale )
{
	LegendCanvas( C ).DrawIconAt( StatusIcon, X, Y, 1.0 );
}

defaultproperties
{
     Title="[Title Missing]"
     Description="[Description Missing]"
     Quote="[Quote Missing]"
     StatusIconSelected=Texture'WOTBase.Icons.S'
     StatusIconFrame=Texture'WOTBase.Icons.M'
     SpawnTempResource=True
     StatusIcon=Texture'WOTBase.Icons.i'
}
