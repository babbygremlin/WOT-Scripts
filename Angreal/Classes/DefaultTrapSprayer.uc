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
    Spread=180.00
    Volume=60.00
    Gravity=(X=0.00,Y=0.00,Z=4.00),
    NumTemplates=2
    Templates(0)=(LifeSpan=1.00,Weight=5.00,MaxInitialVelocity=11.00,MinInitialVelocity=0.00,MaxDrawScale=0.35,MinDrawScale=0.15,MaxScaleGlow=0.25,MinScaleGlow=0.50,GrowPhase=2,MaxGrowRate=0.20,MinGrowRate=0.00,FadePhase=1,MaxFadeRate=-0.40,MinFadeRate=-0.75),
    Templates(1)=(LifeSpan=1.00,Weight=3.00,MaxInitialVelocity=17.00,MinInitialVelocity=12.00,MaxDrawScale=0.20,MinDrawScale=0.08,MaxScaleGlow=-0.01,MinScaleGlow=-0.02,GrowPhase=2,MaxGrowRate=0.20,MinGrowRate=0.00,FadePhase=2,MaxFadeRate=0.40,MinFadeRate=0.75),
    bStatic=False
    VisibilityRadius=1000.00
    VisibilityHeight=1000.00
    bOnlyOwnerSee=True
}
