//------------------------------------------------------------------------------
// CallbackProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	Provides callback routines needed for ProjLeechArtifact.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class CallbackProjectile expands SeekingProjectile;

var bool bExploded;

//------------------------------------------------------------------------------
// If we are destroyed before we explode, notify our source that we lost
// our destination.
//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Role == ROLE_Authority )
	{
		if( !bExploded && ProjLeechArtifact(SourceAngreal) != None )
		{
			ProjLeechArtifact(SourceAngreal).NotifyDestinationLost();
		}
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
// If we lose our destination... hari-kari.
//------------------------------------------------------------------------------
function DestinationLost()
{
	Destroy();
}

//------------------------------------------------------------------------------
simulated function Explode( vector HitLocation, vector HitNormal )
{
	bExploded = True;

 	if( ProjLeechArtifact(SourceAngreal) != None )
	{
		ProjLeechArtifact(SourceAngreal).NotifyReachedDestination( HitActor );
	}

	Super.Explode( HitLocation, HitNormal );
}

defaultproperties
{
     speed=600.000000
     MaxSpeed=600.000000
     LifeSpan=0.000000
     DrawType=DT_None
     CollisionRadius=6.000000
     CollisionHeight=12.000000
}
