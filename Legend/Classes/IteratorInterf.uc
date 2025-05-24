//=============================================================================
// IteratorInterf.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class IteratorInterf expands LegendObjectComponent;

var int CurrentIndex;
var private Collection CurrentCollection;
var private int ItemCount;


function SubjectDestroyed( Object Subject )
{
	if( CurrentCollection == Subject )
	{
		CurrentCollection = None;
	}
	Super.SubjectDestroyed( Subject );
}



function Destructed()
{
	if( CurrentCollection != None )
	{
		CurrentCollection.DetachDestroyObserver( Self );
		CurrentCollection = None;
		ItemCount = 0;
	}
	Super.Destructed();
}



function BindCollection( optional Collection NewCollection, optional int ItemCount )
{
	if( CurrentCollection != None )
	{
		CurrentCollection.DetachDestroyObserver( Self );
	}
	if( ( NewCollection != None ) && NewCollection.AttachDestroyObserver( Self ) )
	{
		CurrentCollection = NewCollection;
	}
	else
	{
		CurrentCollection = None;
	}
	Self.ItemCount = ItemCount;
}



function bool GetCurrentItem( optional out Object CurrentItem )
{
	return GetItemAt( CurrentIndex, CurrentItem );
}



function bool GetFirstItem( optional out Object FirstItem )
{
	local int FirstIndex;
	return ( GetFirstIndex( FirstIndex ) ) && GetItemAt( FirstIndex, FirstItem );
}



function bool GetNextItem( optional out Object NextItem )
{
	local int NextIndex;
	return ( GetNextIndex( NextIndex ) ) && GetItemAt( NextIndex, NextItem );
}



function bool GetPreviousItem( optional out Object PreviousItem )
{
	local int PreviousIndex;
	return ( GetPreviousIndex( PreviousIndex ) ) && GetItemAt( PreviousIndex, PreviousItem );
}



function bool GetLastItem( optional out Object LastItem )
{
	local int LastIndex;
	return ( GetLastIndex( LastIndex ) ) && GetItemAt( LastIndex, LastItem );
}



function bool GetItemAt( int Index, optional out Object Item )
{
	return ( ( CurrentCollection != None ) && CurrentCollection.GetItemAt( Item, Index ) );
}



function bool GetCurrentIndex( optional out int CurrentIndex )
{
	
	CurrentIndex = Self.CurrentIndex;
	return IsIndexValid( CurrentIndex );
}



function bool GetFirstIndex( optional out int FirstIndex )
{
	local int Index, ItemCount;
	local bool bSuccess;
	local Object FirstItem;
	
	if( GetItemCount( ItemCount ) )
	{
		for( Index = 0; Index < ItemCount; Index++ )
		{
			if( IsIndexValid( Index ) )
			{
				FirstIndex = Index;
				CurrentIndex = FirstIndex;
				bSuccess = true;
				break;
			}
		}
	}
	return bSuccess;
}



function bool GetNextIndex( optional out int NextIndex );
function bool GetPreviousIndex( optional out int PreviousIndex );



function bool GetLastIndex( optional out int LastIndex )
{
	local int Index, ItemCount;
	local bool bSuccess;
	local Object LastItem;
	
	if( GetItemCount( ItemCount ) )
	{
		for( Index = ItemCount - 1; Index >= 0; Index-- )
		{
			if( IsIndexValid( Index ) )
			{
				LastIndex = Index;
				CurrentIndex = LastIndex;
				bSuccess = true;
				break;
			}
		}
	}
	return bSuccess;
}



function bool IsIndexValid( int Index )
{
	local bool bValid;
	if( CurrentCollection != None )
	{
		bValid = GetItemAt( Index );
	}
	else
	{
		bValid = ( Index >= 0 ) && ( Index < ItemCount );
	}
	return bValid;
}



function bool GetItemCount( out int ItemCount )
{
	local bool bSuccess;
	if( CurrentCollection != None )
	{
		bSuccess = CurrentCollection.GetItemCount( ItemCount );
	}
	else
	{
		ItemCount = Self.ItemCount;
		bSuccess = true;
	}
	return bSuccess;
}



function DebugLog( Object Invoker )
{
	class'Debug'.static.DebugLog( Invoker, "DebugLog", DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "		CurrentIndex: " $ CurrentIndex, DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "		ItemCount: " $ ItemCount, DebugCategoryName );
	class'Debug'.static.DebugLog( Invoker, "		CurrentCollection: " $ CurrentCollection, DebugCategoryName );
	CurrentCollection.DebugLog( Invoker );
}

defaultproperties
{
}
