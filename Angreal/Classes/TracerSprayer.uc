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
     Gravity=(Z=-1.000000)
     NumTemplates=3
     Templates(0)=(LifeSpan=15.000000,MaxInitialVelocity=5.000000,MaxDrawScale=0.300000,MinDrawScale=0.100000,FadePhase=1,MaxFadeRate=-0.070000,MinFadeRate=-0.100000)
     Templates(1)=(LifeSpan=15.000000,MaxInitialVelocity=5.000000,MaxDrawScale=0.300000,MinDrawScale=0.100000,FadePhase=1,MaxFadeRate=-0.070000,MinFadeRate=-0.100000)
     Templates(2)=(LifeSpan=15.000000,MaxInitialVelocity=5.000000,MaxDrawScale=0.300000,MinDrawScale=0.100000,FadePhase=1,MaxFadeRate=-0.070000,MinFadeRate=-0.100000)
     Particles(0)=Texture'ParticleSystems.Flares.PF03'
     Particles(1)=Texture'ParticleSystems.Flares.PF05'
     Particles(2)=Texture'ParticleSystems.General.Prtcl03'
     bStatic=False
     VisibilityRadius=800.000000
     VisibilityHeight=800.000000
}
