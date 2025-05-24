//------------------------------------------------------------------------------
// BalefireLine.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class BalefireLine expands Line;

var float InitialLifeSpan;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	InitialLifeSpan = LifeSpan;
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	ScaleGlow = LifeSpan / InitialLifeSpan;
}

defaultproperties
{
    SegmentLength=18.00
    bParticleDensityScaled=True
    LifeSpan=1.20
    Texture=Texture'ParticleSystems.Sparks.Sparks01'
    DrawScale=2.00
}
