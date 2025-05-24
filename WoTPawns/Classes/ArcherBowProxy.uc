//=============================================================================
// ArcherBowProxy.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 5 $
//=============================================================================

class ArcherBowProxy expands WotWeapon;

defaultproperties
{
     MinProjectileRange=150.000000
     MaxProjectileRange=10000.000000
     WotWeaponProjectileType=Class'WOTPawns.ArcherArrow'
     MissOdds=0.050000
     InventoryGroup=2
     bNoSmooth=False
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
