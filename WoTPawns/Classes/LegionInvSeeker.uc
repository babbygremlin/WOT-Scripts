//------------------------------------------------------------------------------
// LegionInvSeeker.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 6 $
//
// Description:	Launcher for LegionProjectile.
//------------------------------------------------------------------------------

class LegionInvSeeker expands ProjectileLauncher;

defaultproperties
{
     ProjectileClassName="WOTPawns.LegionProjectile"
     bElementSpirit=True
     bUncommon=True
     bOffensive=True
     bCombat=True
     RoundsPerMinute=120.000000
     ChargeCost=0
     NPCRespawnTime=0.000000
     MaxChargeUsedInterval=0.100000
     MinChargeGroupInterval=0.000000
     Title="LegionSeeker"
     Description="Legion's seeking spirit projectile."
     Quote="None"
     InventoryGroup=52
     PickupMessage=""
     StatusIcon=None
     Texture=None
}
