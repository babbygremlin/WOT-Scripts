//------------------------------------------------------------------------------
// MSFillerRotator.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//
// Description:
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class MSFillerRotator expands MSRotator;

var() int NumFaces;

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	local int i;
	
	Super.PreBeginPlay();

	for( i = 0; i < NumFaces; i++ )
		Spawn( class'MSFace', Self, Event, Location );
}

defaultproperties
{
     NumFaces=288
     bUpdateActorRotation=False
     MinRadius=-1500.000000
     MaxRadius=1500.000000
     RadiusShiftRate=50.000000
     MinRotationRate=-8000.000000
     MaxRotationRate=8000.000000
     RotationShiftRate=1000.000000
     MaxHeight=700.000000
     MinHeight=-700.000000
     HeightShiftRate=50.000000
     Event=MSFillerFaces
}
