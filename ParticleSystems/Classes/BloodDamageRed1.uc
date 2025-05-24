//------------------------------------------------------------------------------
// BloodDamageRed1.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//
//------------------------------------------------------------------------------

class BloodDamageRed1 expands BloodBase;

//------------------------------------------------------------------------------
// Scott's damage blood PS.
// Red.

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 2.1;
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
     Spread=10.000000
     Volume=800.000000
     Gravity=(Z=-225.000000)
     NumTemplates=4
     Templates(0)=(LifeSpan=0.100000,Weight=2.000000,MaxInitialVelocity=10.000000,MinInitialVelocity=10.000000,MaxDrawScale=1.250000,MinDrawScale=0.750000,MaxScaleGlow=6.000000,MinScaleGlow=3.000000,GrowPhase=1,MaxGrowRate=-0.350000,MinGrowRate=-0.500000,MaxFadeRate=-1.500000,MinFadeRate=-3.000000)
     Templates(1)=(LifeSpan=3.000000,Weight=50.000000,MaxInitialVelocity=250.000000,MinInitialVelocity=150.000000,MaxDrawScale=0.150000,MinDrawScale=0.100000,MinScaleGlow=0.800000,GrowPhase=1,MaxGrowRate=-0.025000,MinGrowRate=-0.050000,FadePhase=1,MaxFadeRate=-0.250000,MinFadeRate=-0.500000)
     Templates(2)=(LifeSpan=2.000000,Weight=24.000000,MaxInitialVelocity=150.000000,MinInitialVelocity=50.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=2,MaxGrowRate=0.250000,MinGrowRate=0.150000,FadePhase=2,MaxFadeRate=0.800000,MinFadeRate=0.500000)
     Templates(3)=(LifeSpan=0.500000,Weight=2.000000,MaxInitialVelocity=90.000000,MinInitialVelocity=50.000000,MaxDrawScale=1.500000,GrowPhase=1,MaxGrowRate=-2.000000,MinGrowRate=-3.000000)
     Particles(0)=Texture'ParticleSystems.ModulatedBlood.Blood07'
     Particles(1)=Texture'ParticleSystems.ModulatedBlood.RoundBlood02'
     Particles(2)=Texture'ParticleSystems.ModulatedBlood.RoundBlood01'
     Particles(3)=Texture'ParticleSystems.ModulatedBlood.Blood07'
     TimerDuration=0.100000
     bInitiallyOn=False
     MinVolume=100.000000
     DecalType=Class'ParticleSystems.BloodDecalRed'
     DecalPercent=0.030000
     bInterpolate=True
     bStatic=False
     bDynamicLight=True
     InitialState=TriggerTimed
     Style=STY_Modulated
}
