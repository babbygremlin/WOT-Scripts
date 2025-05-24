//=============================================================================
// WOTCarcassMyrddraal.
//=============================================================================
class WOTCarcassMyrddraal expands WOTCarcassBlack;

defaultproperties
{
     BodyParts(11)=(BounceSoundStr="WOT.GibBounceBone1",bNoBlood=True,Odds=0.500000,bNoDamage=True)
     AnimationTableClass=Class'WOTPawns.AnimationTableMyrddraal'
     AnimSequence=DEATHB
     Mesh=LodMesh'WOTPawns.Myrddraal'
     DrawScale=0.930000
     CollisionHeight=50.000000
}
