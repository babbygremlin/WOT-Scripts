//=============================================================================
// BarrelTap.
// $Author: Mfox $
// $Date: 10/02/99 4:47p $
// $Revision: 3 $
//=============================================================================
class BarrelTap expands BreakableDecoration;

#exec MESH IMPORT MESH=BarrelTap ANIVFILE=MODELS\BarrelTap_a.3d DATAFILE=MODELS\BarrelTap_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=BarrelTap X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=BarrelTap SEQ=All       STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JBarrelTap1 FILE=MODELS\Barrel1.PCX GROUP=Skins FLAGS=2 // Barrel

#exec MESHMAP NEW   MESHMAP=BarrelTap MESH=BarrelTap
#exec MESHMAP SCALE MESHMAP=BarrelTap X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=BarrelTap NUM=1 TEXTURE=JBarrelTap1

defaultproperties
{
     Health=20
     fragmentClass=Class'WOT.WoodFragments'
     fragmentSize=1.750000
     Physics=PHYS_Falling
     Mesh=Mesh'WOTDecorations.BarrelTap'
     CollisionHeight=22.000000
     Mass=60.000000
     Buoyancy=50.000000
}
