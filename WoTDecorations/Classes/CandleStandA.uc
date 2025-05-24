//=============================================================================
// CandleStandA.uc
// $Author: Mfox $
// $Date: 10/02/99 4:47p $
// $Revision: 3 $
//=============================================================================
class CandleStandA expands WOTDecoration;

#exec MESH IMPORT MESH=candlestanda ANIVFILE=MODELS\candlestanda_a.3d DATAFILE=MODELS\candlestanda_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=candlestanda X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=candlestanda SEQ=All          STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=Jcandlestanda1 FILE=MODELS\candlestanda1.PCX GROUP=Skins FLAGS=2 // CandleStandA

#exec MESHMAP NEW   MESHMAP=candlestanda MESH=candlestanda
#exec MESHMAP SCALE MESHMAP=candlestanda X=0.2 Y=0.2 Z=0.4

#exec MESHMAP SETTEXTURE MESHMAP=candlestanda NUM=1 TEXTURE=Jcandlestanda1

defaultproperties
{
     bPushable=True
     Mesh=Mesh'WOTDecorations.CandleStandA'
     CollisionRadius=8.000000
     CollisionHeight=62.000000
     bCollideWorld=True
     Mass=200.000000
}
