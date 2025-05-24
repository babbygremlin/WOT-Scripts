//------------------------------------------------------------------------------
// DefaultTrapSprayer.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class DefaultTrapSprayer expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Spread=180.000000
     Volume=60.000000
     Gravity=(Z=4.000000)
     NumTemplates=2
     Templates(0)=(Weight=5.000000,MaxInitialVelocity=11.000000,MaxDrawScale=0.350000,MinDrawScale=0.150000,MaxScaleGlow=0.250000,MinScaleGlow=0.500000,GrowPhase=2,MaxGrowRate=0.200000,FadePhase=1,MaxFadeRate=-0.400000,MinFadeRate=-0.750000)
     Templates(1)=(Weight=3.000000,MaxInitialVelocity=17.000000,MinInitialVelocity=12.000000,MaxDrawScale=0.200000,MinDrawScale=0.075000,MaxScaleGlow=-0.010000,MinScaleGlow=-0.020000,GrowPhase=2,MaxGrowRate=0.200000,FadePhase=2,MaxFadeRate=0.400000,MinFadeRate=0.750000)
     bStatic=False
     VisibilityRadius=1000.000000
     VisibilityHeight=1000.000000
     bOnlyOwnerSee=True
}
