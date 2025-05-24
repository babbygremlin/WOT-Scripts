//------------------------------------------------------------------------------
// LineDot.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//------------------------------------------------------------------------------
class LineDot expands Effects;

#exec TEXTURE IMPORT FILE=MODELS\LineDot.PCX GROUP=Effects FLAGS=2

var LineDot NextDot;

var() float Duration;

//------------------------------------------------------------------------------
simulated function SetDuration( float T )
{
	Duration = T;
	LifeSpan = T;

	ScaleGlow = default.ScaleGlow;
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	if( LifeSpan > 0.0 )
	{
		ScaleGlow = default.ScaleGlow * (LifeSpan / Duration);	// fade out over duration.
	}
}

//------------------------------------------------------------------------------
// Recursively deletes all dots in linked list.
//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( NextDot != None )
	{
		NextDot.Destroy();
		NextDot = None;
	}

	Super.Destroyed();
}

defaultproperties
{
     DrawType=DT_Sprite
     Style=STY_Translucent
     Texture=Texture'Legend.Effects.LineDot'
     DrawScale=0.500000
}
