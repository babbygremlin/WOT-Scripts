//=============================================================================
// TaintExpDarts.
//=============================================================================
class TaintExpDarts expands TaintExpAssets;

#exec MESH IMPORT MESH=TaintExpDarts ANIVFILE=MODELS\TaintExpDarts_a.3d DATAFILE=MODELS\TaintExpDarts_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=TaintExpDarts X=0 Y=0 Z=0

#exec TEXTURE IMPORT FILE=MODELS\TaintDarts.pcx GROUP=Taint

#exec MESH SEQUENCE MESH=TaintExpDarts SEQ=All           STARTFRAME=0 NUMFRAMES=27
#exec MESH SEQUENCE MESH=TaintExpDarts SEQ=TAINTEXPDARTS STARTFRAME=0 NUMFRAMES=27

#exec MESHMAP NEW   MESHMAP=TaintExpDarts MESH=TaintExpDarts
#exec MESHMAP SCALE MESHMAP=TaintExpDarts X=0.1 Y=0.1 Z=0.2

defaultproperties
{
    NumAnimFrames=27
    DrawType=2
    Texture=Texture'Taint.TaintDarts'
    Mesh=Mesh'TaintExpDarts'
    AmbientGlow=20
    bUnlit=True
}
