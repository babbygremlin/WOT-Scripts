//------------------------------------------------------------------------------
// Flame01.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class Flame01 expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Volume=25.000000
     Gravity=(Z=100.000000)
     NumTemplates=2
     Templates(0)=(LifeSpan=3.000000,MaxInitialVelocity=25.000000,MinInitialVelocity=15.000000,MaxDrawScale=0.500000,MinDrawScale=0.300000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=-0.750000,MinGrowRate=-0.500000,FadePhase=2,MaxFadeRate=0.750000,MinFadeRate=0.500000)
     Templates(1)=(Weight=2.000000,MaxInitialVelocity=25.000000,MinInitialVelocity=15.000000,MaxDrawScale=0.500000,MinDrawScale=0.250000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=-0.750000,MinGrowRate=-0.500000,FadePhase=2,MaxFadeRate=0.750000,MinFadeRate=0.500000)
     Particles(0)=Texture'ParticleSystems.Fire.FlameBase02'
     Particles(1)=Texture'ParticleSystems.Fire.Flame07'
     bOn=True
     bStatic=False
     VisibilityRadius=500.000000
     VisibilityHeight=500.000000
}
