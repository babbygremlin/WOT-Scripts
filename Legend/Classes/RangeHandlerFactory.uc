//=============================================================================
// RangeHandlerFactory.
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 5 $
//=============================================================================

class RangeHandlerFactory expands RangeHandler abstract;

struct THandlerCreateParams
{
	var () bool					bEnabled;
	var () class<RangeHandler>	HandlerClass;
	var () THandlerTemplate		HandlerTemplate;
	var () bool 				bCompositeHandler;
	var () int 					ComponentCount;
	var () int 					FirstComponentIndex;
};

var () private THandlerCreateParams HandlerCreateParams[ 65 ]; //TransitionerCount * HandlerCount
var () private THandlerCreateParams ComponentHandlerCreateParams[ 10 ];

const TransitionerCount = 13;
const HandlerCount = 5;



static function RangeHandler CreateRangeHandler( Object OuterObject,
		class<RangeHandler> HandlerClass,
		Name HandlerAssociatedState,
		Name HandlerAssociatedStateLabel,
		class<WaypointSelectorInterf> HandlerWptSelectorClass,
		class<FocusSelectorInterf> HandlerFcsSelectorClass,
		EObjectIntersectRequirement HandlerObjIntersectReq,
		class<MovementPattern> HandlerMovementPatternClass,
		float FixedRadiusExtension,
		float FixedHeightExtension,
		bool bReentrantRange,
		float RangeMaxDuration,
		float RangeMinEntryInterval )
{
	local RangeHandler NewHandler;
	
	NewHandler = New( OuterObject )HandlerClass;
	NewHandler.SetAssociatedStateInfo( HandlerAssociatedState, HandlerAssociatedStateLabel );
	NewHandler.SetSelectorClasses( HandlerWptSelectorClass, HandlerFcsSelectorClass );
	NewHandler.SetEntryConstraints( bReentrantRange, RangeMaxDuration, RangeMinEntryInterval );
	NewHandler.Template.HT_ObjIntersectReq = HandlerObjIntersectReq;
	if( HandlerMovementPatternClass != None )
	{
		NewHandler.Template.HT_MovementPatternClass = HandlerMovementPatternClass;
		NewHandler.MovementPattern = new( NewHandler )NewHandler.Template.HT_MovementPatternClass;
	}
	
	return NewHandler;
}



static function bool CreateHandler( out RangeHandler NewHandler, Object OuterObject, int TransitionerIndex, int HandlerIndex )
{
	local int HandlerCreateParamIndex;

	HandlerCreateParamIndex = TransitionerIndex * HandlerCount + HandlerIndex;
	//Log( OuterObject $ "CreateHandler TransitionerIndex: " $ TransitionerIndex $ " HandlerIndex: " $ HandlerIndex );
	//Log( OuterObject $ "CreateHandler HandlerCreateParamIndex: " $ HandlerCreateParamIndex );
	return CreateHandlerFromTemplate( NewHandler, OuterObject, default.HandlerCreateParams[ HandlerCreateParamIndex ] );
}



static function bool CreateHandlerFromTemplate( out RangeHandler NewHandler, Object OuterObject, THandlerCreateParams HandlerCreateParams )
{
	local RangeHandler ComponentHandler;
	local int HandlerCreateParamIndex, ComponentIndex, LastComponentIndex;
		
	if( HandlerCreateParams.bEnabled )
	{
		NewHandler = New( OuterObject )HandlerCreateParams.HandlerClass;
		NewHandler.Template.HT_Name = HandlerCreateParams.HandlerTemplate.HT_Name;
		NewHandler.Template.HT_PreHint = HandlerCreateParams.HandlerTemplate.HT_PreHint;
		NewHandler.Template.HT_PostHint = HandlerCreateParams.HandlerTemplate.HT_PostHint;
		NewHandler.SetAssociatedStateInfo( HandlerCreateParams.HandlerTemplate.HT_AssociatedState, HandlerCreateParams.HandlerTemplate.HT_AssociatedLabel );
		NewHandler.SetSelectorClasses( HandlerCreateParams.HandlerTemplate.HT_SelectorClassWpt, HandlerCreateParams.HandlerTemplate.HT_SelectorClassFcs );
		NewHandler.Template.HT_ObjIntersectReq = HandlerCreateParams.HandlerTemplate.HT_ObjIntersectReq;
		NewHandler.Template.HT_bDurationConstrained = HandlerCreateParams.HandlerTemplate.HT_bDurationConstrained;
		NewHandler.SetEntryConstraints( HandlerCreateParams.HandlerTemplate.HT_bReentrant, HandlerCreateParams.HandlerTemplate.HT_MaxDuration, HandlerCreateParams.HandlerTemplate.HT_MinEntryInterval );
		NewHandler.Template.HT_bRequireValidGoal = HandlerCreateParams.HandlerTemplate.HT_bRequireValidGoal;
		
		if( HandlerCreateParams.HandlerTemplate.HT_MovementPatternClass != None )
		{
			NewHandler.Template.HT_MovementPatternClass = HandlerCreateParams.HandlerTemplate.HT_MovementPatternClass;
			NewHandler.MovementPattern = new( NewHandler )NewHandler.Template.HT_MovementPatternClass;
		}
		
		if( HandlerCreateParams.bCompositeHandler )
		{
			LastComponentIndex = HandlerCreateParams.FirstComponentIndex + HandlerCreateParams.ComponentCount;
			for( ComponentIndex = HandlerCreateParams.FirstComponentIndex; ComponentIndex <= LastComponentIndex; ComponentIndex++ )
			{
				if( CreateHandlerFromTemplate( ComponentHandler, NewHandler, default.ComponentHandlerCreateParams[ ComponentIndex ] ) )
				{
					NewHandler.BindHandler( ComponentHandler );
				}
			}
		}
		else if( ( NewHandler.Template.HT_SelectorClassWpt == None ) ||
				( NewHandler.Template.HT_SelectorClassFcs == None ) ||
				( NewHandler.Template.HT_AssociatedState == '' ) )
		{
			Warn( OuterObject $ "::" $ NewHandler.Template.HT_Name $ "::HT_SelectorClassWpt == None" );
			Warn( OuterObject $ "::" $ NewHandler.Template.HT_Name $ "::HT_SelectorClassFcs == None" );
			Warn( OuterObject $ "::" $ NewHandler.Template.HT_Name $ "::HT_AssociatedState == ''" );
			Assert( false );
		}
		
		NewHandler.DebugLog( OuterObject );
	}
	return HandlerCreateParams.bEnabled;
}

defaultproperties
{
     HandlerCreateParams(0)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reached,HT_Priority=50.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(1)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reachable,HT_Priority=40.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(2)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Visible,HT_Priority=30.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(3)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Pathable,HT_Priority=20.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(4)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_UnNavigable,HT_Priority=10.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(5)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reached,HT_Priority=50.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(6)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reachable,HT_Priority=40.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(7)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Visible,HT_Priority=30.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(8)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Pathable,HT_Priority=20.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(9)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_UnNavigable,HT_Priority=10.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(10)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reached,HT_Priority=50.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(11)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reachable,HT_Priority=40.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(12)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Visible,HT_Priority=30.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(13)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Pathable,HT_Priority=20.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(14)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_UnNavigable,HT_Priority=10.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(15)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reached,HT_Priority=50.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(16)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reachable,HT_Priority=40.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(17)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Visible,HT_Priority=30.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(18)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Pathable,HT_Priority=20.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(19)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_UnNavigable,HT_Priority=10.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(20)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reached,HT_Priority=50.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(21)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reachable,HT_Priority=40.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(22)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Visible,HT_Priority=30.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(23)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Pathable,HT_Priority=20.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(24)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_UnNavigable,HT_Priority=10.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(25)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reached,HT_Priority=50.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(26)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reachable,HT_Priority=40.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(27)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Visible,HT_Priority=30.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(28)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Pathable,HT_Priority=20.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(29)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_UnNavigable,HT_Priority=10.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(30)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reached,HT_Priority=50.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(31)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reachable,HT_Priority=40.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(32)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Visible,HT_Priority=30.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(33)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Pathable,HT_Priority=20.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(34)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_UnNavigable,HT_Priority=10.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(35)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reached,HT_Priority=50.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(36)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reachable,HT_Priority=40.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(37)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Visible,HT_Priority=30.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(38)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Pathable,HT_Priority=20.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(39)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_UnNavigable,HT_Priority=10.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(40)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reached,HT_Priority=50.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(41)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reachable,HT_Priority=40.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(42)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Visible,HT_Priority=30.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(43)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Pathable,HT_Priority=20.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(44)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_UnNavigable,HT_Priority=10.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(45)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reached,HT_Priority=50.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(46)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reachable,HT_Priority=40.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(47)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Visible,HT_Priority=30.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(48)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Pathable,HT_Priority=20.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(49)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_UnNavigable,HT_Priority=10.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(50)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reached,HT_Priority=50.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(51)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reachable,HT_Priority=40.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(52)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Visible,HT_Priority=30.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(53)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Pathable,HT_Priority=20.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(54)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_UnNavigable,HT_Priority=10.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(55)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reached,HT_Priority=50.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(56)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reachable,HT_Priority=40.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(57)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Visible,HT_Priority=30.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(58)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Pathable,HT_Priority=20.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(59)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_UnNavigable,HT_Priority=10.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(60)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reached,HT_Priority=50.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(61)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Reachable,HT_Priority=40.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(62)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Visible,HT_Priority=30.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(63)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_Pathable,HT_Priority=20.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     HandlerCreateParams(64)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_Name=GP_UnNavigable,HT_Priority=10.000000,HT_bReentrant=True,HT_bRequireValidGoal=True))
     ComponentHandlerCreateParams(0)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_bReentrant=True,HT_bRequireValidGoal=True))
     ComponentHandlerCreateParams(1)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_bReentrant=True,HT_bRequireValidGoal=True))
     ComponentHandlerCreateParams(2)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_bReentrant=True,HT_bRequireValidGoal=True))
     ComponentHandlerCreateParams(3)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_bReentrant=True,HT_bRequireValidGoal=True))
     ComponentHandlerCreateParams(4)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_bReentrant=True,HT_bRequireValidGoal=True))
     ComponentHandlerCreateParams(5)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_bReentrant=True,HT_bRequireValidGoal=True))
     ComponentHandlerCreateParams(6)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_bReentrant=True,HT_bRequireValidGoal=True))
     ComponentHandlerCreateParams(7)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_bReentrant=True,HT_bRequireValidGoal=True))
     ComponentHandlerCreateParams(8)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_bReentrant=True,HT_bRequireValidGoal=True))
     ComponentHandlerCreateParams(9)=(HandlerClass=Class'Legend.RangeHandler',HandlerTemplate=(HT_bReentrant=True,HT_bRequireValidGoal=True))
}
