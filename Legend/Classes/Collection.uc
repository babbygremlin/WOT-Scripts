//=============================================================================
// Collection.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class Collection expands LegendObjectComponent abstract native;

native event bool GetItemAt( out Object Item, int ItemIndex );
native event bool GetItemCount( out int CurrentItemCount );
function DebugLog( Object Invoker );

defaultproperties
{
     DebugCategoryName=Collection
}
