//=============================================================================
// ArrowTrail.
//=============================================================================
class ArrowTrail expands Effects;

#exec MESH IMPORT MESH=ArrowTrail ANIVFILE=MODELS\ArrowTrail_a.3d DATAFILE=MODELS\ArrowTrail_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=ArrowTrail X=283 Y=0 Z=0

#exec MESH SEQUENCE MESH=ArrowTrail SEQ=All        STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JArrowTrail0 FILE=MODELS\ArrowTrail0.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=ArrowTrail MESH=ArrowTrail
#exec MESHMAP SCALE MESHMAP=ArrowTrail X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=ArrowTrail NUM=0 TEXTURE=JArrowTrail0

simulated function Tick( float DeltaTime )
{
	DrawScale = default.DrawScale * (LifeSpan / default.LifeSpan);
}

defaultproperties
{
     RemoteRole=ROLE_None
     LifeSpan=0.500000
     DrawType=DT_Mesh
     Style=STY_Modulated
     bMustFace=False
     Mesh=Mesh'WOTPawns.ArrowTrail'
     DrawScale=10.000000
     AmbientGlow=20
     bUnlit=True
}
