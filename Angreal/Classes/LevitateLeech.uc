//------------------------------------------------------------------------------
// LevitateLeech.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LevitateLeech expands Leech;

var() float RiseHeight;
var() float LevitateSpeed;

var EPhysics InitialPhysics;
/*
var Effects PN;

function PreBeginPlay()
{
	PN = Spawn( class'Effects' );
	PN.DrawType=DT_Sprite;
	Super.PreBeginPlay();
}

function Destroyed()
{
	PN.Destroy();
	Super.Destroyed();
}
*/
//------------------------------------------------------------------------------
function AttachTo( Pawn NewHost )
{
	Super.AttachTo( NewHost );
	InitialPhysics = Owner.Physics;
}

//------------------------------------------------------------------------------
function UnAttach()
{
	Owner.SetPhysics( InitialPhysics );
	Super.UnAttach();
}

//------------------------------------------------------------------------------
// Try to keep our castor RiseHeight off the ground.
// Move him/her at a constant velocity LevitateSpeed to get there.
//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local vector DesiredLocation;
	local vector HitNormal;
	local float MagicNumber;
	
	MagicNumber = 100.0;

	Super.Tick( DeltaTime );

	Owner.SetPhysics( PHYS_Flying );

	// NOTE[aleiby]: Use desired velocity, not actual velocity.

	//DesiredLocation = Owner.Location + (Owner.Velocity * DeltaTime * 20.0);
	//DesiredLocation = Owner.Location + (Owner.Acceleration * DeltaTime * DeltaTime * MagicNumber);
	//DesiredLocation.Z += Owner.CollisionHeight;
	
	//PN.SetLocation( DesiredLocation );

	class'Util'.static.TraceRecursive( Self, DesiredLocation, HitNormal, Owner.Location, false );
	DesiredLocation.Z += (RiseHeight + Owner.CollisionHeight);
	
	if( Abs(DesiredLocation.Z - Owner.Location.Z) > 8.0 )
	{
		Owner.Velocity.Z = (Normal( DesiredLocation - Owner.Location ) * LevitateSpeed).Z;
	}
	else
	{
		Owner.Velocity.Z = 0.0;
	}
	//Owner.Velocity.Z = (DesiredLocation.Z - Owner.Location.Z);
}

defaultproperties
{
    RiseHeight=20.00
    LevitateSpeed=96.00
    AffectResolution=1.00
}
