//------------------------------------------------------------------------------
// MashadarTrailer.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 11 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
//
//------------------------------------------------------------------------------
class MashadarTrailer expands IKTrailer;

var MashadarGuide Guide;	// Our guiding object.

var() int Damage;			// How much we hurt other pawns when they touch us.

var() float MinScaleGlow, MaxScaleGlow;

var float DesiredScaleGlow;

var int NoDamageCounter;
var() int NoDamageTolerance;// Number of times in a row Mashadar will try to damage the player
							// and fail before giving up.

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	FadeIn();
}

//------------------------------------------------------------------------------
simulated function SetInitialState()
{
	// Let us worry about that.
	// (PreBeginPlay calls FadeIn which sets our state to FadingIn.)
}

//------------------------------------------------------------------------------
// Propogate all damage through our guiding object.
//------------------------------------------------------------------------------
function TakeDamage( int Damage, Pawn DamageInstigator, vector HitLocation, vector Momentum, name DamageType )
{
	if( Guide != None )
	{
		Guide.HurtMashadar( Damage, Self, DamageInstigator, DamageType );
	}
}

//------------------------------------------------------------------------------
function Touch( Actor Other )
{
	local int Health;

	// Only call on the server.
	if( Level.NetMode==NM_Client ) return;

	// Abort if we are guide-less.
	if( Guide == None ) return;

	// Check for lightning.
	if( Pawn(Other) != None )
	{
		if( class'AngrealInvLightning'.static.IsUsingLightning( Pawn(Other) ) )
		{
			Guide.Shock( Pawn(Other) );
			return;
		}
	
		if( (Pawn(Other).PlayerReplicationInfo == None || Pawn(Other).PlayerReplicationInfo.Team != Guide.Team) && Guide.bActive )
		{
			Health = Pawn(Other).Health;
			Other.TakeDamage( Damage, Instigator, Location, vect(0,0,0), 'xxxxS' /*Spirit*/ );
			if( Pawn(Other).Health == Health )
			{
				NoDamageCounter++;
				if( NoDamageCounter > NoDamageTolerance )
				{
					NoDamageCounter = 0;
					Guide.Deactivate();
					Guide.ClientDeactivateFID++;	// Tell the clients to Deactivate.
				}
			}
			else
			{
				NoDamageCounter = 0;
			}

/*Not fun.
			Guide.GiveHealth( Damage );
*/

			// PlaySound.
			if( Pawn(Other).Health > 0 )
			{
				Guide.PlaySlotSound( Guide.SoundTable.MeleeHitEnemyTauntSoundSlot );
			}
			else
			{
				Guide.PlaySlotSound( Guide.SoundTable.MeleeKilledEnemyTauntSoundSlot );
			}
		}
	}
}

//------------------------------------------------------------------------------
// Fail gracefully.
//------------------------------------------------------------------------------
simulated function NotifyLostHeadActor()
{
	//class'Debug'.static.DebugWarn( Self, "Lost head actor... fading away.", 'DebugCategory_Angreal' );
	warn( "Lost head actor... fading away." );
	FadeAway();
}

//------------------------------------------------------------------------------
simulated function Destroyed()
{
	if( bMaster && ChildTrailer != None && GetStateName() != 'FadingAway' )
	{
		MashadarTrailer(ChildTrailer).FadeAway();
	}

	if( Guide != None )
	{
		if( Level.NetMode != NM_Client )
		{
			Guide.NumSegments--;
		}
		else
		{
			Guide.ClientNumSegments--;
		}
	}

	Super.Destroyed();
}

//------------------------------------------------------------------------------
simulated function FadeIn( optional float DesiredSG )
{
	// Set default.
	if( DesiredSG == 0.0 )
	{
		DesiredSG = RandRange( MinScaleGlow, MaxScaleGlow );
	}

	DesiredScaleGlow = DesiredSG;

	if( Level.NetMode == NM_Standalone )
	{
		GotoState('FadingIn');
	}
	else
	{
		ScaleGlow = DesiredScaleGlow;
	}
}

//------------------------------------------------------------------------------
simulated state FadingIn
{
	simulated function BeginState()
	{
		ScaleGlow = 0.0;
	}

	simulated function Tick( float DeltaTime )
	{
		Global.Tick( DeltaTime );

		ScaleGlow += 0.01;
		if( ScaleGlow >= DesiredScaleGlow )
		{
			GotoState('');
		}
	}
}

//------------------------------------------------------------------------------
simulated function FadeAway()
{
	GotoState('FadingAway');
	if( MashadarTrailer(ChildTrailer) != None )
	{
		MashadarTrailer(ChildTrailer).FadeAway();
	}
}

//------------------------------------------------------------------------------
simulated state FadingAway
{
	// Ignores.
	simulated function FadeIn( float DesiredScaleGlow );

	simulated function Tick( float DeltaTime )
	{
		// NOTE[aleiby]: Make this all tweakable from UnrealEd.
		ScaleGlow -= 0.02;
		DrawScale += 0.01;
		if( ScaleGlow <= 0 )
		{
			Destroy();
		}
	}
}

defaultproperties
{
     Damage=1
     MinScaleGlow=0.200000
     MaxScaleGlow=0.400000
     NoDamageTolerance=3
     bCollideActors=True
     bProjTarget=True
}
