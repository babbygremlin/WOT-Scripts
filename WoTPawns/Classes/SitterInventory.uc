//------------------------------------------------------------------------------
// SitterInventory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//
// Description:	Supports display in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class SitterInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\Champions\I_SSitter.PCX        GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Champions\M_SSitter.PCX        GROUP=UI MIPS=Off

defaultproperties
{
     Title="Aes Sedai Sitter of the Hall"
     Description="The ruling council of the Aes Sedai is known as the Hall of the Tower, which consists of three representatives, called @Sitters,@ from each Ajah; the Amyrlin Seat who leads the Hall; and the Keeper of the Chronicles, the Amyrlin's right hand.  The Sitters tend to be the most experienced and dangerous sisters in the Tower; they command a larger repertoire of weaves--more powerful and requiring a greater ability to channel--than any other Aes Sedai."
     StatusIconFrame=Texture'WOTPawns.UI.M_SSitter'
     ResourceClass=Class'WOTPawns.Sitter'
     BaseResourceType=Champion
     StatusIcon=Texture'WOTPawns.UI.I_SSitter'
}
