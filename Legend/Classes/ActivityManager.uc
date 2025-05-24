// ActivityManager.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class ActivityManager expands RegisterableDirective native;

//if the legend pawn must be able to be seen by a relevant pawn
enum EVisibilityRequirement
{
	VR_None,
	VR_LineOfSight,
	VR_CanSee
};

enum EDistanceRequirement
{
	DR_None,
	DR_LessOrEqual,
	DR_Greater
};

enum EEvaluationOrder
{
	EO_Distance,
	EO_Visibility
};

enum EEvaluationRequirement
{
	ER_All,
	ER_Any
};

var () EEvaluationOrder			EvaluationOrder;			//determines which test is done first
var () EEvaluationRequirement	EvaluationRequirement;		//

var () EVisibilityRequirement	VisibilityRequirement;		//
//rlofuture var () EDistanceRequirement	VisibilityRequirement_DistanceRequirement;
//rlofuture var () float 				VisibilityRequirement_Distance;
//rlofuture var () float 				VisibilityRequirement_DeltaAltitude;

var () EDistanceRequirement		DistanceRequirement;				//
var () float					DistanceRequirement_Distance;		//the distance between a relevant player and the pawn that must be satisfied by the distance requirement
var () float					DistanceRequirement_DeltaAltitude;	//the change in altitude between a relevant player and the pawn that must be satisfied by the distance requirement


//the current relevant player and the current registered pawn
var bool						bExcludeNonZonePlayers;		//a player is not relevant if it is not in the same zone as the pawn
var Pawn 						RelevantPlayers[ 16 ];
var int							NotifiedActivePawns;
var int							NotifiedInactivePawns;

var () const editconst Name		ForceActiveNotification;
var () const editconst Name		ForceInactiveNotification;



function OnObservationNotification( Notifier Notification )
{
	class'Debug'.static.DebugLog( Self, "OnObservationNotification", 'ActivityManager' );
	FindRelevantPlayers();
	Super.OnObservationNotification( Notification );
}



native function DirectObservers( Pawn EventInstigator );



function DirectObserver( Actor Observer, Pawn EventInstigator )
{
	local int RelevantPlayerIter;
	local float PlayerDistance;
	local Name ActivityNotification;

	for( RelevantPlayerIter = 0; RelevantPlayerIter < ArrayCount( RelevantPlayers ); RelevantPlayerIter++ )
	{
		if( RelevantPlayers[ RelevantPlayerIter ] != None )
		{
			DetermineActivityNotification( ActivityNotification, Observer, RelevantPlayers[ RelevantPlayerIter ] );
			if( ActivityNotification == ForceActiveNotification )
			{
				//if any player dictates that this pawn should be do not bother check anyone else
				break;
			}
		}
	}
/*
//xxxrlo wacky wacky wacky
	if( ActivityNotification == '' )
	{
		DetermineActivityNotification( ActivityNotification, Observer, RelevantPlayers[ RelevantPlayerIter ] );
	}
*/	
	if( ActivityNotification == ForceActiveNotification )
	{
		NotifiedActivePawns++;
	}
	else
	{
		NotifiedInactivePawns++;
	}
	Notification = ActivityNotification;
	class'Debug'.static.DebugLog( Self, "DirectObserver ActivityNotification " $ ActivityNotification, 'ActivityManager' );
	if( Observer.IsA( 'LegendPawn' ) )
	{
		//xxxrlo hack for performanace reasons
		LegendPawn( Observer ).OnActivityManagerNotification( Self );
	}
	else
	{
		Super.DirectObserver( Observer, EventInstigator );
	}
}



native function FindRelevantPlayers();



native function DetermineActivityNotification( out Name ActivityNotification, Actor RegisteredActor, Pawn RelevantPlayer );

defaultproperties
{
     EvaluationRequirement=ER_Any
     VisibilityRequirement=VR_LineOfSight
     DistanceRequirement=DR_LessOrEqual
     DistanceRequirement_Distance=2500.000000
     DistanceRequirement_DeltaAltitude=2500.000000
     ForceActiveNotification=ForceActiveNotification
     ForceInactiveNotification=ForceInactiveNotification
     bDurationDirective=True
     ObservationMonitorDuration=1.000000
}
