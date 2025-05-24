//------------------------------------------------------------------------------
// FireballSprayer2.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class FireballSprayer2 expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Spread=0.000000
     Volume=60.000000
     NumTemplates=7
     Templates(0)=(LifeSpan=0.100000,MaxDrawScale=0.800000,MinDrawScale=0.600000,GrowPhase=1,MaxGrowRate=-0.400000,MinGrowRate=-0.400000,FadePhase=1,MaxFadeRate=-0.400000,MinFadeRate=-0.400000)
     Templates(1)=(LifeSpan=0.200000,MaxDrawScale=2.000000,MinDrawScale=1.600000,GrowPhase=1,MaxGrowRate=-0.300000,MinGrowRate=-0.300000,FadePhase=1,MaxFadeRate=-0.500000,MinFadeRate=-0.500000)
     Templates(2)=(LifeSpan=0.200000,MaxDrawScale=2.500000,MinDrawScale=1.600000,MaxScaleGlow=1.400000,GrowPhase=1,MaxGrowRate=-0.300000,MinGrowRate=-0.300000,FadePhase=1,MaxFadeRate=-0.200000,MinFadeRate=-0.200000)
     Templates(3)=(LifeSpan=0.100000,MaxDrawScale=2.000000,MaxScaleGlow=0.700000,MinScaleGlow=0.200000,GrowPhase=1,MaxGrowRate=-0.800000,MinGrowRate=-0.800000,FadePhase=1,MaxFadeRate=-0.800000,MinFadeRate=-0.800000)
     Templates(4)=(LifeSpan=0.200000,MaxDrawScale=2.000000,MinDrawScale=1.500000,MinScaleGlow=0.500000,GrowPhase=1,MaxGrowRate=-0.700000,MinGrowRate=-0.700000,FadePhase=1,MaxFadeRate=-0.700000,MinFadeRate=-0.700000)
     Templates(5)=(LifeSpan=0.200000,MaxDrawScale=3.300000,MinDrawScale=2.000000,MaxScaleGlow=0.800000,MinScaleGlow=0.600000,GrowPhase=1,MaxGrowRate=-0.600000,MinGrowRate=-0.600000,FadePhase=1,MaxFadeRate=-0.700000,MinFadeRate=-0.700000)
     Templates(6)=(LifeSpan=0.200000,MaxDrawScale=2.000000,MinDrawScale=1.500000,MaxScaleGlow=0.900000,MinScaleGlow=0.400000,GrowPhase=1,MaxGrowRate=-0.700000,MinGrowRate=-0.700000,FadePhase=1,MaxFadeRate=-0.700000,MinFadeRate=-0.700000)
     Particles(0)=Texture'ParticleSystems.Fire.FlameBase02'
     Particles(1)=Texture'ParticleSystems.General.Prtcl20'
     Particles(2)=Texture'ParticleSystems.General.Prtcl05'
     Particles(3)=Texture'ParticleSystems.General.Prtcl20'
     Particles(4)=Texture'ParticleSystems.General.Prtcl14'
     Particles(5)=Texture'ParticleSystems.Flares.PF13'
     Particles(6)=Texture'ParticleSystems.General.Prtcl20'
     VolumeScalePct=1.000000
     MinVolume=40.000000
     bStatic=False
     LifeSpan=0.100000
     SpriteProjForward=32.000000
     VisibilityRadius=5000.000000
     VisibilityHeight=5000.000000
}
