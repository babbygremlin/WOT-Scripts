//------------------------------------------------------------------------------
// DeflectSprayer.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
// + Spawn.
// + SetColor.
// + SetLocation relative to FollowActor.
// + Call Follow with a valid FollowActor.
//------------------------------------------------------------------------------
class DeflectSprayer expands ParticleSprayer;

var() float LightDuration;
var() float RotGroupDelay;
var float RotGroupTime;

var() Texture RedSprite, GreenSprite, WhiteSprite, BlueSprite, GoldSprite;

var Actor FollowActor;
var vector RelativeOffset;

var float FYaw;

var float OffTime;

replication
{
	reliable if( Role==ROLE_Authority && bNetInitial )
		FollowActor, RelativeOffset;
}

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = LightDuration;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
	RotGroupTime = Level.TimeSeconds + RotGroupDelay;
	OffTime = Level.TimeSeconds + TimerDuration;
}

//------------------------------------------------------------------------------
simulated function Follow( Actor FollowActor )
{
	if( FollowActor != None )
	{
		Self.FollowActor = FollowActor;
		RelativeOffset = (Location - FollowActor.Location) << FollowActor.Rotation;
		UpdateRotation( 0.0 );
	}
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	// Super.Tick( DeltaTime );  -- don't call super.

	// Fade light out.
	LightBrightness = 255.0 * (LifeSpan / LightDuration);

	// Start rotating particles on cue.
	if( !bRotationGrouped && Level.TimeSeconds >= RotGroupTime )
	{
		bRotationGrouped = true;
	}

	// Turn off particles on cue.
	if( bOn && Level.TimeSeconds >= OffTime )
	{
		bOn = false;
	}

	// Orient to FollowActor
	if( FollowActor != None )
	{
		SetLocation( FollowActor.Location + (RelativeOffset >> FollowActor.Rotation) );
		UpdateRotation( DeltaTime );
	}
	else
	{
		Destroy();
	}
}

//------------------------------------------------------------------------------
simulated function UpdateRotation( float DeltaTime )
{
	local rotator Rot;
	local vector X, Y, Z;

	FYaw += RotationRate.Yaw * DeltaTime;
	Rot = rotator(Location - FollowActor.Location);
	Rot.Roll = FYaw;
	Rot = Normalize( Rot );
	GetAxes( Rot, X, Y, Z );
	SetRotation( OrthoRotation( Y, -Z, X ) );
}

//------------------------------------------------------------------------------
simulated function SetColor( name Color )
{
	switch( Color )
	{
	case 'Green' : LightHue =  64; LightSaturation =   0; Particles[0] = GreenSprite;	break;
	case 'White' : LightHue =   0; LightSaturation = 255; Particles[0] = WhiteSprite;	break;
	case 'Red'   : LightHue =   0; LightSaturation =   0; Particles[0] = RedSprite;		break;
	case 'Blue'  : LightHue = 160; LightSaturation =   0; Particles[0] = BlueSprite;	break;
	case 'Gold'  : LightHue =  32; LightSaturation =   0; Particles[0] = GoldSprite;	break;
	default: warn( Color$": Unsupported color type." );
	}
}

defaultproperties
{
     LightDuration=1.500000
     RotGroupDelay=0.750000
     RedSprite=Texture'ParticleSystems.Sparks.Sparks11'
     GreenSprite=Texture'ParticleSystems.Sparks.Sparks04'
     WhiteSprite=Texture'ParticleSystems.Flares.PF04'
     BlueSprite=Texture'ParticleSystems.Sparks.Sparks01'
     GoldSprite=Texture'ParticleSystems.Sparks.Sparks14'
     Spread=5.000000
     Volume=75.000000
     Gravity=(Z=-20.000000)
     NumTemplates=2
     Templates(0)=(MaxInitialVelocity=30.000000,MinInitialVelocity=-30.000000,MaxDrawScale=0.500000,MinDrawScale=0.200000,GrowPhase=1,MinGrowRate=-0.500000,FadePhase=1,MaxFadeRate=-1.000000,MinFadeRate=-1.000000)
     Templates(1)=(MaxInitialVelocity=50.000000,MinInitialVelocity=-50.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,GrowPhase=2,MaxGrowRate=0.200000,MinGrowRate=0.100000,FadePhase=10,MaxFadeRate=-10.000000,MinFadeRate=-10.000000)
     Particles(0)=Texture'ParticleSystems.Sparks.Sparks01'
     Particles(1)=Texture'ParticleSystems.Sparks.Sparks17'
     TimerDuration=0.300000
     bOn=True
     MinVolume=50.000000
     bGrouped=True
     bDisableTick=False
     bStatic=False
     bDynamicLight=True
     bNetTemporary=True
     RemoteRole=ROLE_SimulatedProxy
     bMustFace=False
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightRadius=4
     RotationRate=(Yaw=150000)
}
