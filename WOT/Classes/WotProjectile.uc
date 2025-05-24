//=============================================================================
// WotProjectile.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

class WotProjectile expands Projectile abstract;

var () const editconst Name DestroyedEvent;

defaultproperties
{
     DestroyedEvent=WotProjectileDestroyed
     bCanTeleport=True
}
