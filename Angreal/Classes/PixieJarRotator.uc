//------------------------------------------------------------------------------
// PixieJarRotator.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class PixieJarRotator expands ActorRotator;

defaultproperties
{
     bUpdateActorRotation=False
     MinRadius=-20.000000
     MaxRadius=20.000000
     RadiusShiftRate=5.000000
     MinRotationRate=-40000.000000
     MaxRotationRate=40000.000000
     RotationShiftRate=5000.000000
     MaxHeight=16.000000
     MinHeight=-16.000000
     HeightShiftRate=10.000000
     Physics=PHYS_Rotating
     RemoteRole=ROLE_None
     bFixedRotationDir=True
     RotationRate=(Pitch=8000,Yaw=6000,Roll=10000)
}
