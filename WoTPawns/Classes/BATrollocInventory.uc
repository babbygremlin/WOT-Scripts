//------------------------------------------------------------------------------
// BATrollocInventory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//
// Description:	Supports display in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class BATrollocInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\Champions\I_SBATrolloc.PCX        GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Champions\M_SBATrolloc.PCX        GROUP=UI MIPS=Off

defaultproperties
{
     Title="Trolloc Clan Leader"
     Description="Trollocs are always big and nasty, but only the most horrible climb the ranks to the Clan Leader.  This boar-like half-breed towers over his brethren and is armed with a double-sided halberd--devastating up close, but the Leader can also throw it with amazing accuracy and speed.   The Trolloc Clan Leader is probably the quickest and most resilient of the Dark One's forces."
     Quote="The one still standing raised its spiked axe, coming as close to a smile as a boar's snout and tusks would allow. Rand struggled to move, to breathe."
     StatusIconFrame=Texture'WOTPawns.UI.M_SBATrolloc'
     ResourceClass=Class'WOTPawns.BATrolloc'
     BaseResourceType=Champion
     StatusIcon=Texture'WOTPawns.UI.I_SBATrolloc'
}
