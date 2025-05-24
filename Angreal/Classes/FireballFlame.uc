//------------------------------------------------------------------------------
// FireballFlame.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class FireballFlame expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Spread=2.000000
     Volume=25.000000
     NumTemplates=2
     Templates(0)=(LifeSpan=3.000000,MaxInitialVelocity=600.000000,MinInitialVelocity=500.000000,MaxDrawScale=1.400000,MinDrawScale=1.200000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=-1.000000,MinGrowRate=-1.500000,FadePhase=2,MaxFadeRate=1.000000,MinFadeRate=0.750000)
     Templates(1)=(Weight=2.000000,MaxInitialVelocity=600.000000,MinInitialVelocity=500.000000,MaxDrawScale=0.800000,MinDrawScale=0.400000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=-0.750000,MinGrowRate=-1.000000,FadePhase=2,MaxFadeRate=0.750000,MinFadeRate=0.500000)
     Particles(0)=Texture'ParticleSystems.Fire.FlameBase02'
     Particles(1)=Texture'ParticleSystems.Fire.Flame07'
     bOn=True
     VolumeScalePct=1.000000
     bStatic=False
     SpriteProjForward=32.000000
     VisibilityRadius=5000.000000
     VisibilityHeight=5000.000000
}
