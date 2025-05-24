//------------------------------------------------------------------------------
// AutoTargetReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 5 $
//
// Description:	Targets the closest, reachable, targetable Actor
//				regardless of distance or line-of-sight.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AutoTargetReflector expands DefaultTargetingReflector;

var PathNodeIteratorII PNI;

/////////////////////////
// Overriden Functions //
/////////////////////////

function Actor FindBestTarget( vector Loc, rotator ViewRot, float MaxAngleInDegrees, optional AngrealInventory UsingArtifact )
{
	local Actor BestTarget;
	local float BestDistance, IterDistance;
	local Actor IterA;
	local int i;

	// Must set ignored type before calling IsTagetable().
	Self.UsingArtifact = UsingArtifact;
	
	// Find the closest targetable actor.
	foreach AllActors( class'Actor', IterA )
	{
		if( IsTargetable( IterA ) )
		{
			IterDistance = VSize( IterA.Location - Owner.Location );
			if( BestTarget == None || IterDistance < BestDistance )
			{
				BestTarget = IterA;
				BestDistance = IterDistance;
			}
		}
	}

	return BestTarget;

/* TEST (Note: Comment out IsTargetable() below if using this code.)
	local TargetableItemSorter TargetSorter;
	local int i, ItemCount;
	local Actor BestTarget;

	local bool bIgnored, bReachable;	//!!TEMP

	DM( "### FindBestTarget ###" );

	TargetSorter = TargetableItemSorter( class'Singleton'.static.GetInstance( XLevel, class'TargetableItemSorter' ) );
	TargetSorter.TargetMaster = Self;
	TargetSorter.CollectAllItems( Owner, class'Actor' );
	TargetSorter.InitSorter();
	TargetSorter.SortReq.IR_Origin = Owner.Location;
	TargetSorter.SortItems();
		
	if( TargetSorter.GetItemCount( ItemCount ) )
	{
		for( i = 0; i < ItemCount; i++ )
		{
			BestTarget = TargetSorter.GetItem( i );
			DM( "Testing: "$BestTarget$" @ "$VSize( BestTarget.Location - Owner.Location ) );

			bIgnored = BestTarget.IsA( IgnoredType );
			bReachable = CanReachDestination( BestTarget.Location );

			DM( "bIgnored: "$bIgnored );
			DM( "bReachable: "$bReachable );

			if( !bIgnored && bReachable )
			//if( !BestTarget.IsA( IgnoredType ) && CanReachDestination( BestTarget.Location ) )
			{
				break;
			}
			else
			{
				BestTarget = None;
//				TargetSorter.RejectItem( i );
			}
		}
	}

	DM( "" );

	// Cleanup.
	TargetSorter.TargetMaster = None;
	
	return BestTarget;
*/
}

//------------------------------------------------------------------------------
function bool IsTargetable( Actor Other )
{
	return Super.IsTargetable( Other ) && CanReachDestination( Other.Location );
}

//////////////////////////////////////
// Ripped from SeekingProjectile.uc //
//////////////////////////////////////

//------------------------------------------------------------------------------
// Returns true if we can reach our destination using the path node network.
// (tries direct route first).
//------------------------------------------------------------------------------
simulated function bool CanReachDestination( vector Dest )
{
	local bool bIsReachable;

	bIsReachable = CanDirectlyReachDestination( Dest );

	if( !bIsReachable )
	{
		// Only build a PathNodeIterator if we need one.
		if( PNI == None )
		{
			PNI = Spawn( class'PathNodeIteratorII' );
		}

		// Build a path to the destination using the path nodes in the level.
		bIsReachable = PNI.BuildPath( Owner.Location, Dest );
	}

	return bIsReachable;
}

//------------------------------------------------------------------------------
// Returns true if we can reach our destination without hitting any geometry.
//------------------------------------------------------------------------------
function bool CanDirectlyReachDestination( vector Dest )
{
	local vector HitLocation, HitNormal;
	local Actor HitActor;

	HitActor = Trace(	HitLocation, 
						HitNormal, 
						Dest,
						Owner.Location, 
						false	// Don't trace Actors
					);

	return (HitActor == None);
}

//------------------------------------------------------------------------------
function Destroyed()
{
	if( PNI != None )
	{
		PNI.Destroy();
		PNI = None;
	}

	Super.Destroyed();
}

defaultproperties
{
     Priority=128
     bRemovable=True
     bRemoveExisting=True
     bDisplayIcon=True
}
