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
     SegmentLength=18.000000
     bParticleDensityScaled=True
     LifeSpan=1.200000
     Texture=Texture'ParticleSystems.Sparks.Sparks01'
     DrawScale=2.000000
}
