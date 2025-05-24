//------------------------------------------------------------------------------
// BloodSpray02.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//------------------------------------------------------------------------------

class BloodSpray02 expands BloodBase;

//------------------------------------------------------------------------------
// Small spray of blood used for damage to big chunks. Decals.

var() float Duration;

//------------------------------------------------------------------------------

simulated function PreBeginPlay()
{
	LifeSpan = 0.0;
	SetTimer( Duration, false );
	Super.PreBeginPlay();
}

//------------------------------------------------------------------------------

simulated function Timer()
{
	bOn = false;
	LifeSpan = 2.0;
}

//------------------------------------------------------------------------------

defaultproperties
{
     Duration=0.200000
     Spread=100.000000
     Volume=5000.000000
     Gravity=(Z=-400.000000)
     NumTemplates=4
     Templates(0)=(MaxInitialVelocity=70.000000,MinInitialVelocity=62.000000,MaxDrawScale=0.100000,MinDrawScale=0.050000)
     Templates(1)=(LifeSpan=2.000000,MaxInitialVelocity=62.000000,MinInitialVelocity=55.000000,MaxDrawScale=0.200000,MinDrawScale=0.040000)
     Templates(2)=(LifeSpan=2.000000,MaxInitialVelocity=65.000000,MinInitialVelocity=50.000000,MaxDrawScale=0.100000,MinDrawScale=0.020000)
     Templates(3)=(LifeSpan=2.000000,MaxInitialVelocity=55.000000,MinInitialVelocity=50.000000,MaxDrawScale=0.150000,MinDrawScale=0.050000)
     Particles(0)=Texture'ParticleSystems.ModulatedBlood.RoundBlood01'
     Particles(1)=Texture'ParticleSystems.ModulatedBlood.RoundBlood02'
     Particles(2)=Texture'ParticleSystems.ModulatedBlood.RoundBlood03'
     Particles(3)=Texture'ParticleSystems.ModulatedBlood.RoundBlood04'
     PrimeCount=3.000000
     bOn=True
     DecalType=Class'ParticleSystems.BloodDecalRed'
     DecalPercent=0.030000
     bStatic=False
     DetailLevel=1
     Style=STY_Modulated
     SpriteProjForward=32.000000
     VisibilityRadius=500.000000
     VisibilityHeight=500.000000
}
