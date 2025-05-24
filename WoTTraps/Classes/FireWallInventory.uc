//------------------------------------------------------------------------------
// FireWallInventory.uc
// $Author: Mfox $
// $Date: 9/22/99 2:33p $
// $Revision: 2 $
//
// Description:	Supports display of FireWall in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class FireWallInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\FireWall\I_SFire.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\FireWall\M_SFire.PCX GROUP=UI MIPS=Off

defaultproperties
{
     Title="Fire Wall"
     Description="A fire wall consists of a line of burning boards, sticks, brush--anything flammable.  The fire wall can be placed against any flat vertical surface; it extends across the floor to the far wall.  While people can cross this line, the fire causes quite a bit of damage in the process.  Repeated crossings eventually stamp out the fire."
     Quote="Flames leaped from the floor beneath his feet, furious jets that flashed tapestries and rugs, tables and chests to wisps of ash; he smashed the fires flat."
     StatusIconFrame=Texture'WOTTraps.UI.M_SFire'
     ResourceClass=Class'WOTTraps.FireWall'
     Count=2
     StatusIcon=Texture'WOTTraps.UI.I_SFire'
}
