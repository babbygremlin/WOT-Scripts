//------------------------------------------------------------------------------
// LegionStompSprayerB.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LegionStompSprayerB expands ParticleSprayer;

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

defaultproperties
{
     Duration=0.750000
     ActualLifeSpan=2.150000
     Spread=95.000000
     Volume=40.000000
     Gravity=(Z=-20.000000)
     NumTemplates=1
     Templates(0)=(LifeSpan=1.400000,MaxInitialVelocity=-5.000000,MinInitialVelocity=70.000000,MaxDrawScale=0.500000,MinDrawScale=0.050000,MinScaleGlow=0.500000,GrowPhase=1,MaxGrowRate=1.000000,MinGrowRate=-1.000000,FadePhase=1,MaxFadeRate=-1.000000,MinFadeRate=-0.850000)
     Particles(0)=Texture'ParticleSystems.Lava.LavaSmokeA'
     bOn=True
     MinVolume=10.000000
     bStatic=False
     bMustFace=False
     VisibilityRadius=1200.000000
     VisibilityHeight=1200.000000
}
