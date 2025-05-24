//=============================================================================
// TrainingArches.
//=============================================================================
class TrainingArches expands WOTDecoration;

#exec MESH IMPORT MESH=TrainingArches ANIVFILE=MODELS\TrainingArches_a.3d DATAFILE=MODELS\TrainingArches_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=TrainingArches X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=TrainingArches SEQ=All            STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JTrainingArches1 FILE=MODELS\TrainingArches1.PCX GROUP=Skins FLAGS=2 // Material #1

#exec MESHMAP NEW   MESHMAP=TrainingArches MESH=TrainingArches
#exec MESHMAP SCALE MESHMAP=TrainingArches X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=TrainingArches NUM=1 TEXTURE=JTrainingArches1

defaultproperties
{
     Texture=Texture'WOTDecorations.Skins.JTrainingArches1'
     Mesh=Mesh'WOTDecorations.TrainingArches'
     DrawScale=10.000000
     bMeshEnviroMap=True
}
