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

#exec OBJ LOAD FILE=Textures\LStrikeSparkT.utx PACKAGE=Angreal.Lightning

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 0.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	Super.PreBeginPlay();
}

defaultproperties
{
    Spread=120.00
    Volume=50.00
    Gravity=(X=0.00,Y=0.00,Z=-50.00),
    NumTemplates=3
    Templates(0)=(LifeSpan=0.30,Weight=1.00,MaxInitialVelocity=125.00,MinInitialVelocity=100.00,MaxDrawScale=0.20,MinDrawScale=0.15,MaxScaleGlow=1.00,MinScaleGlow=0.00,GrowPhase=1,MaxGrowRate=-0.75,MinGrowRate=-0.50,FadePhase=2,MaxFadeRate=2.00,MinFadeRate=2.00),
    Templates(1)=(LifeSpan=0.20,Weight=1.00,MaxInitialVelocity=155.00,MinInitialVelocity=135.00,MaxDrawScale=0.20,MinDrawScale=0.10,MaxScaleGlow=0.75,MinScaleGlow=0.00,GrowPhase=1,MaxGrowRate=-0.75,MinGrowRate=-0.50,FadePhase=2,MaxFadeRate=-1.00,MinFadeRate=-1.00),
    Templates(2)=(LifeSpan=0.10,Weight=0.35,MaxInitialVelocity=0.00,MinInitialVelocity=25.00,MaxDrawScale=0.50,MinDrawScale=0.25,MaxScaleGlow=1.00,MinScaleGlow=1.00,GrowPhase=2,MaxGrowRate=1.00,MinGrowRate=1.00,FadePhase=2,MaxFadeRate=1.00,MinFadeRate=0.00),
    Particles(0)=FireTexture'Lightning.LSsparkA'
    Particles(1)=FireTexture'Lightning.LSsparkA'
    Particles(2)=FireTexture'Lightning.LSsparkA'
    bOn=True
    bStatic=False
    VisibilityRadius=800.00
    VisibilityHeight=800.00
}
