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
    Spread=2.00
    Volume=25.00
    NumTemplates=2
    Templates(0)=(LifeSpan=3.00,Weight=1.00,MaxInitialVelocity=600.00,MinInitialVelocity=500.00,MaxDrawScale=1.40,MinDrawScale=1.20,MaxScaleGlow=0.00,MinScaleGlow=0.00,GrowPhase=1,MaxGrowRate=-1.00,MinGrowRate=-1.50,FadePhase=2,MaxFadeRate=1.00,MinFadeRate=0.75),
    Templates(1)=(LifeSpan=1.00,Weight=2.00,MaxInitialVelocity=600.00,MinInitialVelocity=500.00,MaxDrawScale=0.80,MinDrawScale=0.40,MaxScaleGlow=0.00,MinScaleGlow=0.00,GrowPhase=1,MaxGrowRate=-0.75,MinGrowRate=-1.00,FadePhase=2,MaxFadeRate=0.75,MinFadeRate=0.50),
    Particles(0)=Texture'ParticleSystems.Fire.FlameBase02'
    Particles(1)=Texture'ParticleSystems.Fire.Flame07'
    bOn=True
    VolumeScalePct=1.00
    bStatic=False
    SpriteProjForward=32.00
    VisibilityRadius=5000.00
    VisibilityHeight=5000.00
}
