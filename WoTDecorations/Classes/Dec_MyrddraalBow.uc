//=============================================================================
// Dec_MyrddraalBow.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//=============================================================================

class Dec_MyrddraalBow expands BounceableDecoration;

defaultproperties
{
     LandSound1=Sound'WOTPawns.Crossbow_Tossed1'
     LandedRoll=0.000000
     LandedPitch=0.000000
     Mesh=Mesh'WOTPawns.MMyrddraalBow'
     MultiSkins(1)=Texture'WOTPawns.MMyrddraalWeapons'
     MultiSkins(2)=Texture'WOTPawns.MMyrddraalWeapons'
     CollisionRadius=34.000000
     CollisionHeight=6.000000
     Mass=25.000000
}
