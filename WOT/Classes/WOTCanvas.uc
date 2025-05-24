//=============================================================================
// WOTCanvas.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 8 $
//=============================================================================
class WOTCanvas expands LegendCanvas;

// These names should be used in the code and in levels, although they may change.
// Also, keep in mind that any text probably has to fit in 320x200 as well as
// 640x480 and higher, although the plan is to try to automate substituting fonts.

#exec Font Import File=Fonts\UI\F_WOTReg08.pcx		Name=F_WOTReg08
#exec Font Import File=Fonts\UI\F_WOTIta14.pcx		Name=F_WOTIta14
#exec Font Import File=Fonts\UI\F_WOTReg14.pcx		Name=F_WOTReg14
#exec Font Import File=Fonts\UI\F_WOTReg30.pcx		Name=F_WOTReg30
#exec Font Import File=Fonts\UI\F_WOTReg14_S.pcx	Name=F_WOTReg14_S
#exec Font Import File=Fonts\UI\F_WOTReg30_S.pcx	Name=F_WOTReg30_S

// end of WOTCanvas.uc

// don't override SmallFont or we hose the stat menus etc.

defaultproperties
{
     MedFont=Font'WOT.F_WOTReg14'
     BigFont=Font'WOT.F_WOTReg14'
     LargeFont=Font'WOT.F_WOTReg30'
}
