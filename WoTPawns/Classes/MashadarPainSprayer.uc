//------------------------------------------------------------------------------
// MashadarPainSprayer.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class MashadarPainSprayer expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 1.0;
	Super.PreBeginPlay();
}

//------------------------------------------------------------------------------
simulated function SetInitialState()
{
	Super.SetInitialState();
	Trigger( Self, None );
}

defaultproperties
{
     Spread=90.000000
     Volume=120.000000
     Gravity=(Z=-200.000000)
     NumTemplates=4
     Templates(0)=(LifeSpan=0.750000,Weight=0.500000,MaxInitialVelocity=150.000000,MinInitialVelocity=75.000000,MaxDrawScale=0.200000,MinDrawScale=0.200000,MaxScaleGlow=0.010000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=-0.090000,MinGrowRate=-0.050000,FadePhase=2,MaxFadeRate=1.000000,MinFadeRate=1.000000)
     Templates(1)=(LifeSpan=0.750000,MaxInitialVelocity=140.000000,MinInitialVelocity=65.000000,MaxDrawScale=0.200000,MinDrawScale=0.200000,MaxScaleGlow=0.020000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=1.500000,MinGrowRate=0.750000,FadePhase=2,MaxFadeRate=1.000000,MinFadeRate=1.000000)
     Templates(2)=(LifeSpan=0.750000,MaxInitialVelocity=125.000000,MinInitialVelocity=55.000000,MaxDrawScale=0.500000,MinDrawScale=0.400000,MaxScaleGlow=0.010000,MinScaleGlow=0.000000,GrowPhase=2,MaxGrowRate=1.500000,MinGrowRate=0.750000,FadePhase=2,MaxFadeRate=1.000000,MinFadeRate=1.000000)
     Templates(3)=(LifeSpan=0.750000,MaxInitialVelocity=110.000000,MinInitialVelocity=65.000000,MaxDrawScale=0.500000,MinDrawScale=0.400000,MaxScaleGlow=0.010000,MinScaleGlow=0.100000,GrowPhase=2,MaxGrowRate=1.500000,MinGrowRate=0.750000,FadePhase=2,MaxFadeRate=1.000000,MinFadeRate=1.000000)
     Particles(0)=WetTexture'WOTPawns.Mashadar.MyTex2'
     Particles(1)=Texture'ParticleSystems.Smoke.particle_fog06'
     Particles(2)=Texture'ParticleSystems.Smoke.particle_fog05'
     Particles(3)=Texture'WOTPawns.Mashadar.NewSmoke.SmokePuff02'
     TimerDuration=0.100000
     bInitiallyOn=False
     bOn=True
     MinVolume=50.000000
     bStatic=False
     bNetTemporary=True
     RemoteRole=ROLE_SimulatedProxy
     InitialState=TriggerTimed
}
