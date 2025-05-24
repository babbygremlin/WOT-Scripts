//------------------------------------------------------------------------------
// LegionStompSprayerA.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LegionStompSprayerA expands ParticleSprayer;

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
     Duration=0.750000
     ActualLifeSpan=2.250000
     Spread=22.000000
     Volume=30.000000
     NumTemplates=1
     Templates(0)=(LifeSpan=1.500000,MaxInitialVelocity=125.000000,MinInitialVelocity=115.000000,MaxDrawScale=0.500000,MinDrawScale=0.250000,MinScaleGlow=0.500000,GrowPhase=2,MaxGrowRate=1.000000,FadePhase=1,MaxFadeRate=-1.000000,MinFadeRate=-0.850000)
     Particles(0)=Texture'ParticleSystems.Lava.LavaSkullA'
     bOn=True
     MinVolume=7.500000
     bStatic=False
     bMustFace=False
     VisibilityRadius=1200.000000
     VisibilityHeight=1200.000000
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=255
     LightHue=18
     LightSaturation=36
     LightRadius=8
}
