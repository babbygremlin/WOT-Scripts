//------------------------------------------------------------------------------
// BloodBurstRed2.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//
//------------------------------------------------------------------------------

class BloodBurstRed2 expands BloodBase;

//------------------------------------------------------------------------------
// Scott's "explosion" of blood PS for gibbing. 
// Red blood.

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
     Spread=80.000000
     Volume=600.000000
     Gravity=(Z=-225.000000)
     NumTemplates=7
     Templates(0)=(LifeSpan=0.450000,Weight=8.000000,MaxInitialVelocity=100.000000,MinInitialVelocity=80.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,MaxScaleGlow=6.000000,MinScaleGlow=3.000000,GrowPhase=2,MaxGrowRate=5.000000,MinGrowRate=4.000000,MaxFadeRate=-1.500000,MinFadeRate=-3.000000)
     Templates(1)=(LifeSpan=0.800000,Weight=30.000000,MaxInitialVelocity=200.000000,MinInitialVelocity=100.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,MinScaleGlow=0.800000,GrowPhase=2,MaxGrowRate=3.000000,MinGrowRate=1.000000,FadePhase=1,MaxFadeRate=-0.250000,MinFadeRate=-0.500000)
     Templates(2)=(LifeSpan=2.000000,Weight=30.000000,MaxInitialVelocity=150.000000,MinInitialVelocity=100.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,MaxScaleGlow=0.000000,MinScaleGlow=0.000000,GrowPhase=2,MaxGrowRate=0.500000,MinGrowRate=0.300000,FadePhase=2,MaxFadeRate=0.800000,MinFadeRate=0.500000)
     Templates(3)=(LifeSpan=0.500000,Weight=4.000000,MaxInitialVelocity=150.000000,MinInitialVelocity=80.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,GrowPhase=2,MaxGrowRate=7.000000,MinGrowRate=1.500000)
     Templates(4)=(LifeSpan=0.250000,Weight=5.000000,MaxInitialVelocity=80.000000,MinInitialVelocity=50.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,GrowPhase=2,MaxGrowRate=6.000000,MinGrowRate=6.000000)
     Templates(5)=(LifeSpan=1.500000,Weight=5.000000,MaxInitialVelocity=120.000000,MinInitialVelocity=80.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,GrowPhase=2,MaxGrowRate=3.000000,MinGrowRate=1.000000)
     Templates(6)=(LifeSpan=0.100000,Weight=10.000000,MaxInitialVelocity=200.000000,MinInitialVelocity=10.000000,MaxDrawScale=3.000000,MinDrawScale=0.500000,GrowPhase=1,MaxGrowRate=-0.500000,MinGrowRate=-1.000000)
     Particles(0)=Texture'ParticleSystems.ModulatedBlood.Blood11'
     Particles(1)=Texture'ParticleSystems.ModulatedBlood.RoundBlood02'
     Particles(2)=Texture'ParticleSystems.ModulatedBlood.RoundBlood04'
     Particles(3)=Texture'ParticleSystems.ModulatedBlood.Blood16'
     Particles(4)=Texture'ParticleSystems.ModulatedBlood.Blood17'
     Particles(5)=Texture'ParticleSystems.ModulatedBlood.Blood08'
     Particles(6)=Texture'ParticleSystems.ModulatedBlood.Blood07'
     TimerDuration=0.100000
     bInitiallyOn=False
     DecalType=Class'ParticleSystems.BloodDecalRed'
     DecalPercent=0.030000
     bInterpolate=True
     bStatic=False
     InitialState=TriggerTimed
     Style=STY_Modulated
}
