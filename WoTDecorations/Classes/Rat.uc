//=============================================================================
// Rat.
//=============================================================================
class Rat expands WOTDecoration;

#exec MESH IMPORT MESH=Rat ANIVFILE=MODELS\Rat_a.3d DATAFILE=MODELS\Rat_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Rat X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Rat SEQ=All   STARTFRAME=0 NUMFRAMES=92
#exec MESH SEQUENCE MESH=Rat SEQ=DIE   STARTFRAME=0 NUMFRAMES=34
#exec MESH SEQUENCE MESH=Rat SEQ=PAUSE STARTFRAME=34 NUMFRAMES=28
#exec MESH SEQUENCE MESH=Rat SEQ=SIT   STARTFRAME=62 NUMFRAMES=26
#exec MESH SEQUENCE MESH=Rat SEQ=WALK  STARTFRAME=88 NUMFRAMES=4

#exec TEXTURE IMPORT NAME=JRat0 FILE=MODELS\Rat0.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=Rat MESH=Rat
#exec MESHMAP SCALE MESHMAP=Rat X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Rat NUM=0 TEXTURE=JRat0

defaultproperties
{
     bAutoAnimate=True
     bStatic=False
     bStasis=False
     bNetTemporary=True
     RemoteRole=ROLE_SimulatedProxy
     Mesh=Mesh'WOTDecorations.Rat'
}
