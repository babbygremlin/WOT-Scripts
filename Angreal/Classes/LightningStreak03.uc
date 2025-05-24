//------------------------------------------------------------------------------
// LightningStreak03.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class LightningStreak03 expands LightningStreak02;

#exec MESH    IMPORT     MESH=LStwotri ANIVFILE=MODELS\LStwotri_a.3D DATAFILE=MODELS\LStwotri_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH    ORIGIN     MESH=LStwotri X=0 Y=0 Z=0 YAW=0 PITCH=-64 ROLL=0
#exec MESH    SEQUENCE   MESH=LStwotri SEQ=All  STARTFRAME=0  NUMFRAMES=1

#exec MESHMAP NEW        MESHMAP=LStwotri MESH=LStwotri
#exec MESHMAP SCALE      MESHMAP=LStwotri X=0.1 Y=0.1 Z=0.2
#exec MESHMAP SETTEXTURE MESHMAP=LStwotri NUM=0 TEXTURE=LB_A01

defaultproperties
{
    SegmentLength=61.40
    bAlwaysFace=True
    Style=3
    Mesh=Mesh'LStwotri'
    ScaleGlow=5.00
    AmbientGlow=254
}
