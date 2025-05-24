//=============================================================================
// Bushes.uc
// $Author: Mfox $
// $Date: 10/02/99 4:47p $
// $Revision: 3 $
//=============================================================================
class Bushes expands WOTDecoration;

#exec MESH IMPORT MESH=Bushes ANIVFILE=MODELS\Bushes_a.3d DATAFILE=MODELS\Bushes_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Bushes X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Bushes SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JBushes1 FILE=MODELS\Bushes1.PCX GROUP=Skins FLAGS=2

#exec MESHMAP NEW   MESHMAP=Bushes MESH=Bushes
#exec MESHMAP SCALE MESHMAP=Bushes X=0.2 Y=0.2 Z=0.4

#exec MESHMAP SETTEXTURE MESHMAP=Bushes NUM=1 TEXTURE=JBushes1

defaultproperties
{
     bHighDetail=True
     Mesh=Mesh'WOTDecorations.Bushes'
     bUnlit=True
     CollisionHeight=33.000000
     bBlockActors=False
     bBlockPlayers=False
}
