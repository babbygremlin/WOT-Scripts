//=============================================================================
// DragonFly.
// $Author: Mfox $
// $Date: 8/31/99 10:14p $
// $Revision: 2 $
//=============================================================================
class DragonFly expands WOTDecoration;

#exec MESH IMPORT MESH=DragonFly ANIVFILE=MODELS\DragonFly_a.3d DATAFILE=MODELS\DragonFly_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=DragonFly X=0 Y=0 Z=0       

#exec MESH SEQUENCE MESH=DragonFly SEQ=All       STARTFRAME=0 NUMFRAMES=3
#exec MESH SEQUENCE MESH=DragonFly SEQ=DRAGONFLY STARTFRAME=0 NUMFRAMES=3

#exec TEXTURE IMPORT NAME=JDragonFly1 FILE=MODELS\DragonFly1.PCX GROUP=Skins FLAGS=2 // DragonFly

#exec MESHMAP NEW   MESHMAP=DragonFly MESH=DragonFly
#exec MESHMAP SCALE MESHMAP=DragonFly X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=DragonFly NUM=1 TEXTURE=JDragonFly1

var() float MaxAnimRate;
var() float MinAnimRate;

function PreBeginPlay()
{
	LoopAnim( 'DRAGONFLY', RandRange( MinAnimRate, MaxAnimRate ) );

	Super.PreBeginPlay();
}

defaultproperties
{
     MaxAnimRate=2.000000
     MinAnimRate=1.500000
     bStatic=False
     bStasis=False
     Mesh=Mesh'WOTDecorations.DragonFly'
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     bCollideActors=False
     bBlockActors=False
     bBlockPlayers=False
}
