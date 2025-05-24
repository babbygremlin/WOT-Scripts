//=============================================================================
// Path.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class Path expands Collection;

function bool GetItemAt( out Object Item, int ItemIndex );
function bool GetItemCount( out int ItemCount );

function bool SetAnchorLocations( Vector SourceLocation, Vector DestinationLocation );
function GetAnchorLocations( out Vector SourceLocation, out Vector DestinationLocation );

function bool SetAnchorActors( Actor SourceActor, Actor DestinationActor );
function GetAnchorActors( out Actor SourceActor, out Actor DestinationActor );

function Invalidate();
function bool IsValid();

function bool BuildPath( Pawn BuildFor );

defaultproperties
{
}
