//------------------------------------------------------------------------------
// RoamInventory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//
// Description:	Supports display of Alarm in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class RoamInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\I_Roam.PCX        GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\M_Roam.PCX        GROUP=UI MIPS=Off

defaultproperties
{
     StatusIconFrame=Texture'WOT.UI.M_Roam'
     StatusIcon=Texture'WOT.UI.I_Roam'
     bHidden=True
}
