//------------------------------------------------------------------------------
// QuestionerInventory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//
// Description:	Supports display in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class QuestionerInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\Champions\I_SQuestioner.PCX        GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Champions\M_SQuestioner.PCX        GROUP=UI MIPS=Off

defaultproperties
{
     Title="Whitecloak Questioner"
     Description="Even other Whitecloaks are afraid of the sect called The Hand of the Light.   Known among themselves as The Hand that digs out Truth, they are more often known to others as the Questioners.  They search for those who have given their souls to the Dark One, forcing confession from their victims using any methods necessary.  The Questioners in this remote borderland garrison have been outfitted with a special shield from the Age of Legends that has the power to reflect any projectile back at the attacker.  These attacks still damage the shield, however, and they can eventually be destroyed."
     Quote="Their cloaks bore the same golden sunburst on the breast as his, the same as every Child of the Light, and their leader even had golden knots of rank below it equivalent to Bornhald's. But behind their sunbursts were red shepherd's crooks."
     StatusIconFrame=Texture'WOTPawns.UI.M_SQuestioner'
     ResourceClass=Class'WOTPawns.Questioner'
     BaseResourceType=Champion
     StatusIcon=Texture'WOTPawns.UI.I_SQuestioner'
}
