//------------------------------------------------------------------------------
// BFSprayer01.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	ParticleSprayer used by Balefire.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class BFSprayer01 expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
    Spread=20.00
    Volume=30.00
    NumTemplates=1
    Templates=(LifeSpan=0.50,Weight=1.00,MaxInitialVelocity=100.00,MinInitialVelocity=50.00,MaxDrawScale=0.50,MinDrawScale=0.50,MaxScaleGlow=0.00,MinScaleGlow=0.00,GrowPhase=1,MaxGrowRate=-1.00,MinGrowRate=-1.50,FadePhase=1,MaxFadeRate=1.00,MinFadeRate=0.50),
    Particles=Texture'ParticleSystems.Flares.PF15'
    ParticleDistribution=1
    bOn=True
    bStatic=False
    VisibilityRadius=800.00
    VisibilityHeight=800.00
}
