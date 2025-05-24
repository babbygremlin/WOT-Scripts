//=============================================================================
// WOTCarcassHumanoid.
//=============================================================================

class WOTCarcassHumanoid expands WOTCarcass;

//=============================================================================
// Spawn a few extra humanoid-specific parts.
//=============================================================================

defaultproperties
{
     BodyParts(5)=(Odds=0.900000)
     BodyParts(8)=(MeshName="WOT.Arm",SkinName="WOT.Skins.ArmLegFlesh",Odds=0.900000,bZeroPitch=True)
     BodyParts(9)=(MeshName="WOT.Leg",SkinName="WOT.Skins.ArmLegFlesh",Odds=0.900000,bZeroRoll=True,bZeroPitch=True)
     BodyParts(10)=(MeshName="WOT.ThighBone",SkinName="WOT.Skins.BonesBloody",BounceSoundStr="WOT.GibBounceBone1",bNoBlood=True,Odds=0.900000,bNoDamage=True,bZeroPitch=True)
     BodyParts(11)=(MeshName="WOT.Skull",SkinName="WOT.Skins.SkullBlood",BounceSoundStr="WOT.GibBounceBone1",bNoBlood=True,Odds=0.330000,bNoDamage=True)
     ZOffsets(8)=0.250000
     ZOffsets(9)=-0.250000
     ZOffsets(10)=-0.250000
     ZOffsets(11)=0.500000
}
