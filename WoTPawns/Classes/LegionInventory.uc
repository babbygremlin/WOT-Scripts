//------------------------------------------------------------------------------
// LegionInventory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//
// Description:	Supports display in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class LegionInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\Champions\I_SLegion.PCX        GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Champions\M_SLegion.PCX        GROUP=UI MIPS=Off

defaultproperties
{
     Title="Legion"
     Description="Mashadar lacks a physical form, but it found that it could create one by binding the almost-dead bodies of its victims together, then animate it by manipulating the still-living muscles and tendons.  The result is a hulking, lumbering monstrosity.  Despite the frail appearance of the collected bodies, Legion can smash its bulk into the ground to cause violent tremors that throw sprays of energy upward.  Legion can also unleash seeking spirit tendrils to track down and subdue its prey, readying it for inclusion into Legion's collection."
     Quote="@Late in the Trolloc Wars, an army camped within these ruins -- Trollocs, Darkfriends, Myrddraal, Dreadlords, thousands in all. When they did not come out, scouts were sent inside the walls. The scouts found weapons, bits of armor, and blood splattered everywhere. And messages scratched on the walls in the Trolloc tongue, calling on the Dark One to aid them in their last hour.@"
     StatusIconFrame=Texture'WOTPawns.UI.M_SLegion'
     ResourceClass=Class'WOTPawns.Legion'
     BaseResourceType=Champion
     StatusIcon=Texture'WOTPawns.UI.I_SLegion'
}
