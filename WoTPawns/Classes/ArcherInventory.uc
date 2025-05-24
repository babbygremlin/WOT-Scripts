//------------------------------------------------------------------------------
// ArcherInventory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//
// Description:	Supports display in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class ArcherInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\Captains\I_SArcher.PCX        GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Captains\M_SArcher.PCX        GROUP=UI MIPS=Off

defaultproperties
{
     Title="Whitecloak Archer"
     Description="The archer is a Whitecloak officer¾stronger, swifter, and better trained than the soldiers under his command.  Although he lacks the soldier's shield, he is armed with a powerful longbow.  The archer must kneel on the ground to use it, but once there, he can let loose a swift, unerring arrow.  The archer can be commanded to kill intruders, guard an area, guard a seal, run for reinforcements, or sound an alarm."
     Quote="They looked around them as if looking at things that had wriggled out from under a rotting log. Nobody looked back, though. Nobody even seemed to notice them. Just the same, the three did not have to push through the crowd; the bustle parted to either side of the white-cloaked men as if by happenstance, leaving them to walk in a clear space that moved with them."
     StatusIconFrame=Texture'WOTPawns.UI.M_SArcher'
     ResourceClass=Class'WOTPawns.Archer'
     BaseResourceType=Captain
     StatusIcon=Texture'WOTPawns.UI.I_SArcher'
}
