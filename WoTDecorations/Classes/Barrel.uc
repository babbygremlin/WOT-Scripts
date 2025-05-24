//=============================================================================
// Barrel.uc
// $Author: Mfox $
// $Date: 10/02/99 4:47p $
// $Revision: 3 $
//=============================================================================
class Barrel expands BreakableDecoration;

#exec MESH IMPORT MESH=Barrel ANIVFILE=MODELS\Barrelnew_a.3d DATAFILE=MODELS\Barrelnew_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Barrel X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=Barrel SEQ=All    STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JBarrel1 FILE=MODELS\Barrel1.PCX GROUP=Skins FLAGS=2 // Barrel

#exec MESHMAP NEW   MESHMAP=Barrel MESH=Barrel
#exec MESHMAP SCALE MESHMAP=Barrel X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Barrel NUM=1 TEXTURE=JBarrel1

#exec AUDIO IMPORT FILE="Sounds\PushBox2.wav" NAME="PushBox2" // GROUP="General"
#exec AUDIO IMPORT FILE="Sounds\PushBx2a.wav" NAME="PushBx2a" // GROUP="General"

defaultproperties
{
     fragmentClass=Class'WOT.WoodFragments'
     fragmentSize=1.750000
     PushSound=Sound'WOTDecorations.PushBox2'
     EndPushSound=Sound'WOTDecorations.PushBx2a'
     Physics=PHYS_Falling
     bDirectional=True
     Mesh=Mesh'WOTDecorations.Barrel'
     CollisionRadius=22.000000
}
