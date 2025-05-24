//------------------------------------------------------------------------------
// AirBlastBall.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AirBlastBall expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Spread=0.000000
     NumTemplates=3
     Templates(0)=(LifeSpan=0.300000,MaxInitialVelocity=350.000000,MinInitialVelocity=350.000000,MaxDrawScale=0.500000,MinDrawScale=0.300000,FadePhase=1,MaxFadeRate=-3.000000,MinFadeRate=-3.000000)
     Templates(1)=(LifeSpan=0.300000,MaxInitialVelocity=350.000000,MinInitialVelocity=350.000000,MaxDrawScale=0.500000,MinDrawScale=0.300000,FadePhase=1,MaxFadeRate=-3.000000,MinFadeRate=-3.000000)
     Templates(2)=(LifeSpan=0.300000,MaxInitialVelocity=350.000000,MinInitialVelocity=350.000000,MaxDrawScale=0.500000,MinDrawScale=0.300000,FadePhase=1,MaxFadeRate=-3.000000,MinFadeRate=-3.000000)
     Particles(0)=Texture'ParticleSystems.Appear.CyanCorona'
     Particles(1)=Texture'ParticleSystems.Flares.PF17'
     Particles(2)=Texture'ParticleSystems.Sparks.Sparks01'
     bOn=True
     MinVolume=10.000000
     bStatic=False
     bStasis=True
     VisibilityRadius=2500.000000
     VisibilityHeight=2500.000000
}
