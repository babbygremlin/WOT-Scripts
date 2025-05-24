//=============================================================================
// CrateSQUARE.uc
// $Author: Mfox $
// $Date: 8/31/99 10:14p $
// $Revision: 2 $
//=============================================================================
class CrateSQUARE expands BreakableDecoration;

#exec MESH IMPORT MESH=CrateSQUARE ANIVFILE=MODELS\CrateSQUARE_a.3d DATAFILE=MODELS\CrateSQUARE_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=CrateSQUARE X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=CrateSQUARE SEQ=All         STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=CrateSQUARE SEQ=CRATESQUARE STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT FILE=MODELS\CrateWoodA_brown.PCX		GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\CrateWoodA_grey.PCX		GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\CrateWoodA_red.PCX		GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\CrateWoodB_brown.PCX		GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\CrateWoodB_grey.PCX		GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\CrateWoodB_red.PCX		GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT FILE=MODELS\CrateWoodB_yellow.PCX	GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=CrateSQUARE MESH=CrateSQUARE
#exec MESHMAP SCALE MESHMAP=CrateSQUARE X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=CrateSQUARE NUM=0 TEXTURE=CrateWoodA_brown

#exec AUDIO IMPORT FILE="Sounds\PushBox2.wav" NAME="PushBox1" // GROUP="General"
#exec AUDIO IMPORT FILE="Sounds\PushBx2a.wav" NAME="PushBx1b" // GROUP="General"

defaultproperties
{
     fragmentClass=Class'WOT.WoodFragments'
     fragmentSize=1.000000
     PushSound=Sound'WOTDecorations.PushBox1'
     EndPushSound=Sound'WOTDecorations.PushBx1b'
     Mesh=Mesh'WOTDecorations.CrateSQUARE'
     CollisionRadius=8.000000
     CollisionHeight=8.000000
}
