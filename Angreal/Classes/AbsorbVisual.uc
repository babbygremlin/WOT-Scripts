//------------------------------------------------------------------------------
// AbsorbVisual.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 3 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AbsorbVisual expands Effects;

#exec MESH IMPORT MESH=AbsorbVisual ANIVFILE=MODELS\AbsorbVisual_a.3d DATAFILE=MODELS\AbsorbVisual_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=AbsorbVisual X=0 Y=0 Z=-100

#exec MESH SEQUENCE MESH=AbsorbVisual SEQ=All          STARTFRAME=0 NUMFRAMES=36
#exec MESH SEQUENCE MESH=AbsorbVisual SEQ=AbsorbVisual STARTFRAME=0 NUMFRAMES=36

#exec TEXTURE IMPORT NAME=JAbsorbVisual0 FILE=MODELS\AbsorbVisual0.PCX GROUP=Effects FLAGS=2

#exec MESHMAP NEW   MESHMAP=AbsorbVisual MESH=AbsorbVisual
#exec MESHMAP SCALE MESHMAP=AbsorbVisual X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=AbsorbVisual NUM=0 TEXTURE=JAbsorbVisual0
/*
var Actor FollowActor;

replication
{
	reliable if( Role==ROLE_Authority )
		FollowActor;
}
*/
//------------------------------------------------------------------------------
auto simulated state Animate
{
Begin:	
	PlayAnim( 'All', 1.0 );
	FinishAnim();
	Destroy();
}
/*
//------------------------------------------------------------------------------
simulated function SetFollowActor( Actor Other )
{
	FollowActor = Other;
	SetBase( FollowActor );
}

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );
	
	if( Base != FollowActor )
	{
		SetBase( FollowActor );
	}
}
*/
defaultproperties
{
    bTrailerSameRotation=True
    Physics=11
    RemoteRole=2
    DrawType=2
    Style=3
    bMustFace=False
    Texture=Texture'Effects.JAbsorbVisual0'
    Mesh=Mesh'AbsorbVisual'
    DrawScale=3.00
    bMeshCurvy=True
}
