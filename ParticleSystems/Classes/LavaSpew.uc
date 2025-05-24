//------------------------------------------------------------------------------
// LavaSpew.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LavaSpew expands ParticleSprayer;

var() float Duration;
var() float ActualLifeSpan;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = ActualLifeSpan;	// Due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
	SetTimer( Duration, false );
}

//------------------------------------------------------------------------------
simulated function Timer()
{
	bOn = false;
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );
	LightBrightness = default.LightBrightness * LifeSpan / ActualLifeSpan;
}

defaultproperties
{
     Duration=0.250000
     ActualLifeSpan=3.500000
     Volume=100.000000
     Gravity=(Z=-100.000000)
     NumTemplates=3
     Templates(0)=(LifeSpan=5.000000,Weight=4.000000,MaxInitialVelocity=150.000000,MinInitialVelocity=30.000000,MaxDrawScale=0.600000,MinScaleGlow=0.800000,GrowPhase=1,MaxGrowRate=-0.100000,MinGrowRate=-0.500000,FadePhase=1,MaxFadeRate=-0.200000,MinFadeRate=-0.400000)
     Templates(1)=(LifeSpan=4.000000,Weight=3.000000,MaxInitialVelocity=140.000000,MinInitialVelocity=10.000000,MaxDrawScale=0.400000,MinDrawScale=0.100000,MinScaleGlow=0.700000,GrowPhase=1,MaxGrowRate=-0.050000,MinGrowRate=-0.300000,FadePhase=1,MinFadeRate=-0.400000)
     Templates(2)=(LifeSpan=4.000000,MaxInitialVelocity=400.000000,MinInitialVelocity=80.000000,MaxDrawScale=0.600000,MinDrawScale=0.300000,MinScaleGlow=0.700000,GrowPhase=1,MaxGrowRate=-0.200000,MinGrowRate=-0.500000,FadePhase=1,MaxFadeRate=-0.300000,MinFadeRate=-0.700000)
     Particles(0)=Texture'ParticleSystems.General.Prtcl05'
     Particles(1)=Texture'ParticleSystems.General.Prtcl04'
     Particles(2)=Texture'ParticleSystems.General.Prtcl08'
     bStatic=False
     VisibilityRadius=500.000000
     VisibilityHeight=500.000000
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=18
     LightSaturation=36
     LightRadius=8
}
