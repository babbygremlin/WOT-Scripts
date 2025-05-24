//------------------------------------------------------------------------------
// SnowSprayer02.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class SnowSprayer02 expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Spread=155.000000
     Volume=60.000000
     Gravity=(X=15.000000,Z=-50.000000)
     NumTemplates=1
     Templates(0)=(MaxInitialVelocity=20.000000,MinInitialVelocity=-10.000000,MaxDrawScale=0.300000,MinDrawScale=0.090000,MinScaleGlow=0.000000,GrowPhase=2,FadePhase=2)
     Particles(0)=Texture'Angreal.Ice.SnowB'
     bOn=True
     MinVolume=20.000000
     bStatic=False
}
