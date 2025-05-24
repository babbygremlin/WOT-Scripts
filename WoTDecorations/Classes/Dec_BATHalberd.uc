//=============================================================================
// Dec_BATHalberd.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//=============================================================================

class Dec_BATHalberd expands BounceableDecoration;

defaultproperties
{
     LandSound1=Sound'WOTPawns.Halberd_HitWall1'
     LandedYaw=16384.000000
     LandedRoll=22222.000000
     LandedPitch=16384.000000
     Mesh=Mesh'WOTPawns.MBATHalberd'
     MultiSkins(1)=Texture'WOTPawns.Skins.MMiscWeapons'
     CollisionHeight=15.000000
     Mass=50.000000
}
