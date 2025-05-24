//------------------------------------------------------------------------------
// TrollocInventory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 5 $
//
// Description:	Supports display in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class TrollocInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\Grunts\I_STrolloc.PCX        GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Grunts\M_STrolloc.PCX        GROUP=UI MIPS=Off

defaultproperties
{
     Title="Trolloc"
     Description="Trollocs are the grunt soldiers of the Forsaken, crossbred from human and animal stock.  They come in many varieties, but the worst of them are quick, tough, and ferocious¾very difficult to kill.  Some tend to close in to their opponents¾preferring to get a good look at their victims while they rip them apart with their axes¾although other Trollocs have been known to hurl their weapons as well."
     Quote="The Defenders in the anteroom were fighting for their lives beneath the gilded lamps, against bulky, black-mailed shapes head-and-shoulders taller than they, shapes like huge men, but with heads and faces distorted by horns or feathers, by muzzle or beak where mouth and nose should be. They strode on paws and hooves as often as on booted feet..."
     StatusIconFrame=Texture'WOTPawns.UI.M_STrolloc'
     ResourceClass=Class'WOTPawns.TrollocStrong'
     BaseResourceType=Grunt
     StatusIcon=Texture'WOTPawns.UI.I_STrolloc'
}
