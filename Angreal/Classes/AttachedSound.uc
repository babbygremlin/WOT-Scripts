//------------------------------------------------------------------------------
// AttachedSound.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
// + Spawn on server-side.
// + Set AmbientSound.
// + Destroy when no longer needed.
//------------------------------------------------------------------------------
class AttachedSound expands Leech;

var vector OwnerLocation;

replication
{
	unreliable if( Role==ROLE_Authority && Owner!=None && !Owner.bNetRelevant )
		OwnerLocation;
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	if( Owner != None )
	{
		OwnerLocation = Owner.Location;
	}

	SetLocation( OwnerLocation );

	Super.Tick( DeltaTime );
}

defaultproperties
{
     RemoteRole=ROLE_SimulatedProxy
     DrawType=DT_None
     SoundRadius=64
     SoundVolume=192
}
