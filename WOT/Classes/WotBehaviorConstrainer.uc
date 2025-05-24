//=============================================================================
// WotBehaviorConstrainer.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

class WotBehaviorConstrainer expands BehaviorConstrainer;

var() float SearchBiasMinDist; //Searching always picks best path if current goal is this far away, or closer
var() float SearchBiasMaxDist; //Searching never picks best path (except randomly) if current goal is this far away, or farther



function float GetCurrentMaxFindHelpDistance( Actor ConstrainedActor )
{
	local Captain ConstrainedCaptain;
	local float MaxFinHelpDistance;
	
	ConstrainedCaptain = Captain( ConstrainedActor );
	
	if(	ConstrainedCaptain!= none )
	{
		MaxFinHelpDistance = ConstrainedCaptain.FindHelpRadius;
	}
	return MaxFinHelpDistance;
}

defaultproperties
{
     SearchBiasMinDist=480.000000
     SearchBiasMaxDist=1440.000000
}
