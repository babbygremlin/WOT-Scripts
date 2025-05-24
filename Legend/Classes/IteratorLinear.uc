//=============================================================================
// IteratorLinear.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================

class IteratorLinear expands IteratorInterf;

var() private const editconst bool bTerminated;

/*
If set to False the iterator will return the first or last item index in the
event that there is not a next or previous item index. The effect of this is
that GetNext and GetPrevious will always return a valid item index if there
are any items in the collection that is being iterated over.
*/



function bool GetNextIndex( optional out int NextIndex )
{
	local int IndexCounter, Index, ItemCount;
	local bool bSuccess;
	
	if( GetItemCount( ItemCount ) )
	{
		Index = CurrentIndex + 1;
		for( IndexCounter = 0; ( IndexCounter < ItemCount ); IndexCounter++ )
		{
			if( Index >= ItemCount )
			{
				//get this by default bSuccess = false
				break;
			}
			if( IsIndexValid( Index ) )
			{
				NextIndex = Index;
				CurrentIndex = NextIndex;
				bSuccess = true;
				break;
			}
			Index++;
		}
		if( !bSuccess && !bTerminated )
		{
			bSuccess = GetLastIndex( NextIndex );
		}
	}
	return bSuccess;
}



function bool GetPreviousIndex( optional out int PreviousIndex )
{
	local int IndexCounter, Index, ItemCount;
	local bool bSuccess;
	
	if( GetItemCount( ItemCount ) )
	{
		Index = CurrentIndex - 1;
		for( IndexCounter = 0; ( IndexCounter < ItemCount ); IndexCounter++ )
		{
			if( Index < 0 )
			{
				//get this by default bSuccess = false
				break;
			}
			if( IsIndexValid( Index ) )
			{
				PreviousIndex = Index;
				CurrentIndex = PreviousIndex;
				bSuccess = true;
				break;
			}
			Index--;
		}
		if( !bSuccess && !bTerminated )
		{
			bSuccess = GetFirstIndex( PreviousIndex );
		}
	}
	return bSuccess;
}

defaultproperties
{
     bTerminated=True
}
