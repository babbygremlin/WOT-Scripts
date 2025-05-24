//=============================================================================
// ExternalDirective.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class ExternalDirective expands ObservableDirective abstract;

enum ENotificationAcknowledgment
{
	NA_Accept,
	NA_Refuse
};

var () private class<ExternalDirectiveGoal> DirectiveGoalClass;
var () private float DirectiveGoalPriority;
var () private float DirectiveGoalPriorityDistance;
var () private float DirectiveGoalPriorityDistanceUsage;
var () private float DirectiveGoalSuggestedSpeed;
var () const editconst Name AssumeDirectiveEvent;
var () const editconst Name UnAssumeDirectiveEvent;
var ExternalDirectiveGoal DirectiveGoal;



static function ENotificationAcknowledgment NotificationAcknowledgment(
		ENotificationAcknowledgment NotificationAcknowledgment )
{
	return NotificationAcknowledgment;
}



function PostBeginPlay()
{
	class'Debug'.static.DebugLog( Self, "PostBeginPlay", DebugCategoryName );
	Super.PostBeginPlay();
	CreateDirectiveGoal( DirectiveGoal, Self );
}



function Trigger( Actor Other, Pawn EventInstigator )
{
	class'Debug'.static.DebugLog( Self, "Trigger", DebugCategoryName );
	if( DirectiveGoal != None ) 
	{
		Super.Trigger( Other, EventInstigator );
	}
}



function bool CreateDirectiveGoal( out ExternalDirectiveGoal CreatedDirectiveGoal,
		Actor DirectiveOuter )
{
	local GoalAbstracterInterf CreatedGoal;
	local bool bSuccess;
	
	class'Debug'.static.DebugLog( Self, "CreateDirectiveGoal DirectiveGoalClass " $ DirectiveGoalClass, DebugCategoryName );
	if( ( DirectiveGoalClass != None ) && ( class'GoalFactory'.static.CreateGoal( CreatedGoal, Self,
				class'GoalFactory'.default.GDN_Actor, DirectiveGoalClass ) ) )
	{
		CreatedGoal.AssignObject( Self, Self );
		class'GoalFactory'.static.InitGoal( CreatedGoal, Self, DirectiveGoalPriority, DirectiveGoalPriorityDistance,
				DirectiveGoalPriorityDistanceUsage, DirectiveGoalSuggestedSpeed );
		CreatedDirectiveGoal = ExternalDirectiveGoal( CreatedGoal );
		bSuccess = ( CreatedDirectiveGoal != None );
		class'Debug'.static.DebugLog( Self, "CreateDirectiveGoal CreatedDirectiveGoal: " $ CreatedDirectiveGoal, DebugCategoryName );
	}
	return bSuccess;
}



function Destroyed()
{
	if( DirectiveGoal != None )
	{
		DirectiveGoal.Delete();
		DirectiveGoal = None;
	}
	Super.Destroyed();
}



function AcknowledgeNotification( Actor InvokingActor, out GoalAbstracterInterf PawnDirectiveGoal,
		ENotificationAcknowledgment Acknowledgment )
{
	class'Debug'.static.DebugLog( Self, "AcknowledgeNotification Acknowledgment: " $ Acknowledgment, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "AcknowledgeNotification PawnDirectiveGoal: " $ PawnDirectiveGoal, DebugCategoryName );
	class'Debug'.static.DebugLog( Self, "AcknowledgeNotification AcknowledgingPawn: " $ InvokingActor, DebugCategoryName );
	switch( Acknowledgment )
	{
		case NA_Accept:
			class'Debug'.static.DebugLog( Self, "AcknowledgeNotification DirectiveGoal: " $ DirectiveGoal, DebugCategoryName );
			PawnDirectiveGoal = DirectiveGoal;
			break;
		case NA_Refuse:
			break;
	}
}



static function bool RelinquishDirective( Actor InvokingActor, out GoalAbstracterInterf PawnDirectiveGoal )
{
	PawnDirectiveGoal = None;
}



function DirectObserver( Actor Observer, Pawn EventInstigator )
{
	Notification = AssumeDirectiveEvent;
	Super.DirectObserver( Observer, EventInstigator );
}

defaultproperties
{
     DirectiveGoalClass=Class'Legend.ExternalDirectiveGoal'
     DirectiveGoalPriorityDistance=-1.000000
     DirectiveGoalPriorityDistanceUsage=-1.000000
     DirectiveGoalSuggestedSpeed=-1.000000
     AssumeDirectiveEvent=AssumeDirectiveEvent
     UnAssumeDirectiveEvent=UnAssumeDirectiveEvent
     DebugCategoryName=ExternalDirective
}
