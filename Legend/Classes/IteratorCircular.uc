//=============================================================================
// IteratorCircular.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================

class IteratorCircular expands IteratorInterf;



function bool GetNextIndex( optional out int NextIndex )
{
	local int TestedItemCount, Index, ItemCount;
	local bool bSuccess;
	
	if( GetItemCount( ItemCount ) )
	{
		Index = CurrentIndex + 1;
		for( TestedItemCount = 0; ( TestedItemCount < ItemCount ); TestedItemCount++ )
		{
			if( Index > ( ItemCount - 1 ) )
			{
				//reached the end of the collection
				Index = 0;
			}
			if( IsIndexValid( Index ) )
			{
				NextIndex =  Index;
				CurrentIndex = NextIndex;
				bSuccess = true;
				break;
			}
			Index++;
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
				Index = ItemCount - 1;
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
	}
	return bSuccess;
}

defaultproperties
{
}
