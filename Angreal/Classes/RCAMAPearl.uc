//------------------------------------------------------------------------------
// RCAMAPearl.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	Remove Curse AMAPearl
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class RCAMAPearl expands AMAPearl;

var Leech ParentLeech;

//------------------------------------------------------------------------------
simulated singular function Destroyed()
{
	if( ParentLeech != None && !ParentLeech.bDeleteMe )
	{
		ParentLeech.UnAttach();
		ParentLeech.Destroy();
	}

	Super.Destroyed();
}

defaultproperties
{
    FinalScale=3.00
    InitialScaleRate=20.00
    Duration=2.50
    FadeTime=0.20
    FadingExpandRate=2.00
    EndLightRadius=3
    Priority=0
    ProjTouchTime=0.00
    bNetTemporary=False
    Physics=11
    Style=3
    ScaleGlow=0.30
}
