//------------------------------------------------------------------------------
// GenericDamageEffect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//
//------------------------------------------------------------------------------

class GenericDamageEffect expands ParticleSprayer;

var() float EffectDuration;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
	SetTimer( EffectDuration, False );
}

simulated function Timer()
{
	LifeSpan = 2.000000;
	bOn = false;
}

defaultproperties
{
     EffectDuration=0.100000
     Volume=100.000000
     Gravity=(Z=-500.000000)
     NumTemplates=2
     Templates(0)=(MaxInitialVelocity=200.000000,MinInitialVelocity=100.000000,MinDrawScale=0.300000,GrowPhase=1,MaxGrowRate=-1.000000,MinGrowRate=-1.000000)
     Templates(1)=(LifeSpan=0.700000,MaxInitialVelocity=250.000000,MinInitialVelocity=100.000000,MaxDrawScale=0.300000,GrowPhase=1,MaxGrowRate=1.000000)
     Particles(1)=Texture'ParticleSystems.ModulatedBlood.Blood18'
     bStatic=False
     Style=STY_Masked
     VisibilityRadius=500.000000
     VisibilityHeight=500.000000
}
