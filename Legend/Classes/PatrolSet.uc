//=============================================================================
// PatrolSet.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class PatrolSet expands CollectionProxy;

var() Name PatrolItemTagNames[ 63 ];
var ArrayedCollection ActualArrayedCollection;



function SubjectDestroyed( Object Subject )
{
	if( ActualArrayedCollection == Subject )
	{
		ActualArrayedCollection = None;
	}
	Super.SubjectDestroyed( Subject );
}



function PostBeginPlay()
{
	local int PatrolItemIdx, PatrolItemTagNameIdx;
	local Actor CurrentActor;
	
	Super.PostBeginPlay();
	class'Debug'.static.DebugLog( Self, "PostBeginPlay", DebugCategoryName );
	ActualArrayedCollection = ArrayedCollection( ActualCollection );
	if( ActualArrayedCollection != None )
	{
		for( PatrolItemTagNameIdx = 0; ( PatrolItemTagNameIdx < ArrayCount( PatrolItemTagNames ) ); PatrolItemTagNameIdx++ )
		{
			class'Debug'.static.DebugLog( Self, "PostBeginPlay PatrolItemTagNameIdx " $ PatrolItemTagNameIdx, DebugCategoryName );
			class'Debug'.static.DebugLog( Self, "PostBeginPlay PatrolItemTagNames[ PatrolItemTagNameIdx ] " $ PatrolItemTagNames[ PatrolItemTagNameIdx ], DebugCategoryName );
			if( PatrolItemTagNames[ PatrolItemTagNameIdx ] != '' )
			{
				foreach AllActors( class'Actor', CurrentActor, PatrolItemTagNames[ PatrolItemTagNameIdx ] )
				{
					class'Debug'.static.DebugLog( Self, "PostBeginPlay CurrentActor " $ CurrentActor, DebugCategoryName );
					ActualArrayedCollection.SetItemAt( CurrentActor, PatrolItemIdx++ );
					break;
				}
			}
		}
		ActualArrayedCollection.DebugLog( Self );
	}
}



function Destroyed()
{
	if( ActualArrayedCollection != None )
	{
		ActualArrayedCollection.DetachDestroyObserver( Self );
		ActualArrayedCollection = None;
	}
	Super.Destroyed();
}



function DebugLog( Object Invoker )
{
	local int PatrolItemIdx, PatrolItemTagNameIdx;
	local Actor CurrentActor;

	class'Debug'.static.DebugLog( Invoker, "DebugLog", DebugCategoryName );

	//log out all of the stuff in the patrol controllers item tag name array
	for( PatrolItemTagNameIdx = 0; ( PatrolItemTagNameIdx < ArrayCount( PatrolItemTagNames ) ); PatrolItemTagNameIdx++ )
	{
		class'Debug'.static.DebugLog( Invoker,  "DebugLog PatrolItemTagNames[ " $ PatrolItemTagNameIdx $ " ] " $ PatrolItemTagNames[ PatrolItemTagNameIdx ], DebugCategoryName );
		if( PatrolItemTagNames[ PatrolItemTagNameIdx ] != '' )
		{
			foreach AllActors( class'Actor', CurrentActor, PatrolItemTagNames[ PatrolItemTagNameIdx ] )
			{
				class'Debug'.static.DebugLog( Invoker,  "DebugLog PatrolItem " $ CurrentActor, DebugCategoryName );
				break;
			}
		}
	}

	//log out all of the stuff in the actual arrayed collection
	class'Debug'.static.DebugLog( Invoker,  "DebugLog ActualArrayedCollection: " $ ActualArrayedCollection, DebugCategoryName );
	if( ActualArrayedCollection != None )
	{
		ActualArrayedCollection.DebugLog( Invoker );
	}
}

defaultproperties
{
     CollectionClass=Class'Legend.ArrayedCollection'
     DebugCategoryName=PatrolSet
     bStatic=True
     bCollideWhenPlacing=True
     Texture=Texture'Engine.S_Patrol'
     CollisionRadius=46.000000
     CollisionHeight=50.000000
}
