//=============================================================================
// ArrayedCollection.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class ArrayedCollection expands Collection;

var Object Items[ 63 ];



function Destructed()
{
	ClearItems();
	Super.Destructed();
}



function ClearItems()
{
	local int i;
	for( i = 0; ( i < ArrayCount( Items ) ); i++ )
	{
		if( Items[ i ] != None )
		{
			Items[ i ].DetachDestroyObserver( Self );
			Items[ i ] = None;
		}
	}
}



function SubjectDestroyed( Object Subject )
{
	local int ItemIndex;

	for( ItemIndex = 0; ( ItemIndex < ArrayCount( Items ) ); ItemIndex++ )
	{
		if( Items[ ItemIndex ] == Subject )
		{
			Items[ ItemIndex ] = None;
		}
	}
	Super.SubjectDestroyed( Subject );
}



function bool GetItemAt( out Object Item, int ItemIndex )
{
	local bool bSuccess;
	if( ( ItemIndex >= 0 ) && ( ItemIndex < ArrayCount( Items ) ) && ( Items[ ItemIndex ] != None ) )
	{
		Item = Items[ ItemIndex ];
		bSuccess = true;
	}
	return bSuccess;
}



function bool GetItemCount( out int CurrentItemCount )
{
	CurrentItemCount = ArrayCount( Items );
	return true;
}



function bool SetItemAt( Object Item, int ItemIndex )
{
	local bool bSuccess;
	if( ( ItemIndex >= 0 ) && ( ItemIndex < ArrayCount( Items ) ) )
	{
		if( Items[ ItemIndex ] != None )
		{
			Items[ ItemIndex ].DetachDestroyObserver( Self );
		}
		if( ( Item != None ) && Item.AttachDestroyObserver( Self ) )
		{
			Items[ ItemIndex ] = Item;
		}
		else
		{
			Items[ ItemIndex ] = None;
		}
		bSuccess = true;
	}
	return bSuccess;
}



function DebugLog( Object Invoker )
{
	local int ItemIndex;
	class'Debug'.static.DebugLog( Invoker, "DebugLog", DebugCategoryName );
	for( ItemIndex = 0; ( ItemIndex < ArrayCount( Items ) ); ItemIndex++ )
	{
		class'Debug'.static.DebugLog( Invoker, "DebugLog Item[ " $ ItemIndex  $ " ] " $ Items[ ItemIndex ], DebugCategoryName );
		if( Items[ ItemIndex ] != None )
		{
			if( Items[ ItemIndex  ].IsA( 'Actor' ) )
			{
				class'Debug'.static.DebugLog( Invoker, "DebugLog with Tag: " $ Actor( Items[ ItemIndex ] ).Tag, DebugCategoryName );
			}
		}
	}
}

defaultproperties
{
     DebugCategoryName=ArrayedCollection
}
