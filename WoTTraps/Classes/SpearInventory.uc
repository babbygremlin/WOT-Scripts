//------------------------------------------------------------------------------
// SpearInventory.uc
// $Author: Mfox $
// $Date: 9/22/99 2:33p $
// $Revision: 2 $
//
// Description:	Supports display of Alarm in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class SpearInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\Spear\I_SSpear.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Spear\M_SSpear.PCX GROUP=UI MIPS=Off

defaultproperties
{
     Title="Spear Trap"
     Description="The spear trap can be placed on any vertical or horizontal surface large enough to support it.  It appears as a simple hole.  When someone approaches this hole, a thick, dangerous spear shoots out, cutting and pushing the victim back.  Afterward, it is drawn back into the hole by a connected chain."
     Quote="He stopped in his tracks. That spear waited, ready to seek his ribs..."
     StatusIconFrame=Texture'WOTTraps.UI.M_SSpear'
     ResourceClass=Class'WOTTraps.Spear'
     Count=2
     StatusIcon=Texture'WOTTraps.UI.I_SSpear'
}
