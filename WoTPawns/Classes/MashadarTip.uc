//------------------------------------------------------------------------------
// MashadarTip.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class MashadarTip expands MashadarTrailer;

#exec MESH IMPORT MESH=MashTip ANIVFILE=MODELS\MashTip_a.3d DATAFILE=MODELS\MashTip_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MashTip X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=MashTip SEQ=All     STARTFRAME=0 NUMFRAMES=10

#exec MESHMAP NEW   MESHMAP=MashTip MESH=MashTip
#exec MESHMAP SCALE MESHMAP=MashTip X=0.2 Y=0.2 Z=0.4

var() float MinAnimRate;
var() float MaxAnimRate;

//------------------------------------------------------------------------------
function PreBeginPlay()
{
	Super.PreBeginPlay();
	LoopAnim( 'All', RandRange( MinAnimRate, MaxAnimRate ) );
}

defaultproperties
{
     MinAnimRate=0.010000
     MaxAnimRate=0.030000
     MaxAngleExt=50.000000
     MinAngleExt=40.000000
     dist=48.000000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=WetTexture'WOTPawns.Mashadar.MyTex2'
     Mesh=Mesh'WOTPawns.MashTip'
     DrawScale=0.200000
     bParticles=True
     CollisionRadius=42.000000
     CollisionHeight=12.000000
}
