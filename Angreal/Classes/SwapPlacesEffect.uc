//------------------------------------------------------------------------------
// SwapPlacesEffect.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 10 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
// 
// + Spawn this effect.
// + Set the source and destination actors to swap.
// + Give to the destination actor to process.
//------------------------------------------------------------------------------
class SwapPlacesEffect expands SourceDestinationEffect;

//------------------------------------------------------------------------------
// Regression Tests:
// 
// Setup: Two clients on a dedicated server.  Type ENABLEADMIN
//        and ALLANGREAL 1 to get enough charges to perform tests.
//
// Action: Face each other and fire swap places at the other player.
// Result: You should switch places, and still be facing each other.
//
// Action: Fire a seeker at the other player followed by a swap places 
//         (such that the swap places hits first).
// Result: Seeker hits you (move around to make sure it's tracking you,
//         and not just going continuing in the same direction).
//
// Action: Fire decay at other player.  Let decay hit other player.  
//         Swap places with other player before decay wears off.
// Result: Other player should still be decaying.  You should not be decaying.
//
// Action: Other player locks onto you with lightning.  You go out of lightning's
//         lock-on range (lightning is still hurting you).  You swap places with
//         the other player.
// Result: The other player stops casting.
//
// Action: Other player lifts you into the air with whirlwind.  You swap places
//         with them.
// Result: Other player stop casting, and falls from where you were since locations
//         were switched.
//
// Action: Other player lists you into the air with whirlwind.  You swap places
//         with a third player (use trolloc if needed).
// Result: Trolloc is stuck in whirlwind, while you are safe on the ground.
//
// Action: Place a PersonalIllusion.  Fire a Seeker at it.  Fire SwapPlaces at it
//         such that the swap places hits the illusion before the seeker does.
// Result: You swap places with the PersonalIllusion.  The seeker is now following
//         you.  (You may want to try this the other way around having the seekers
//         originally comming after you to make sure you can escape from them.)
//
// Action: Shoot Seeker at other player.  Other player then shoots SwapPlaces
//         such that the swap places hits you before the seeker hits them.
// Result: Seeker is now comming after you.  Verify that the Seeker frame is 
//         lit up for you.
//
// Action: Shoot Ice at other player.  When other player is frozen, shoot swap
//         places at them (other player should be trying to move around). Should
//		   be tested with 2 clients on a server.
// Result: You should end up in the ice, frozen. Other player should end up
//         where you were, unfrozen, not telefragged. 
//------------------------------------------------------------------------------

var() localized string SourceFailMessage;
var() localized string DestinationFailMessage;
var() float ActorFitsRadius;

//------------------------------------------------------------------------------
// Swaps the Source and Destination's location, rotation, viewrotation, 
// projectiles that are seeking after them, and bad, removable leeches.
//------------------------------------------------------------------------------
function Invoke()
{	
	local vector SourceLoc, DestinationLoc;
	local rotator SourceRot, DestinationRot;
	local bool bSourceCollideActors, bSourceBlockActors, bSourceBlockPlayers;
	local bool bDestinationCollideActors, bDestinationBlockActors, bDestinationBlockPlayers;

	local SeekingProjectile Seekers[64];	// If our destination has more that 64 seeking projectiles after him, then tough.  
											// NOTE[aleiby]: Use dynamic storage type.
	local int i;
	local SeekingProjectile IterProj;

	local Leech SourceLeeches[32];
	local Leech DestinationLeeches[32];
	
	local Leech L;
	local LeechIterator IterL;

	local Reflector SourceReflectors[32];
	local Reflector DestinationReflectors[32];
	
	local Reflector R;
	local ReflectorIterator IterR;
	
	local AppearEffect SourceEffect, DestinationEffect;

	// Don't swap with yourself.
	if( Source == Destination )
	{
		return;
	}

	// NOTE[aleiby]: Is changing the ViewRotation too disorienting?

	SourceLoc					= Source.Location;
	SourceRot					= Source.Rotation;
	DestinationLoc				= Destination.Location;
	DestinationRot				= Destination.Rotation;
	bSourceCollideActors		= Source.bCollideActors;
	bSourceBlockActors			= Source.bBlockActors;
	bSourceBlockPlayers			= Source.bBlockPlayers;
	bDestinationCollideActors	= Destination.bCollideActors;
	bDestinationBlockActors		= Destination.bBlockActors;
	bDestinationBlockPlayers	= Destination.bBlockPlayers;

	// only check for fit if destination actor is smaller than source actor
	if( Destination.CollisionHeight < Source.CollisionHeight || Destination.CollisionRadius < Source.CollisionRadius )
	{
		// Error check.
		Destination.SetCollision( false, false, false );
		//Source.SetCollision( bSourceCollideActors, bSourceBlockActors, bSourceBlockPlayers );	
		if( !class'Util'.static.ActorFits( Source, DestinationLoc, ActorFitsRadius ) )
		{
			if( WOTPlayer(Source) != None )
			{
				WOTPlayer(Source).CenterMessage( SourceAngreal.Title$" "$SourceFailMessage, , true );
			}

			// NOTE[aleiby]: Play fail sound?

			Destination.SetCollision( bDestinationCollideActors, bDestinationBlockActors, bDestinationBlockPlayers );
			return;
		}
	}

	// only check for fit if source actor is smaller than destination actor
	if( Source.CollisionHeight < Destination.CollisionHeight || Source.CollisionRadius < Destination.CollisionRadius )
	{
		Source.SetCollision( false, false, false );	
		Destination.SetCollision( bDestinationCollideActors, bDestinationBlockActors, bDestinationBlockPlayers );
		if( !class'Util'.static.ActorFits( Destination, SourceLoc, ActorFitsRadius ) )
		{
			if( WOTPlayer(Source) != None )
			{
				WOTPlayer(Source).CenterMessage( SourceAngreal.Title$" "$DestinationFailMessage, , true );
			}

			// NOTE[aleiby]: Play fail sound?

			Source.SetCollision( bSourceCollideActors, bSourceBlockActors, bSourceBlockPlayers );	
			return;
		}
	}

	//Source.SetCollision( false, false, false );	
	Destination.SetCollision( false, false, false );

	// Update locations (with error checking).
	// NOTE[aleiby]: This could use some code factoring.
	if( !Source.SetLocation( DestinationLoc ) )
	{
		if( WOTPlayer(Source) != None )
		{
			WOTPlayer(Source).CenterMessage( SourceAngreal.Title$" "$SourceFailMessage, , true );
		}

		// NOTE[aleiby]: Play fail sound?

		Source.SetCollision( bSourceCollideActors, bSourceBlockActors, bSourceBlockPlayers );
		Destination.SetCollision( bDestinationCollideActors, bDestinationBlockActors, bDestinationBlockPlayers );
		return;
	}
	
	if( !Destination.SetLocation( SourceLoc ) )
	{
		if( WOTPlayer(Source) != None )
		{
			WOTPlayer(Source).CenterMessage( SourceAngreal.Title$" "$DestinationFailMessage, , true );
		}

		// NOTE[aleiby]: Play fail sound?

		Source.SetLocation( SourceLoc );	// In case previous SetLocation succeeded.
		Source.SetCollision( bSourceCollideActors, bSourceBlockActors, bSourceBlockPlayers );
		Destination.SetCollision( bDestinationCollideActors, bDestinationBlockActors, bDestinationBlockPlayers );
		return;
	}
	
	// Update rotations.
	Source.SetRotation( DestinationRot );
	if( Pawn(Source) != None )
	{
		Pawn(Source).ViewRotation = DestinationRot;	
		Pawn(Source).ClientSetRotation( DestinationRot );
	}
		
	Destination.SetRotation( SourceRot );
	if( Pawn(Destination) != None )
	{
		Pawn(Destination).ViewRotation = SourceRot;	
		Pawn(Destination).ClientSetRotation( SourceRot );
	}
	
	// Restore collision.
	Source.SetCollision( bSourceCollideActors, bSourceBlockActors, bSourceBlockPlayers );	
	Destination.SetCollision( bDestinationCollideActors, bDestinationBlockActors, bDestinationBlockPlayers );

	//
	// Swap seeking projectiles too.
	//
	i = 0;
	foreach AllActors( class'SeekingProjectile', IterProj )
	{
		if( IterProj != SourceProjectile )	// Don't swap our own projectile.
		{
			if( IterProj.Destination == Destination )
			{
				Seekers[i++] = IterProj;
				if( i >= ArrayCount(Seekers) )
				{
					warn( "Seekers array capacity exceeded." );
					break;
				}
			}
			else if( IterProj.Destination == Source )
			{
				IterProj.SetDestination( Destination );
				IterProj.Instigator = Pawn(Source);
				IterProj.SourcePawn = IterProj.Instigator;
				if( !IterProj.bHurtsOwner )
				{
					IterProj.SetIgnoredPawn( Pawn(Source) );
				}
			}
		}
	}
	for( i = 0; i < ArrayCount(Seekers) && Seekers[i] != None; i++ )
	{
		Seekers[i].SetDestination( Source );
		Seekers[i].Instigator = Pawn(Destination);
		Seekers[i].SourcePawn = Seekers[i].Instigator;
		if( !Seekers[i].bHurtsOwner )
		{
			Seekers[i].SetIgnoredPawn( Pawn(Destination) );
		}
	}

	//
	// Swap bad, removable leeches that are not from projectiles (like lightning and whirlwind).
	//
	if( WOTPlayer(Source) != None || WOTPawn(Source) != None )
	{
		i = 0;
		IterL = class'LeechIterator'.static.GetIteratorFor( Pawn(Source) );
		for( IterL.First(); !IterL.IsDone(); IterL.Next() )
		{
			L = IterL.GetCurrent();

			if( L.bRemovable && L.bDeleterious && !L.bFromProjectile )
			{
				L.UnAttach();
				SourceLeeches[i++] = L;
				if( i >= ArrayCount(SourceLeeches) )
				{
					warn( "SourceLeeches array capacity exceeded." );
					break;
				}
			}
		}
		IterL.Reset();
		IterL = None;
	}

	if( WOTPlayer(Destination) != None || WOTPawn(Destination) != None )
	{
		i = 0;
		IterL = class'LeechIterator'.static.GetIteratorFor( Pawn(Destination) );
		for( IterL.First(); !IterL.IsDone(); IterL.Next() )
		{
			L = IterL.GetCurrent();

			if( L.bRemovable && L.bDeleterious && !L.bFromProjectile )
			{
				if( L.Instigator == Destination )	// Example: If we swap with someone that is lightning us, make them stop casting.
				{
					L.SourceAngreal.UnCast();		// (the assumption is that if you have a leech on you that was not from a projectile, then the castor must still be holding down their button to sustain the leech.)
				}
				else								// otherwise put the other person in the lightning in your place.
				{
					L.UnAttach();
					DestinationLeeches[i++] = L;
					if( i >= ArrayCount(DestinationLeeches) )
					{
						warn( "DestinationLeeches array capacity exceeded." );
						break;
					}
				}
			}
		}
		IterL.Reset();
		IterL = None;
	}

	if( WOTPlayer(Destination) != None || WOTPawn(Destination) != None )
	{
		for( i = 0; i < ArrayCount(SourceLeeches) && SourceLeeches[i] != None; i++ )
		{
			SourceLeeches[i].AttachTo( Pawn(Destination) );
		}
	}

	if( WOTPlayer(Source) != None || WOTPawn(Source) != None )
	{
		for( i = 0; i < ArrayCount(DestinationLeeches) && DestinationLeeches[i] != None; i++ )
		{
			DestinationLeeches[i].AttachTo( Pawn(Source) );
		}
	}

	//
	// Swap bad, removable reflectors that are not from projectiles (like lightning and whirlwind).
	//
	if( WOTPlayer(Source) != None || WOTPawn(Source) != None )
	{
		i = 0;
		IterR = class'ReflectorIterator'.static.GetIteratorFor( Pawn(Source) );
		for( IterR.First(); !IterR.IsDone(); IterR.Next() )
		{
			R = IterR.GetCurrent();

			if( R.bRemovable && R.bDeleterious && !R.bFromProjectile )
			{
				if( R.Instigator == Destination )	// Example: If we swap with someone that is lightning us, make them stop casting.
				{
					R.SourceAngreal.UnCast();		// (the assumption is that if you have a reflector on you that was not from a projectile, then the castor must still be holding down their button to sustain the reflector.)
				}
				else								// otherwise put the other person in the lightning in your place.
				{
					R.UnInstall();
					SourceReflectors[i++] = R;
					if( i >= ArrayCount(SourceReflectors) )
					{
						warn( "SourceReflectors array capacity exceeded." );
						break;
					}
				}
			}
		}
		IterR.Reset();
		IterR = None;
	}

	if( WOTPlayer(Destination) != None || WOTPawn(Destination) != None )
	{
		i = 0;
		IterR = class'ReflectorIterator'.static.GetIteratorFor( Pawn(Destination) );
		for( IterR.First(); !IterR.IsDone(); IterR.Next() )
		{
			R = IterR.GetCurrent();

			if( R.bRemovable && R.bDeleterious && !R.bFromProjectile )
			{
				R.UnInstall();
				DestinationReflectors[i++] = R;
				if( i >= ArrayCount(DestinationReflectors) )
				{
					warn( "DestinationReflectors array capacity exceeded." );
					break;
				}
			}
		}
		IterR.Reset();
		IterR = None;
	}

	if( WOTPlayer(Destination) != None || WOTPawn(Destination) != None )
	{
		for( i = 0; i < ArrayCount(SourceReflectors) && SourceReflectors[i] != None; i++ )
		{
			SourceReflectors[i].Install( Pawn(Destination) );
		}
	}

	if( WOTPlayer(Source) != None || WOTPawn(Source) != None )
	{
		for( i = 0; i < ArrayCount(DestinationReflectors) && DestinationReflectors[i] != None; i++ )
		{
			DestinationReflectors[i].Install( Pawn(Source) );
		}
	}

	// Set instigator in case we kill the guy.
	if( WOTPlayer(Destination) != None )
	{
		WOTPlayer(Destination).SetSuicideInstigator( Instigator );
	}
	else if( WOTPawn(Destination) != None )
	{
		WOTPawn(Destination).SetSuicideInstigator( Instigator );
	}

	//
	// Create visuals.
	//
	SourceEffect = Spawn( class'AppearEffect' );
	DestinationEffect = Spawn( class'AppearEffect' );
	SourceEffect.bFadeIn = false;
	DestinationEffect.bFadeIn = false;
	if( WOTPlayer(Source) != None && WOTPlayer(Destination) != None )
	{
		SourceEffect.SetColors( WOTPlayer(Source).PlayerColor );
		DestinationEffect.SetColors( WOTPlayer(Destination).PlayerColor );
	}
	else if( WOTPlayer(Source) != None && WOTPlayer(Destination) == None )
	{
		SourceEffect.SetColors( WOTPlayer(Source).PlayerColor );
		DestinationEffect.SetColors( WOTPlayer(Source).PlayerColor );
	}
	else if( WOTPlayer(Source) == None && WOTPlayer(Destination) != None )
	{
		SourceEffect.SetColors( WOTPlayer(Destination).PlayerColor );
		DestinationEffect.SetColors( WOTPlayer(Destination).PlayerColor );
	}
	else
	{
		SourceEffect.SetColors( 'Blue' );
		DestinationEffect.SetColors( 'Green' );
	}
	SourceEffect.SetAppearActor( Source );
	DestinationEffect.SetAppearActor( Destination );
}

defaultproperties
{
     SourceFailMessage="failed because you don't fit at the target's location."
     DestinationFailMessage="failed because the target doesn't fit at your location."
     ActorFitsRadius=1024.000000
     bDeleterious=True
}
