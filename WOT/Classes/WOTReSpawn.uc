//=============================================================================
// WOTReSpawn.
//=============================================================================
class WOTReSpawn expands Effects;

#exec MESH IMPORT MESH=ReSpawnEffect ANIVFILE=MODELS\Spawn_a.3D DATAFILE=MODELS\Spawn_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=ReSpawnEffect X=0 Y=0 Z=0 YAW=0
#exec MESH SEQUENCE MESH=ReSpawnEffect SEQ=All       STARTFRAME=0   NUMFRAMES=16
#exec MESH SEQUENCE MESH=ReSpawnEffect SEQ=Explosion STARTFRAME=0   NUMFRAMES=16
#exec TEXTURE IMPORT NAME=JSpawn1 FILE=MODELS\Spawn.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=ReSpawnEffect X=0.03 Y=0.03 Z=0.06
#exec MESHMAP SETTEXTURE MESHMAP=ReSpawnEffect NUM=1 TEXTURE=JSpawn1

auto state Explode
{
Begin:
	PlaySound (EffectSound1);
	PlayAnim('All');
	FinishAnim();				
	Destroy();	
}

defaultproperties
{
     bNetTemporary=False
     DrawType=DT_Mesh
     Mesh=Mesh'WOT.ReSpawnEffect'
     AmbientGlow=250
     bUnlit=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightBrightness=210
     LightHue=30
     LightSaturation=224
     LightRadius=8
}
