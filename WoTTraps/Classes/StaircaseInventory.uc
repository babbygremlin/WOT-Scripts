//------------------------------------------------------------------------------
// StaircaseInventory.uc
// $Author: Mfox $
// $Date: 9/22/99 2:33p $
// $Revision: 2 $
//
// Description:	Supports display of FireWall in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class StaircaseInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\Staircase\I_SStaircase.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Staircase\M_SStaircase.PCX GROUP=UI MIPS=Off

defaultproperties
{
     Title="Tilting Stairway"
     Description="Inside of your citadel, every stairway marked with the stair trap icon can be trapped.  Once the stair trap is active, it waits until someone reaches the center step, after which all of the steps flatten and send the victim stumbling to the ground below.   This keeps people from climbing the stairs, and could potentially push them into other traps at the bottom."
     Quote="Lan leaped down the last stairs, landing with a crash, sword in hand."
     StatusIconFrame=Texture'WOTTraps.UI.M_SStaircase'
     ResourceClass=Class'WOTTraps.Staircase'
     SpawnTempResource=False
     Count=2
     StatusIcon=Texture'WOTTraps.UI.I_SStaircase'
}
