//------------------------------------------------------------------------------
// MSInnerRotator.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//
// Description:
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class MSInnerRotator expands MSRotator;

#exec AUDIO IMPORT FILE=Sounds\MS001.wav
#exec AUDIO IMPORT FILE=Sounds\MS002.wav
#exec AUDIO IMPORT FILE=Sounds\MS003.wav
#exec AUDIO IMPORT FILE=Sounds\MS004.wav
#exec AUDIO IMPORT FILE=Sounds\MS005.wav
#exec AUDIO IMPORT FILE=Sounds\MS006.wav

var() Sound FaceSounds[6];

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	local int i;
	local MSFaceWithSound Face;
	
	Super.PreBeginPlay();

	for( i = 0; i < ArrayCount(FaceSounds); i++ )
	{
		Face = Spawn( class'MSFaceWithSound', Self, Event, Location );
		Face.AmbientSound = FaceSounds[i];
		SoundPitch = 64;
	}
}

defaultproperties
{
     FaceSounds(0)=Sound'MachinShin.MS001'
     FaceSounds(1)=Sound'MachinShin.MS002'
     FaceSounds(2)=Sound'MachinShin.MS003'
     FaceSounds(3)=Sound'MachinShin.MS004'
     FaceSounds(4)=Sound'MachinShin.MS005'
     FaceSounds(5)=Sound'MachinShin.MS006'
     bUpdateActorRotation=False
     MinRadius=200.000000
     MaxRadius=1000.000000
     RadiusShiftRate=50.000000
     MinRotationRate=-10000.000000
     MaxRotationRate=10000.000000
     RotationShiftRate=2000.000000
     MaxHeight=500.000000
     MinHeight=-500.000000
     HeightShiftRate=50.000000
     Event=MSInnerFaces
}
