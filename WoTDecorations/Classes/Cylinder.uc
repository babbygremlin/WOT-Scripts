//=============================================================================
// Cylinder.uc
// $Author: Mfox $
// $Date: 10/02/99 4:47p $
// $Revision: 3 $
//=============================================================================
class Cylinder expands WOTDecoration;

#exec MESH IMPORT MESH=Cylinder ANIVFILE=MODELS\Cylinder_a.3d DATAFILE=MODELS\Cylinder_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Cylinder X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Cylinder SEQ=All        STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JCylinder0 FILE=MODELS\Cylinder.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=Cylinder MESH=Cylinder
#exec MESHMAP SCALE MESHMAP=Cylinder X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Cylinder NUM=0 TEXTURE=JCylinder0

defaultproperties
{
     Mesh=Mesh'WOTDecorations.Cylinder'
     bCollideActors=False
}
