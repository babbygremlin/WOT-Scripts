//------------------------------------------------------------------------------
// HandInfo.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 7 $
//------------------------------------------------------------------------------
class HandInfo expands Info;

var name		ClassName[10];	// the plan for the hand
var byte		bHaveThis[10];	// flag this for latent search
var Inventory	Item[10];		// the items in the hand -- set in Update()

var int			Selected;		// which item in the list is selected

var name		ItemAdded;		// recently added item (used in BaseHUD)
var float		ItemAddedTime;

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	Empty();
}

//------------------------------------------------------------------------------
simulated function Empty()
{
	local int i;

	for( i = 0; i < ArrayCount(ClassName); i++ ) 
	{
		Item[i] = None;
		bHaveThis[i] = 0;
	}
	Selected = 0;
}

//------------------------------------------------------------------------------
simulated function Update()
{
	local int i;

	for( i = 0; i < ArrayCount(ClassName); i++ )
	{
		if( bHaveThis[i] != 0 && Item[i] == None )
		{
			Item[i] = WOTPlayer(Owner).FindInventoryName( ClassName[i] );
		}
	}
}

//------------------------------------------------------------------------------
simulated function int GetArrayCount()
{
	return ArrayCount(ClassName);
}

//------------------------------------------------------------------------------
simulated function int GetItemCount()
{
	local int i, ItemCount;

	for( i = 0; i < ArrayCount(ClassName); i++ )
	{
		if( bHaveThis[i] != 0 )
		{
			ItemCount++;
		}
	}

	return ItemCount;
}

//------------------------------------------------------------------------------
simulated function Inventory GetItem( int Index )
{
	assert( Index >= 0 && Index < ArrayCount(ClassName) );
	return( Item[Index] );
}

//------------------------------------------------------------------------------
simulated function Inventory GetSelectedItem()
{
	return GetItem( Selected );
}

//------------------------------------------------------------------------------
simulated function name GetClassName( int Index )
{
	assert( Index >= 0 && Index < ArrayCount(ClassName) );
	if( bHaveThis[Index] != 0 )
	{
		return ClassName[Index];
	}
	return '';
}

//------------------------------------------------------------------------------
simulated function name GetSelectedClassName()
{
	return GetClassName( Selected );
}

//------------------------------------------------------------------------------
simulated function bool IsEmpty()
{
	local int i;

	for( i = 0; i < ArrayCount(ClassName); i++ ) 
	{
		if( bHaveThis[i] != 0 )
		{
			return false;
		}
	}

	return true;
}

//------------------------------------------------------------------------------
simulated function bool IsIn( name ItemName )
{
	local int i;

	for( i = 0; i < ArrayCount(ClassName); i++ )
	{
		if( GetClassName( i ) == ItemName )
		{
			return true;
		}
	}

	return false;
}

//------------------------------------------------------------------------------
simulated function AddClassName( name NewClassName, int Slot )
{
	local int i;
	
	assert( Slot >= 0 && Slot < ArrayCount(ClassName) );

	// verify that the class isn't already present
	for( i = 0; i < ArrayCount(ClassName); i++ )
	{
		assert( ClassName[i] != NewClassName );
	}

	ClassName[ Slot ] = NewClassName;
}

//------------------------------------------------------------------------------
simulated function AddItem( name ItemName, optional bool bSelect )
{
	local int i;
	local bool bPreviouslyEmpty;

	bPreviouslyEmpty = IsEmpty();

	for( i = 0; i < ArrayCount(ClassName); i++ )
	{
		if( ClassName[i] == ItemName )
		{
			bHaveThis[i] = 1;

			// if this failes on the client, Update() will refresh Item[i] as soon as the object has replicated
			Item[i] = WOTPlayer(Owner).FindInventoryName( ItemName );

			ItemAdded = ItemName;
			ItemAddedTime = Level.TimeSeconds;
			
			if( bPreviouslyEmpty || bSelect )
			{
				Select( i );
			}
			break;
		}
	}
}

//------------------------------------------------------------------------------
simulated function RemoveItem( name ItemName )
{
	local int i;

	for( i = 0; i < ArrayCount(ClassName); i++ )
	{
		if( ClassName[i] == ItemName )
		{
			Item[i] = None;
			bHaveThis[i] = 0;
			break;
		}
	}
}

//------------------------------------------------------------------------------
simulated function SelectItem( name ItemName )
{
	local int i;

	for( i = 0; i < ArrayCount(ClassName); i++ )
	{
		if( ClassName[i] == ItemName ) 
		{
			Select( i );
			break;
		}
	}
}

//------------------------------------------------------------------------------
simulated function SelectFirst()
{
	local int i;
	
	if( !IsEmpty() )
	{
		for( i = 0; i < ArrayCount(ClassName) && GetClassName( i ) == ''; i++ );
	}
	
	Select( i );
}

//------------------------------------------------------------------------------
simulated function SelectNext()
{
	local int i;

	i = Selected;
	do
	{
		i = ( i + 1 ) % ArrayCount(ClassName);
	}
	until( i == Selected || GetClassName( i ) != '' );

	Select( i );
}

//------------------------------------------------------------------------------
simulated function SelectPrevious()
{
	local int i;

	i = Selected;
	do
	{
		i--;
		if( i < 0 )
		{
			i = ArrayCount(ClassName) - 1;
		}
	}
	until( i == Selected || GetClassName( i ) != '' );

	Select( i );
}

//------------------------------------------------------------------------------
simulated function Select( int Index )
{
	assert( Index >= 0 && Index < ArrayCount(ClassName) );
	Selected = Index;
}

// end of HandInfo.uc

defaultproperties
{
     RemoteRole=ROLE_None
     bAlwaysRelevant=True
}
