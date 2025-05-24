//=============================================================================
// Dec_TrollocAxe.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//=============================================================================

class Dec_TrollocAxe expands BounceableDecoration;

defaultproperties
{
     LandSound1=Sound'WOTPawns.Sword_HitWall1'
     LandedRoll=0.000000
     LandedPitch=0.000000
     Mesh=Mesh'WOTPawns.MTrollocAxeSProjectile'
     MultiSkins(1)=Texture'WOTPawns.Skins.TBird'
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     Mass=15.000000
}
