//------------------------------------------------------------------------------
// MinionInventory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//
// Description:	Supports display in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class MinionInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\Grunts\I_SMinion.PCX        GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Grunts\M_SMinion.PCX        GROUP=UI MIPS=Off

defaultproperties
{
     Title="Minion"
     Description="Uninvited guests to the ruined city of Shadar Logoth don't usually leave.  The lucky ones die.  Others cling to life, but are corrupted by Mashadar--the soulless evil that pervades the city¾until they become Minions.  Born cowards, Minions hide in the shadows, waiting for a hapless victim to wander nearby. Minions are extremely quick and can evade most standard projectiles, but they prefer to remain still--watching and waiting, especially if they think their movement might be seen.  When eyes are turned, they bolt to a pocket of shadows close to their prey, then extend the hooked limbs attached to their backs into the victim's flesh and draw them into the shadows to rend the meat from their bones."
     Quote="Down the street, beyond a spired monument miraculously standing straight, something moved, a shadowed shape darting across the way in the darkness."
     StatusIconFrame=Texture'WOTPawns.UI.M_SMinion'
     ResourceClass=Class'WOTPawns.Minion'
     BaseResourceType=Grunt
     StatusIcon=Texture'WOTPawns.UI.I_SMinion'
}
