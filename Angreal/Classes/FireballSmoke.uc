//------------------------------------------------------------------------------
// FireballSmoke.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class FireballSmoke expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
    Spread=3.00
    Gravity=(X=0.00,Y=0.00,Z=10.00),
    NumTemplates=1
    Templates=(LifeSpan=2.00,Weight=1.00,MaxInitialVelocity=100.00,MinInitialVelocity=80.00,MaxDrawScale=2.00,MinDrawScale=1.50,MaxScaleGlow=0.00,MinScaleGlow=0.00,GrowPhase=2,MaxGrowRate=0.75,MinGrowRate=0.30,FadePhase=2,MaxFadeRate=0.20,MinFadeRate=0.05),
    Particles=Texture'ParticleSystems.Smoke.particle_fog07'
    bOn=True
    VolumeScalePct=1.00
    bStatic=False
    SpriteProjForward=32.00
    bMustFace=False
    VisibilityRadius=5000.00
    VisibilityHeight=5000.00
}
