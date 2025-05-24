//------------------------------------------------------------------------------
// MyrdSprayerA.uc
// $Author: Aleiby $
// $Date: 8/26/99 8:24p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class MyrdSprayerA expands ParticleSprayer;

//var() float FadeOutTime;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.0;
	Super.PreBeginPlay();
}
/*
//------------------------------------------------------------------------------
// Don't call Super.
//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime );

//------------------------------------------------------------------------------
simulated state FadeAway
{
	simulated function BeginState()
	{
		LifeSpan = FadeOutTime;
	}

	simulated function Tick( float DeltaTime )
	{
		LightBrightness = default.LightBrightness * (LifeSpan / FadeOutTime);
	}
}
*/

defaultproperties
{
     Spread=180.000000
     Volume=100.000000
     Gravity=(Z=8.000000)
     NumTemplates=5
     Templates(0)=(LifeSpan=1.250000,Weight=8.000000,MaxInitialVelocity=10.000000,MinInitialVelocity=-10.000000,MaxDrawScale=0.200000,MinDrawScale=0.100000,GrowPhase=1,MaxGrowRate=-0.050000,MinGrowRate=-0.100000,FadePhase=1,MaxFadeRate=-0.400000,MinFadeRate=-0.800000)
     Templates(1)=(LifeSpan=0.200000,Weight=2.000000,MaxDrawScale=0.200000,MinDrawScale=0.100000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,FadePhase=2,MaxFadeRate=10.000000,MinFadeRate=5.000000)
     Templates(2)=(LifeSpan=3.200000,Weight=15.000000,MaxInitialVelocity=12.000000,MinInitialVelocity=-15.000000,MaxDrawScale=0.150000,MinDrawScale=0.075000,GrowPhase=1,MaxGrowRate=-0.010000,MinGrowRate=-0.050000)
     Templates(3)=(LifeSpan=2.000000,Weight=0.000000,MaxInitialVelocity=2.000000,MinInitialVelocity=-2.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,GrowPhase=2,MaxGrowRate=0.150000,MinGrowRate=0.100000)
     Templates(4)=(LifeSpan=1.500000,MaxInitialVelocity=25.000000,MinInitialVelocity=-25.000000,MaxDrawScale=0.200000,MinDrawScale=0.100000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,FadePhase=5,MaxFadeRate=3.000000,MinFadeRate=2.000000)
     Particles(0)=Texture'ParticleSystems.Flares.PF04'
     Particles(1)=Texture'ParticleSystems.Flares.PF01'
     Particles(2)=Texture'ParticleSystems.Flares.PF17'
     Particles(3)=Texture'ParticleSystems.General.Prtcl18'
     Particles(4)=Texture'ParticleSystems.Sparks.Sparks03'
     bOn=True
     MinVolume=10.000000
     bInterpolate=True
     bStatic=False
     bMustFace=False
}
