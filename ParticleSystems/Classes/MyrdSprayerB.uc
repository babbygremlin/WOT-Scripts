//------------------------------------------------------------------------------
// MyrdSprayerB.uc
// $Author: Aleiby $
// $Date: 8/26/99 8:24p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class MyrdSprayerB expands ParticleSprayer;

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
     Spread=30.000000
     Volume=60.000000
     Gravity=(Z=-15.000000)
     NumTemplates=3
     Templates(0)=(LifeSpan=3.000000,MaxInitialVelocity=8.000000,MinInitialVelocity=-8.000000,MaxDrawScale=0.300000,MinDrawScale=0.250000,GrowPhase=1,MaxGrowRate=-0.100000,MinGrowRate=-0.200000,MinFadeRate=-0.800000)
     Templates(1)=(LifeSpan=3.000000,MaxInitialVelocity=20.000000,MinInitialVelocity=-20.000000,MaxDrawScale=0.200000,MinDrawScale=0.100000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=-0.060000,MinGrowRate=-0.100000,MaxFadeRate=10.000000,MinFadeRate=5.000000)
     Templates(2)=(LifeSpan=2.500000,MaxInitialVelocity=12.000000,MinInitialVelocity=-15.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,GrowPhase=2,MaxGrowRate=0.065000,MinGrowRate=0.025000)
     Templates(3)=(LifeSpan=2.000000,Weight=3.000000,MaxInitialVelocity=2.000000,MinInitialVelocity=-2.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,GrowPhase=2,MaxGrowRate=0.150000,MinGrowRate=0.100000)
     Templates(4)=(LifeSpan=1.500000,MaxInitialVelocity=25.000000,MinInitialVelocity=-25.000000,MaxDrawScale=0.200000,MinDrawScale=0.100000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,FadePhase=5,MaxFadeRate=3.000000,MinFadeRate=2.000000)
     Particles(0)=Texture'ParticleSystems.SmokeBlack32.Blk32_009'
     Particles(1)=Texture'ParticleSystems.SmokeBlack32.Blk32_014'
     Particles(2)=Texture'ParticleSystems.SmokeBlack64.Blk64_001'
     bOn=True
     MinVolume=5.000000
     bInterpolate=True
     bStatic=False
     Style=STY_Modulated
     bMustFace=False
}
