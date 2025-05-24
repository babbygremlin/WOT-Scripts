//=============================================================================
// ClosedBookB.uc
// $Author: Mfox $
// $Date: 10/02/99 4:47p $
// $Revision: 3 $
//=============================================================================
class ClosedBookB expands BounceableDecoration;

#exec MESH IMPORT MESH=closedbookb ANIVFILE=MODELS\closedbookb_a.3d DATAFILE=MODELS\closedbookb_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=closedbookb X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=closedbookb SEQ=All         STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=Jclosedbookb1 FILE=MODELS\closedbookb1.PCX GROUP=Skins FLAGS=2 // ClosedBookB

#exec MESHMAP NEW   MESHMAP=closedbookb MESH=closedbookb
#exec MESHMAP SCALE MESHMAP=closedbookb X=0.03 Y=0.03 Z=0.06

#exec MESHMAP SETTEXTURE MESHMAP=closedbookb NUM=1 TEXTURE=Jclosedbookb1

#exec AUDIO IMPORT FILE="Sounds\Book2.wav" NAME="Book2" // GROUP="General"

defaultproperties
{
     LandSound1=Sound'WOTDecorations.Book2'
     Mesh=Mesh'WOTDecorations.closedbookb'
     CollisionRadius=10.000000
     Mass=10.000000
     Buoyancy=9.000000
}
