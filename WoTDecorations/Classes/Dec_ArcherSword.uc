//=============================================================================
// Dec_ArcherSword.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//=============================================================================

class Dec_ArcherSword expands BounceableDecoration;

defaultproperties
{
     LandSound1=Sound'WOTPawns.Sword_HitWall1'
     LandedRoll=16384.000000
     LandedPitch=16384.000000
     Mesh=Mesh'WOTPawns.MArcherSword'
     DrawScale=0.500000
     MultiSkins(1)=Texture'WOTPawns.Skins.MMiscWeapons'
     MultiSkins(2)=Texture'WOTPawns.Skins.MMiscWeapons'
     CollisionHeight=6.000000
     Mass=25.000000
}
