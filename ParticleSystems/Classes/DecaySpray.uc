//------------------------------------------------------------------------------
// DecaySpray.uc
// $Author: Aleiby $
// $Date: 8/26/99 8:24p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class DecaySpray expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.0;
	Super.PreBeginPlay();
}

defaultproperties
{
     Spread=0.000000
     Volume=1.000000
     Gravity=(Z=-950.000000)
     NumTemplates=1
     Templates(0)=(LifeSpan=2.000000,MaxDrawScale=0.400000,MinDrawScale=0.200000,GrowPhase=10,MaxGrowRate=0.700000,MinGrowRate=0.500000)
     Templates(1)=(LifeSpan=2.000000,MaxDrawScale=0.400000,MinDrawScale=0.200000,GrowPhase=10,MaxGrowRate=0.700000,MinGrowRate=0.500000)
     Particles(0)=Texture'ParticleSystems.Decay.decaydrop'
     Particles(1)=Texture'ParticleSystems.Decay.decaydrop1'
     bOn=True
     DecalType=Class'ParticleSystems.DecaySplatter'
     DecalPercent=1.000000
     bDisableTick=False
     bStatic=False
     Style=STY_Modulated
}
