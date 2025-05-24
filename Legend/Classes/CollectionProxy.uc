//=============================================================================
// CollectionProxy.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class CollectionProxy expands LegendActorComponent;

var () class<Collection> CollectionClass;
var Collection ActualCollection;



function PostBeginPlay()
{
	class'Debug'.static.DebugLog( Self, "PostBeginPlay", DebugCategoryName );
	if( CollectionClass != None )
	{
		ActualCollection = new( Self )CollectionClass;
	}
	class'Debug'.static.DebugLog( Self, "PostBeginPlay ActualCollection " $ ActualCollection, DebugCategoryName );
}



function Destroyed()
{
	if( ActualCollection != None )
	{
		ActualCollection.Delete();
		ActualCollection = None;
	}
	Super.Destroyed();
}

defaultproperties
{
     DebugCategoryName=CollectionProxy
}
