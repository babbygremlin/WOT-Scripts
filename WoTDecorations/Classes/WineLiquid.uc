//=============================================================================
// WineLiquid.
//=============================================================================
class WineLiquid expands BreakableDecoration;

#exec MESH IMPORT MESH=WineLiquid ANIVFILE=MODELS\WineLiquid_a.3d DATAFILE=MODELS\WineLiquid_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=WineLiquid X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=WineLiquid SEQ=All        STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JWineLiquid1 FILE=MODELS\Wine.PCX GROUP=Skins FLAGS=2 // TRANSLUCENT

#exec MESHMAP NEW   MESHMAP=WineLiquid MESH=WineLiquid
#exec MESHMAP SCALE MESHMAP=WineLiquid X=0.07 Y=0.07 Z=0.14

#exec MESHMAP SETTEXTURE MESHMAP=WineLiquid NUM=1 TEXTURE=JWineLiquid1

defaultproperties
{
     Health=2
     fragmentClass=Class'WOT.GlassFragments'
     fragmentSize=0.200000
     MinDamageVelocityZ=300
     Physics=PHYS_Falling
     Mesh=Mesh'WOTDecorations.WineLiquid'
     CollisionRadius=6.000000
     CollisionHeight=20.000000
     Mass=10.000000
     Buoyancy=5.000000
}
