//=============================================================================
// RangeHandlerFactoryMyrddraal.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//=============================================================================

class RangeHandlerFactoryMyrddraal expands RangeHandlerFactoryCaptain;

defaultproperties
{
     HandlerCreateParams(21)=(HandlerTemplate=(HT_MovementPatternClass=Class'WOTPawns.MovementPatternMyrddraal0'))
     HandlerCreateParams(23)=(HandlerTemplate=(HT_MovementPatternClass=Class'Legend.MovementPatternNavigating'))
     ComponentHandlerCreateParams(1)=(HandlerTemplate=(HT_MovementPatternClass=Class'WOTPawns.MovementPatternMyrddraal1'))
}
