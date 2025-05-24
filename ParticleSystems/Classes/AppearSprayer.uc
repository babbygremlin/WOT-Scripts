//------------------------------------------------------------------------------
// AppearSprayer.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AppearSprayer expands ParticleSprayer;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Spread=5.000000
     Volume=25.000000
     NumTemplates=1
     Templates(0)=(LifeSpan=2.000000,MaxInitialVelocity=20.000000,MaxDrawScale=0.500000,MinDrawScale=0.250000,GrowPhase=1,MaxGrowRate=0.300000,MinGrowRate=-0.300000,FadePhase=1,MaxFadeRate=-0.500000,MinFadeRate=-0.700000)
     bOn=True
     VolumeScalePct=0.000000
     bLOSClip=True
     bStatic=False
     VisibilityRadius=0.000000
     VisibilityHeight=0.000000
}
