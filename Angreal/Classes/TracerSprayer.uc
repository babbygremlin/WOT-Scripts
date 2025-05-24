//------------------------------------------------------------------------------
// TracerSprayer.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class TracerSprayer expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
    Gravity=(X=0.00,Y=0.00,Z=-1.00),
    NumTemplates=3
    Templates(0)=(LifeSpan=15.00,Weight=1.00,MaxInitialVelocity=5.00,MinInitialVelocity=0.00,MaxDrawScale=0.30,MinDrawScale=0.10,MaxScaleGlow=1.00,MinScaleGlow=1.00,GrowPhase=0,MaxGrowRate=0.00,MinGrowRate=0.00,FadePhase=1,MaxFadeRate=-0.07,MinFadeRate=-0.10),
    Templates(1)=(LifeSpan=15.00,Weight=1.00,MaxInitialVelocity=5.00,MinInitialVelocity=0.00,MaxDrawScale=0.30,MinDrawScale=0.10,MaxScaleGlow=1.00,MinScaleGlow=1.00,GrowPhase=0,MaxGrowRate=0.00,MinGrowRate=0.00,FadePhase=1,MaxFadeRate=-0.07,MinFadeRate=-0.10),
    Templates(2)=(LifeSpan=15.00,Weight=1.00,MaxInitialVelocity=5.00,MinInitialVelocity=0.00,MaxDrawScale=0.30,MinDrawScale=0.10,MaxScaleGlow=1.00,MinScaleGlow=1.00,GrowPhase=0,MaxGrowRate=0.00,MinGrowRate=0.00,FadePhase=1,MaxFadeRate=-0.07,MinFadeRate=-0.10),
    Particles(0)=Texture'ParticleSystems.Flares.PF03'
    Particles(1)=Texture'ParticleSystems.Flares.PF05'
    Particles(2)=Texture'ParticleSystems.General.Prtcl03'
    bStatic=False
    VisibilityRadius=800.00
    VisibilityHeight=800.00
}
