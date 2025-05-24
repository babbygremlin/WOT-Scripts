//=============================================================================
// TwoTriangles.
//=============================================================================
class TwoTriangles expands WOTDecoration;

#exec MESH IMPORT MESH=TwoTriangles ANIVFILE=MODELS\TwoTriangles_a.3d DATAFILE=MODELS\TwoTriangles_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=TwoTriangles X=0 Y=0 Z=0 Pitch=64 Yaw=0 Roll=0

#exec MESH SEQUENCE MESH=TwoTriangles SEQ=All        STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JTwoTriangles0 FILE=MODELS\TwoTriangles.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=TwoTriangles MESH=TwoTriangles
#exec MESHMAP SCALE MESHMAP=TwoTriangles X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=TwoTriangles NUM=0 TEXTURE=JTwoTriangles0

defaultproperties
{
     Mesh=Mesh'WOTDecorations.twotriangles'
}
