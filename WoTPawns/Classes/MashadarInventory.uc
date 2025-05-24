//------------------------------------------------------------------------------
// MashadarInventory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//
// Description:	Supports display in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class MashadarInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\Captains\I_SMashadar.PCX        GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Captains\M_SMashadar.PCX        GROUP=UI MIPS=Off

defaultproperties
{
     Title="Mashadar"
     Description="Thousands of years ago, the city of Aridhol--now known as Shadar Logoth, or @Shadow's Waiting@ in the old tongue--collapsed under the weight of its own evil.  The only resident left was a single evil entity known as Mashadar.  It manifests as tendrils of mist which, upon contact with flesh, drain the life force from its victims; Mashadar grows stronger as the victim weakens and eventually dies.  Each tendril can be destroyed, which causes it to retract back into the city walls.  Mashadar tendrils can be commanded to guard an area, guard a seal, or kill intruders."
     Quote="Behind him, the glow in the windows of the palace brightened. Mashadar oozed out of the windows, thick billows of silver-gray fog sliding together, merging as they loomed above his head."
     StatusIconFrame=Texture'WOTPawns.UI.M_SMashadar'
     ResourceClass=Class'WOTPawns.MashadarFocusPawn'
     BaseResourceType=Captain
     StatusIcon=Texture'WOTPawns.UI.I_SMashadar'
}
