//=============================================================================
// HalfTorchHolder.
// $Author: Mfox $
// $Date: 10/02/99 4:47p $
// $Revision: 3 $
//=============================================================================
class HalfTorchHolder expands WOTDecoration;

#exec MESH IMPORT MESH=HalfTorchHolder ANIVFILE=MODELS\HalfTorchHolder_a.3d DATAFILE=MODELS\HalfTorchHolder_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=HalfTorchHolder X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=HalfTorchHolder SEQ=All             STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JHalfTorchHolder1 FILE=MODELS\HalfTorchHolder.PCX GROUP=Skins FLAGS=2 // HalfTorchHolder

#exec MESHMAP NEW   MESHMAP=HalfTorchHolder MESH=HalfTorchHolder
#exec MESHMAP SCALE MESHMAP=HalfTorchHolder X=0.05 Y=0.05 Z=0.1

#exec MESHMAP SETTEXTURE MESHMAP=HalfTorchHolder NUM=1 TEXTURE=JHalfTorchHolder1

defaultproperties
{
     Mesh=Mesh'WOTDecorations.HalfTorchHolder'
     CollisionRadius=4.300000
     CollisionHeight=1.000000
}
