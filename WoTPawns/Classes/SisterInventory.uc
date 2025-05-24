//------------------------------------------------------------------------------
// SisterInventory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//
// Description:	Supports display in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class SisterInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\Captains\I_SSister.PCX        GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Captains\M_SSister.PCX        GROUP=UI MIPS=Off

defaultproperties
{
     Title="Aes Sedai Sister"
     Description="A woman who can touch the One Power usually finds her way to the White Tower to be trained; otherwise, she may find death or insanity.  After years of study, passing a final test, and taking the three oaths, she becomes a full sister and must join one of the seven sects¾or Ajahs¾within the Tower.  All Aes Sedai are able to channel the One Power to create powerful offensive and defensive weaves for use in defending the Tower.  Sisters can be commanded to kill intruders, guard an area, guard a seal, run for reinforcements, or sound the alarm."
     Quote="She was slender and not at all tall, and smooth-cheeked Aes Sedai agelessness often made her appear younger than she was, but Moiraine had a commanding grace and calm presence that could dominate any gathering."
     StatusIconFrame=Texture'WOTPawns.UI.M_SSister'
     ResourceClass=Class'WOTPawns.Sister'
     BaseResourceType=Captain
     StatusIcon=Texture'WOTPawns.UI.I_SSister'
}
