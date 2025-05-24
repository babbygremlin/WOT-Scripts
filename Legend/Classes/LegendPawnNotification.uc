//=============================================================================
// LegendPawnNotification.
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 5 $
//=============================================================================


//=============================================================================
/*
How to use LPNT_ForceStationary and LPNT_UnforceStationary:
Set the NI_NotificationType to LPNT_ForceStationary or LPNT_UnforceStationary.
Leave the NI_NotificationParamsIndex property value at -1.
Don't set anything in the NotificationParams array.

How to use LPNT_GoalModify:

Select an item in the NotificationInfos array.
Set the NI_NotificationType to LPNT_GoalModify.
Set the NI_NotificationParamsIndex to an unused index in the NotificationParams array.
In the associated index in the NotificationParams array set up the following properties.

NP_Float0 must be set to 0, 1, 2, or 3. These values correspond to the
	respective elements of the EGoalModifyType enumeration.
NP_Float1 can be set to and value that makes sense for the EGoalModifyType
	being used.
NP_Name0 can be set to the name of any goal in the legend pawns GoalInfos
	array. These names can be found by looking under the default properties for
	the npc under the group GoalInfo in the GoalInfos array. The current values
	are Threat, ExternalDirective, Refuge, Guarding, Colleague, Intermediate,
	Waiting, CurrentWayPoint, CurrentFocus. It is possible to attempt to use
	any of these name but only Threat has been tested and confirmed to work.
	Use others at your own risk. Also, the ExternalDirective name is only a place
	holder for a globally accessed goal (possibly from a patrol controller) if you
	modify this goal the changes will affect all npcs using that goal. Again this
	is untested so be afraid!

Example: NI_NotificationType == LPNT_GoalModify
		 NI_NotificationParamsIndex == 4
		 NotificationParams[ 4 ].NP_Float0 == 2
		 NotificationParams[ 4 ].NP_Float1 == 5
		 NotificationParams[ 4 ].NP_Float3 (unused)
		 NotificationParams[ 4 ].NP_Name0 == Threat
		 NotificationParams[ 4 ].NP_Name1 (unused)
		 NotificationParams[ 4 ].NP_String0 (unused)
		 
The above will result in the Observing legend pawn's goal with the name of
'threat' having its priority incremented by the value 5.

How to use LPNT_HandleHint: DONT!!! It is still under development!
How to use LPNT_Use: DONT!!! It is still under development!
*/
//=============================================================================

class LegendPawnNotification expands ObservableDirective;

enum ELegendPawnNotificationType
{
	LPNT_None,
	LPNT_ForceStationary,
	LPNT_UnforceStationary,
	LPNT_GoalModify,
	LPNT_HandleHint,
	LPNT_Use,
	LPNT_ForceDormant,
	LPNT_UnForceDormant
};

struct TNotificationInfo
{
	var () ELegendPawnNotificationType NI_NotificationType;
	var () int NI_NotificationParamsIndex;
};

struct TNotificationParams
{
	var () float NP_Float0;
	var () float NP_Float1;
	var () float NP_Float2;
	var () float NP_Float3;
	var () Name NP_Name0;
	var () Name NP_Name1;
	var () string NP_String0;
};

enum EGoalModifyType
{
	GMT_None,
	GMT_PrioritySet,
	GMT_PriorityIncrement,
	GMT_PriorityDecrement,
};

/*
//xxxrlofutre
enum EWotHint
{
	WH_Grunt_SwitchProjectileWeapon,
	WH_Grunt_SwitchMeleeWeapon,
	WH_Grunt_PreferProjectileWeapon,
	WH_Grunt_PreferMeleeWeapon,
	WH_AngrealUser_UseAngreal,
	WH_AngrealUser_UseSpecificAngreal
};
*/

var () private int CurrentNotificationInfoIndex;
var () private TNotificationInfo NotificationInfos[ 32 ];
var () private TNotificationParams NotificationParams[ 32 ];

const InvalidNotificationParamIndex = -1;
const InvalidNotificationInfoIndex = -1;



event bool IsObserverIgnored( Actor Observer, Pawn EventInstigator )
{
	return !Observer.IsA( 'LegendPawn' ); //this directive only applies to legend pawns
}



function MediatorDirectObserver( DirectiveMediator Mediator )
{
	local int MediatorInfoIndex;
	class'Debug'.static.DebugLog( Self, "MediatorDirectObserver Mediator " $ Mediator, 'LegendPawnNotification' );
	if( Mediator.IsA( 'LegendPawnNotificationMediator' ) )
	{
		MediatorInfoIndex = LegendPawnNotificationMediator( Mediator ).LegendPawnNotificationInfoIndex;
		if( ( MediatorInfoIndex >= 0 ) && ( MediatorInfoIndex < ArrayCount( NotificationInfos ) ) )
		{
			CurrentNotificationInfoIndex = MediatorInfoIndex;
			Super.MediatorDirectObserver( Mediator );
		}
	}
}



function DirectObserver( Actor Observer, Pawn EventInstigator )
{
	class'Debug'.static.DebugLog( Self, "DirectObserver Observer "$ Observer, 'LegendPawnNotification' );
	if( GetNotificationInfoIndex() )
	{
		Super.DirectObserver( Observer, EventInstigator );
	}
}



function bool GetNotificationInfoIndex( optional out int NotificationInfoIndex )
{
	local bool bGetNotificationInfoIndex;
	if( ( CurrentNotificationInfoIndex >= 0 ) && ( CurrentNotificationInfoIndex < ArrayCount( NotificationInfos ) ) )
	{
		NotificationInfoIndex = CurrentNotificationInfoIndex;
		bGetNotificationInfoIndex = true;
	}
	return bGetNotificationInfoIndex;
}



function SetNotificationInfoIndex( int NotificationInfoIndex )
{
	CurrentNotificationInfoIndex = NotificationInfoIndex;
}



function bool GetNotificationParamsIndex( out int NotificationParamsIndex )
{
	local int NotificationInfoIndex;
	if( GetNotificationInfoIndex( NotificationInfoIndex ) &&
			( NotificationInfos[ NotificationInfoIndex ].NI_NotificationParamsIndex >= 0 ) &&
			( NotificationInfos[ NotificationInfoIndex ].NI_NotificationParamsIndex < ArrayCount( NotificationInfos ) ) )
	{
		NotificationParamsIndex = NotificationInfos[ NotificationInfoIndex ].NI_NotificationParamsIndex;
		return true;
	}
	return false;
}



function ELegendPawnNotificationType GetNotificationType()
{
	local ELegendPawnNotificationType NotificationType;
	local int NotificationInfoIndex;
	if( GetNotificationInfoIndex( NotificationInfoIndex ) )
	{
		NotificationType = NotificationInfos[ NotificationInfoIndex ].NI_NotificationType;
	}
	return NotificationType;
}



function EGoalModifyType GetGoaModifyType()
{
	local EGoalModifyType GoalModifyType;
	local int NotificationInfoIndex, NotificationParamsIndex;

	if( GetNotificationInfoIndex( NotificationInfoIndex ) &&
		( NotificationInfos[ NotificationInfoIndex ].NI_NotificationType == LPNT_GoalModify ) &&
		GetNotificationParamsIndex( NotificationParamsIndex ) )
	{
		switch( int( NotificationParams[ NotificationParamsIndex ].NP_Float0 ) )
		{
			case 1:
				GoalModifyType = GMT_PrioritySet;
				break;
			case 2:
				GoalModifyType = GMT_PriorityIncrement;
				break;
			case 3:
				GoalModifyType = GMT_PriorityDecrement;
				break;
		}
	}
	return GoalModifyType;
}



function Name GetGoalModifyName()
{
	local Name GoalModifyName;
	local int NotificationInfoIndex, NotificationParamsIndex;
	if( GetNotificationInfoIndex( NotificationInfoIndex ) &&
			( NotificationInfos[ NotificationInfoIndex ].NI_NotificationType == LPNT_GoalModify ) &&
			GetNotificationParamsIndex( NotificationParamsIndex ) )
	{
		GoalModifyName = NotificationParams[ NotificationParamsIndex ].NP_Name0;
	}
	return GoalModifyName;
}



function float GetGoaModifyPriority()
{
	local float GoalModifyPriority;
	local int NotificationInfoIndex, NotificationParamsIndex;
	if( GetNotificationInfoIndex( NotificationInfoIndex ) &&
			( NotificationInfos[ NotificationInfoIndex ].NI_NotificationType == LPNT_GoalModify ) &&
			GetNotificationParamsIndex( NotificationParamsIndex ) )
	{
		GoalModifyPriority = NotificationParams[ NotificationParamsIndex ].NP_Float1;
	}
	return GoalModifyPriority;
}



function Name GetHintName()
{
	local Name HintName;
	local int NotificationInfoIndex, NotificationParamsIndex;
	if( GetNotificationInfoIndex( NotificationInfoIndex ) &&
			( NotificationInfos[ NotificationInfoIndex ].NI_NotificationType == LPNT_HandleHint ) &&
			GetNotificationParamsIndex( NotificationParamsIndex ) )
	{
		HintName = NotificationParams[ NotificationParamsIndex ].NP_Name0;
	}
	return HintName;
}



function class GetWhatToUseClass()
{
	local class WhatToUseClass;
	local int NotificationInfoIndex, NotificationParamsIndex;
	if( GetNotificationInfoIndex( NotificationInfoIndex ) &&
			( NotificationInfos[ NotificationInfoIndex ].NI_NotificationType == LPNT_Use ) &&
			GetNotificationParamsIndex( NotificationParamsIndex ) )
	{
		WhatToUseClass = class<Projectile>( DynamicLoadObject( NotificationParams[ NotificationParamsIndex ].NP_String0, class'Class' ) );
	}
	return WhatToUseClass;
}



function Name GetWhatToUseItOn()
{
	local Name WhatToUseItOn;
	local int NotificationInfoIndex, NotificationParamsIndex;
	if( GetNotificationInfoIndex( NotificationInfoIndex ) &&
			( NotificationInfos[ NotificationInfoIndex ].NI_NotificationType == LPNT_Use ) &&
			GetNotificationParamsIndex( NotificationParamsIndex ) )
	{
		WhatToUseItOn = NotificationParams[ NotificationParamsIndex ].NP_Name0;
	}
	return WhatToUseItOn;
}

defaultproperties
{
     CurrentNotificationInfoIndex=-1
     NotificationInfos(0)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(1)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(2)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(3)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(4)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(5)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(6)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(7)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(8)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(9)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(10)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(11)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(12)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(13)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(14)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(15)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(16)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(17)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(18)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(19)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(20)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(21)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(22)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(23)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(24)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(25)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(26)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(27)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(28)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(29)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(30)=(NI_NotificationParamsIndex=-1)
     NotificationInfos(31)=(NI_NotificationParamsIndex=-1)
}
