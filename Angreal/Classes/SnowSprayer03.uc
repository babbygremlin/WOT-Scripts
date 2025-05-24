//------------------------------------------------------------------------------
// SnowSprayer03.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class SnowSprayer03 expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Spread=10.000000
     Volume=60.000000
     Gravity=(X=50.000000)
     NumTemplates=1
     Templates(0)=(LifeSpan=0.100000,MinInitialVelocity=-5.000000,MaxDrawScale=0.600000,MinDrawScale=0.550000,MaxScaleGlow=0.000000,MaxGrowRate=1.000000,FadePhase=2,MaxFadeRate=3.000000,MinFadeRate=2.000000)
     Particles(0)=Texture'Angreal.Ice.SnowC'
     bOn=True
     MinVolume=20.000000
     bStatic=False
}
