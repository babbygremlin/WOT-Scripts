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
    Spread=0.00
    Volume=60.00
    NumTemplates=7
    Templates(0)=(LifeSpan=0.10,Weight=1.00,MaxInitialVelocity=0.00,MinInitialVelocity=0.00,MaxDrawScale=0.80,MinDrawScale=0.60,MaxScaleGlow=1.00,MinScaleGlow=1.00,GrowPhase=1,MaxGrowRate=-0.40,MinGrowRate=-0.40,FadePhase=1,MaxFadeRate=-0.40,MinFadeRate=-0.40),
    Templates(1)=(LifeSpan=0.20,Weight=1.00,MaxInitialVelocity=0.00,MinInitialVelocity=0.00,MaxDrawScale=2.00,MinDrawScale=1.60,MaxScaleGlow=1.00,MinScaleGlow=1.00,GrowPhase=1,MaxGrowRate=-0.30,MinGrowRate=-0.30,FadePhase=1,MaxFadeRate=-0.50,MinFadeRate=-0.50),
    Templates(2)=(LifeSpan=0.20,Weight=1.00,MaxInitialVelocity=0.00,MinInitialVelocity=0.00,MaxDrawScale=2.50,MinDrawScale=1.60,MaxScaleGlow=1.40,MinScaleGlow=1.00,GrowPhase=1,MaxGrowRate=-0.30,MinGrowRate=-0.30,FadePhase=1,MaxFadeRate=-0.20,MinFadeRate=-0.20),
    Templates(3)=(LifeSpan=0.10,Weight=1.00,MaxInitialVelocity=0.00,MinInitialVelocity=0.00,MaxDrawScale=2.00,MinDrawScale=1.00,MaxScaleGlow=0.70,MinScaleGlow=0.20,GrowPhase=1,MaxGrowRate=-0.80,MinGrowRate=-0.80,FadePhase=1,MaxFadeRate=-0.80,MinFadeRate=-0.80),
    Templates(4)=(LifeSpan=0.20,Weight=1.00,MaxInitialVelocity=0.00,MinInitialVelocity=0.00,MaxDrawScale=2.00,MinDrawScale=1.50,MaxScaleGlow=1.00,MinScaleGlow=0.50,GrowPhase=1,MaxGrowRate=-0.70,MinGrowRate=-0.70,FadePhase=1,MaxFadeRate=-0.70,MinFadeRate=-0.70),
    Templates(5)=(LifeSpan=0.20,Weight=1.00,MaxInitialVelocity=0.00,MinInitialVelocity=0.00,MaxDrawScale=3.30,MinDrawScale=2.00,MaxScaleGlow=0.80,MinScaleGlow=0.60,GrowPhase=1,MaxGrowRate=-0.60,MinGrowRate=-0.60,FadePhase=1,MaxFadeRate=-0.70,MinFadeRate=-0.70),
    Templates(6)=(LifeSpan=0.20,Weight=1.00,MaxInitialVelocity=0.00,MinInitialVelocity=0.00,MaxDrawScale=2.00,MinDrawScale=1.50,MaxScaleGlow=0.90,MinScaleGlow=0.40,GrowPhase=1,MaxGrowRate=-0.70,MinGrowRate=-0.70,FadePhase=1,MaxFadeRate=-0.70,MinFadeRate=-0.70),
    Particles(0)=Texture'ParticleSystems.Fire.FlameBase02'
    Particles(1)=Texture'ParticleSystems.General.Prtcl20'
    Particles(2)=Texture'ParticleSystems.General.Prtcl05'
    Particles(3)=Texture'ParticleSystems.General.Prtcl20'
    Particles(4)=Texture'ParticleSystems.General.Prtcl14'
    Particles(5)=Texture'ParticleSystems.Flares.PF13'
    Particles(6)=Texture'ParticleSystems.General.Prtcl20'
    VolumeScalePct=1.00
    MinVolume=40.00
    bStatic=False
    LifeSpan=0.10
    SpriteProjForward=32.00
    VisibilityRadius=5000.00
    VisibilityHeight=5000.00
}
