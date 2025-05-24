//=============================================================================
// PathNodeIterator.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================

class PathNodeIterator expands LegendActorComponent intrinsic transient;

var NavigationPoint NodePath[ 256 ];
var int             NodeCount;
var int             NodeIndex;
var int             NodeCost;
var vector          NodeStart;
var vector          NodeEnd;

intrinsic final function BuildPath( vector Start, vector End );
intrinsic final function NavigationPoint GetFirst();
intrinsic final function NavigationPoint GetPrevious();
intrinsic final function NavigationPoint GetCurrent();
intrinsic final function NavigationPoint GetNext();
intrinsic final function NavigationPoint GetLast();
intrinsic final function NavigationPoint GetLastVisible();

// end of PathNodeIterator.uc

defaultproperties
{
     bMovable=False
}
