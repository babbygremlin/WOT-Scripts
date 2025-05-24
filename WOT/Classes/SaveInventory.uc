//------------------------------------------------------------------------------
// SaveInventory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//
// Description:	Supports display of Alarm in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class SaveInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\I_Save.PCX        GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Save.PCX        GROUP=UI MIPS=Off

defaultproperties
{
     StatusIconFrame=Texture'WOT.UI.M_Save'
     StatusIcon=Texture'WOT.UI.I_Save'
     bHidden=True
}
