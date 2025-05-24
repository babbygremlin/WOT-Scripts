//------------------------------------------------------------------------------
// MyrddraalInventory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//
// Description:	Supports display in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class MyrddraalInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\Captains\I_SMyrddraal.PCX        GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Captains\M_SMyrddraal.PCX        GROUP=UI MIPS=Off

defaultproperties
{
     Title="Myrddraal"
     Description="Trollocs are almost impossible to control.  They obey only out of fear, and they fear only the Myrddraal. Myrddraal can attack either with a crossbow or with the black swords forged on the slopes of Shayol Ghul whose blades continue to do damage long after the actual cut.  They also have the ability to fade into the shadows and then reappear elsewhere in the dark to strike.  Like other captains, the Myrddraal can be commanded to kill intruders, guard an area, guard a seal, run for reinforcements, or sound an alarm."
     Quote="It was a man in form, no larger than most, but there the resemblance ended. Dead black clothes and cloak, hardly seeming to stir as it moved, made its maggot-white skin appear even paler. And it had no eyes."
     StatusIconFrame=Texture'WOTPawns.UI.M_SMyrddraal'
     ResourceClass=Class'WOTPawns.Myrddraal'
     BaseResourceType=Captain
     StatusIcon=Texture'WOTPawns.UI.I_SMyrddraal'
}
