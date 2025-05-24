//------------------------------------------------------------------------------
// SprayerBlower.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//
// Description:	Used to blow ParticleSprayers with a burst of wind.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Spawn.
// + Set magnitude.
// + Set Rotation.
// + Set Duration.
// + Set CollisionRadius, etc.
// + Trigger.
//------------------------------------------------------------------------------
class SprayerBlower expands Effects;

var() float Magnitude;		// Magnitude of burst of air.
var vector Wind;

var vector WindPerSecond;
var vector WindAccum;

var() float Duration;

var ParticleSprayer AffectedSprayers[64];
var int NumSprayers;

var name IgnoredTypes[16];

//------------------------------------------------------------------------------
simulated function BeginPlay()
{
	Super.BeginPlay();
	Disable('Tick');
	LifeSpan = 0.0;
}

//------------------------------------------------------------------------------
simulated function Trigger( Actor Other, Pawn EventInstigator )
{
	local ParticleSprayer IterPS;
	local vector Projection;
	local int i;

	// Get all ParticleSprayers in our collision cylinder.
	foreach AllActors( class'ParticleSprayer', IterPS )
	{
		if
		(	!IsIgnored( IterPS )
		&&	IterPS.Location.Z >= Location.Z - CollisionHeight
		&&	IterPS.Location.Z <= Location.Z + CollisionHeight
		)
		{
			Projection = IterPS.Location - Location;
			Projection.Z = 0;
			if( VSize(Projection) <= CollisionRadius )
			{
				if( NumSprayers < ArrayCount(AffectedSprayers) )
				{
					AffectedSprayers[ NumSprayers++ ] = IterPS;
				}
			}
		}
	}

	// Calc wind.
	Wind = Normal(vector(Rotation)) * Magnitude;
	WindPerSecond = Wind / Duration;

	// Add our wind to the affected sprayers.
	for( i = 0; i < NumSprayers; i++ )
	{
		AffectedSprayers[i].Gravity += Wind;
	}

	LifeSpan = Duration;
	Enable('Tick');
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local int i;
	local vector DeltaWind;

	Super.Tick( DeltaTime );

	DeltaWind = WindPerSecond * DeltaTime;
	WindAccum += DeltaWind;

	// Ensure we don't subtract too much gravity.
	if( VSize(WindAccum) > VSize(Wind) )
	{
		DeltaWind -= WindAccum - Wind;
		Disable('Tick');
	}
	
	for( i = 0; i < NumSprayers; i++ )
	{
		if( AffectedSprayers[i] != None )
		{
			AffectedSprayers[i].Gravity -= DeltaWind;
		}
	}
}

//------------------------------------------------------------------------------
simulated function bool IsIgnored( ParticleSprayer Sprayer )
{
	local int i;

	if( Sprayer.bIsWindResistant )
	{
		return true;
	}

	for( i = 0; i < ArrayCount(IgnoredTypes); i++ )
	{
		if( IgnoredTypes[i] != '' )
		{
			if( Sprayer.Class.Name == IgnoredTypes[i] )
			{
				return true;
			}
		} //??else break;
	}

	return false;
}

//------------------------------------------------------------------------------
simulated function AddIgnoredType( name Type )
{
	local int i;

	for( i = 0; i < ArrayCount(IgnoredTypes); i++ )
	{
		if( IgnoredTypes[i] == '' )
		{
			IgnoredTypes[i] = Type;
			return;
		}
	}

	warn( "IgnoredTypes capacity exceeded." );
}

defaultproperties
{
     Magnitude=250.000000
     Duration=1.000000
     bDirectional=True
     CollisionRadius=60.000000
     CollisionHeight=60.000000
}
