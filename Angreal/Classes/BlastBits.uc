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
     Spread=125.000000
     Volume=120.000000
     NumTemplates=2
     Templates(0)=(LifeSpan=0.500000,Weight=2.000000,MaxInitialVelocity=600.000000,MinInitialVelocity=560.000000,MaxDrawScale=0.700000,MinDrawScale=0.400000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=-0.400000,MinGrowRate=-1.000000,FadePhase=2)
     Templates(1)=(LifeSpan=0.500000,Weight=0.500000,MaxInitialVelocity=550.000000,MaxDrawScale=0.750000,MinDrawScale=0.200000,MinScaleGlow=0.000000,GrowPhase=1,MaxGrowRate=-1.500000,MinGrowRate=-1.250000,FadePhase=2)
     Particles(0)=WetTexture'Angreal.BlastBits.AniBitA'
     Particles(1)=WetTexture'Angreal.BlastBits.AniBitB'
     bOn=True
     VolumeScalePct=0.000000
     bStatic=False
}
