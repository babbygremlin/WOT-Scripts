//------------------------------------------------------------------------------
// SealInventory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//
// Description:	Supports display of Alarm in Citadel Editor HUD
//
//------------------------------------------------------------------------------
class SealInventory expands WOTInventory;

defaultproperties
{
     Title="Cuendillar Seal"
     Description="Although this appears to be no more than a stone disc, perhaps a hand-span across, it is actually a cuendillar artifact from the Age of Legends.  It represents a focus point for the actual seals holding closed the Dark One's prison at Shayol Ghul.  If someone holds four of these at once and understands how to manipulate them, they can affect the prison of the Dark One¾possibly releasing the Dark One, or shutting him away."
     Quote="She took something from her pouch and laid it on the table before her.  It was a disc the size of a man's hand, seemingly made of two teardrops fitted together, one black as pitch, the other white as snow."
     StatusIconFrame=Texture'WOT.UI.M_SSeal'
     ResourceClass=Class'WOT.Seal'
     Count=1
     StatusIcon=Texture'WOT.UI.I_SSeal'
     bHidden=True
}
