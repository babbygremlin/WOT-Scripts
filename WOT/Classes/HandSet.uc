//------------------------------------------------------------------------------
// HandSet.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 5 $
//------------------------------------------------------------------------------
class HandSet expands Info;

var HandInfo   Hands[10];	// The hands
var int	       Selected;	// Which hand is selected?

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	local int i;

	for( i = 0; i < ArrayCount(Hands); i++ ) 
	{
		Hands[i].Destroy();
		Hands[i] = None;
	}
}

//------------------------------------------------------------------------------
simulated function Empty()
{
	local int i;

	for( i = 0; i < ArrayCount(Hands); i++ ) 
	{
		Hands[i].Empty();
	}
}

//------------------------------------------------------------------------------
simulated function Update()
{
	local int i;

	for( i = 0; i < ArrayCount(Hands); i++ ) 
	{
		Hands[i].Update();
	}
}

//------------------------------------------------------------------------------
simulated function int GetArrayCount()
{
	return ArrayCount(Hands);
}

//------------------------------------------------------------------------------
simulated function HandInfo GetHand( int Index )
{
	assert( Index >= 0 && Index < ArrayCount(Hands) );
	return Hands[Index];
}

//------------------------------------------------------------------------------
simulated function HandInfo GetSelectedHand()
{
	return GetHand( Selected );
}

//------------------------------------------------------------------------------
simulated function AddItem( name ItemName )
{
	local int i;

	for( i = 0; i < ArrayCount(Hands); i++ )
	{
		if( Hands[i] != None ) 
		{
			Hands[i].AddItem( ItemName, (i!=Selected) );
		}
	}
}

//------------------------------------------------------------------------------
simulated function RemoveItem( name ItemName )
{
	local int i;

	for( i = 0; i < ArrayCount(Hands); i++ )
	{
		if( Hands[i] != None ) 
		{
			Hands[i].RemoveItem( ItemName );
		}
	}
}

//------------------------------------------------------------------------------
simulated function SetHand( int Index, HandInfo Hand )
{
	assert(	Index >= 0 && Index < ArrayCount(Hands) );
	assert( Hands[Index] == None );
	Hands[Index] = Hand;
}

//------------------------------------------------------------------------------
simulated function SelectItem( name ItemName )
{
	local int i;

	for( i = 0; i < ArrayCount(Hands); i++ ) 
	{
		if( Hands[i] != None && Hands[i].IsIn( ItemName ) ) 
		{
			Select( i );
			Hands[i].SelectItem( ItemName );
			break;
		}
	}
}

//------------------------------------------------------------------------------
simulated function Select( int Index )
{
	local int i;

	assert( Index >= 0 && Index < ArrayCount(Hands) );

	// don't select if empty (will force player to reselect current hand)
	if( GetHand( Index ).IsEmpty() )
	{
		return;
	}

	if( Selected != Index )
	{
		Selected = Index;
		if( GetSelectedHand().GetSelectedClassName() == '' )
		{
			GetSelectedHand().SelectNext();
		}
	}
	else
	{
		GetSelectedHand().SelectNext();
	}
}

//------------------------------------------------------------------------------
simulated function int GetPrevious()
{
	local int i;

	i = Selected;
	do
	{
		i--;
		if( i < 0 )
		{
			i = ArrayCount(Hands) - 1;
		}
	}
	until( i == Selected || !Hands[i].IsEmpty() );

	return i;
}

//------------------------------------------------------------------------------
simulated function int GetNext()
{
	local int i;

	i = Selected;
	do
	{
		i = ( i + 1 ) % ArrayCount(Hands);
	}
	until( i == Selected || !Hands[i].IsEmpty() );

	return i;
}

// end of HandSet.uc

defaultproperties
{
     RemoteRole=ROLE_None
     bAlwaysRelevant=True
}
