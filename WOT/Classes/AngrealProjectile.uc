//------------------------------------------------------------------------------
// AngrealProjectile.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 9 $
//
// Description:	AngrealProjectiles serve a twofold purpose.  First, they are 
//				the visual/audio cues that inform the player that they are 
//				effecting or being effected by another pawn in the game.  Of 
//				all the artifact-related classes, these are the most visable 
//				to the end user.  Second, they enable an angreal artifact to 
//				effect a pawn other than its owner.  With few exceptions (like 
//				Balefire), an offensive angreal artifact will spawn a 
//				projectile and allow the projectile to effect other pawns.  
//				AngrealProjectiles will therefore be primarily concerned with 
//				creating visual/audio feedback for the player, and creating and 
//				installing invokable effects in other pawns.
//------------------------------------------------------------------------------
// How to use this class:
// 
// + Just create the projectile using Spawn with the appropriate parameters, 
//   set its SourceAngreal and be on your way.  AngrealProjectiles are 
//   responsible for taking care of the rest.  All other interfaces are defined 
//   by the engine and projectile base class - like Explode().
//
//------------------------------------------------------------------------------
class AngrealProjectile expands WotProjectile
	abstract;

#exec AUDIO IMPORT FILE=Sounds\Notification\Reflected.wav		GROUP=Effect

// The sound played when this projectile is reflected.
var() string ReflectedSoundName;

// The angreal responsible for my creation. - may be none by the time I explode.
var AngrealInventory SourceAngreal;	 

// Essentially our Instigator... stored seperately for replication purposes.
var Pawn SourcePawn; 
									
// The type of angreal that created me.
var class<AngrealInventory> SourceAngrealClass;	

// If bGenProjTouch == True, we generate ProjTouch() and ProjUnTouch() notifications.  
// This is good for up to MAX_PROJ_TOUCHING simultaneously Actors touching us.
// Touch() and UnTouch() are only reliable for up to four simultaneously touching Actors.
// NOTE: These notifications will only use spherical collision as defined by CollisionRadius.
// NOTE: Touching criteria does not take the other actor's collision cylinder into account, 
// instead is uses the other actor's CollisionRadius to create a collision sphere around
// the other actor and uses that to approximate collision.
const MAX_PROJ_TOUCHING = 256;
var(Collision) bool bGenProjTouch;
var(Collision) float ProjTouchTime;			// How often we check to see if we are touching anything.
var(Collision) float ProjCollisionRadius;	// Use instead of collision radius.
var(Collision) name TouchableTypes[8];		// The types of Actors that we care about touching.
var(Collision) bool bTouchPawnsOnly;		// Check for touching pawns.		(Optimization)
var(Collision) bool bTouchProjectilesOnly;	// Check for touching projectiles.	(Optimization)
var(Collision) bool bTouchPawnsAndProjectilesOnly;	// Check both.				(Optimization)
var float ProjTouchTimer;
var Actor ProjTouching[256];	// Fix Tim Sweeney: Allow defining array sizes with constants.

replication
{
	reliable if( Role==ROLE_Authority )
		SourceAngreal, SourcePawn,
		ProjTouchTime, ProjCollisionRadius;
}

//#if 1 //NEW -- Mark, make sure this matches up with Epic's Touch function 
// in Engine\Projectile.uc minus the BlockAll part.
//------------------------------------------------------------------------------
simulated singular function Touch(Actor Other)
{
	local actor HitActor;
	local vector HitLocation, HitNormal, TestLocation;
	
//#if 0 //NEW -- Level Designers want to be able to fire through BlockAlls.
//	if ( Other.IsA('BlockAll') )
//	{
//		HitWall( Normal(Location - Other.Location), Other);
//		return;
//	}
//#endif
	if ( Other.bProjTarget || (Other.bBlockActors && Other.bBlockPlayers) )
	{
		//get exact hitlocation
	 	HitActor = Trace(HitLocation, HitNormal, Location, OldLocation, true);
		if (HitActor == Other)
		{
			if ( Other.bIsPawn 
				&& !Pawn(Other).AdjustHitLocation(HitLocation, Velocity) )
					return;
			ProcessTouch(Other, HitLocation); 
		}
		else 
			ProcessTouch(Other, Other.Location + Other.CollisionRadius * Normal(Location - Other.Location));
	}
}
//#endif

//------------------------------------------------------------------------------
// This function must be called when an AngrealProjectile is created.
//------------------------------------------------------------------------------
function SetSourceAngreal( AngrealInventory Source )
{
	SourceAngreal = Source;

	if( SourceAngreal != None )
	{
		Instigator = Pawn(SourceAngreal.Owner);
		SourcePawn = Instigator;
	}
}

//------------------------------------------------------------------------------
// Notification that the projectile has been reflected.  
// This is where you take care of playing a reflected sound, explosion,
// or whatever.
//------------------------------------------------------------------------------
function Reflected()
{
	// NOTE[aleiby]: Override in subclasses and add assets - graphics, sounds, etc.
	
	if( ReflectedSoundName != "" )
	{
		PlaySound( Sound( DynamicLoadObject( ReflectedSoundName, class'Sound' ) ) );
	}
}

//------------------------------------------------------------------------------
simulated function ProjTouch( Actor Other );

//------------------------------------------------------------------------------
simulated function ProjUnTouch( Actor Other );

//------------------------------------------------------------------------------
simulated function Tick( float DeltaTime )
{
	local Actor IterA;
	local Actor LastTouching[256];
	local int i, j;
	local float CRad;

	// Make sure these always match up.
	SourcePawn = Instigator;

	if( bGenProjTouch )
	{
		// Only do this occationally.
		ProjTouchTimer -= DeltaTime;
		if( ProjTouchTimer < 0 )
		{
			ProjTouchTimer = ProjTouchTime;

			// Store actors that were touching us last time.
			for( i = 0; i < MAX_PROJ_TOUCHING; i++ )
			{
				LastTouching[i] = ProjTouching[i];	// Copy old element.
				ProjTouching[i] = None;				// Clean up old array.
			}

			i = 0;

			// Get current list of touching actors.
			if( bTouchPawnsOnly || bTouchPawnsAndProjectilesOnly )
			{
				for( IterA = Level.PawnList; IterA != None; IterA = Pawn(IterA).NextPawn )
				{
					CRad = IterA.CollisionRadius;

					if( VSize(IterA.Location - Location) - CRad < ProjCollisionRadius )
					{
						assert( i < MAX_PROJ_TOUCHING );	// Must increase array size.
						ProjTouching[i++] = IterA;
					}
				}
			}
			if( bTouchProjectilesOnly || bTouchPawnsAndProjectilesOnly )
			{
				for( IterA = Level.ProjectileList; IterA != None; IterA = Projectile(IterA).NextProjectile )
				{
					if( IterA != Self )		// Don't touch yourself.
					{
						CRad = IterA.CollisionRadius;

						if( VSize(IterA.Location - Location) - CRad < ProjCollisionRadius )
						{
							assert( i < MAX_PROJ_TOUCHING );	// Must increase array size.
							ProjTouching[i++] = IterA;
						}
					}
				}
			}
			if( !bTouchPawnsOnly && !bTouchProjectilesOnly && !bTouchPawnsAndProjectilesOnly )
			{
				foreach AllActors( class'Actor', IterA )
				{
					if( IsTouchable( IterA ) )
					{
						// Don't touch yourself AND
						// Only touch colliding actors AND
						// See if our CollisionSpheres intersect.
						if( AngrealProjectile(IterA) != None && AngrealProjectile(IterA).bGenProjTouch )
						{
							CRad = AngrealProjectile(IterA).ProjCollisionRadius;
						}
						else
						{
							CRad = IterA.CollisionRadius;
						}
						if( IterA != Self && IterA.bCollideActors && VSize(IterA.Location - Location) - CRad < ProjCollisionRadius )
						{
							assert( i < MAX_PROJ_TOUCHING );	// Must increase array size.
							ProjTouching[i++] = IterA;
						}
					}
				}
			}

			// Check differences.
			// NOTE[aleiby]: Is there a better (more efficient) way of doing this?
			for( i = 0; i < MAX_PROJ_TOUCHING; i++ )
			{
				if( ProjTouching[i] != None )
				{
					for( j = 0; j < MAX_PROJ_TOUCHING; j++ )
					{
						if( ProjTouching[i] == LastTouching[j] )
						{
							break;
						}
					}

					if( j == MAX_PROJ_TOUCHING )	// ProjTouching[i] is not in LastTouching.
					{
						ProjTouch( ProjTouching[i] );
					}
				}
			}
			for( i = 0; i < MAX_PROJ_TOUCHING; i++ )
			{
				if( LastTouching[i] != None )
				{
					for( j = 0; j < MAX_PROJ_TOUCHING; j++ )
					{
						if( LastTouching[i] == ProjTouching[j] )
						{
							break;
						}
					}

					if( j == MAX_PROJ_TOUCHING )	// LastTouching[i] is not in ProjTouching.
					{
						ProjUnTouch( LastTouching[i] );
					}
				}
			}
		}
	}

	Super.Tick( DeltaTime );
}

//------------------------------------------------------------------------------
simulated function bool IsTouchable( Actor Other )
{
	local int i;

	for( i = 0; i < ArrayCount(TouchableTypes); i++ )
	{
		if( TouchableTypes[i] != '' )
		{
			if( Other.IsA( TouchableTypes[i] ) )
			{
				return true;
			}
		}
	}

	return false;
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	local int i;

	if( bGenProjTouch )
	{
		for( i = 0; i < MAX_PROJ_TOUCHING; i++ )
		{
			ProjUnTouch( ProjTouching[i] );
		}
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
simulated function SpawnChunks( class<Actor> RockType, vector HitLocation, vector HitNormal )
{
	local rotator Rot;
	local Actor Rock;

	Rot = rotator(vect(1,0,0));
	Rot.Pitch += 8192 * FRand();			// 0 to 45 degrees
	Rot.Yaw	+= 65536 * FRand();				// 0 to 360 degrees
	Rock = Spawn( RockType,,, HitLocation, rotator(HitNormal) + Rot );
	if( AngrealProjectile(Rock) != None )
	{
		AngrealProjectile(Rock).SetSourceAngreal( SourceAngreal );
		Rock.Instigator = Instigator;
	}

	Rot = rotator(vect(1,0,0));
	Rot.Pitch += 8192 * FRand() + 8192;		// 45 to 90 degrees
	Rot.Yaw	+= 16384 * FRand();				// 0 to 90 degrees
	Rock = Spawn( RockType,,, HitLocation, rotator(HitNormal) + Rot );
	if( AngrealProjectile(Rock) != None )
	{
		AngrealProjectile(Rock).SetSourceAngreal( SourceAngreal );
		Rock.Instigator = Instigator;
	}

	Rot = rotator(vect(1,0,0));
	Rot.Pitch += 8192 * FRand() + 8192;		// 45 to 90 degrees
	Rot.Yaw	+= 16384 * FRand() + 16384;		// 90 to 180 degrees
	Rock = Spawn( RockType,,, HitLocation, rotator(HitNormal) + Rot );
	if( AngrealProjectile(Rock) != None )
	{
		AngrealProjectile(Rock).SetSourceAngreal( SourceAngreal );
		Rock.Instigator = Instigator;
	}
	
	Rot = rotator(vect(1,0,0));
	Rot.Pitch += 8192 * FRand() + 8192;		// 45 to 90 degrees
	Rot.Yaw	+= 16384 * FRand() + 32768;		// 180 to 270 degrees
	Rock = Spawn( RockType,,, HitLocation, rotator(HitNormal) + Rot );
	if( AngrealProjectile(Rock) != None )
	{
		AngrealProjectile(Rock).SetSourceAngreal( SourceAngreal );
		Rock.Instigator = Instigator;
	}
	
	Rot = rotator(vect(1,0,0));
	Rot.Pitch += 8192 * FRand() + 8192;		// 45 to 90 degrees
	Rot.Yaw	+= 16384 * FRand() + 49152;		// 270 to 360 degrees
	Rock = Spawn( RockType,,, HitLocation, rotator(HitNormal) + Rot );	
	if( AngrealProjectile(Rock) != None )
	{
		AngrealProjectile(Rock).SetSourceAngreal( SourceAngreal );
		Rock.Instigator = Instigator;
	}
}

defaultproperties
{
     ReflectedSoundName="WOT.Effect.Reflected"
}
