//------------------------------------------------------------------------------
// AngrealInvTracer.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 9 $
//
// Description:	Leaves a trail to the nearest seal, which slowly fades when it 
//				finally connects to it.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AngrealInvTracer expands ProjectileLauncher;

#exec MESH IMPORT MESH=AngrealTracerPickup ANIVFILE=MODELS\AngrealTracer_a.3D DATAFILE=MODELS\AngrealTracer_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=AngrealTracerPickup X=0 Y=0 Z=0 Roll=-32

#exec MESH SEQUENCE MESH=AngrealTracerPickup SEQ=All       STARTFRAME=0   NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JAngrealTracer1 FILE=MODELS\AngrealTracer.PCX GROUP=Skins FLAGS=2

#exec MESHMAP NEW   MESHMAP=AngrealTracerPickup MESH=AngrealTracerPickup
#exec MESHMAP SCALE MESHMAP=AngrealTracerPickup X=0.03 Y=0.03 Z=0.06

#exec MESHMAP SETTEXTURE MESHMAP=AngrealTracerPickup NUM=1 TEXTURE=JAngrealTracer1

#exec TEXTURE IMPORT FILE=ICONS\I_Tracer.pcx GROUP=Icons MIPS=Off
#exec TEXTURE IMPORT FILE=ICONS\M_Tracer.pcx GROUP=Icons MIPS=Off

var PathNodeIteratorII PNI;

//------------------------------------------------------------------------------
// Finds the closest seal.
// Ignores any seals that your are holding.
// If a player is holding the 
//------------------------------------------------------------------------------
function Actor GetBestTarget()
{
	local Seal iSeal; 
	local float iCost;

	local Pawn iPawn;

	local Actor BestSeal, BestUnReachableSeal;
	local float BestCost, BestUnReachableCost;

	if( PNI == None )
	{
		PNI = Spawn( class'PathNodeIteratorII' );
	}

	// Check all the seals that aren't currently being carried.
	foreach AllActors( class'Seal', iSeal )
	{
		if( iSeal.GetStateName() == 'Pickup' )
		{
			if( CanDirectlyReach( iSeal.Location, Owner.Location ) )
			{
				iCost = VSize( iSeal.Location - Owner.Location );
				if( BestSeal == None || iCost < BestCost )
				{
					BestSeal = iSeal;
					BestCost = iCost;
				}
			}
			else if( PNI.BuildPath( Owner.Location, iSeal.Location, true ) )
			{
				iCost = PNI.NodeCost;
				if( BestSeal == None || iCost < BestCost )
				{
					BestSeal = iSeal;
					BestCost = iCost;
				}
			}
			else
			{
				iCost = VSize( iSeal.Location - Owner.Location );
				if( BestUnReachableSeal == None || iCost < BestUnReachableCost )
				{
					BestUnReachableSeal = iSeal;
					BestUnReachableCost = iCost;
				}
			}
		}
	}

	// Check all the seals that are being carried.
	for( iPawn = Level.PawnList; iPawn != None; iPawn = iPawn.NextPawn )
	{
		if( iPawn.FindInventoryType( class'Seal' ) != None )
		{
			if( CanDirectlyReach( iPawn.Location, Owner.Location ) )
			{
				iCost = VSize( iPawn.Location - Owner.Location );
				if( BestSeal == None || iCost < BestCost )
				{
					BestSeal = iPawn;
					BestCost = iCost;
				}
			}
			else if( PNI.BuildPath( Owner.Location, iPawn.Location, true ) )
			{
				iCost = PNI.NodeCost;
				if( BestSeal == None || iCost < BestCost )
				{
					BestSeal = iPawn;
					BestCost = iCost;
				}
			}
			else
			{
				iCost = VSize( iPawn.Location - Owner.Location );
				if( BestUnReachableSeal == None || iCost < BestUnReachableCost )
				{
					BestUnReachableSeal = iPawn;
					BestUnReachableCost = iCost;
				}
			}
		}
	}

	if( BestSeal == None )
	{
		BestSeal = BestUnReachableSeal;
	}

	return BestSeal;
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( PNI != None )
	{
		PNI.Destroy();
		PNI = None;
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
// Returns true if we can reach the location "To" from the location "From"
// without hitting any geometry on the way.
//------------------------------------------------------------------------------
simulated function bool CanDirectlyReach( vector To, vector From )
{
	local vector HitLocation, HitNormal;
	local Actor HitActor;

	HitActor = Trace(	HitLocation, 
						HitNormal, 
						To,
						From, 
						false	// Don't trace Actors
					);

	return (HitActor == None);
}

defaultproperties
{
    ProjectileClassName="Angreal.AngrealTracerProjectile"
    bElementFire=True
    bElementAir=True
    bRare=True
    bInfo=True
    MinInitialCharges=2
    MaxInitialCharges=4
    MaxCharges=10
    MaxChargesInGroup=5
    MinChargeGroupInterval=6.00
    Title="Tracer"
    Description="Tracer creates a weave that seeks out the nearest seal, leaving behind a fiery trail. When the weave eventually touches the seal, the trail slowly fades away."
    Quote="Rolling onto his back, he could see the remnants of those burning red wires still, fresh enough to make out Fire and Air woven in a way he had not known. Enough to make out exactly the direction they had come from."
    StatusIconFrame=Texture'Icons.M_Tracer'
    PickupMessage="You got the Tracer ter'angreal"
    PickupViewMesh=Mesh'AngrealTracerPickup'
    StatusIcon=Texture'Icons.I_Tracer'
    Texture=None
    Skin=Texture'Skins.JAngrealTracer1'
    Mesh=Mesh'AngrealTracerPickup'
}
