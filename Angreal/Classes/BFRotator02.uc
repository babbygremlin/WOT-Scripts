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
     MinRadius=50.000000
     MaxRadius=50.000000
     MinRotationRate=-100000.000000
     MaxRotationRate=-100000.000000
     MaxHeight=50.000000
     HeightShiftRate=120.000000
     bBounceHeight=True
}
