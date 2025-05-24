//------------------------------------------------------------------------------
// PitInventory.uc
// $Author: Mfox $
// $Date: 9/22/99 2:33p $
// $Revision: 2 $
//
// Description:	Supports display of FireWall in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class PitInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\Pit\I_SPit.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Pit\M_SPit.PCX GROUP=UI MIPS=Off

defaultproperties
{
     Title="Pit"
     Description="Pits can be placed on any horizontal space large enough to support them.  They cannot overlap.  Once placed, the pit is rather difficult to see.  The square cover appears as a faint design.  It is illusory, a false floor, which sends anyone walking upon it falling into the deep pit below.  Hitting bottom causes a fair amount of damage, but vines growing on the pit walls make climbing out easy."
     Quote="He lurched another step, and the floor gave way beneath him. Desperately he flung out his hands; with a jolt, the right hand caught hold of a rough edge. He dangled into the pitch blackness. The fall beneath his boots might be a few spans into a basement, or a mile for all he could tell."
     StatusIconFrame=Texture'WOTTraps.UI.M_SPit'
     ResourceClass=Class'WOTTraps.Pit'
     Count=2
     StatusIcon=Texture'WOTTraps.UI.I_SPit'
}
