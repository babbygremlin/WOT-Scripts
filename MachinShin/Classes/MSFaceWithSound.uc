//------------------------------------------------------------------------------
// MSFaceWithSound.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//
// Description:
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class MSFaceWithSound expands MSFace;

#exec AUDIO IMPORT FILE=Sounds\MachShin03.wav

var() byte MinPitch, MaxPitch;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();

	SoundPitch = RandRange( MinPitch, MaxPitch );
	
	if( FRand() < 0.05 )
		SoundPitch = SoundPitch / 2;
}

defaultproperties
{
     MinPitch=55
     maxPitch=67
     SoundRadius=64
     SoundVolume=250
     AmbientSound=Sound'MachinShin.MachShin03'
}
