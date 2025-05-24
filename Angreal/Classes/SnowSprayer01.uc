//------------------------------------------------------------------------------
// SnowSprayer01.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class SnowSprayer01 expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Spread=95.000000
     Volume=60.000000
     Gravity=(X=20.000000,Z=-90.000000)
     NumTemplates=2
     Templates(0)=(LifeSpan=0.650000,MaxInitialVelocity=-20.000000,MinInitialVelocity=-18.000000,MaxDrawScale=0.400000,MinDrawScale=0.100000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=1.000000,FadePhase=2,MaxFadeRate=3.000000)
     Templates(1)=(LifeSpan=0.750000,MaxInitialVelocity=20.000000,MinInitialVelocity=-18.000000,MaxDrawScale=0.400000,MinDrawScale=0.100000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=2,MaxGrowRate=1.000000,FadePhase=2,MaxFadeRate=3.000000)
     Particles(0)=Texture'Angreal.Ice.SnowE'
     Particles(1)=Texture'Angreal.Ice.SnowD'
     bOn=True
     MinVolume=20.000000
     bStatic=False
}
