//=============================================================================
// SpriteSmokePuff.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================
class SpriteSmokePuff expands AnimSpriteEffect;

#exec OBJ LOAD FILE=textures\SmokeGray.utx PACKAGE=WOT.SmokeGray

defaultproperties
{
     AnimSets(0)=Texture'WOT.SmokeGray.sp_A00'
     AnimSets(1)=Texture'WOT.SmokeGray.sp1_A00'
     AnimSets(2)=Texture'WOT.SmokeGray.sp2_A00'
     AnimSets(3)=Texture'WOT.SmokeGray.sp3_A00'
     AnimSets(4)=Texture'WOT.SmokeGray.sp4_A00'
     AnimSets(5)=Texture'WOT.SmokeGray.sp5_A00'
     AnimSets(6)=Texture'WOT.SmokeGray.sp6_A00'
     AnimSets(7)=Texture'WOT.SmokeGray.sp7_A00'
     AnimSets(8)=Texture'WOT.SmokeGray.sp8_A00'
     AnimSets(9)=Texture'WOT.SmokeGray.sp9_A00'
     NumSets=10
     RisingRate=30.000000
     Texture=Texture'WOT.SmokeGray.sp1_A00'
}
