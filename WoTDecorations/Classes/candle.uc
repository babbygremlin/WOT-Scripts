//=============================================================================
// candle.
//=============================================================================
class candle expands WOTDecoration;

#exec MESH IMPORT MESH=candle ANIVFILE=MODELS\candle_a.3d DATAFILE=MODELS\candle_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=candle X=-5 Y=0 Z=10

#exec MESH SEQUENCE MESH=candle SEQ=All    STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=Jcandle1 FILE=MODELS\candle1.PCX GROUP=Skins FLAGS=2 // Candle

#exec MESHMAP NEW   MESHMAP=candle MESH=candle
#exec MESHMAP SCALE MESHMAP=candle X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=candle NUM=1 TEXTURE=Jcandle1

defaultproperties
{
     Mesh=Mesh'WOTDecorations.candle'
     CollisionRadius=5.000000
     CollisionHeight=20.000000
}
