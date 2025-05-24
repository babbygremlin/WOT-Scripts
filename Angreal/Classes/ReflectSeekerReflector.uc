//------------------------------------------------------------------------------
// ReflectSeeker.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	If targeted by a seeker, it redirects that seeker back to the
//				originator. 
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class ReflectSeekerReflector expands Reflector;

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
// Called by angreal projectiles to notify the victim what just hit them.
//
// If the projectile did not have to seek to get to you, shoot it back
// the opposite direction it was going.
// Otherwise, have it seek back to the originator.
//------------------------------------------------------------------------------
function NotifyTargettedByAngrealProjectile( AngrealProjectile Proj )
{
	// NOTE[aleiby]: If Glen decides he want's seeking projectiles to stop
	// in mid flight if both sender and destination have reflect on, 
	// put code here.  Remember to delay it by a tick so we don't end
	// up with an infinate loop.

	// Notify the Projectile that it was just reflected.
	Proj.Reflected();

	// Pass control off to next reflector.
	Super.NotifyTargettedByAngrealProjectile( Proj );
}

defaultproperties
{
    Priority=128
    bRemoveExisting=True
}
