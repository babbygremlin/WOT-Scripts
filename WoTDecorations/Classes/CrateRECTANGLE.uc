//=============================================================================
// CrateRECTANGLE.uc
// $Author: Mfox $
// $Date: 10/02/99 4:47p $
// $Revision: 3 $
//=============================================================================
class CrateRECTANGLE expands BreakableDecoration;

#exec MESH IMPORT MESH=CrateRECTANGLE ANIVFILE=MODELS\CrateRECTANGLE_a.3d DATAFILE=MODELS\CrateRECTANGLE_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=CrateRECTANGLE X=0 Y=0 Z=38

#exec MESH SEQUENCE MESH=CrateRECTANGLE SEQ=All            STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT FILE=MODELS\CrateMetal01.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=CrateRECTANGLE MESH=CrateRECTANGLE
#exec MESHMAP SCALE MESHMAP=CrateRECTANGLE X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=CrateRECTANGLE NUM=0 TEXTURE=CrateMetal01

#exec AUDIO IMPORT FILE="Sounds\PushBox2.wav" NAME="PushBox2" // GROUP="General"
#exec AUDIO IMPORT FILE="Sounds\PushBx2a.wav" NAME="PushBx2a" // GROUP="General"

defaultproperties
{
     fragmentClass=Class'WOT.WoodFragments'
     fragmentSize=1.000000
     PushSound=Sound'WOTDecorations.PushBox2'
     EndPushSound=Sound'WOTDecorations.PushBx2a'
     Mesh=Mesh'WOTDecorations.CrateRECTANGLE'
     CollisionRadius=15.000000
     CollisionHeight=8.000000
}
