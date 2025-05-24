//=============================================================================
// ActorCollection.uc
// $Author: Mfox $
// $Date: 1/05/00 2:36p $
// $Revision: 2 $
//=============================================================================

//------------------------------------------------------------------------------
// Description:	A simple data structure used to store Actors and enumerate
//              across them.
//------------------------------------------------------------------------------
// How to use this class:
//
// + To Iterate across all the items in the collection:
//     for( iActor = Collection.GetFirst(); !Collection.IsDone(); iActor = Collection.GetNext() );
//------------------------------------------------------------------------------

class ActorCollection expands Object
	native;

//
// NOTE: THIS CLASS IS NOT READY FOR PRODUCTION USE.
//

//////////////////////
// Member variables //
//////////////////////

var private const array<Actor> ItemList;
var private const int Index;

////////////////
// Interfaces //
////////////////

//------------------------------------------------------------------------------
// Add the given item to the collection.
// Note: This *is* safe to call while iterating.
// If you add the same item multiple times, it will show up multiple times
// while iterating.
//------------------------------------------------------------------------------
native(1080) final function AddItem( Actor Item );

//------------------------------------------------------------------------------
// Removes all occurances of the specified item from the collection.
// Note: This *is* safe to call while iterating.
//------------------------------------------------------------------------------
native(1081) final function RemoveItem( Actor Item );

//------------------------------------------------------------------------------
// Removes all Items from this collection.
// Note: This *is* safe to call while iterating.
//------------------------------------------------------------------------------
native(1082) final function RemoveAll();

///////////////////////
// Iteration support //
///////////////////////

//------------------------------------------------------------------------------
// Gets the first item in the collection.
//------------------------------------------------------------------------------
native(1083) final function Actor GetFirst();

//------------------------------------------------------------------------------
// Guaranteed to return a valid Actor while IsDone() returns true.
//------------------------------------------------------------------------------
native(1084) final function Actor GetNext();

//------------------------------------------------------------------------------
// Guaranteed to return a valid Actor while IsDone() returns true.
//------------------------------------------------------------------------------
native(1085) final function Actor GetCurrent();

//------------------------------------------------------------------------------
// Used for iteration purposes.
//------------------------------------------------------------------------------
native(1086) final function bool IsDone();

defaultproperties
{
}
