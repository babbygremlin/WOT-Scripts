//=============================================================================
// BlackSmoke.
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================
class BlackSmoke expands AnimSpriteEffect;

#exec OBJ LOAD FILE=Textures\SmokeBlack.utx PACKAGE=WOT.SmokeBlack

defaultproperties
{
     AnimSets(0)=Texture'WOT.SmokeBlack.bs_a00'
     AnimSets(1)=Texture'WOT.SmokeBlack.bs2_a00'
     AnimSets(2)=Texture'WOT.SmokeBlack.bs3_a00'
     AnimSets(3)=Texture'WOT.SmokeBlack.bs4_a00'
     NumSets=4
     RisingRate=70.000000
     bHighDetail=True
     Style=STY_Modulated
     Texture=Texture'WOT.SmokeBlack.bs2_a00'
     DrawScale=2.200000
}
