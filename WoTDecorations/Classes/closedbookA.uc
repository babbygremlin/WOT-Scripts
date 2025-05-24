//=============================================================================
// ClosedBookA.uc
// $Author: Mfox $
// $Date: 10/02/99 4:47p $
// $Revision: 3 $
//=============================================================================
class ClosedBookA expands BounceableDecoration;

#exec MESH IMPORT MESH=closedbookA ANIVFILE=MODELS\closedbookA_a.3d DATAFILE=MODELS\closedbookA_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=closedbookA X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=closedbookA SEQ=All         STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JclosedbookA1 FILE=MODELS\closedbookA1.PCX GROUP=Skins FLAGS=2 // ClosedBookA

#exec MESHMAP NEW   MESHMAP=closedbookA MESH=closedbookA
#exec MESHMAP SCALE MESHMAP=closedbookA X=0.03 Y=0.03 Z=0.06

#exec MESHMAP SETTEXTURE MESHMAP=closedbookA NUM=1 TEXTURE=JclosedbookA1

#exec AUDIO IMPORT FILE="Sounds\Book7.wav" NAME="Book7" // GROUP="General"

defaultproperties
{
     LandSound1=Sound'WOTDecorations.Book7'
     Mesh=Mesh'WOTDecorations.closedbookA'
     CollisionRadius=10.000000
     Mass=10.000000
     Buoyancy=9.000000
}
