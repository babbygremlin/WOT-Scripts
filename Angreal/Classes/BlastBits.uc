//------------------------------------------------------------------------------
// BlastBits.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class BlastBits expands ParticleSprayer;

#exec OBJ LOAD FILE=Textures\BlastT.utx PACKAGE=Angreal.BlastBits

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	LifeSpan = 2.000000;	// Hardcoded due to struct bug where actual LifeSpan gets overwritten with data from struct.
	SetTimer( 0.2, False );
	Super.PreBeginPlay();
}

//------------------------------------------------------------------------------
simulated function Timer()
{
	bOn = False;
}

defaultproperties
{
    Spread=125.00
    Volume=120.00
    NumTemplates=2
    Templates(0)=(LifeSpan=0.50,Weight=2.00,MaxInitialVelocity=600.00,MinInitialVelocity=560.00,MaxDrawScale=0.70,MinDrawScale=0.40,MaxScaleGlow=1.00,MinScaleGlow=0.00,GrowPhase=1,MaxGrowRate=-0.40,MinGrowRate=-1.00,FadePhase=2,MaxFadeRate=0.00,MinFadeRate=0.00),
    Templates(1)=(LifeSpan=0.50,Weight=0.50,MaxInitialVelocity=550.00,MinInitialVelocity=0.00,MaxDrawScale=0.75,MinDrawScale=0.20,MaxScaleGlow=1.00,MinScaleGlow=0.00,GrowPhase=1,MaxGrowRate=-1.50,MinGrowRate=-1.25,FadePhase=2,MaxFadeRate=0.00,MinFadeRate=0.00),
    Particles(0)=WetTexture'BlastBits.AniBitA'
    Particles(1)=WetTexture'BlastBits.AniBitB'
    bOn=True
    VolumeScalePct=0.00
    bStatic=False
}
