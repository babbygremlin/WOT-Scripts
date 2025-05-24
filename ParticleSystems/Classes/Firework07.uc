//------------------------------------------------------------------------------
// Firework07.uc
// $Author: Aleiby $
// $Date: 8/26/99 8:24p $
// $Revision: 2 $
//
// Description:	Purple Swirly Exp Type
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class Firework07 expands ParticleSprayer;

var() float LightDuration;

var int Stage;
var float Stage0Time, Stage1Time, Stage2Time, Stage3Time;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 4.250000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();

	Stage0Time = Level.TimeSeconds + 0.0;
	Stage1Time = Level.TimeSeconds + 1.0;
	Stage2Time = Level.TimeSeconds + 2.0;
	Stage3Time = Level.TimeSeconds + 3.0;
}

//------------------------------------------------------------------------------
simulated function SetInitialState()
{
	Super.SetInitialState();
	Trigger( Self, None );
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	// Super.Tick( DeltaTime );  -- don't call super.

	if( Level.TimeSeconds > Stage1Time ) Stage = 1;
	if( Level.TimeSeconds > Stage2Time ) Stage = 2;
	if( Level.TimeSeconds > Stage3Time ) Stage = 3;

	// Fade light in.  Rotate.
	if( Stage == 0 )
	{
		LightBrightness = default.LightBrightness * (Level.TimeSeconds - Stage0Time);
		RotationRate.Yaw = default.RotationRate.Yaw;
	}

	// Fade light out.  No rotate.
	else if( Stage == 1 )
	{
		LightBrightness = default.LightBrightness * (1.0 - (Level.TimeSeconds - Stage1Time));
		RotationRate.Yaw = 0;
	}

	// Fade light in.  Rotate.
	else if( Stage == 2 )
	{
		LightBrightness = default.LightBrightness * (Level.TimeSeconds - Stage2Time);
		RotationRate.Yaw = default.RotationRate.Yaw;
	}

	// Fade light out.  Rotate.
	else if( Stage == 3 )
	{
		LightBrightness = FMax( default.LightBrightness * (1.0 - (Level.TimeSeconds - Stage3Time)), 0.0 );
		RotationRate.Yaw = default.RotationRate.Yaw;
	}
}

defaultproperties
{
     LightDuration=4.250000
     Spread=150.000000
     Volume=200.000000
     Gravity=(Z=-25.000000)
     NumTemplates=2
     Templates(0)=(LifeSpan=4.000000,Weight=5.000000,MaxInitialVelocity=250.000000,MinInitialVelocity=120.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=4,MaxGrowRate=1.500000,MinGrowRate=0.600000,FadePhase=4,MaxFadeRate=0.900000,MinFadeRate=0.300000)
     Templates(1)=(LifeSpan=1.500000,MaxInitialVelocity=90.000000,MinInitialVelocity=15.000000,MaxDrawScale=0.100000,MinDrawScale=0.010000,GrowPhase=2,MaxGrowRate=-0.100000,MinGrowRate=-0.150000,FadePhase=2)
     Particles(0)=Texture'ParticleSystems.Sparks.Sparks01'
     Particles(1)=Texture'ParticleSystems.General.Prtcl18'
     TimerDuration=0.250000
     bInitiallyOn=False
     bOn=True
     MinVolume=8.000000
     bInterpolate=True
     bRotationGrouped=True
     bDisableTick=False
     bStatic=False
     bDynamicLight=True
     Physics=PHYS_Rotating
     InitialState=TriggerTimed
     Rotation=(Pitch=82092)
     bMustFace=False
     VisibilityRadius=0.000000
     VisibilityHeight=0.000000
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=180
     LightRadius=20
     bFixedRotationDir=True
     RotationRate=(Yaw=50000)
}
