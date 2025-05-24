//=============================================================================
// BudgetInfo.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 14 $
//=============================================================================
class BudgetInfo expands Info;

// NOTE: if more than one player is allowed to access the budget simultaneously,
// see Item.Count check in EditorHUD.LeftMouseDown.  Currently, this check
// is only syncronized for a single player.
const PlayerEditLimit = 1; // maximum number of players allowed to edit per team

struct Resource
{
	var() name ResourcePackageName;
	var() name ResourceAdapterName;
	var() int ItemCount;
};

var() byte Team;			// which team gets this budget
var() Resource Budget[12];	// the Citadel Game budget for this team
var() name BeginEditEvent;	// intended for SP scripting
var() name EndEditEvent;

var int PlayerEditCount;	// reference count the number of editing players

function string GetFullName( int i )
{
	return string(Budget[i].ResourcePackageName)$"."$string(Budget[i].ResourceAdapterName);
}

function PostBeginPlay()
{
	Super.PostBeginPlay();
	if( Level.NetMode != NM_Client )
	{
		ServerPreLoad();
	}
}

function ServerPreLoad()
{
	local int i;

	for( i = 0; i < ArrayCount(Budget); i++ )
	{
		if( GetResourceAdapterName( i ) != '' )
		{
			DynamicLoadObject( GetFullName( i ), class'Class' );
		}
	}
}

function int GetArrayCount()
{
	return ArrayCount(Budget);
}

function int GetItemCount( int Index  )
{
	return Budget[ Index ].ItemCount;
}

function name GetResourceAdapterName( int Index )
{
	return Budget[ Index ].ResourceAdapterName;
}

function class<WOTInventory> GetResourceType( name ResourceType )
{
	local int i;
	local class<WOTInventory> ItemClass;

	for( i = 0; i < ArrayCount(Budget); i++ )
	{
		if( GetResourceAdapterName( i ) != '' )
		{
			ItemClass = class<WOTInventory>( DynamicLoadObject( GetFullName( i ), class'Class' ) );
			if( ItemClass != None && ItemClass.default.BaseResourceType == ResourceType )
			{
				return ItemClass;
			}
		}
	}

	assert( false ); // this can't happen if the budget is correct
}

function int GetIndex( name ResourceAdapterName )
{
	local int i;

	for( i = 0; i < ArrayCount(Budget); i++ )
	{
		if( GetResourceAdapterName( i ) == ResourceAdapterName )
		{
			return i;
		}
	}

	assert( false ); // couldn't find named resource
}

function Reset( int SealCount )
{
	local int i;
	
	i = GetIndex( 'SealInventory' );
	Budget[i].ItemCount = SealCount;
}

function bool BeginEdit( WOTPlayer Player )
{
	local Actor A;

	assert( Player.PlayerReplicationInfo.Team == Team );

	if( PlayerEditCount >= PlayerEditLimit )
	{
		return false;
	}

	PlayerEditCount++;

	// support for triggering events when editing begins (intended for SP only)
	if( BeginEditEvent != '' )
	{
		foreach AllActors( class'Actor', A, BeginEditEvent )
		{
			A.Trigger( Self, Player );
		}
	}

	return true;
}

function EndEdit( WOTPlayer Player )
{
	local Actor A;

	assert( Player.PlayerReplicationInfo.Team == Team );
	assert( PlayerEditCount > 0 );
	PlayerEditCount--;

	// support for triggering events upon edit termination (intended for SP only)
	if( EndEditEvent != '' )
	{
		foreach AllActors( class'Actor', A, EndEditEvent )
		{
			A.Trigger( Self, Player );
		}
	}
}

function int PlaceSeals( SealAltar A, WOTPlayer Player )
{
	local int i, SealCount;
	local Seal S;

	// find the current number of seals remaining in the budget, and decrement them
	i = GetIndex( 'SealInventory' );
	SealCount = Budget[i].ItemCount;
	Budget[i].ItemCount = 0;

	for( i = 0; i < SealCount; i++ )
	{
		S = Spawn( class'Seal', Player );
		if( S != None )
		{
			A.PlaceSeal( S, true );
		}
	}

	return SealCount;
}

function Increment( name ResourceName )
{
	Budget[ GetIndex( ResourceName ) ].ItemCount++;
}

function Decrement( name ResourceName )
{
	Budget[ GetIndex( ResourceName ) ].ItemCount--;
}

// end of BudgetInfo.uc

defaultproperties
{
     bStatic=True
     Texture=Texture'Engine.S_Inventory'
}
