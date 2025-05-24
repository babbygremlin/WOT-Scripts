//=============================================================================
// ItemSorter.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================

class ItemSorter expands ItemCollector native;

struct TItemSortInfo
{
	var float ISI_SortScore; //the distance from the collector origin to the associated item
	var ETraceInfo ISI_SortTraceInfo;
	var byte ISI_bSortRejected;
};

var TItemRequirement SortReq;
var private TItemSortInfo ItemSortInfos[ 32 ];



function float GetSortScore( int ItemIdx )
{
	return ItemSortInfos[ ItemIdx ].ISI_SortScore;
}



function ETraceInfo GetSortTraceInfo( int ItemIdx )
{
	return ItemSortInfos[ ItemIdx ].ISI_SortTraceInfo;
}



function bool IsSortRejected( int ItemIdx )
{
	return bool( ItemSortInfos[ ItemIdx ].ISI_bSortRejected );
}



native function InitSorter();
native function SortItems();
native function bool FirstItemBeforeSecond( int FirstItemIdx, int SecondItemIdx );



function DebugLog( Object Invoker )
{
	local int ItemIdx, CurrentItemCount;
	
	if( GetItemCount( CurrentItemCount ) )
	{
		class'Debug'.static.DebugLog( Invoker, "DebugLog CurrentItemCount: " $ CurrentItemCount, 'ItemSorter' );
		while( ItemIdx < CurrentItemCount )
		{
			class'Debug'.static.DebugLog( Invoker, "DebugLog ItemIdx: " $ ItemIdx, 'ItemSorter' );
			
			class'Debug'.static.DebugLog( Invoker, "DebugLog Item: " $ GetItem( ItemIdx ), 'ItemSorter' );
			class'Debug'.static.DebugLog( Invoker, "DebugLog Item-Distance: " $ GetItemDistance( ItemIdx ), 'ItemSorter' );
			class'Debug'.static.DebugLog( Invoker, "DebugLog Item-TraceInfo: " $ GetItemTraceInfo( ItemIdx ), 'ItemSorter' );
			class'Debug'.static.DebugLog( Invoker, "DebugLog Item-bAccepted: " $ IsItemAccepted( ItemIdx ), 'ItemSorter' );
			
			class'Debug'.static.DebugLog( Invoker, "DebugLog Sort-SortScore: " $ GetSortScore( ItemIdx ), 'ItemSorter' );
			class'Debug'.static.DebugLog( Invoker, "DebugLog Sort-TraceInfo: " $ GetSortTraceInfo( ItemIdx ), 'ItemSorter' );
			class'Debug'.static.DebugLog( Invoker, "DebugLog Sort-bRejected: " $ IsSortRejected( ItemIdx ), 'ItemSorter' );
			
			ItemIdx++;
		}
	}
}

defaultproperties
{
}
