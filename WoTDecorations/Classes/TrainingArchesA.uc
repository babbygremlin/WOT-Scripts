//=============================================================================
// TrainingArchesA.
//=============================================================================
class TrainingArchesA expands TrainingArches;

#exec MESH IMPORT MESH=TrainingArchesA ANIVFILE=MODELS\TrainingArchesA_a.3d DATAFILE=MODELS\TrainingArchesA_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=TrainingArchesA X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=TrainingArchesA SEQ=All             STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=TrainingArchesA MESH=TrainingArchesA
#exec MESHMAP SCALE MESHMAP=TrainingArchesA X=0.1 Y=0.1 Z=0.2

defaultproperties
{
     Mesh=Mesh'WOTDecorations.TrainingArchesA'
}
