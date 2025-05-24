//------------------------------------------------------------------------------
// SeekerSmoke.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class SeekerSmoke expands ParticleSprayer;

#exec TEXTURE IMPORT FILE=MODELS\SeekerParticle.pcx GROUP=Skins FLAGS=2 // SKIN

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
    NumTemplates=1
    Templates=(LifeSpan=2.00,Weight=1.00,MaxInitialVelocity=20.00,MinInitialVelocity=10.00,MaxDrawScale=1.50,MinDrawScale=1.00,MaxScaleGlow=0.00,MinScaleGlow=0.00,GrowPhase=1,MaxGrowRate=-0.50,MinGrowRate=-1.00,FadePhase=2,MaxFadeRate=0.10,MinFadeRate=0.05),
    Particles=Texture'Effects.FBExp503'
    bOn=True
    VolumeScalePct=1.00
    bStatic=False
    VisibilityRadius=2000.00
    VisibilityHeight=2000.00
}
