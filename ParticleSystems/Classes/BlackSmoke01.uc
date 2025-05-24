//------------------------------------------------------------------------------
// BlackSmoke01.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class BlackSmoke01 expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Spread=100.000000
     Volume=12.000000
     Gravity=(Z=40.000000)
     NumTemplates=3
     Templates(0)=(LifeSpan=5.000000,Weight=5.000000,MaxInitialVelocity=30.000000,MinInitialVelocity=10.000000,MinDrawScale=0.500000,GrowPhase=1,MaxGrowRate=-0.200000,MinGrowRate=-0.300000)
     Templates(1)=(LifeSpan=5.000000,Weight=3.000000,MaxInitialVelocity=50.000000,MinInitialVelocity=5.000000,GrowPhase=1,MaxGrowRate=-0.200000,MinGrowRate=-0.500000)
     Templates(2)=(LifeSpan=5.000000,MaxDrawScale=0.000000,MinDrawScale=0.000000,GrowPhase=2,MaxGrowRate=0.700000,MinGrowRate=0.200000)
     Templates(3)=(LifeSpan=5.000000,Weight=1000000.000000,GrowPhase=1,MaxGrowRate=-0.200000,MinGrowRate=-0.400000)
     Particles(0)=Texture'ParticleSystems.SmokeBlack32.Blk32_005'
     Particles(1)=Texture'ParticleSystems.SmokeBlack32.Blk32_008'
     Particles(2)=Texture'ParticleSystems.SmokeBlack32.Blk32_011'
     bOn=True
     bStatic=False
     bSelected=True
     Style=STY_Modulated
     VisibilityRadius=500.000000
     VisibilityHeight=500.000000
}
