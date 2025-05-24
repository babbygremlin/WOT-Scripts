//------------------------------------------------------------------------------
// AbsorbReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 10 $
//
// Description:	Takes the source angreal away from the castor and gives it to
//				our owner.
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class AbsorbReflector expands Reflector;

#exec AUDIO IMPORT FILE=Sounds\Absorb\AbsorbABS.wav		GROUP=Absorb

var() Sound InvokeSound;			// Sound played when an item is absorbed from another player.

var() name NonStealableTypes[2];	// Types of artifacts we cannot steal.

var() name UnAffectedProjs[7];		// Types of projectiles we are not allowed to affect.

/////////////////////////
// Overriden Functions //
/////////////////////////

//------------------------------------------------------------------------------
// Called by angreal projectiles to notify the victim what just hit them.
//------------------------------------------------------------------------------
simulated function NotifyHitByAngrealProjectile( AngrealProjectile HitProjectile )
{
	if( GenericProjectile(HitProjectile) != None && IsAffectable( HitProjectile ) )
	{
		StealArtifact( HitProjectile.SourceAngreal );
		GenericProjectile(HitProjectile).bExplode = false;
		GenericProjectile(HitProjectile).bAbortProcessTouch = true;
		GenericProjectile(HitProjectile).Destroy();

		// Only useful once.
		UnInstall();
		Destroy();
	}
	else
	{
		Super.NotifyHitByAngrealProjectile( HitProjectile );
	}
}

//------------------------------------------------------------------------------
function ProcessEffect( Invokable I )
{
	if
	(	I.bDeleterious						// Absorb bad effects.
	&&	I.SourceProjClass == None			// But not ones from projectiles since they should only be absorbed via NotifyHitByAngrealProjectile.  This prevents us from absorbing things via splash damage, etc.
	&&	I.SourceAngreal != SourceAngreal	// And not ones that we inflict on ourselves.
	)	
	{
		StealArtifact( I.SourceAngreal );

		// Only useful once.
		UnInstall();
		Destroy();
	}
	else
	{
		Super.ProcessEffect( I );
	}
}

//------------------------------------------------------------------------------
simulated function Install( Pawn NewHost )
{
	local LeechIterator IterL;
	local Leech L;

	local ReflectorIterator IterR;
	local Reflector R;
		
	Super.Install( NewHost );

	if( Role == ROLE_Authority )
	{
		if( Owner != None && Owner == NewHost )
		{

			IterL = class'LeechIterator'.static.GetIteratorFor( Pawn(Owner) );
			for( IterL.First(); !IterL.IsDone(); IterL.Next() )
			{
				L = IterL.GetCurrent();

				if( L.bRemovable && L.bDeleterious && !L.bFromProjectile )
				{
					StealArtifact( L.SourceAngreal );
					L.UnAttach();
					L.Destroy();
					
					// Only useful once.
					UnInstall();
					Destroy();

					IterL.Reset();
					IterL = None;
					return;
				}
			}
			IterL.Reset();
			IterL = None;

			IterR = class'ReflectorIterator'.static.GetIteratorFor( Pawn(Owner) );
			for( IterR.First(); !IterR.IsDone(); IterR.Next() )
			{
				R = IterR.GetCurrent();

				if( R.bRemovable && R.bDeleterious && !R.bFromProjectile )
				{
					StealArtifact( R.SourceAngreal );
					R.UnInstall();
					R.Destroy();
					
					// Only useful once.
					UnInstall();
					Destroy();
					
					IterR.Reset();
					IterR = None;
					return;
				}
			}
			IterR.Reset();
			IterR = None;
		}
	}
}

//------------------------------------------------------------------------------
function StealArtifact( AngrealInventory A )
{
	// Make sure we can steal this kind.
	if( !IsStealable( A ) )
	{
		return;
	}

	// Take away from current owner.
	if( Pawn(A.Owner) != None )
	{
		if( WOTPawn(A.Owner) != None )	// Don't take away from NPCs.
		{
			A = Spawn( A.Class );
		}
		else
		{
			Pawn(A.Owner).DeleteInventory( A );
		}
	}

	// Give the charge used on us back.
	A.AddCharges( 1 );

	// Give it to our Owner.
	if( Pawn(Owner) != None )
	{
		if( Level.Game.PickupQuery( Pawn(Owner), A ) )
		{
			A.GiveTo( Pawn(Owner) );
		}
		//ARL what happens if the pickup is not approved?
	}

	DoCoolEffect();
}

//------------------------------------------------------------------------------
function DoCoolEffect()
{
	local AbsorbVisual Visual;

	Visual = Spawn( class'AbsorbVisual', Owner,, Owner.Location );
	//Visual.SetFollowActor( Owner );

	if( InvokeSound != None )
	{
		Owner.PlaySound( InvokeSound );
	}
}

//------------------------------------------------------------------------------
function bool IsStealable( AngrealInventory A )
{
	local int i;

	for( i = 0; i < ArrayCount(NonStealableTypes); i++ )
		if( NonStealableTypes[i] != '' && A.IsA( NonStealableTypes[i] ) )
			return false;

	if( A == SourceAngreal )	// Don't steal yourself.
		return false;

	return true;
}

//------------------------------------------------------------------------------
simulated function bool IsAffectable( Actor Other )
{
	local int i;

	for( i = 0; i < ArrayCount(UnAffectedProjs); i++ )
	{
		if( UnAffectedProjs[i] != '' )
		{
			if( Other.IsA( UnAffectedProjs[i] ) )
			{
				return false;
			}
		}
	}

	return true;
}

defaultproperties
{
     InvokeSound=Sound'Angreal.Absorb.AbsorbABS'
     NonStealableTypes(0)=AngrealInvAirBurst
     UnAffectedProjs(0)=MashadarGuide
     UnAffectedProjs(1)=MachinShin
     UnAffectedProjs(2)=AMAPearl
     UnAffectedProjs(3)=AngrealDistantEyeProjectile
     UnAffectedProjs(4)=AngrealWallOfAirProjectile
     UnAffectedProjs(5)=EarthTremorRock
     UnAffectedProjs(6)=LavaRock
     Priority=170
     bRemoveExisting=True
     RemoteRole=ROLE_SimulatedProxy
}
