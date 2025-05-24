//------------------------------------------------------------------------------
// ReturnToSenderReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 11 $
//
// Description:	When a HitByAngreal notification comes in, this reflector
//				will cast a projectile of the same type back at the originator.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class ReturnToSenderReflector expands Reflector;

//var() float CollisionRadiusScale;	// How much bigger should our collision radius be than our owner's?
//var() float CollisionHeightScale;	// How much bigger should our collision height be than our owner's?
var() string SoundReflectName;		// Sound to play when reflecting

var vector OwnerLocation;

var() name UnAffectedTypes[9];		// Types of projectiles we are not allowed to affect.

var bool bHandled;

var GenericProjectile NewProjectile;

replication
{
	unreliable if( Role==ROLE_Authority /*&& Owner!=None && !Owner.bNetRelevant*/ )	// Fix ARL: Remove extra checks when Tim fixes the replication code.
		OwnerLocation;
}

////////////////
// Interfaces //
////////////////

//------------------------------------------------------------------------------
simulated function OnReflectedTouch( GenericProjectile HitProjectile )
{
	if( !IsAffectable( HitProjectile ) )
	{
		return;
	}

	bHandled = true;

	SpawnImpactEffect( HitProjectile.Location );

	// Reflect the direction.
	AdjustVelocity( HitProjectile );

	if( HitProjectile != None )
	{
		HitProjectile.SetLocation( HitProjectile.Location );	// This sets bJustTeleported to True which keeps the physics code from trashing our new velocity.

		if( Role == ROLE_Authority )
		{	
			ServerOnReflectedTouch( HitProjectile );

			// If this seeking projectile was after me, tell it to seek the originator.	
			// Note: If the Instigator is dead, the seeking projectile won't try to find it.
			if
			(	SeekingProjectile(HitProjectile) != None 
			&&	SeekingProjectile(HitProjectile).bSeeking
			&&	SeekingProjectile(HitProjectile).Destination == Owner
			)
			{
				SeekingProjectile(HitProjectile).SetDestination( HitProjectile.SourcePawn );
			}

			// Fix its Instigator since we're shooting it, not the angreal's owner.
			HitProjectile.Instigator = Pawn(Owner);
		}

		HitProjectile.SourcePawn = Pawn(Owner);

		// Note: Still using same SourceAngreal even though Instigator is different.
		
		// Adjust IgnoredPawn.
		if( !HitProjectile.bHurtsOwner )
		{
			HitProjectile.SetIgnoredPawn( Pawn(Owner) );
		}
	}
}
function ServerOnReflectedTouch( GenericProjectile HitProjectile )
{
	if( Owner != None )
	{
		Owner.PlaySound( Sound( DynamicLoadObject( SoundReflectName, class'Sound' ) ) );
	}
}

//------------------------------------------------------------------------------
simulated function bool IsAffectable( Actor Other )
{
	local int i;

	for( i = 0; i < ArrayCount(UnAffectedTypes); i++ )
	{
		if( UnAffectedTypes[i] != '' )
		{
			if( Other.IsA( UnAffectedTypes[i] ) )
			{
				return false;
			}
		}
	}

	return true;
}

//------------------------------------------------------------------------------
function SpawnImpactEffect( vector AimLoc )
{
	local ReflectSkinEffect Effect;

	Effect = Spawn( class'ReflectSkinEffect', Owner,, Owner.Location, Owner.Rotation); 
	Effect.Mesh = Owner.Mesh;
	Effect.DrawScale = Owner.DrawScale;
	if( WOTPlayer(Owner) != None )
	{
		Effect.SetColor( WOTPlayer(Owner).PlayerColor );
	}
	else
	{
		Effect.SetColor( 'Green' );
	}

/* -- OLD
	local DeflectSprayer Shell;
	local vector Offset;

	Offset = vect(1,0,0) * FMax( Owner.CollisionRadius, Owner.CollisionHeight );

	// Spawn cool effect.
	Shell = Spawn( class'DeflectSprayer',,, Owner.Location + (Offset >> rotator(AimLoc - Owner.Location)) );
	if( WOTPlayer(Owner) != None )
	{
		Shell.SetColor( WOTPlayer(Owner).PlayerColor );
	}
	else
	{
		Shell.SetColor( 'White' );
	}
	Shell.Follow( Owner );
*/
}

function DoAdjustVelocity( GenericProjectile InProjectile, GenericProjectile OutProjectile )
{
	OutProjectile.Velocity = VSize(InProjectile.Velocity) * vector(InProjectile.CalculateTrajectory( Owner, InProjectile.Instigator ));
}

//------------------------------------------------------------------------------
// Aim back at the instigator.
//
// Override to change behavior of reflected velocity.
//------------------------------------------------------------------------------
simulated function AdjustVelocity( out GenericProjectile HitProjectile )
{
	// Cannot use because Instigator is None on the client-side.
	//HitProjectile.Velocity = VSize(HitProjectile.Velocity) * Normal(HitProjectile.Instigator.Location - HitProjectile.Location);

	if
	(	(HitProjectile != None && HitProjectile.Instigator == None)
	||	(SeekingProjectile(HitProjectile) != None && SeekingProjectile(HitProjectile).bSeeking)
	)
	{
		HitProjectile.Velocity = -HitProjectile.Velocity;
		HitProjectile.bAbortProcessTouch = true;
	}
	else
	{
		if( Role == ROLE_Authority )
		{
			NewProjectile = Spawn( HitProjectile.Class, HitProjectile.Owner, HitProjectile.Tag, HitProjectile.Location, HitProjectile.Rotation );
			NewProjectile.SetSourceAngreal( HitProjectile.SourceAngreal );
			DoAdjustVelocity( HitProjectile, NewProjectile );
		}

		HitProjectile.bExplode = false;
		HitProjectile.bAbortProcessTouch = true;
		HitProjectile.Destroy();
		HitProjectile = NewProjectile;
	}
}

//////////////////////
// Worker functions //
//////////////////////

//------------------------------------------------------------------------------
simulated function NotifyHitByAngrealProjectile( AngrealProjectile HitProjectile )
{
	if( HitProjectile == NewProjectile )
	{
		NewProjectile.bAbortProcessTouch = true;
		return;		// We're not done with it yet.
	}

	bHandled = false;

	// Essentially, reflect all GenericProjectiles unless it is suppose to ignore our owner.
	// Only reflect SeekingProjectiles that are actually after us.

	if( GenericProjectile(HitProjectile) != None && GenericProjectile(HitProjectile).IgnoredPawn != Owner )
	{
		// If it is a seeking projectile that is after us, reflect it.
		if( SeekingProjectile(HitProjectile) != None && SeekingProjectile(HitProjectile).bSeeking )
		{
			if( SeekingProjectile(HitProjectile).bSeeking && SeekingProjectile(HitProjectile).Destination == Owner )
			{
				OnReflectedTouch( GenericProjectile(HitProjectile) );
			}
		}
		else
		{
			OnReflectedTouch( GenericProjectile(HitProjectile) );
		}
	}

	if( !bHandled )
	{
		Super.NotifyHitByAngrealProjectile( HitProjectile );
	}
	
	if( NewProjectile != None )
	{
		NewProjectile.bAbortProcessTouch = false;	// NOTE[aleiby]: Is this needed?  Is it bad or benign?
		NewProjectile = None;
	}
}

/*
//------------------------------------------------------------------------------
function Install( Pawn NewHost )
{
	Super.Install( NewHost );

	if( Owner != None )
	{
		SetCollisionSize( Owner.CollisionRadius * CollisionRadiusScale, Owner.CollisionHeight * CollisionHeightScale );
		SetCollision( default.bCollideActors, default.bBlockActors, default.bBlockPlayers );
		OwnerLocation = Owner.Location;
		SetLocation( OwnerLocation );
	}
}

function UnInstall()
{
	Super.Uninstall();
	SetCollision( false, false, false );
}

//------------------------------------------------------------------------------
singular simulated function Touch( Actor Other )
{
	// Essentially, reflect all GenericProjectiles unless it is suppose to ignore our owner.
	// Only reflect SeekingProjectiles that are actually after us.

	if( GenericProjectile(Other) != None && GenericProjectile(Other).IgnoredPawn != Owner )
	{
		// If it is a seeking projectile that is after us, reflect it.
		if( SeekingProjectile(Other) != None && SeekingProjectile(Other).bSeeking )
		{
			if( SeekingProjectile(Other).bSeeking && SeekingProjectile(Other).Destination == Owner )
			{
				OnReflectedTouch( GenericProjectile(Other) );
			}
		}
		else
		{
			OnReflectedTouch( GenericProjectile(Other) );
		}
	}
}
*/

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	Super.Tick( DeltaTime );

	// Server: Send updates to clients as needed.
	// Client: Store for when we need it.
	if( Owner != None )
	{
		OwnerLocation = Owner.Location;
	}

//	SetLocation( OwnerLocation );
}

defaultproperties
{
    SoundReflectName="WOT.Effect.Reflected"
    UnAffectedTypes(0)=MashadarGuide
    UnAffectedTypes(1)=MachinShin
    UnAffectedTypes(2)=AMAPearl
    UnAffectedTypes(3)=AngrealAMAProjectile
    UnAffectedTypes(4)=AngrealDistantEyeProjectile
    UnAffectedTypes(5)=AngrealExpWardProjectile
    UnAffectedTypes(6)=AngrealTracerProjectile
    UnAffectedTypes(7)=AngrealWallOfAirProjectile
    UnAffectedTypes(8)=EarthTremorRock
    Priority=160
    bRemoveExisting=True
    RemoteRole=2
}
