//------------------------------------------------------------------------------
// MSFace.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//
// Description:
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class MSFace expands GenericSprite;

// Face sprites.
#exec TEXTURE IMPORT FILE=MODELS\Face01.PCX GROUP=Faces
#exec TEXTURE IMPORT FILE=MODELS\Face02.PCX GROUP=Faces
#exec TEXTURE IMPORT FILE=MODELS\Face03.PCX GROUP=Faces
#exec TEXTURE IMPORT FILE=MODELS\Face04.PCX GROUP=Faces
#exec TEXTURE IMPORT FILE=MODELS\Face05.PCX GROUP=Faces
#exec TEXTURE IMPORT FILE=MODELS\Face06.PCX GROUP=Faces
#exec TEXTURE IMPORT FILE=MODELS\Face07.PCX GROUP=Faces
#exec TEXTURE IMPORT FILE=MODELS\Face08.PCX GROUP=Faces
#exec TEXTURE IMPORT FILE=MODELS\Face09.PCX GROUP=Faces

var() Texture FaceTextures[9];

var Actor Subject;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	Subject = Owner;
	Subject.AttachDestroyObserver( Self );
	Texture = FaceTextures[ Rand( ArrayCount(FaceTextures) ) ];
}

//------------------------------------------------------------------------------
simulated function SubjectDestroyed( Object Subject )
{
	if( Subject == Self.Subject )
	{
		Destroy();
	}

	Super.SubjectDestroyed( Subject );
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	Subject.DetachDestroyObserver( Self );
	Super.Destroyed();
}

defaultproperties
{
     FaceTextures(0)=Texture'MachinShin.Faces.Face01'
     FaceTextures(1)=Texture'MachinShin.Faces.Face02'
     FaceTextures(2)=Texture'MachinShin.Faces.Face03'
     FaceTextures(3)=Texture'MachinShin.Faces.Face04'
     FaceTextures(4)=Texture'MachinShin.Faces.Face05'
     FaceTextures(5)=Texture'MachinShin.Faces.Face06'
     FaceTextures(6)=Texture'MachinShin.Faces.Face07'
     FaceTextures(7)=Texture'MachinShin.Faces.Face08'
     FaceTextures(8)=Texture'MachinShin.Faces.Face09'
     Style=STY_Translucent
     Texture=Texture'MachinShin.Faces.Face01'
     DrawScale=1.200000
     ScaleGlow=20.000000
     VisibilityRadius=700.000000
     VisibilityHeight=700.000000
     RenderIteratorClass=Class'Legend.DistanceFadeRI'
}
