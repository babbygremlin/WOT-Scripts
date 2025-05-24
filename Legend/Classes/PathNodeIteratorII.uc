//=============================================================================
// PathNodeIteratorII.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 4 $
//=============================================================================

class PathNodeIteratorII expands LegendActorComponent
	native
	transient;

const MAX_PATH_NODES = 512;	// Maximum number of path nodes in a single path.

var NavigationPoint NodePath[ 512 /*MAX_PATH_NODES*/ ];
var int             NodeCount;
var int             NodeIndex;
var int             NodeCost;
var vector          NodeStart;
var vector          NodeEnd;

native(1040) final function bool            BuildPath( vector Start, vector End, optional bool bDesperate );
native(1041) final function NavigationPoint GetCurrent();
native(1042) final function NavigationPoint GetFirst();
native(1043) final function NavigationPoint GetLast();
native(1044) final function NavigationPoint GetNext();
native(1045) final function NavigationPoint GetPrevious();

// end of PathNodeIteratorII.uc

defaultproperties
{
     bMovable=False
}
