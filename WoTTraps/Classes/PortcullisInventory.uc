//------------------------------------------------------------------------------
// PortcullisInventory.uc
// $Author: Mfox $
// $Date: 9/22/99 2:33p $
// $Revision: 2 $
//
// Description:	Supports display of FireWall in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class PortcullisInventory expands WOTInventory;

#exec TEXTURE IMPORT FILE=Icons\Portcullis\I_SPortcullis.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Portcullis\M_SPortcullis.PCX GROUP=UI MIPS=Off

defaultproperties
{
     Title="Portcullis"
     Description="All archways marked with the Portcullis icon can be trapped.  Once the portcullis is active, it waits for someone to walk beneath the arch.  This causes a metal gate to fall from the ceiling, damaging anyone directly underneath, but more likely trapping that person on the other side.  Portcullises are much more fragile than walls, and can be destroyed without difficulty."
     Quote="A door of iron bars stood in her way, with a lock as big as her head.  She channeled Earth before she reached it, and when she pushed against the bars, the lock tore in half."
     StatusIconFrame=Texture'WOTTraps.UI.M_SPortcullis'
     ResourceClass=Class'WOTTraps.Portcullis'
     SpawnTempResource=False
     Count=2
     StatusIcon=Texture'WOTTraps.UI.I_SPortcullis'
}
