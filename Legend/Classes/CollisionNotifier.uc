//------------------------------------------------------------------------------
// CollisionNotifier.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//
// Description:	Used to add a second collision radius to a projectile.
//				If we had interfaces *hint* *hint*, we could easily generalize
//				this to notify any Actor.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Spawn.
// + Set CollisionHeight and Radius.
// + Initialize with a Projectile to follow/notify and an offset from that 
//   projectile.  Notifications will be send via Explode().
// + TurnOn() and TurnOff() as desired.	(Starts as off)
// + Destroy when no longer needed.
//------------------------------------------------------------------------------
class CollisionNotifier expands LegendActorComponent;

var Projectile ParentProj;	// Projectile to follow/notify.
var vector Offset;			// Offset from parent projectile. (Relative to projectile's rotation).
var Actor IgnoredActor;		// Does not notify collisions with this actor.

////////////////
// Interfaces //
////////////////

//------------------------------------------------------------------------------
function Initialize( Projectile ParentProj, optional vector Offset )
{
	self.ParentProj = ParentProj;
	SetOffset( Offset );
}

//------------------------------------------------------------------------------
function SetOffset( vector Offset )
{
	self.Offset = Offset;
	SetLocation( ParentProj.Location + (Offset >> ParentProj.Rotation) );
}

//------------------------------------------------------------------------------
function SetIgnoredActor( Actor Ignore )
{
	IgnoredActor = Ignore;
}

//------------------------------------------------------------------------------
function TurnOn()
{
	bCollideWorld = True;
	SetCollision( True );
}

//------------------------------------------------------------------------------
function TurnOff()
{
	bCollideWorld = False;
	SetCollision( False );
}

///////////////////
// Notifications //
///////////////////

//------------------------------------------------------------------------------
// ripped from projectile.uc
//------------------------------------------------------------------------------
function Touch( Actor Other )
{
	local actor HitActor;
	local vector HitLocation, HitNormal;
	
	if( Other == IgnoredActor )
	{
		// Do nothing.
	}
	else if( Other.IsA('BlockAll') )
	{
		HitWall( Normal(Location - Other.Location), Other);
	}
	else if( Other.bProjTarget || (Other.bBlockActors && Other.bBlockPlayers) )
	{
		//get exact hitlocation, hitnormal
	 	HitActor = Trace(HitLocation, HitNormal, Location, OldLocation, true);
		if( HitActor == Other )
		{
			ParentProj.Explode( HitLocation, HitNormal ); 
		}
		else	// aproximate hitlocation, hitnormal.
		{
			ParentProj.Explode( Other.Location + Other.CollisionRadius * Normal(Location - Other.Location), Normal(Location - Other.Location) );
		}
	}
}

//------------------------------------------------------------------------------
function HitWall( vector HitNormal, Actor Wall )
{
	ParentProj.Explode( Location, HitNormal );
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	if( ParentProj != None )
	{
		SetLocation( ParentProj.Location + (Offset >> ParentProj.Rotation) );
	}
	Super.Tick( DeltaTime );
}

defaultproperties
{
}
