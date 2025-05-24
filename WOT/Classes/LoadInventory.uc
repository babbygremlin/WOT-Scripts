//------------------------------------------------------------------------------
// LoadInventory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//
// Description:	Supports display of Alarm in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class LoadInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\I_Load.PCX        GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Load.PCX        GROUP=UI MIPS=Off

defaultproperties
{
     StatusIconFrame=Texture'WOT.UI.M_Load'
     StatusIcon=Texture'WOT.UI.I_Load'
     bHidden=True
}
