//=============================================================================
// TaintParts.
//=============================================================================
class TaintParts expands Effects;

#exec MESH IMPORT MESH=TaintParts ANIVFILE=MODELS\TaintParts_a.3d DATAFILE=MODELS\TaintParts_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=TaintParts X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=TaintParts SEQ=All        STARTFRAME=0 NUMFRAMES=76
#exec MESH SEQUENCE MESH=TaintParts SEQ=TaintLoop	 STARTFRAME=0 NUMFRAMES=49
#exec MESH SEQUENCE MESH=TaintParts SEQ=TaintImpact STARTFRAME=49 NUMFRAMES=25

#exec MESHMAP NEW   MESHMAP=TaintParts MESH=TaintParts
#exec MESHMAP SCALE MESHMAP=TaintParts X=0.2 Y=0.2 Z=0.4

#exec TEXTURE IMPORT FILE=MODELS\TaintParts.pcx GROUP=Taint

auto state Rotating
{	
begin:
	LoopAnim( 'TaintLoop', 1.0 );
}

state Impact
{
begin:
	FinishAnim();
	PlayAnim( 'TaintImpact', 1.0 );
	FinishAnim();
	Destroy();
}

defaultproperties
{
    DrawType=2
    Style=3
    Texture=Texture'Taint.TaintParts'
    Mesh=Mesh'TaintParts'
    DrawScale=0.07
    bParticles=True
}
