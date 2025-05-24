//=============================================================================
// Drip.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 5 $
//=============================================================================
class Drip expands DripGenerator;

#exec MESH IMPORT MESH=DripMesh ANIVFILE=MODELS\drip_a.3D DATAFILE=MODELS\drip_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=DripMesh X=0 Y=0 Z=-50 YAW=64
#exec MESH SEQUENCE MESH=DripMesh SEQ=All       STARTFRAME=0   NUMFRAMES=6
#exec MESH SEQUENCE MESH=DripMesh SEQ=Dripping  STARTFRAME=0   NUMFRAMES=6
#exec TEXTURE IMPORT NAME=DripSkin FILE=MODELS\misc.PCX GROUP=Skins 
#exec MESHMAP SCALE MESHMAP=DripMesh X=0.01 Y=0.01 Z=0.02
#exec MESHMAP SETTEXTURE MESHMAP=DripMesh NUM=0 TEXTURE=DripSkin

#exec AUDIO IMPORT FILE="Sounds\Effect\Drip.wav" NAME=DripSound

auto state FallingState
{
	function Landed( vector HitNormal )
	{
		HitWall( HitNormal, None );	
	}

	simulated function HitWall( vector HitNormal, actor Wall )
	{
		PlaySound( sound'DripSound' );
		Destroy();
	}
	
	singular function Touch(actor Other)
	{
		PlaySound( sound'DripSound' );	
		Destroy();
	}

Begin:
	PlayAnim( 'Dripping', 0.3 );
}

defaultproperties
{
     DripPause=0.000000
     DripVariance=0.000000
     bHidden=False
     Physics=PHYS_Falling
     LifeSpan=5.000000
     DrawType=DT_Mesh
     Skin=Texture'WOT.Skins.DripSkin'
     Mesh=Mesh'WOT.DripMesh'
     bMeshCurvy=True
     CollisionRadius=0.000000
     CollisionHeight=0.000000
     bCollideWorld=True
}
