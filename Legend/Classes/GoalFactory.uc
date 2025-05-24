//=============================================================================
// GoalFactory.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 2 $
//=============================================================================

class GoalFactory expands GoalBase;

struct TGoalDescriptor
{
	var () Name 						DescriptorName; 
	var () class<GoalAbstracterInterf> 	GoalAbstracterClass;
};

var () Name GDN_Generic;
var () Name GDN_Location;
var () Name GDN_Actor;
var () Name GDN_Pawn;

var () TGoalDescriptor Descriptors[ 4 ];
const DescriptorCount = 4;



static function bool CreateGoal( out GoalAbstracterInterf CreatedGoal,
		Object GoalOuter,
		Name DescriptorName,
		optional class<GoalAbstracterInterf> RequiredGoalClass )
{
	local int DescriptorIndex;
	local bool bCreated;
	local class<GoalAbstracterInterf> NewGoalClass;
	
	class'Debug'.static.DebugLog( GoalOuter, "CreateGoal", default.DebugCategoryName );
	if( ( DescriptorName != '' ) &&
			GetDescriptorIndex( DescriptorIndex, DescriptorName ) &&
			( default.Descriptors[ DescriptorIndex ].GoalAbstracterClass != None ) )
	{
		class'Debug'.static.DebugLog( GoalOuter, "CreateGoal DescriptorName " $ DescriptorName, default.DebugCategoryName );
		class'Debug'.static.DebugLog( GoalOuter, "CreateGoal DescriptorIndex " $ DescriptorIndex, default.DebugCategoryName );
		
		//goal descripter has a type defined in it
		if( RequiredGoalClass == None )
		{
			NewGoalClass = default.Descriptors[ DescriptorIndex ].GoalAbstracterClass;
		}
		else if( ClassIsChildOf( RequiredGoalClass, default.Descriptors[ DescriptorIndex ].GoalAbstracterClass ) )
		{
			//the required goal type is ultimatly derived from the descripter defined type
			NewGoalClass = RequiredGoalClass;
		}
				
		if( NewGoalClass != None )
		{
			class'Debug'.static.DebugLog( GoalOuter, "CreateGoal GoalAbstracterClass " $ NewGoalClass, default.DebugCategoryName );
			CreatedGoal = New( GoalOuter )NewGoalClass;
			bCreated = CreatedGoal != None;
			if( bCreated )
			{
				class'Debug'.static.DebugLog( GoalOuter, "CreateGoal DescriptorIndex " $ DescriptorIndex, default.DebugCategoryName );
				if( ( DescriptorName == default.GDN_Pawn ) && ClassIsChildOf( CreatedGoal.class, class'GoalAbstracterImpl' ) )
				{
					GoalAbstracterImpl( CreatedGoal ).bPawnsMustBeAlive = true;
				}
			}
		}
	}
	class'Debug'.static.DebugLog( GoalOuter, "CreateGoal CreatedGoal " $ CreatedGoal, default.DebugCategoryName );
	class'Debug'.static.DebugLog( GoalOuter, "CreateGoal returning " $ bCreated, default.DebugCategoryName );
	return bCreated;
}


static function bool GetDescriptorIndex( out int DescriptorIndex, Name DescriptorName )
{
	for( DescriptorIndex = 0; DescriptorIndex < DescriptorCount; DescriptorIndex++ )
	{
		if( default.Descriptors[ DescriptorIndex ].DescriptorName == DescriptorName )
		{
			return true;
		}
	}
}



static function InitGoal( GoalAbstracterInterf Goal,
		Object OuterObject,
		float GoalPriority,
		float GoalPriorityDistance,
		float GoalPriorityDistanceUsage,
		float GoalSuggestedSpeed )
{
	class'Debug'.static.DebugLog( OuterObject, "InitGoal GoalPriority " $ GoalPriority, default.DebugCategoryName );
	class'Debug'.static.DebugLog( OuterObject, "InitGoal GoalPriorityDistance " $ GoalPriorityDistance, default.DebugCategoryName );
	class'Debug'.static.DebugLog( OuterObject, "InitGoal GoalPriorityDistanceUsage " $ GoalPriorityDistanceUsage, default.DebugCategoryName );
	class'Debug'.static.DebugLog( OuterObject, "InitGoal GoalSuggestedSpeed " $ GoalSuggestedSpeed, default.DebugCategoryName );

	if( GoalPriority != Goal.Priority_Unused )
	{
		Goal.SetGoalPriority( OuterObject, GoalPriority );
	}

	if( GoalPriorityDistance != Goal.PriorityDistance_Unused )
	{
		if( GoalPriorityDistanceUsage == Goal.PriorityDistanceUsage_ZeroIfGreater )
		{
			Goal.SetGoalPriorityDistance( OuterObject, GPDU_ZeroIfGreater, GoalPriorityDistance );
		}
		else if( GoalPriorityDistanceUsage == Goal.PriorityDistanceUsage_ZeroIfLess )
		{
			Goal.SetGoalPriorityDistance( OuterObject, GPDU_ZeroIfLess, GoalPriorityDistance );
		}
		else
		{
			Goal.SetGoalPriorityDistance( OuterObject, GPDU_Unused );
		}
	}
/*
	else if( GoalPriorityDistanceUsage == Goal.PriorityDistanceUsage_Unused )
	{
		Goal.SetGoalPriorityDistance( OuterObject, GPDU_Unused );
	}
*/
	if( GoalSuggestedSpeed != Goal.SuggestedSpeed_Unused )
	{
		Goal.SetSuggestedSpeed( OuterObject, GoalSuggestedSpeed );
	}
}

defaultproperties
{
     GDN_Generic=GoalDescriptorName_Generic
     GDN_Location=GoalDescriptorName_Location
     GDN_Actor=GoalDescriptorName_Actor
     GDN_Pawn=GoalDescriptorName_Pawn
     Descriptors(0)=(DescriptorName=GoalDescriptorName_Generic,GoalAbstracterClass=Class'Legend.ContextSensitiveGoal')
     Descriptors(1)=(DescriptorName=GoalDescriptorName_Location,GoalAbstracterClass=Class'Legend.ContextSensitiveGoal')
     Descriptors(2)=(DescriptorName=GoalDescriptorName_Actor,GoalAbstracterClass=Class'Legend.ContextSensitiveGoal')
     Descriptors(3)=(DescriptorName=GoalDescriptorName_Pawn,GoalAbstracterClass=Class'Legend.ContextSensitiveGoal')
     DebugCategoryName=GoalFactory
}
