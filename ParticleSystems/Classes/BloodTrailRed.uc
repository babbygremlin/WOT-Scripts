//------------------------------------------------------------------------------
// BloodTrailRed.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//------------------------------------------------------------------------------

class BloodTrailRed expands BloodBase;

//------------------------------------------------------------------------------
// First cut at a trailing blood PS. Needs work.

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
     Duration=500.000000
     Spread=100.000000
     Volume=500.000000
     Gravity=(Z=-4096.000000)
     NumTemplates=4
     Templates(0)=(LifeSpan=5.000000,MaxInitialVelocity=140.000000,MinInitialVelocity=125.000000,MaxDrawScale=0.100000,MinDrawScale=0.050000)
     Templates(1)=(LifeSpan=5.000000,MaxInitialVelocity=125.000000,MinInitialVelocity=110.000000,MaxDrawScale=0.200000,MinDrawScale=0.040000)
     Templates(2)=(LifeSpan=5.000000,MaxInitialVelocity=130.000000,MinInitialVelocity=100.000000,MaxDrawScale=0.100000,MinDrawScale=0.020000)
     Templates(3)=(LifeSpan=5.000000,MaxInitialVelocity=110.000000,MinInitialVelocity=100.000000,MaxDrawScale=0.150000,MinDrawScale=0.050000)
     Particles(0)=Texture'ParticleSystems.ModulatedBlood.RoundBlood01'
     Particles(1)=Texture'ParticleSystems.ModulatedBlood.RoundBlood02'
     Particles(2)=Texture'ParticleSystems.ModulatedBlood.RoundBlood03'
     Particles(3)=Texture'ParticleSystems.ModulatedBlood.RoundBlood04'
     bOn=True
     bStatic=False
     DetailLevel=1
     Style=STY_Modulated
     VisibilityRadius=500.000000
     VisibilityHeight=500.000000
}
