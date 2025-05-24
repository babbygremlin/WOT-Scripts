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
    MinRadius=-20.00
    MaxRadius=20.00
    RadiusShiftRate=5.00
    MinRotationRate=-40000.00
    MaxRotationRate=40000.00
    RotationShiftRate=5000.00
    MaxHeight=16.00
    MinHeight=-16.00
    HeightShiftRate=10.00
    Physics=5
    RemoteRole=0
    bFixedRotationDir=True
    RotationRate=(Pitch=8000,Yaw=6000,Roll=10000),
}
