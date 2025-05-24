//=============================================================================
// WOTBurst.
//=============================================================================
class WOTBurst expands Effects;
    
#exec MESH IMPORT MESH=WOTburst ANIVFILE=MODELS\burst_a.3D DATAFILE=MODELS\burst_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=WOTburst X=0 Y=0 Z=0 YAW=-64

#exec MESH SEQUENCE MESH=WOTburst SEQ=All       STARTFRAME=0   NUMFRAMES=6
#exec MESH SEQUENCE MESH=WOTburst SEQ=Explo     STARTFRAME=0   NUMFRAMES=6

#exec TEXTURE IMPORT NAME=WOTburst1 FILE=MODELS\burst.PCX FAMILY=Skins FLAGS=2

#exec MESHMAP NEW   MESHMAP=WOTburst MESH=WOTburst
#exec MESHMAP SCALE MESHMAP=WOTburst X=0.2 Y=0.2 Z=0.4 YAW=128

#exec MESHMAP SETTEXTURE MESHMAP=WOTburst NUM=1 TEXTURE=WOTburst1

auto state Explode
{
	function Tick( float DeltaTime )
	{
		LightBrightness = Max( LightBrightness - 250*DeltaTime, 0 );
	}
Begin:
	SetRotation( rotator(VRand()) );
	PlayAnim   ( 'Explo', 0.6 );
	PlaySound (EffectSound1);	
	MakeNoise  ( 1.0 );
	FinishAnim ();
  	Destroy();
}

defaultproperties
{
     DrawType=DT_Mesh
     Mesh=Mesh'WOT.WOTBurst'
}
