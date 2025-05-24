//------------------------------------------------------------------------------
// Firework05.uc
// $Author: Aleiby $
// $Date: 8/26/99 8:24p $
// $Revision: 2 $
//
// Description:	Yellow Sparkly Exp Type
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class Firework05 expands ParticleSprayer;

var() float LightDuration;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 3.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
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

	LightDuration -= DeltaTime;
	LightBrightness = byte( FMax( (LightDuration / default.LightDuration) * float(default.LightBrightness), 0.0 ) );
}

defaultproperties
{
     LightDuration=3.000000
     Spread=220.000000
     Volume=200.000000
     Gravity=(Z=-40.000000)
     NumTemplates=3
     Templates(0)=(LifeSpan=1.500000,Weight=8.000000,MaxInitialVelocity=15.000000,MinInitialVelocity=15.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,GrowPhase=10,MaxGrowRate=0.500000,MinGrowRate=0.250000,FadePhase=1,MaxFadeRate=-0.300000,MinFadeRate=-0.700000)
     Templates(1)=(LifeSpan=2.500000,Weight=20.000000,MaxInitialVelocity=45.000000,MinInitialVelocity=30.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,MaxScaleGlow=0.300000,MinScaleGlow=0.150000,GrowPhase=15,MaxGrowRate=0.800000,MinGrowRate=0.400000,FadePhase=2,MaxFadeRate=0.400000,MinFadeRate=0.100000)
     Templates(2)=(MaxInitialVelocity=50.000000,MinInitialVelocity=50.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,GrowPhase=12,MaxGrowRate=3.000000,MinGrowRate=1.000000,FadePhase=5,MaxFadeRate=-0.300000,MinFadeRate=-0.500000)
     Particles(0)=Texture'ParticleSystems.Sparks.Sparks12'
     Particles(1)=Texture'ParticleSystems.Sparks.Sparks13'
     Particles(2)=Texture'ParticleSystems.Sparks.Sparks15'
     TimerDuration=0.400000
     bInitiallyOn=False
     bOn=True
     MinVolume=8.000000
     bInterpolate=True
     bDisableTick=False
     bStatic=False
     InitialState=TriggerTimed
     Rotation=(Pitch=147504,Yaw=-208)
     bMustFace=False
     VisibilityRadius=0.000000
     VisibilityHeight=0.000000
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=40
     LightSaturation=80
     LightRadius=15
     bFixedRotationDir=True
     RotationRate=(Yaw=50000)
}
