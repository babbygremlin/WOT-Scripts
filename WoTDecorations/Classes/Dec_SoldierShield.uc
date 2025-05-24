//=============================================================================
// Dec_SoldierShield.uc
// $Author: Mpoesch $
// $Date: 8/24/99 9:20p $
// $Revision: 1 $
//=============================================================================

class Dec_SoldierShield expands BounceableDecoration;

defaultproperties
{
     LandSound1=Sound'WOTPawns.Shield_Deflect1'
     BaseBounceVolume=0.500000
     LandedRoll=0.000000
     LandedPitch=0.000000
     Style=STY_Masked
     Mesh=Mesh'WOTPawns.MSoldierShield'
     MultiSkins(0)=Texture'WOTPawns.Skins.MSoldierShield0'
     CollisionRadius=20.000000
     Mass=25.000000
}
