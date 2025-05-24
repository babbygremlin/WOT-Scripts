//=============================================================================
// RestPoint.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================

// Description:	Used to keep track of where we should go when we have no one 
//				to hunt.  MachinShin and Mashadar both use this to remember
//				where they were spawned.

class RestPoint expands NavigationPoint;

defaultproperties
{
     bStatic=False
     bCollideWhenPlacing=False
     bAlwaysRelevant=True
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
