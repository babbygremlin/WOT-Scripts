//=============================================================================
// WineNoLiquid.
//=============================================================================
class WineNoLiquid expands BreakableDecoration;

#exec MESH IMPORT MESH=WineNoLiquid ANIVFILE=MODELS\WineNoLiquid_a.3d DATAFILE=MODELS\WineNoLiquid_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=WineNoLiquid X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=WineNoLiquid SEQ=All          STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=JWineNoLiquid1 FILE=MODELS\Wine.PCX GROUP=Skins FLAGS=2 // TRANSLUCENT

#exec MESHMAP NEW   MESHMAP=WineNoLiquid MESH=WineNoLiquid
#exec MESHMAP SCALE MESHMAP=WineNoLiquid X=0.07 Y=0.07 Z=0.14

#exec MESHMAP SETTEXTURE MESHMAP=WineNoLiquid NUM=1 TEXTURE=JWineNoLiquid1

defaultproperties
{
     Health=1
     fragmentClass=Class'WOT.GlassFragments'
     fragmentSize=0.200000
     MinDamageVelocityZ=300
     Physics=PHYS_Falling
     Mesh=Mesh'WOTDecorations.WineNoLiquid'
     CollisionRadius=6.000000
     CollisionHeight=20.000000
     Mass=10.000000
     Buoyancy=15.000000
}
