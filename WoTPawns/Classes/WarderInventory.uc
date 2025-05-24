//------------------------------------------------------------------------------
// WarderInventory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//
// Description:	Supports display in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class WarderInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\Grunts\I_SWarder.PCX        GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Grunts\M_SWarder.PCX        GROUP=UI MIPS=Off

defaultproperties
{
     Title="Warder"
     Description="Once a woman becomes Aes Sedai, she may bond a Warder.  Men, chosen for their skills at arms, are permanently linked to Aes Sedai sisters and then trained to be protectors.  They are also issued a color-shifting cloak that allows them to fade into the background, effectively making them invisible.  Warders are among the most fearsome warriors known; some ascribe their uncanny fighting ability to their special bond, but the Aes Sedai deny this."
     Quote="As she left, a tall man Rand had not noticed before moved away from the front of the inn and followed her, one hand resting on the long hilt of a sword. His clothes were dark grayish green that would have faded into leaf or shadow, and his cloak swirled through shades of gray and green and brown as it shifted in the wind. It almost seemed to disappear at times, that cloak, fading into whatever lay beyond it."
     StatusIconFrame=Texture'WOTPawns.UI.M_SWarder'
     ResourceClass=Class'WOTPawns.Warder'
     BaseResourceType=Grunt
     StatusIcon=Texture'WOTPawns.UI.I_SWarder'
}
