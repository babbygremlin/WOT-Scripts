//=============================================================================
// WOTCarcassMinion.
//=============================================================================
class WOTCarcassMinion expands WOTCarcassBlack;

// black versions, no spine, armbone

defaultproperties
{
     AnimationTableClass=Class'WOTPawns.AnimationTableMinion'
     AnimSequence=DEATHB
     AnimFrame=0.980000
     Skin=Texture'WOTPawns.Skins.JMinion1'
     Mesh=LodMesh'WOTPawns.Minion'
     DrawScale=1.400000
     MultiSkins(1)=Texture'WOTPawns.Skins.JMinion1'
     MultiSkins(2)=Texture'WOTPawns.Skins.JMinion1'
     CollisionRadius=30.000000
     CollisionHeight=50.000000
}
