//=============================================================================
// TrainingArchesSingle.
//=============================================================================
class TrainingArchesSingle expands TrainingArches;

#exec MESH IMPORT MESH=TrainingArchSingle ANIVFILE=MODELS\TrainingArchSingle_a.3d DATAFILE=MODELS\TrainingArchSingle_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=TrainingArchSingle X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=TrainingArchSingle SEQ=All                STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=TrainingArchSingle MESH=TrainingArchSingle
#exec MESHMAP SCALE MESHMAP=TrainingArchSingle X=0.1 Y=0.1 Z=0.2

defaultproperties
{
     Mesh=Mesh'WOTDecorations.TrainingArchSingle'
}
