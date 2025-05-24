//=============================================================================
// GnarledTree.
// $Author: Mfox $
// $Date: 10/02/99 4:47p $
// $Revision: 4 $
//=============================================================================
class GnarledTree expands WOTDecoration;

#exec MESH IMPORT MESH=GnarledTree ANIVFILE=MODELS\GnarledTree_a.3d DATAFILE=MODELS\GnarledTree_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=GnarledTree X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=GnarledTree SEQ=All         STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JGnarledTree1 FILE=MODELS\GnarledTree1.PCX GROUP=Skins FLAGS=2 // TWOSIDED

#exec MESHMAP NEW   MESHMAP=GnarledTree MESH=GnarledTree
#exec MESHMAP SCALE MESHMAP=GnarledTree X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=GnarledTree NUM=0 TEXTURE=JGnarledTree1

defaultproperties
{
     Mesh=Mesh'WOTDecorations.GnarledTree'
}
