//=============================================================================
// Bush03.uc
// $Author: Mfox $
// $Date: 8/31/99 10:14p $
// $Revision: 2 $
//=============================================================================
class Bush03 expands WOTDecoration;

#exec MESH IMPORT MESH=Bush03 ANIVFILE=MODELS\Bush03_a.3d DATAFILE=MODELS\Bush03_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Bush03 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Bush03 SEQ=All    STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Bush03 SEQ=Bush03 STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JBush031 FILE=MODELS\Bush031.PCX GROUP=Skins FLAGS=2

#exec MESHMAP NEW   MESHMAP=Bush03 MESH=Bush03
#exec MESHMAP SCALE MESHMAP=Bush03 X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Bush03 NUM=1 TEXTURE=JBush031

defaultproperties
{
     bHighDetail=True
     Style=STY_Masked
     Mesh=Mesh'WOTDecorations.Bush03'
     CollisionHeight=13.000000
}
