//------------------------------------------------------------------------------
// LegionEarthTremor.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//
// Description:	This class simply orchestrates the placement of EarthTremorRocks.
//              You will never actually see this class, only its results.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Spawn.
// + SetSourceAngreal
// + Call Go();
//------------------------------------------------------------------------------
class LegionEarthTremor expands EarthTremor;

var() int NumRows;			// How many rows in the stomp.
var int RowNum;				// What row are we on now?

var() float RowInterval;	// Time to wait before creating next row.
var() float StartAngle;		// in degrees from local x axis.
var() float EndAngle;		// in degrees from local x axis.

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	// Don't delete other earthtremors.
	Super(AngrealProjectile).PreBeginPlay();
}

//------------------------------------------------------------------------------
simulated function Go()
{
	GotoState( 'LegionStomp' );
}

//------------------------------------------------------------------------------
simulated state LegionStomp
{
Begin:
	while( RowNum++ < NumRows )
	{
		SpawnRing( 1.25, StartAngle, EndAngle, RippleDistance * RowNum );
		Sleep( RowInterval );
	}
	Destroy();		
}

//------------------------------------------------------------------------------
simulated function SpawnRing( float Scale, float StartAngle, float EndAngle, float RingRadius )
{
	local vector Loc, X, Y, Z, XAxis, YAxis, ZAxis;
	local rotator Rot;
	local float Angle;
	local EarthTremorRock Rock;
	local vector Ignored;

	local float AngleInterval;

	//AngleInterval = ((2 * Pi * RingRadius) * (Abs( EndAngle - StartAngle ) / 360.0)) / (2 * class'EarthTremorRock'.default.CollisionRadius * Scale);	// Arc length / Rock Size.
	AngleInterval = 32.0;	// CollisionRadius wasn't set up properly.
	
	GetAxes( Rotation, X, Y, Z );
	
	for( Angle = StartAngle; Angle < EndAngle; Angle += AngleInterval )
	{
		XAxis = class'Util'.static.DSin( Angle ) * Y + class'Util'.static.DCos( Angle ) * X;

		Loc = Location + XAxis*RingRadius;
		
		// Make sure we aren't going to run into geometry.
		if( Trace( Ignored, Ignored, Loc, Location, false ) == None )
		{
			ZAxis = Z;
			YAxis = ZAxis cross XAxis;
			Rot = OrthoRotation( XAxis, YAxis, ZAxis );
			
			Rock = Spawn( class'EarthTremorRock',,, Loc, Rot );
			if( Rock != None )
			{
				Rock.SetCollisionSize( Rock.CollisionRadius + 15, Rock.CollisionHeight + 15 );
				Rock.SetSourceAngreal( SourceAngreal );
				Rock.Instigator = Instigator;
				Rock.IgnoredPawn = Instigator;
				Rock.Lifespan = 1.0;
				Rock.MinAnimRate = 2.0;
				Rock.MaxAnimRate = 2.5;
				Rock.Damage = 10.0;
				Rock.DrawScale *= Scale;
				Rock.Go();
			}
		}
	}
}

defaultproperties
{
     NumRows=6
     RowInterval=0.400000
     StartAngle=-90.000000
     EndAngle=90.000000
     RippleDistance=96.000000
     SpawnHeight=64.000000
     SecondRingDelay=0.300000
     ThirdRingDelay=0.400000
     FourthRingDelay=0.500000
}
