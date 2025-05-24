//------------------------------------------------------------------------------
// BalefireStreak.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class BalefireStreak expands Streak;

#exec MESH IMPORT MESH=BalefireSeg ANIVFILE=MODELS\BalefireSeg_a.3d DATAFILE=MODELS\BalefireSeg_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=BalefireSeg X=0 Y=0 Z=0 Pitch=-64

#exec MESH SEQUENCE MESH=BalefireSeg SEQ=All			STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=BalefireSeg SEQ=BalefireSeg	STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JBalefireSeg0 FILE=MODELS\BalefireSeg.pcx GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=BalefireSeg MESH=BalefireSeg
#exec MESHMAP SCALE MESHMAP=BalefireSeg X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=BalefireSeg NUM=0 TEXTURE=JBalefireSeg0

defaultproperties
{
     SegmentLength=96.000000
     bDirectional=True
     DrawType=DT_Mesh
     Mesh=Mesh'Angreal.BalefireSeg'
     DrawScale=3.000000
     AmbientGlow=254
     bUnlit=True
}
