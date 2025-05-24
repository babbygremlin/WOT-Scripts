//=============================================================================
// Singleton.
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 4 $
//=============================================================================

class Singleton expands LegendObjectComponent native;

var private const array<Object> Instances;

//------------------------------------------------------------------------------
// Retrieves the single instance of this class.
//
// + Helper is used to spawn the Instance if needed.
// (Self works in most cases - it just needs to have a valid level.)
//
// + Type is the type of Invokable we are looking for.
//
// + The optional UniqueID is used to allow multiple instances of the given class.
//   The UniqueID will match the Tag of the instance.
//   If a LD places an instance of said object with said Tag, then that instance
//   will be returned.  (If a LD places two instances of said class with
//   said Tag in the level, then they must be brought outside and flogged -- and
//   the first instance will be used -- which means the outcome is undefined.)
//   (Obviously this only works for Actors since Objects don't have tags.)
//------------------------------------------------------------------------------
native static function Object GetInstance( Level Level, class<Object> Type, optional name UniqueID );

defaultproperties
{
}
