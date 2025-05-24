//------------------------------------------------------------------------------
// BFRotator02.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	ActorRotator used by Balefire.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class BFRotator02 expands ActorRotator;

defaultproperties
{
    bUpdateActorRotation=False
    bFaceIn=True
    MinRadius=50.00
    MaxRadius=50.00
    MinRotationRate=-100000.00
    MaxRotationRate=-100000.00
    MaxHeight=50.00
    HeightShiftRate=120.00
    bBounceHeight=True
}
