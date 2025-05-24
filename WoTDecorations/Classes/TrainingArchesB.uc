//=============================================================================
// TrainingArchesB.
//=============================================================================
class TrainingArchesB expands TrainingArches;

#exec MESH IMPORT MESH=TrainingArchesB ANIVFILE=MODELS\TrainingArchesB_a.3d DATAFILE=MODELS\TrainingArchesB_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=TrainingArchesB X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=TrainingArchesB SEQ=All             STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=TrainingArchesB MESH=TrainingArchesB
#exec MESHMAP SCALE MESHMAP=TrainingArchesB X=0.1 Y=0.1 Z=0.2

defaultproperties
{
     Mesh=Mesh'WOTDecorations.TrainingArchesB'
}
