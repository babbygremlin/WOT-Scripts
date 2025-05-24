//=============================================================================
// WaypointSelectorRetreat.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 4 $
//=============================================================================

class WaypointSelectorRetreat expands WaypointSelector;



static function bool GetRawMovementDestination( GoalAbstracterInterf RawWaypoint,
		Actor RetreatingActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	local RetreatInstigator Instigator;
	local Vector RetreatVector;	
	//Log( "::WaypointSelectorRetreat::GetRawMovementDestination" );
	Instigator = RetreatInstigator( Goal );	
	if( Instigator != none )
	{
		//move away from the retreat instigator
		if( GetRetreatVector( RetreatingActor, RetreatVector, Instigator, Constrainer,
				Instigator.GetThreatInfluence( RetreatingActor ) ) )
		{
			RawWaypoint.AssignVector( RetreatingActor, RetreatingActor.Location - RetreatVector );
		}
	}
	return true;
}



static function bool GetRetreatVector( Actor RetreatingActor,
		out Vector RetreatVector,
		RetreatInstigator Instigator,
		BehaviorConstrainer Constrainer,
		optional float ThreatInfluence )
{
	local Vector RetreatOrigin, RetreatExtents, Difference;
	local float CurrentDistance;
	local float BackAwayDistance;
	local bool bShouldRetreat;
	
	//Log( "::WaypointSelectorRetreat::GetRetreatVector" );
	if( Instigator.GetRetreatInstigatorParams( RetreatingActor, RetreatOrigin, RetreatExtents ) )
	{
		RetreatExtents *= ThreatInfluence;
		
		Difference = RetreatOrigin - RetreatingActor.Location;
		Difference.Z = 0;
		CurrentDistance = VSize( RetreatOrigin - RetreatingActor.Location );
		
		if( CurrentDistance < RetreatExtents.x )
		{
			//the instigator is within the retreat radius
			BackAwayDistance = RetreatExtents.x - CurrentDistance;
			
			//xxx use Constrainer.BoundDestinationDistance
			if( BackAwayDistance < Constrainer.GetCurrentMinTravelDistance( RetreatingActor ) + 1 )
			{
				BackAwayDistance = Constrainer.GetCurrentMinTravelDistance( RetreatingActor ) + 1;
			}
			
			RetreatVector = Normal( Difference ) * BackAwayDistance;
			bShouldRetreat = true;
		}
	}
	return bShouldRetreat;
}

defaultproperties
{
}
