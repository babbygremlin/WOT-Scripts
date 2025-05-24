//=============================================================================
// WotThrowableWeapon.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

class WotThrowableWeapon expands WotWeapon;



function FireProjectile( Actor FiringActor, Vector ProjectileSource, Rotator ProjectileDirection )
{
	local Weapon RemovedWeapon;
	local Pawn FiringPawn;
	local WotProjectile SpawnedProjectile;

	FiringPawn = Pawn( FiringActor );
	if( FiringPawn != None )
	{
		RemovedWeapon = class'Util'.static.RemoveInventoryWeapon( FiringPawn, Self.Class );
		class'Debug'.static.DebugAssert( Self, ( RemovedWeapon == Self ), "FireProjectile ( RemovedWeapon == Self )", DebugCategoryName );
		RemovedWeapon.SetOwner( FiringPawn );
	}

    SpawnedProjectile = Spawn( WotWeaponProjectileType, Self, /*tag*/, ProjectileSource, ProjectileDirection );

	// make sure projectile inherits skin, style from "thrown" weapon
	SpawnedProjectile.Skin	= Skin;
	SpawnedProjectile.Style = Style;
}



function OnWotProjectileDestroyed( WotProjectile DestroyedWotProjectile )
{
	local Pawn OwnerPawn;
	
	if( DestroyedWotProjectile.Owner == Self )
	{
		//the destroyed projectile is owned by this weapon
		OwnerPawn = Pawn( Owner );
		if( ( OwnerPawn != None ) && ( OwnerPawn.AddInventory( Self ) ) )
		{
			//the owner of this weapon is a pawn and this weapon was
			//successfully added back into its inventory
   			Self.WeaponSet( OwnerPawn );
   		}
		else
		{
			class'Debug'.static.DebugWarn( Self, "OnWotProjectileDestroyed error adding rangedweaponholder to inventory!!!", DebugCategoryName );
		}
	}
}

defaultproperties
{
}
