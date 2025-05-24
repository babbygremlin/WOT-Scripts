//------------------------------------------------------------------------------
// MashadarSegment.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class MashadarSegment expands MashadarTrailer;

#exec MESH IMPORT MESH=MashSeg ANIVFILE=MODELS\MashSeg_a.3d DATAFILE=MODELS\MashSeg_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MashSeg X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=MashSeg SEQ=All     STARTFRAME=0 NUMFRAMES=10

#exec MESHMAP NEW   MESHMAP=MashSeg MESH=MashSeg
#exec MESHMAP SCALE MESHMAP=MashSeg X=0.2 Y=0.2 Z=0.4

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
     dist=42.000000
     DrawType=DT_Mesh
     Style=STY_Translucent
     Texture=WetTexture'WOTPawns.Mashadar.MyTex2'
     Mesh=Mesh'WOTPawns.MashSeg'
     DrawScale=0.300000
     bParticles=True
     CollisionRadius=25.000000
     CollisionHeight=12.000000
}
