//------------------------------------------------------------------------------
// RespawnFire.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class RespawnFire expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Volume=5.000000
     NumTemplates=4
     Templates(0)=(LifeSpan=3.000000,MaxInitialVelocity=5.000000,MaxDrawScale=0.450000,MinDrawScale=0.350000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=2,MaxGrowRate=0.500000,MinGrowRate=0.250000,FadePhase=2,MaxFadeRate=0.200000,MinFadeRate=0.150000)
     Templates(1)=(LifeSpan=3.000000,MaxInitialVelocity=5.000000,MaxDrawScale=0.450000,MinDrawScale=0.350000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=2,MaxGrowRate=0.500000,MinGrowRate=0.250000,FadePhase=2,MaxFadeRate=0.200000,MinFadeRate=0.150000)
     Templates(2)=(LifeSpan=3.000000,Weight=3.000000,MaxInitialVelocity=5.000000,MaxDrawScale=0.450000,MinDrawScale=0.350000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=2,MaxGrowRate=0.500000,MinGrowRate=0.250000,FadePhase=2,MaxFadeRate=0.200000,MinFadeRate=0.150000)
     Templates(3)=(LifeSpan=3.000000,Weight=5.000000,MaxInitialVelocity=5.000000,MaxDrawScale=0.450000,MinDrawScale=0.350000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=2,MaxGrowRate=0.500000,MinGrowRate=0.250000,FadePhase=2,MaxFadeRate=0.200000,MinFadeRate=0.150000)
     Particles(0)=Texture'ParticleSystems.ReSpawnEffect.RespawnA'
     Particles(1)=Texture'ParticleSystems.ReSpawnEffect.RespawnB'
     Particles(2)=Texture'ParticleSystems.ReSpawnEffect.RespawnC'
     Particles(3)=Texture'ParticleSystems.ReSpawnEffect.RespawnD'
     bOn=True
     bStatic=False
     VisibilityRadius=1000.000000
     VisibilityHeight=1000.000000
}
