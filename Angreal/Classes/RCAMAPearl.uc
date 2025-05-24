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
     FinalScale=3.000000
     InitialScaleRate=20.000000
     Duration=2.500000
     FadeTime=0.200000
     FadingExpandRate=2.000000
     EndLightRadius=3
     Priority=0
     ProjTouchTime=0.000000
     bNetTemporary=False
     Physics=PHYS_Trailer
     Style=STY_Translucent
     ScaleGlow=0.300000
}
