//------------------------------------------------------------------------------
// SoldierInventory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//
// Description:	Supports display in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class SoldierInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\Grunts\I_SSoldier.PCX        GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Grunts\M_SSoldier.PCX        GROUP=UI MIPS=Off

defaultproperties
{
     Title="Whitecloak Soldier"
     Description="The soldiers are the backbone of the Children of the Light's fanatical army.  Their uniforms include conical helmets, a sunburst shield, and the traditional white cloaks by which they are known.   The soldiers are trained to close with their opponents and attack with blades, while using their shields to deflect any physical projectiles.  Unfortunately, the shields are damaged by such attacks and can eventually be destroyed."
     Quote="Three men in breastplates and conical steel caps, burnished till they shone like silver, were making their way down the street toward Rand and Mat. Even the mail on their arms gleamed. Their long cloaks, pristine white and embroidered on the left breast with a golden sunburst, just cleared the mud and puddles of the street."
     StatusIconFrame=Texture'WOTPawns.UI.M_SSoldier'
     ResourceClass=Class'WOTPawns.Soldier'
     BaseResourceType=Grunt
     StatusIcon=Texture'WOTPawns.UI.I_SSoldier'
}
