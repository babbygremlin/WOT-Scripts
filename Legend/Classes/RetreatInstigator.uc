//=============================================================================
// RetreatInstigator.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

//A retreat instigator is a logical extension of a goal abstracter. The purpose
//of the class is to provide new set of functions that are invoked by the
//existing goal abstracter interface. Specifically, GetGoalActor is implemented
//as a call to GetRetreatInstigator. This allows the client of a retreat
//instigator to use the new functions provided by retreat instigator without
//knowing that it is a retreat instigator. As far as the client is concerned the
//object is just some concrete instance of a class derived from
//GoalAbstracterInterf. Yahoo, I just gave a basic description of polymorphism.
//When deriving from this class the functions of particular concern are
//GetRetreatInstigator and GetRetreatInstigatorParams.

class RetreatInstigator expands ContextSensitiveGoal;

const DefaultThreatInfluence = 1; //1 ~= 100 percent



function bool GetGoalActor( Object InvokingObject, out Actor CurrentGoalActor )
{
	//Log( Self $ "::RetreatInstigator::GetGoalActor" );
	return GetRetreatInstigator( InvokingObject, CurrentGoalActor );
}



function bool GetRetreatInstigator( Object InvokingObject, out Actor InstigatingActor )
{
	//Log( Self $ "::RetreatInstigator::GetRetreatInstigator" );
	return Super.GetGoalActor( InvokingObject, InstigatingActor );
}



//GetRetreatInstigatorParams is intended to provide the client with the location
//and the extents of the retreat instigator. The meaning of the location of the
//retreat instigator is straightforward. The meaning the extents of the retreat
//instigator is intended to provide the client with the range of which the retreat
//instigator may have influence over potential retreating clients.
function bool GetRetreatInstigatorParams( Object InvokingObject,
		out Vector InstigatorLocation,
		out Vector InstigatorExtents )
{
	//Log( Self $ "::RetreatInstigator::GetRetreatInstigatorParams" );
	//return Super.GetGoalActorParams( InstigatorLocation, InstigatorExtents );
}



function bool GetRetreatInstigatorLocation( Object InvokingObject, out Vector InstigatorLocation )
{
	local Vector InstigatorExtents;
	//Log( Self $ "::RetreatInstigator::GetRetreatInstigatorLocation" );
	return GetRetreatInstigatorParams( InvokingObject, InstigatorLocation, InstigatorExtents );
}



function bool GetRetreatInstigatorExtents( Object InvokingObject, out Vector InstigatorExtents )
{
	local Vector InstigatorLocation;
	return GetRetreatInstigatorParams( InvokingObject, InstigatorLocation, InstigatorExtents );
}



//GetThreatInfluence is intended to provide the client with an evaluation of the
//influence that the retreat instigator has over the given actor. The returned number
//is intended to be a percentage. A return value of zero would imply that the retreat
//instigator has no influence over potential retreating clients and a return value of
//one would imply that the retreat instigator has full influence over potential
//retreating clients.
function float GetThreatInfluence( Object InvokingObject )
{
	//Log( Self $ "::RetreatInstigator::GetThreatInfluence returning " $ DefaultThreatInfluence );
	return DefaultThreatInfluence;
}

defaultproperties
{
}
