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
     Templates(0)=(LifeSpan=2.000000,MaxInitialVelocity=20.000000,MinInitialVelocity=10.000000,MaxDrawScale=1.500000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=-0.500000,MinGrowRate=-1.000000,FadePhase=2,MaxFadeRate=0.100000,MinFadeRate=0.050000)
     Particles(0)=Texture'Angreal.Effects.FBExp503'
     bOn=True
     VolumeScalePct=1.000000
     bStatic=False
     VisibilityRadius=2000.000000
     VisibilityHeight=2000.000000
}
