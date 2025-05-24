//------------------------------------------------------------------------------
// PlayInventory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//
// Description:	Supports display of Alarm in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class PlayInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\I_Play.PCX        GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Play.PCX        GROUP=UI MIPS=Off

defaultproperties
{
     StatusIconFrame=Texture'WOT.UI.M_Play'
     Count=1
     StatusIcon=Texture'WOT.UI.I_Play'
     bHidden=True
}
