//------------------------------------------------------------------------------
// Firework08.uc
// $Author: Aleiby $
// $Date: 8/26/99 8:24p $
// $Revision: 2 $
//
// Description:	Green/Blue Exp Type
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class Firework08 expands ParticleSprayer;

var() float LightDuration;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 4.250000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
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
     LightDuration=4.250000
     Volume=200.000000
     Gravity=(Z=-100.000000)
     NumTemplates=3
     Templates(0)=(LifeSpan=4.000000,MaxInitialVelocity=150.000000,MinInitialVelocity=-20.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=0.300000,MinGrowRate=0.150000,FadePhase=40,MaxFadeRate=10.000000,MinFadeRate=8.000000)
     Templates(1)=(LifeSpan=3.000000,MaxInitialVelocity=150.000000,MinInitialVelocity=50.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,MaxScaleGlow=0.300000,MinScaleGlow=0.150000,GrowPhase=4,MaxGrowRate=1.000000,MinGrowRate=0.200000,FadePhase=2,MaxFadeRate=0.200000,MinFadeRate=0.100000)
     Templates(2)=(LifeSpan=2.500000,Weight=2.000000,MaxInitialVelocity=500.000000,MinInitialVelocity=200.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=7,MaxGrowRate=3.000000,MinGrowRate=1.000000,FadePhase=2,MaxFadeRate=2.000000,MinFadeRate=0.800000)
     Particles(0)=Texture'ParticleSystems.Appear.AWhiteCorona'
     Particles(1)=Texture'ParticleSystems.Flares.PF11'
     Particles(2)=Texture'ParticleSystems.Appear.CyanCorona'
     TimerDuration=0.250000
     bInitiallyOn=False
     bOn=True
     MinVolume=8.000000
     bInterpolate=True
     bDisableTick=False
     bStatic=False
     bDynamicLight=True
     InitialState=TriggerTimed
     Rotation=(Pitch=145072,Yaw=-208)
     bMustFace=False
     VisibilityRadius=0.000000
     VisibilityHeight=0.000000
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=128
     LightSaturation=30
     LightRadius=20
     bFixedRotationDir=True
     RotationRate=(Yaw=50000)
}
