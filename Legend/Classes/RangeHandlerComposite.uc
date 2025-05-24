//=============================================================================
// RangeHandlerComposite.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================

class RangeHandlerComposite expands RangeHandler;

var RangeHandler Handlers[ 4 ];
var (RangeHandler) editconst int HandlerIdx;
const InvalidHandlerIdx = -1;



function Destructed()
{
	local int Idx;
	
	for( Idx = 0; Idx < ArrayCount( Handlers ); Idx++ )
	{
		if( Handlers[ Idx ] != none )
		{
			Handlers[ Idx ].Delete();
			Handlers[ Idx ] = None;
		}
	}
	Super.Destructed();
}



function BindHandler( RangeHandler NewHandler )
{
	local RangeHandler SelectedHandler;
	local int HandlerIter;
	local bool bPreviouslyBound;
	
	//see if this range handler is already bound
	for( HandlerIter = 0;
			( ( HandlerIter < ArrayCount( Handlers ) ) && !bPreviouslyBound );
			HandlerIter++ )
	{
		if( ( Handlers[ HandlerIter ] != none ) &&
				( Handlers[ HandlerIter ] == NewHandler ) )
		{
			bPreviouslyBound = true;
		}
	}
	
	//try to find an empty slot for the new range handler
	if( !bPreviouslyBound )
	{
		for( HandlerIter = 0; HandlerIter < ArrayCount( Handlers ); HandlerIter++ )
		{
			if( Handlers[ HandlerIter ] == none )
			{
				Handlers[ HandlerIter ] = NewHandler;
				break;
			}
		}
	}
}



function RangeHandler GetHandler()
{
	local RangeHandler ReturnHandler;
	if( HandlerIdx != InvalidHandlerIdx )
	{
		ReturnHandler = Handlers[ HandlerIdx ];
	}
	class'Debug'.static.DebugLog( Self, "GetHandler ReturnHandler: " $ ReturnHandler, DebugCategoryName );
	return ReturnHandler;
}



function SetSelectorClasses( Class<WaypointSelectorInterf> RangeWptSelectorClass,
		Class<FocusSelectorInterf> RangeFcsSelectorClass )
{
	if( HandlerIdx != InvalidHandlerIdx )
	{
		Handlers[ HandlerIdx ].SetSelectorClasses( RangeWptSelectorClass, RangeFcsSelectorClass );
	}
}



function SetEntryConstraints( bool bReentrantRange,
		optional float RangeMaxDuration,
		optional float RangeMinEntryInterval )
{
	if( HandlerIdx != InvalidHandlerIdx )
	{
		Handlers[ HandlerIdx ].SetEntryConstraints( bReentrantRange, RangeMaxDuration, RangeMinEntryInterval );
	}
}



function SetAssociatedStateInfo( optional Name StateName, optional Name StateNameLabel )
{
	if( HandlerIdx != InvalidHandlerIdx )
	{
		Handlers[ HandlerIdx ].SetAssociatedStateInfo( StateName, StateNameLabel );
	}
}




function GetDynamicCylinderExtension( out float RadiusExtension,
		out float HeightExtension,
		Actor RangeActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	if( HandlerIdx != InvalidHandlerIdx )
	{
		Handlers[ HandlerIdx ].GetDynamicCylinderExtension( RadiusExtension, HeightExtension, RangeActor, Constrainer, Goal );
	}
}



function bool TransitionToAssociatedState( Actor TransitioningActor )
{
	local bool bTransitioned;
	if( HandlerIdx != InvalidHandlerIdx )
	{
		bTransitioned = Handlers[ HandlerIdx ].TransitionToAssociatedState( TransitioningActor );
	}
	return bTransitioned;
}



function bool IsInRange( Actor RangeActor,
		BehaviorConstrainer Constrainer ,
		GoalAbstracterInterf Goal )
{
	local bool bInRange;
	if( HandlerIdx != InvalidHandlerIdx )
	{
		bInRange = Handlers[ HandlerIdx ].IsInRange( RangeActor, Constrainer, Goal );
	}
	return bInRange;
}



function bool IsValidAsNextRange( Actor RangeActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	local int HandlerIter;
	
	class'Debug'.static.DebugLog( RangeActor, "IsValidAsNextRange", DebugCategoryName );
	HandlerIdx = InvalidHandlerIdx;
	for( HandlerIter = 0; HandlerIter < ArrayCount( Handlers ); HandlerIter++ )
	{
		class'Debug'.static.DebugLog( RangeActor, "IsValidAsNextRange CurrentHandler: " $ Handlers[ HandlerIter ], DebugCategoryName );
		if( ( Handlers[ HandlerIter ] != none ) &&
				Handlers[ HandlerIter ].IsValidAsNextRange( RangeActor, Constrainer, Goal ) )
		{
			HandlerIdx = HandlerIter;
			break;
		}
	}
	class'Debug'.static.DebugLog( RangeActor, "IsValidAsNextRange HandlerIdx: " $ HandlerIdx, DebugCategoryName );
	class'Debug'.static.DebugLog( RangeActor, "IsValidAsNextRange returning " $ ( HandlerIdx != InvalidHandlerIdx ), DebugCategoryName );
	return ( HandlerIdx != InvalidHandlerIdx );
}



function bool CanActorEnterRange( Actor EnteringActor )
{
	local bool bCanEnterRange;
	if( HandlerIdx != InvalidHandlerIdx )
	{
		bCanEnterRange = Handlers[ HandlerIdx ].CanActorEnterRange( EnteringActor );
	}
	return bCanEnterRange;
}



function ResetRangeEntryTime( Actor TransitioningActor )
{
	if( HandlerIdx != InvalidHandlerIdx )
	{
		Handlers[ HandlerIdx ].ResetRangeEntryTime( TransitioningActor );
	}
}



function DebugLog( Object InvokingObject )
{
	if( HandlerIdx != InvalidHandlerIdx )
	{
		Handlers[ HandlerIdx ].DebugLog( InvokingObject );
	}
}

defaultproperties
{
     HandlerIdx=-1
     DebugCategoryName=RangeHandlerComposite
}
