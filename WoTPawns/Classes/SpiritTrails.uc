//=============================================================================
// SpiritTrails.
//=============================================================================
class SpiritTrails expands ParticleSprayer;

function PreBeginPlay()
{
	Super.PreBeginPlay();

	LifeSpan=0.0;
}

defaultproperties
{
     NumTemplates=1
     Templates(0)=(LifeSpan=5.000000,MaxInitialVelocity=15.000000,MinInitialVelocity=10.000000,MaxDrawScale=0.700000,MinDrawScale=0.200000,MinScaleGlow=0.100000,GrowPhase=1,MaxGrowRate=-0.100000,MinGrowRate=-0.300000,FadePhase=1,MaxFadeRate=-0.500000,MinFadeRate=-0.500000)
     Particles(0)=Texture'ParticleSystems.Magic.particle_white1'
     ParticleDistribution=DIST_Linear
     bStatic=False
}
