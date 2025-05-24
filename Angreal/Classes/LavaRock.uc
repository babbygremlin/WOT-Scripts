//------------------------------------------------------------------------------
// LavaRock.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 4 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LavaRock expands BurningChunk;

#exec MESH IMPORT MESH=LavaRock ANIVFILE=MODELS\LavaRock_a.3d DATAFILE=MODELS\LavaRock_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=LavaRock X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=LavaRock SEQ=All      STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT FILE=MODELS\LavaRock3D.PCX GROUP=Skins FLAGS=2 // LavaRock3D

#exec MESHMAP NEW   MESHMAP=LavaRock MESH=LavaRock
#exec MESHMAP SCALE MESHMAP=LavaRock X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=LavaRock NUM=1 TEXTURE=LavaRock3D

defaultproperties
{
     MinSpeed=400.000000
     MaxSpeed=600.000000
     SprayerTypes(0)=Class'ParticleSystems.BlackSmoke01'
     DrawType=DT_Mesh
     Style=STY_Normal
     Mesh=Mesh'Angreal.LavaRock'
     DrawScale=0.700000
}
