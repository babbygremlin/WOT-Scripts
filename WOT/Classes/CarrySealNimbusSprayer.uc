//------------------------------------------------------------------------------
// CarrySealNimbusSprayer.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class CarrySealNimbusSprayer expands ParticleSprayer;

#exec OBJ LOAD FILE=Textures\CarryingSealT.utx PACKAGE=WOT.CarryingSeal

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Spread=5.000000
     Volume=20.000000
     NumTemplates=1
     Templates(0)=(LifeSpan=0.500000,MaxDrawScale=0.500000,MinDrawScale=0.500000,MaxScaleGlow=0.200000,MinScaleGlow=0.150000,GrowPhase=1,MaxGrowRate=0.500000,MinGrowRate=0.500000,FadePhase=1,MaxFadeRate=-0.500000,MinFadeRate=-0.500000)
     ParticleDistribution=DIST_Linear
     bOn=True
     MinVolume=0.250000
     bGrouped=True
     bStatic=False
     bTrailerSameRotation=True
     bTrailerPrePivot=True
     Physics=PHYS_Trailer
     VisibilityRadius=800.000000
     VisibilityHeight=800.000000
}
