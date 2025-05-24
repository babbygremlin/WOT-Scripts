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
     Spread=3.000000
     Gravity=(Z=10.000000)
     NumTemplates=1
     Templates(0)=(LifeSpan=2.000000,MaxInitialVelocity=100.000000,MinInitialVelocity=80.000000,MaxDrawScale=2.000000,MinDrawScale=1.500000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=2,MaxGrowRate=0.750000,MinGrowRate=0.300000,FadePhase=2,MaxFadeRate=0.200000,MinFadeRate=0.050000)
     Particles(0)=Texture'ParticleSystems.Smoke.particle_fog07'
     bOn=True
     VolumeScalePct=1.000000
     bStatic=False
     SpriteProjForward=32.000000
     bMustFace=False
     VisibilityRadius=5000.000000
     VisibilityHeight=5000.000000
}
