//=============================================================================
// RangeHandlerSniping.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

class RangeHandlerSniping expands RangeHandlerVisible;


function bool IsInRange( Actor RangeActor,
		BehaviorConstrainer Constrainer,
		GoalAbstracterInterf Goal )
{
	local bool bInRange;
	local Grunt Sniper;
	local WotWeapon ProjectileWeapon;

	class'Debug'.static.DebugLog( RangeActor, "RangeHandlerSniping::IsInRange", DebugCategoryName );
	Sniper = Grunt( RangeActor );
	if( Sniper != none )
	{
		ProjectileWeapon = WotWeapon( class'Util'.static.GetInventoryWeapon( Sniper, Sniper.RangedWeaponType ) );
		class'Debug'.static.DebugLog( RangeActor, "RangeHandlerSniping::IsInRange ProjectileWeapon " $ ProjectileWeapon, DebugCategoryName );
		if( ProjectileWeapon != None )
		{
			//the sniper has a projectile weapon
/*
			if( Sniper.Weapon == ProjectileWeapon )
			{
				//the sniper's current weapon is the projectile weapon
			}
			else
			{
				//the sniper's current weapon is not the projectile weapon
				Template.HT_MinEntryInterval = default.Template.HT_MinEntryInterval;
			}
*/			
			ProjectileWeapon.DetermineWeaponUsage( Sniper, Goal );
			if( ProjectileWeapon.GetWeaponUsage() == WU_Projectile )
			{
				class'Debug'.static.DebugLog( RangeActor, "RangeHandlerSniping::IsInRange WU_Projectile", DebugCategoryName );
				bInRange = Super.IsInRange( RangeActor, Constrainer, Goal );
			}
		}
	}
	class'Debug'.static.DebugLog( RangeActor, "RangeHandlerSniping::IsInRange returning " $ bInRange, DebugCategoryName );
	return bInRange;
}

defaultproperties
{
     DebugCategoryName=RangeHandlerSniping
}
