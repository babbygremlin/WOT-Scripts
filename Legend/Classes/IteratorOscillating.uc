//=============================================================================
// IteratorOscillating.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================

class IteratorOscillating expands IteratorInterf;

var() private editconst int Incrementer;




function bool GetNextIndex( optional out int NextIndex )
{
	local int IndexCounter, Index, ItemCount;
	local bool bSuccess;
	
	if( GetItemCount( ItemCount ) )
	{
		Index = CurrentIndex + Incrementer;
		for( IndexCounter = 0; ( IndexCounter < ItemCount ); IndexCounter++ )
		{
			if( Index == -1 )
			{
				Incrementer = 1;
				Index = 1;
			}
			else if( Index < -1 )
			{
				Incrementer = 1;
				Index = 0;
			}
			else if( Index == ItemCount )
			{
				Incrementer = -1;
				Index = ItemCount - 2;
			}
			else if( Index > ItemCount )
			{
				Incrementer = -1;
				Index = ItemCount - 1;
			}
			if( IsIndexValid( Index ) )
			{
				NextIndex = Index;
				CurrentIndex = NextIndex;
				bSuccess = true;
				break;
			}
			Index += Incrementer;
		}
	}
	return bSuccess;
}



function bool GetPreviousIndex( optional out int PreviousIndex )
{
	local int Index, IndexCounter, ItemCount;
	local bool bSuccess;
		
	if( GetItemCount( ItemCount ) )
	{
		Index = CurrentIndex - Incrementer;
		for( IndexCounter = 0; ( IndexCounter < ItemCount ); IndexCounter++ )
		{
			if( Index == -1 )
			{
				Incrementer = 1;
				Index = 1;
			}
			else if( Index < -1 )
			{
				Incrementer = 1;
				Index = 0;
			}
			else if( Index == ItemCount )
			{
				Incrementer = -1;
				Index = ItemCount - 2;
			}
			else if( Index > ItemCount )
			{
				Incrementer = -1;
				Index = ItemCount - 1;
			}
			if( IsIndexValid( Index ) )
			{
				PreviousIndex = Index;
				CurrentIndex = PreviousIndex;
				bSuccess = true;
				break;
			}
			Index -= Incrementer;
		}
	}
	return bSuccess;
}

defaultproperties
{
     Incrementer=1
}
