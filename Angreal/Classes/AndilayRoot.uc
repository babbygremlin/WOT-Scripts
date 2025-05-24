//------------------------------------------------------------------------------
// AndilayRoot.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 7 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
// + Set Min and Max Charges to the amount of health points you want the
//   root to give to the player.
//------------------------------------------------------------------------------
class AndilayRoot expands LeechAttacher;

#exec MESH    IMPORT     MESH=AndilayRoot ANIVFILE=MODELS\AndilayRoot_a.3D DATAFILE=MODELS\AndilayRoot_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=AndilayRoot X=0 Y=0 Z=70 PITCH=0 YAW=0 ROLL=0

#exec MESH    SEQUENCE   MESH=AndilayRoot SEQ=All  STARTFRAME=0  NUMFRAMES=1

#exec TEXTURE IMPORT     NAME=JAndilayRoot FILE=MODELS\AndilayRoot0.PCX GROUP=Skins FLAGS=2

#exec MESHMAP NEW        MESHMAP=AndilayRoot MESH=AndilayRoot
#exec MESHMAP SCALE      MESHMAP=AndilayRoot X=0.1 Y=0.1 Z=0.2
#exec MESHMAP SETTEXTURE MESHMAP=AndilayRoot NUM=1 TEXTURE=JAndilayRoot

#exec TEXTURE IMPORT FILE=Icons\I_AndilayRoot.pcx	GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_AndilayRoot.pcx	GROUP=Icons MIPS=Off

#exec AUDIO IMPORT FILE=Sounds\AndilayRoot\ActivateAR.wav	GROUP=AndilayRoot

//------------------------------------------------------------------------------
auto state PickUp
{
	function Touch( Actor Other )
	{
		// Only give to pawns that need it. (allow them to pick up one at full health)
		if( Pawn(Other) != None )
		{
			if( GetPotentialHealth( Pawn(Other) ) <= Pawn(Other).default.Health )
			{
				Super.Touch( Other );
			}
		}
		else
		{
			Super.Touch( Other );
		}
	}
}

//------------------------------------------------------------------------------
function GiveTo( Pawn Other )
{
	local int NumCharges;
	
	local Leech L;
	local LeechIterator IterL;
	
	local Actor StoredOwner;

	// Only give to pawns that need it.
	if( GetPotentialHealth( Other ) <= Other.default.Health )
	{
		Super.GiveTo( Other );

		// Automatically cast when we are picked up.
		if( Other == Owner )
		{
			// Store for later.
			NumCharges = CurCharges;
			StoredOwner = Owner;

			ChargeCost = CurCharges;	// Use up all charges.
			Cast();	// Warning: This will set our Owner to None and our charges to zero, and a bunch of other bad things.

			// Find installed leech and add charges.
			IterL = class'LeechIterator'.static.GetIteratorFor( Pawn(StoredOwner) );
			for( IterL.First(); !IterL.IsDone(); IterL.Next() )
			{
				L = IterL.GetCurrent();

				if( AndilayRootLeech(L) != None )
				{
					AndilayRootLeech(L).GiveCharges( NumCharges );
					break;	// There will only ever be one.
				}
			}
			IterL.Reset();
			IterL = None;
		}
	}
}

//------------------------------------------------------------------------------
function int GetPotentialHealth( Pawn Other )
{
	local Leech IterL;
	local int AdditionalAndilayHealth;

	if( WOTPlayer(Other) != None )
	{
		IterL = WOTPlayer(Other).FirstLeech;
	}
	else if( WOTPawn(Other) != None )
	{
		IterL = WOTPawn(Other).FirstLeech;
	}
	while( IterL != None )
	{
		if( AndilayRootLeech(IterL) != None )
		{
			AdditionalAndilayHealth += AndilayRootLeech(IterL).NumCharges;
		}
		IterL = IterL.NextLeech;
	}

	return Other.Health + AdditionalAndilayHealth;
}

defaultproperties
{
    LeechClasses=Class'AndilayRootLeech'
    DurationType=1
    TAINT_COMMON_DAMAGE=0
    TAINT_UNCOMMON_DAMAGE=0
    TAINT_RARE_DAMAGE=0
    MinInitialCharges=15
    MaxInitialCharges=20
    ActivateSoundName="Angreal.ActivateAR"
    Title="Andilay Root"
    Description="None"
    Quote="None"
    StatusIconFrame=Texture'Icons.M_AndilayRoot'
    InventoryGroup=50
    bAmbientGlow=False
    PickupMessage="You found an Andilay Root"
    PickupViewMesh=Mesh'AndilayRoot'
    StatusIcon=Texture'Icons.I_AndilayRoot'
    PickupSound=None
    Texture=None
    Mesh=Mesh'AndilayRoot'
    AmbientGlow=0
    CollisionRadius=10.00
    CollisionHeight=16.00
    bFixedRotationDir=False
    RotationRate=(Pitch=0,Yaw=0,Roll=0),
}
