//=============================================================================
// TrapBurst.
//=============================================================================
class TrapBurst expands Effects;
    
#exec MESH IMPORT MESH=Trapburst ANIVFILE=MODELS\TrapBurst\burst_a.3D DATAFILE=MODELS\TrapBurst\burst_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Trapburst X=0 Y=0 Z=0 YAW=-64

#exec MESH SEQUENCE MESH=Trapburst SEQ=All       STARTFRAME=0   NUMFRAMES=6
#exec MESH SEQUENCE MESH=Trapburst SEQ=Explo     STARTFRAME=0   NUMFRAMES=6

#exec TEXTURE IMPORT NAME=Trapburst1 FILE=MODELS\TrapBurst\burst.PCX FAMILY=Skins FLAGS=2

#exec MESHMAP NEW   MESHMAP=Trapburst MESH=Trapburst
#exec MESHMAP SCALE MESHMAP=Trapburst X=0.2 Y=0.2 Z=0.4 YAW=128

#exec MESHMAP SETTEXTURE MESHMAP=Trapburst NUM=1 TEXTURE=Trapburst1

auto simulated state Explode
{
Begin:
	SetRotation( rotator(VRand()) );
	PlaySound( EffectSound1 );	
	MakeNoise( 1.0 );
	PlayAnim( 'Explo', 0.6 );
	FinishAnim();
  	Destroy();
}

defaultproperties
{
     RemoteRole=ROLE_SimulatedProxy
     DrawType=DT_Mesh
     Mesh=Mesh'WOTTraps.TrapBurst'
}
