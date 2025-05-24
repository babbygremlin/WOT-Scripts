//------------------------------------------------------------------------------
// BFSprayer.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	ParticleSprayer used by Balefire.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class BFSprayer expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Spread=0.000000
     Volume=30.000000
     NumTemplates=1
     Templates(0)=(LifeSpan=0.300000,MaxInitialVelocity=100.000000,MinInitialVelocity=50.000000,MaxDrawScale=0.200000,MinDrawScale=0.100000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=-0.400000,MinGrowRate=-0.400000,FadePhase=1,MaxFadeRate=3.000000,MinFadeRate=1.000000)
     Particles(0)=Texture'ParticleSystems.Flares.PF15'
     ParticleDistribution=DIST_Linear
     bOn=True
     bStatic=False
     VisibilityRadius=800.000000
     VisibilityHeight=800.000000
}
