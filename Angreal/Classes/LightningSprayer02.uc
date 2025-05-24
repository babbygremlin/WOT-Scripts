//------------------------------------------------------------------------------
// LightningSprayer02.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LightningSprayer02 expands ParticleSprayer;

#exec OBJ LOAD FILE=Textures\LStrikeSparkT.utx PACKAGE=Angreal.Lightning //FIXME this doesn't seem to exist

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
     Spread=120.000000
     Volume=50.000000
     Gravity=(Z=-50.000000)
     NumTemplates=3
     Templates(0)=(LifeSpan=0.300000,MaxInitialVelocity=125.000000,MinInitialVelocity=100.000000,MaxDrawScale=0.200000,MinDrawScale=0.150000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=-0.750000,MinGrowRate=-0.500000,FadePhase=2,MaxFadeRate=2.000000,MinFadeRate=2.000000)
     Templates(1)=(LifeSpan=0.200000,MaxInitialVelocity=155.000000,MinInitialVelocity=135.000000,MaxDrawScale=0.200000,MinDrawScale=0.100000,MaxScaleGlow=0.750000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=-0.750000,MinGrowRate=-0.500000,FadePhase=2,MaxFadeRate=-1.000000,MinFadeRate=-1.000000)
     Templates(2)=(LifeSpan=0.100000,Weight=0.350000,MinInitialVelocity=25.000000,MaxDrawScale=0.500000,MinDrawScale=0.250000,GrowPhase=2,MaxGrowRate=1.000000,MinGrowRate=1.000000,FadePhase=2,MaxFadeRate=1.000000)
     Particles(0)=FireTexture'Angreal.Lightning.LSsparkA'
     Particles(1)=FireTexture'Angreal.Lightning.LSsparkA'
     Particles(2)=FireTexture'Angreal.Lightning.LSsparkA'
     bOn=True
     bStatic=False
     VisibilityRadius=800.000000
     VisibilityHeight=800.000000
}
