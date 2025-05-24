//------------------------------------------------------------------------------
// WallInventory.uc
// $Author: Mfox $
// $Date: 9/22/99 2:33p $
// $Revision: 2 $
//
// Description:	Supports display of Alarm in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class WallInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\Wall\I_SWall.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Wall\M_SWall.PCX GROUP=UI MIPS=Off

defaultproperties
{
     Title="Wall"
     Description="The wall is a hastily built barricade consisting of any convenient materials.  It can be placed against any flat vertical surface.  The wall extends across the floor to block off possible passage through corridors or rooms.  Although the wall is sturdier than a portcullis, it can still be destroyed."
     Quote="Like a nightmare the wall above toppled outward in half a dozen places, Aiel and stones smashing down on those still climbing. Before those bouncing sliding chunks of masonry reached the streets, Trollocs appeared in the openings, dropping the tree-thick battering rams they had used..."
     StatusIconFrame=Texture'WOTTraps.UI.M_SWall'
     ResourceClass=Class'WOTTraps.Wall'
     Count=2
     StatusIcon=Texture'WOTTraps.UI.I_SWall'
}
