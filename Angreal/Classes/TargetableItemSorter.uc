//=============================================================================
// ItemSorter.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//=============================================================================

class TargetableItemSorter expands ItemSorter;

var AutoTargetReflector TargetMaster;

simulated function bool CollectItem( Actor Item, int ItemIndex )
{
	// Filter out non-targetable types.
	if( TargetMaster != None && TargetMaster.IsTargetable( Item ) )
		return Super.CollectItem( Item, ItemIndex );
	else
		return false;
}

defaultproperties
{
     CollectionReq=(IR_MaxDeltaAltitude=999999.000000)
}
