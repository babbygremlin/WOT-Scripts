//=============================================================================
// WOTTextWindowInfo.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 5 $
//=============================================================================

class WOTTextWindowInfo expands Info;

var() int WindowSizeX;
var() int WindowSizeY;
var() int WindowOffsetX;
var() int WindowOffsetY;
var() localized string Title;
var() localized string SubTitle;
var() localized string Content[96];

// end of WOTTextWindowInfo.uc

defaultproperties
{
     WindowSizeX=-1
     WindowSizeY=-1
     WindowOffsetX=-1
     WindowOffsetY=-1
}
