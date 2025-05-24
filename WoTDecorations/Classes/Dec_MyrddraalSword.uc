//=============================================================================
// Dec_MyrddraalSword.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//=============================================================================

class Dec_MyrddraalSword expands BounceableDecoration;

defaultproperties
{
     LandSound1=Sound'WOTPawns.Sword_HitWall1'
     LandedYaw=16384.000000
     LandedRoll=16384.000000
     LandedPitch=0.000000
     Mesh=Mesh'WOTPawns.MMyrddraalSword'
     DrawScale=0.660000
     MultiSkins(1)=Texture'WOTPawns.MMyrddraalWeapons'
     MultiSkins(2)=Texture'WOTPawns.MMyrddraalWeapons'
     CollisionRadius=9.000000
     CollisionHeight=10.000000
     Mass=15.000000
}
