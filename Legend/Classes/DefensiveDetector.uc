//=============================================================================
// DefensiveDetector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 9 $
//=============================================================================

class DefensiveDetector expands DurationNotifier native;

var() float	CollectionRadius;
var() class<Actor> CollectClass;

var () bool bRestrictCollectionToFOV;
var bool bRejectResponded;
var () class<Actor> ExplicitClassRejections[ 4 ];
var () bool bActiveDetection; //If set to true the defensive detector will poll for offending actors that are within the collection radius
var () bool bPassiveDetection; //If set to true the defensive detector will notify the outer of actors that compromise the defensive perimeter
var () float DefensivePerimeterRadiusFactor;
var () float DefensivePerimeterHeightFactor;

enum EOffenderRejectionInfo
{
	ORI_NotRejected,
	ORI_RespondedRejected,
	ORI_ExplicitClassRejected,
	ORI_FovRejected,
	ORI_NotMovingTowardRejected,
	ORI_ResponseTimeRejected,
	ORI_OtherRejection
};

struct TDefensiveResponse
{
	var() float DR_MinResponseTime;
	var() float	DR_MaxResponseTime;
	var() Name DR_ResponsePreHint;
	var() Name DR_ResponsePostHint;
};

var () private TDefensiveResponse DefensiveResponses[ 4 ];

var private ItemSorter OffendingSorter;
var private Actor ClosestOffender;
var private EOffenderRejectionInfo ClosestOffenderRejectionInfo;

var private Actor LastRespondedTo;
//xxxrlofuture var private Actor EarliestArrivingOffender;
//xxxrlofuture function Actor GetEarliestArrivingOffender() { return EarliestArrivingOffender }

var () const editconst Name OffendingNotification;
var () const editconst Name NoOffendingNotification;



function SubjectDestroyed( Object Subject )
{
	if( ClosestOffender == Subject )
	{
		ClosestOffender = None;
	}
	if( LastRespondedTo == Subject )
	{
		LastRespondedTo = None;
	}
	Super.SubjectDestroyed( Subject );
}



function Destructed()
{
	if( OffendingSorter != None )
	{
		OffendingSorter.Delete();
		OffendingSorter = None;
	}
	if( ClosestOffender != None )
	{
		ClosestOffender.DetachDestroyObserver( Self );
		ClosestOffender = None;
	}
	if( LastRespondedTo != None )
	{
		LastRespondedTo.DetachDestroyObserver( Self );
		LastRespondedTo = None;
	}
	Super.Destructed();
}



function Actor GetOffender()
{
	return ClosestOffender;
}



function EOffenderRejectionInfo GetOffenderRejectionInfo()
{
	return ClosestOffenderRejectionInfo;
}



function GetResponseHints( Actor RespondingTo, out Name ResponsePreHint, out Name ResponsePostHint )
{
	ResponsePreHint = DefensiveResponses[ 0 ].DR_ResponsePreHint;
	ResponsePostHint = DefensiveResponses[ 0 ].DR_ResponsePostHint;
}



static function Notifier CreateNotifier( Actor NotifierOuter, optional Name NotifierCallbackFunctionName)
{
	local Notifier CreatedNotifier;
	CreatedNotifier = Super.CreateNotifier( NotifierOuter, NotifierCallbackFunctionName );
	DefensiveDetector( CreatedNotifier ).ThisNotifierProxy.SetCollisionSize( NotifierOuter.CollisionRadius *
				DefensiveDetector( CreatedNotifier ).DefensivePerimeterRadiusFactor, NotifierOuter.CollisionHeight *
				DefensiveDetector( CreatedNotifier ).DefensivePerimeterHeightFactor );
	return CreatedNotifier;
}




event EnableNotifier()
{
	EnableDefensivePerimiter();
	Super.EnableNotifier();
}



event DisableNotifier()
{
	DisableDefensivePerimiter();
	Super.DisableNotifier();
}



function EnableDefensivePerimiter()
{
	if( bPassiveDetection )
	{
		Assert( ThisNotifierProxy != None );
		Assert( ClassIsChildOf( NotifierProxyClass, class'DefensivePerimeter' ) );
		ThisNotifierProxy.SetCollision( ThisNotifierProxy.default.bCollideActors, ThisNotifierProxy.default.bBlockActors, ThisNotifierProxy.bBlockPlayers );
	}
}



function DisableDefensivePerimiter()
{
	if( bPassiveDetection )
	{
		Assert( ThisNotifierProxy != None );
		Assert( ClassIsChildOf( NotifierProxyClass, class'DefensivePerimeter' ) );
		ThisNotifierProxy.SetCollision( false, false, false );
	}
}



function Constructed()
{
	Super.Constructed();
	OffendingSorter = new( Self )class'ItemSorter';
}



function RespondedToActor( Actor RespondedTo, optional bool bRecollect )
{
	if( LastRespondedTo != None )
	{
		LastRespondedTo.DetachDestroyObserver( Self );
		LastRespondedTo = None;
	}
	if( ( RespondedTo != None ) && RespondedTo.AttachDestroyObserver( Self ) )
	{
		LastRespondedTo = RespondedTo;
	}
	bRejectResponded = !bRecollect;
}



function OnPerimeterCompromised( Actor Offender )
{
	if( bEnabled && bPassiveDetection && ( Offender != None ) && Offender.IsA( CollectClass.Name ) )
	{
		if( Offender.AttachDestroyObserver( Self ) )
		{
			if( ClosestOffender != None )
			{
				ClosestOffender.DetachDestroyObserver( Self );
				ClosestOffender = None;
			}
			ClosestOffender = Offender;
			ClosestOffenderRejectionInfo = RejectOffender( Actor( Outer ), Offender );
			Notification = OffendingNotification;
			Notify( Outer );
		}
	}
}



function bool IsOffenderRejected( Actor Inquirer, Actor OffendingActor )
{
	return ( RejectOffender( Inquirer, OffendingActor ) != ORI_NotRejected );
}



native function bool CheckForOffending( Actor Inquirer, out Actor Offender, out EOffenderRejectionInfo OffenderRejectionInfo );

native event EOffenderRejectionInfo RejectOffender( Actor Inquirer, Actor OffendingActor );

native function bool GetArrivalTime( Actor OffendingActor, Actor Inquirer, out float EstimatedTimeToCollision );

/*
enum EIncomingType
{
	IT_None,
	IT_Seeker,
	IT_NonSeeker,
};

var() bool bDetectSeekers;		//true if class should handle seekers
var() bool bDetectNonSeekers;	//true if class should handle non-seekers

function EIncomingType GetIncomingType( Projectile CurrentIncomingProjectile )
{
	local SeekingProjectile IncomingSeekingProjectile;
	local EIncomingType CurrentIncomingType;
	local Actor HitActor;
	local vector HitLocation, HitNormal, TraceExtents;
	
	IncomingSeekingProjectile = SeekingProjectile( CurrentIncomingProjectile );
	if( IncomingSeekingProjectile != None )
	{
		class'Debug'.static.DebugLog( Self, "CheckForOffendingProjectile Checking seeker" );
		if( bDetectSeekers && IncomingSeekingProjectile.Destination == Owner )
		{
			//seeker after owner
			class'Debug'.static.DebugLog( Self, "CheckForOffendingProjectile Checking seeker seeking me" );
			CurrentIncomingType = IT_Seeker;
		}
	}
	else if( bDetectNonSeekers )
	{
		class'Debug'.static.DebugLog( Self, "CheckForOffendingProjectile Checking seeker Checking Non-seeker" );
		TraceExtents.x = CurrentIncomingProjectile.CollisionRadius;
		TraceExtents.y = CurrentIncomingProjectile.CollisionRadius;
		TraceExtents.z = CurrentIncomingProjectile.CollisionHeight;
		HitActor = CurrentIncomingProjectile.Trace( HitLocation, HitNormal, 
				CurrentIncomingProjectile.Location + IncomingSearchRadius *
				Normal( vector( CurrentIncomingProjectile.Rotation ) ),
				CurrentIncomingProjectile.Location, true, TraceExtents );
		if( HitActor == Owner )
		{
			CurrentIncomingType = IT_NonSeeker;
		}
	}
	return CurrentIncomingType;
}
*/

defaultproperties
{
     CollectionRadius=1024.000000
     CollectClass=Class'Engine.Projectile'
     ExplicitClassRejections(0)=Class'Engine.Fragment'
     DefensivePerimeterRadiusFactor=1.500000
     DefensivePerimeterHeightFactor=1.500000
     OffendingNotification=IncomingActor
     NoOffendingNotification=NoIncomingActors
     NotifierProxyClass=Class'Legend.DefensivePerimeter'
     DebugCategoryName=DefensiveDetector
}
