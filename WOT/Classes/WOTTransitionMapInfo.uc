//=============================================================================
// WOTTransitionMapInfo.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================

class WOTTransitionMapInfo expands Info abstract;

var() localized string EndText;					// name for location at end of current level
var() int EndX, EndY;							// coordinates for location at end of current level (<0 ==> don't show)
var() localized string NextText;				// name for location at start of next level
var() int NextX, NextY;							// coordinates for location at start of next level (<0 ==> don't show)
var() bool bShowMap;							// if set, no map -- just "Loading" over background

//=============================================================================

defaultproperties
{
     EndX=-1
     EndY=-1
     NextX=-1
     NextY=-1
     bShowMap=True
}
