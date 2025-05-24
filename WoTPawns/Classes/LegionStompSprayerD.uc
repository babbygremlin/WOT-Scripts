//------------------------------------------------------------------------------
// LegionStompSprayerD.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LegionStompSprayerD expands ParticleSprayer;

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
     ActualLifeSpan=2.750000
     Spread=15.000000
     Volume=90.000000
     NumTemplates=2
     Templates(0)=(LifeSpan=2.000000,MaxInitialVelocity=185.000000,MinInitialVelocity=140.000000,MaxDrawScale=0.350000,MinDrawScale=0.150000,MinScaleGlow=0.500000,MaxGrowRate=1.000000,MinGrowRate=-0.500000,FadePhase=1,MaxFadeRate=-1.000000,MinFadeRate=-1.500000)
     Templates(1)=(LifeSpan=2.000000,MaxInitialVelocity=130.000000,MinInitialVelocity=120.000000,MaxDrawScale=0.150000,MinDrawScale=0.100000,MinScaleGlow=0.500000,GrowPhase=2,MaxGrowRate=0.500000,MinGrowRate=-1.000000,FadePhase=1,MaxFadeRate=-1.000000,MinFadeRate=-1.500000)
     Particles(0)=Texture'ParticleSystems.Lava.LavaFlamesA'
     Particles(1)=Texture'ParticleSystems.Lava.LavaSkullA'
     bOn=True
     MinVolume=22.500000
     bStatic=False
     bMustFace=False
     VisibilityRadius=1200.000000
     VisibilityHeight=1200.000000
}
