//------------------------------------------------------------------------------
// DynamicCrosshairLeech.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
// + Spawn.
// + Set CrosshairType.
// + Attach to player.
//------------------------------------------------------------------------------
class DynamicCrosshairLeech expands Leech;

var() class<ParticleSprayer> CrosshairType;
var ParticleSprayer Crosshair;

var() bool bDebugMode;

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( Crosshair != None )
	{
		Crosshair.bOn = false;
		Crosshair.LifeSpan = 12.0;
		Crosshair = None;
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local vector StartLoc, Direction;
	local vector HitLocation, HitNormal;
	local Actor HitActor;

	if( Level.NetMode != NM_DedicatedServer )
	{
		if( Owner != None )
		{
			StartLoc = Owner.Location + (Pawn(Owner).BaseEyeHeight * vect(0,0,1));
			Direction = vector(Pawn(Owner).ViewRotation);

			HitActor = class'Util'.static.TraceRecursive( Self, HitLocation, HitNormal, StartLoc, true,, Direction );

			if( bDebugMode ) BroadcastMessage( HitActor );

			if( Crosshair == None )
			{
				Crosshair = Spawn( CrosshairType, Owner,, HitLocation, rotator(HitNormal) );
				if( Crosshair != None )
				{
					Crosshair.bOnlyOwnerSee = true;
				}
			}
			else
			{
				Crosshair.SetLocation( HitLocation );
				Crosshair.SetRotation( rotator(HitNormal) );
			}
		}
	}

	Super.Tick( DeltaTime );
}

defaultproperties
{
     bRemovable=False
     RemoteRole=ROLE_SimulatedProxy
}
