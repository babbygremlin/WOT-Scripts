//------------------------------------------------------------------------------
// Firework09.uc
// $Author: Aleiby $
// $Date: 8/26/99 8:24p $
// $Revision: 2 $
//
// Description:	Red Exp Type
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class Firework09 expands ParticleSprayer;

var() float LightDuration;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 3.250000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
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
     LightDuration=3.250000
     Spread=230.000000
     Volume=200.000000
     NumTemplates=3
     Templates(0)=(LifeSpan=1.500000,Weight=8.000000,MaxInitialVelocity=150.000000,MinInitialVelocity=50.000000,MinDrawScale=0.700000,GrowPhase=1,MaxGrowRate=-0.300000,MinGrowRate=-0.600000,FadePhase=1,MaxFadeRate=-0.300000,MinFadeRate=-0.700000)
     Templates(1)=(LifeSpan=3.000000,Weight=5.000000,MaxInitialVelocity=100.000000,MinInitialVelocity=100.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,GrowPhase=16,MaxGrowRate=1.000000,MinGrowRate=0.800000,FadePhase=2,MaxFadeRate=0.200000,MinFadeRate=0.100000)
     Templates(2)=(MaxInitialVelocity=-100.000000,MinInitialVelocity=-150.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,GrowPhase=3,MaxGrowRate=3.000000,MinGrowRate=1.000000,FadePhase=5,MaxFadeRate=-0.300000,MinFadeRate=-0.500000)
     Particles(0)=Texture'ParticleSystems.General.Prtcl23'
     Particles(1)=Texture'ParticleSystems.Appear.AWhiteCorona'
     Particles(2)=Texture'ParticleSystems.General.Prtcl23'
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
     Rotation=(Pitch=114752)
     bMustFace=False
     VisibilityRadius=0.000000
     VisibilityHeight=0.000000
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=18
     LightRadius=25
     bFixedRotationDir=True
     RotationRate=(Yaw=16384)
}
