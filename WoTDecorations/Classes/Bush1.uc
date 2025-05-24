//=============================================================================
// Bush1.uc
// $Author: Mfox $
// $Date: 8/31/99 10:14p $
// $Revision: 2 $
//=============================================================================
class Bush1 expands WOTDecoration;

#exec MESH IMPORT MESH=Bush1 ANIVFILE=MODELS\Bush1_a.3d DATAFILE=MODELS\Bush1_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Bush1 X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Bush1 SEQ=All     STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Bush1 SEQ=Bush1 STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JBush1 FILE=MODELS\Bush1.PCX GROUP=Skins FLAGS=2 // TWOSIDED

#exec MESHMAP NEW   MESHMAP=Bush1 MESH=Bush1
#exec MESHMAP SCALE MESHMAP=Bush1 X=0.3 Y=0.3 Z=0.6

#exec MESHMAP SETTEXTURE MESHMAP=Bush1 NUM=1 TEXTURE=JBush1

defaultproperties
{
     bHighDetail=True
     Mesh=Mesh'WOTDecorations.Bush1'
     bUnlit=True
     CollisionHeight=16.000000
     bBlockActors=False
     bBlockPlayers=False
}
