//=============================================================================
// ItemCollector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 6 $
//=============================================================================

class ItemCollector expands Collection native;


enum EIterationType
{
	IT_RadiusActors,
	IT_AllActors
};

enum ETraceInfo
{
	TRACE_Untested,
	TRACE_Unobstruced,
//rlofuture TRACE_ActorObstruced,
	TRACE_GeometryObstruced
};

enum ERequirement
{
	R_Irrelevant,
	R_Prefer,
	R_Require
};

struct TItemRequirement
{
	var () Vector IR_Origin;
	var () float IR_MaxDeltaAltitude;
	//xxxrlofuture var () ERequirement IR_MaxDeltaAltitudeReq;
	var () float IR_MaxDistance;
	var () ERequirement IR_MaxDistanceReq;
	var () float IR_MinDistance;
	var () ERequirement IR_MinDistanceReq;
	var () ETraceInfo IR_TraceInfo;
	var () ERequirement IR_TraceInfoReq;
};

struct TItemInfo
{
	var Actor II_Item;
	var float II_Distance; //the distance from the collection origin to the associated item
	var ETraceInfo II_TraceInfo;
	var byte II_bAccepted;
};

var Actor CollectionSurrogate;
var class<Actor> CollectedActorClass;
var EIterationType IterationType;
var float CollectionRadius;
var () bool bRejectSurrogate;
var () TItemRequirement CollectionReq; //requirement that determines if an item is accepted or rejected during the collection process

var const int CollectedItemCount;
var private TItemInfo ItemInfos[ 32 ];



native function CollectAllItems( Actor CollectingActor, class<Actor> CollectedActorClass );
native function CollectRadiusItems( Actor CollectingActor, class<Actor> CollectedActorClass, float CollectionRadius );
native function Actor GetItem( int ItemIdx );
native function float GetItemDistance( int ItemIdx );
native function ETraceInfo GetItemTraceInfo( int ItemIdx );
native function bool IsItemAccepted( int ItemIdx );
native function RejectItem( int ItemIdx );
native function InitCollector();
native function CollectItems();
native event bool CollectItem( Actor Item, int ItemIndex );


function DebugLog( Object Invoker )
{
	local int ItemIdx;
	while( ItemIdx < CollectedItemCount )
	{
		class'Debug'.static.DebugLog( Invoker , "DebugLog ItemIdx: " $ ItemIdx, DebugCategoryName );
		class'Debug'.static.DebugLog( Invoker , "DebugLog Item: " $ GetItem( ItemIdx ), DebugCategoryName );
		class'Debug'.static.DebugLog( Invoker , "DebugLog Item-Distance: " $ GetItemDistance( ItemIdx ), DebugCategoryName );
		class'Debug'.static.DebugLog( Invoker , "DebugLog Item-TraceInfo: " $ GetItemTraceInfo( ItemIdx ), DebugCategoryName );
		class'Debug'.static.DebugLog( Invoker , "DebugLog Item-bAccepted: " $ IsItemAccepted( ItemIdx ), DebugCategoryName );
		ItemIdx++;
	}
}		

defaultproperties
{
     bRejectSurrogate=True
     CollectionReq=(IR_MaxDeltaAltitude=320.000000)
     DebugCategoryName=ItemCollector
}
