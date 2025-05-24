//------------------------------------------------------------------------------
// DecalManager.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//
// Description: Acts as a garbage collector for Decals.  It sweeps the level
//				for Actor versions of Decals and converts them into a render 
//				iterator proxy object to be drawn internally.  
//				This allows us to do our own filtering.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------

class DecalManager expands LegendActorComponent
	native;

var() int MaxDecals;	// Maximum number of decals allowed to co-exist in the
						// level at any given moment.

var() float ShrinkTime;	// Amount of time use to shrink decals out of existance.

var() float DecalExpireTime;	// LifeSpan of individual decals.

var() float SweepResolution;	// How often we check for Decals.
var float SweepTimer;

var() int MaxDecalsCollectedPerSweep;	// 1 or more.

var() name SearchTypes[6];		// Types of classes to convert.

var() float VolumeScalePct;		// Percentage of VisibilityCylinder to start
								// scaling decals out of existance.
								// (so they don't just pop out of view)

var() bool bSinglePass;	// If set, we will collect all of the specified Actors
						// at startup.

replication
{
	reliable if( Role==ROLE_Authority )
		MaxDecals, ShrinkTime, DecalExpireTime, SweepResolution;
}

//------------------------------------------------------------------------------
// Converts an Actor to a Decal as a RenderIterator.
// Returns success or failure.
// Actor Decal is deleted on success.
//------------------------------------------------------------------------------
native(1001) final function bool AddDecal( Actor Decal );

//------------------------------------------------------------------------------
// Sweep the level for Decal Actors.
//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local Actor IterA;
	local bool bSuccess;
	local int i;

	if( !bStasis )	// !! Fix: WHY DOESN"T bSTASIS WORK?!?
	{
		// Special Single-pass code.
		if( bSinglePass )
		{
			foreach AllActors( class'Actor', IterA )
			{
				if( IsCollectable( IterA ) )
				{
					bSuccess = AddDecal( IterA );

					if( !bSuccess )
					{
						warn( "Failed to add "$IterA$".  Destroying instead." );
						IterA.Destroy();
					}
				}
			}

			Disable('Tick');
			return;
		}

		SweepTimer += DeltaTime;

		if( SweepTimer >= SweepResolution )
		{
			// -- OLD SweepTimer = 0.0;
			SweepTimer = SweepResolution;

			foreach AllActors( class'Actor', IterA )
			{
				if( IsCollectable( IterA ) )
				{
					bSuccess = AddDecal( IterA );

					if( !bSuccess )
					{
						// If AddDecal fails, it's probably because it has no render iterator.
						// If it has no render iterator it probably means we are on a dedicated server.
						// If we are on a dedicated server, we don't really want the decals laying around.
						// Therefore we should destroy them ourself.
						IterA.Destroy();	
					}
/* -- OLD
					// Get one every tick until we don't find any more.
					// Then don't check for another SweepResolution seconds.
					SweepTimer = SweepResolution;	
					break;
*/
					// Only collect MaxDecalsCollectedPerSweep.
					i += 1;
					if( i >= MaxDecalsCollectedPerSweep )
					{
						break;
					}
				}
			}
		}
	}
}

//------------------------------------------------------------------------------
simulated function bool IsCollectable( Actor A )
{
	local int i;

	// Don't collect them until they are visible.
	// Example: Decals aren't visible until they hit the ground and are correctly oriented.
	// We don't want to collect them while they are in mid-air.
	if( A.bHidden )
	{
		return false;
	}

	if( Event != '' && A.Tag == Event )
	{
		return true;
	}

	for( i = 0; i < ArrayCount(SearchTypes); i++ )
	{
		if( SearchTypes[i] != '' )
		{
			if( A.IsA( SearchTypes[i] ) )
			{
				return true;
			}
		}
	}

	return false;
}

defaultproperties
{
     MaxDecals=1000
     DecalExpireTime=300.000000
     SweepResolution=10.000000
     MaxDecalsCollectedPerSweep=5
     VolumeScalePct=0.100000
     bHidden=False
     bStasis=True
     bNetTemporary=True
     RemoteRole=ROLE_SimulatedProxy
     bMustFace=False
     bAlwaysRelevant=True
     bGameRelevant=True
     RenderIteratorClass=Class'Legend.DecalManagerRI'
}
