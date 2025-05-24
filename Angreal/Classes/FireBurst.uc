//------------------------------------------------------------------------------
// FireBurst.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class FireBurst expands Effects;

#exec MESH IMPORT MESH=FireBurst ANIVFILE=MODELS\FireBurst_a.3d DATAFILE=MODELS\FireBurst_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=FireBurst X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=FireBurst SEQ=All     STARTFRAME=0 NUMFRAMES=26
#exec MESH SEQUENCE MESH=FireBurst SEQ=EXPLODE STARTFRAME=0 NUMFRAMES=26

#exec TEXTURE IMPORT NAME=JFireBurst0 FILE=MODELS\FireBurst16a.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=FireBurst MESH=FireBurst
#exec MESHMAP SCALE MESHMAP=FireBurst X=0.4 Y=0.4 Z=0.8

#exec MESHMAP SETTEXTURE MESHMAP=FireBurst NUM=0 TEXTURE=JFireBurst0

var() float FadeTime;
var float FadeTimer;

auto state Burst
{
	function Tick( float DeltaTime )
	{
		FadeTimer += DeltaTime;
		ScaleGlow = FadeTime - FadeTimer;
		if( ScaleGlow < 0 )
		{
			ScaleGlow = 0;
		}

		Super.Tick( DeltaTime );
	}

begin:
	PlayAnim('Explode', 2.0);
	FinishAnim();
	Destroy();
}

defaultproperties
{
    FadeTime=0.50
    DrawType=2
    Style=3
    Texture=Texture'Skins.JFireBurst0'
    Mesh=Mesh'FireBurst'
    DrawScale=0.30
    bUnlit=True
    bParticles=True
}
