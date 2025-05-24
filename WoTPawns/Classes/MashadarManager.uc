//------------------------------------------------------------------------------
// MashadarManager.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 11 $
//
// Description:	
//------------------------------------------------------------------------------
// How to use this class:
// 
//------------------------------------------------------------------------------
class MashadarManager expands Info;

// Initial health for a Mashadar.
var() int MashadarMaxHealth;
var() int MashadarMinHealth;

struct MashadarInfo
{
	var int MashadarHealth;			// Current health of said mashadar.
	var byte Active;				// Active state of this mashadar "slot". 1 = Active, 0 = Unactive.
};
var MashadarInfo MashadarSlot[256];	// Mashadar "slots".

const GUARD_POINT_ALLOWANCE = 1.0;	// How close is "close enough" when comparing guard point locations?

struct MashadarGuardInfo
{
	var() Actor GuardActor;			// Actors we need to guard (takes precidence over GuardPoint).
	var() vector GuardPoint;		// Points we need to guard.
	var() byte Valid;				// 1 = Data is valid, 0 = Data is not valid.
	var   byte Claimed;				// 1 = A tendril is actively guarding this point currently, 0 = Free for the claiming.
};
var() MashadarGuardInfo GuardData[256];

var() float GuardRadius;			// How close something has to get to one of our guard points or 
									// actors before we will attack it.

var() int SealGuardCount;			// Number of tendrils allowed to guard seals at any given time.

var() float SealGuardRadius;		// Same as GuardRadius but for seals specifically.

// Maximum number of Mashadar active at any given time.
var() int MaxActiveMashadar;

// The team I'm managing for.
// There should only ever be one MashadarManager per team.
var() byte Team;

// Damage required to stimulate a die hard audio response on death of a tendril.
var() int DieHardThreshold;

// Damage required to stimulate a hard hit audio response.
var() int HitHardThreshold;

// Arena interface for assigning death points, etc.
var Pawn ArenaMashadarPawnInterface;

replication
{
	reliable if( Role==ROLE_Authority )
		MaxActiveMashadar,
		Team,
		DieHardThreshold,
		HitHardThreshold;
}

//------------------------------------------------------------------------------
simulated function PreBeginPlay()
{
	local int i, Max;

	Max = MaxActiveMashadar;
	MaxActiveMashadar = 0;

	for( i = 0; i < Max; i++ )
	{
		AddMashadar();
	}

	Super.PreBeginPlay();
}

//------------------------------------------------------------------------------
function bool AddMashadar()
{
	local int i;

	if( MaxActiveMashadar < ArrayCount(MashadarSlot) )
	{
		MashadarSlot[MaxActiveMashadar++].MashadarHealth = int(RandRange( MashadarMinHealth, MashadarMaxHealth ));
		return true;
	}
	else
	{
		//OBE CleanUpSlots();

		// Find a dead mashadar slot and use it.
		for( i = 0; i < MaxActiveMashadar; i++ )
		{
			if( MashadarSlot[i].Active == 0 && MashadarSlot[i].MashadarHealth <= 0 )
			{
				MashadarSlot[i].MashadarHealth = int(RandRange( MashadarMinHealth, MashadarMaxHealth ));
				return true;	// No need to go on.
			}
		}
		warn( "Cannot add Mashadar... maximum capacity reached." );
		return false;
	}
}

//------------------------------------------------------------------------------
// If no Mashadar is given, then remove any non-active slot.
//------------------------------------------------------------------------------
function RemoveMashadar( optional MashadarGuide Mash )
{
	local int i;

	if( Mash != None && Mash.bActive )
	{
		MashadarSlot[Mash.Index].MashadarHealth = 0;
		MashadarSlot[Mash.Index].Active = 0;
		// NOTE[aleiby]: Should we be deactivating the MashadarGuide here too, or leave the
		// responsibility to the caller.
	}
	else
	{
		for( i = 0; i < MaxActiveMashadar; i++ )
		{
			if( MashadarSlot[i].Active == 0 && MashadarSlot[i].MashadarHealth > 0 )
			{
				MashadarSlot[i].MashadarHealth = 0;
				break;	// No need to go on.
			}
		}
	}
}

//------------------------------------------------------------------------------
simulated function CleanUpSlots()
{
	// NOTE[aleiby]: Remove slots with Health <= 0 and collapse remaining slots.
	warn( "Aaron forgot to implement this function." );
	assert( true );
/*
	local int i;

	MaxActiveMashadar = 0;
	for( i = 0; i < ArrayCount(MashadarSlot); i++ )
	{
		if( MashadarSlot[i].MashadarHealth <= 0 )
		{
			MashadarSlot[MaxActiveMashadar].MashadarHealth = MashadarSlot[i].MashadarHealth;
			MashadarSlot[MaxActiveMashadar].Active = MashadarSlot[i].Active;
			{Update associated Mashadar's Index to reflect slot shuffling.}
			MaxActiveMashadar++;
		}
	}
*/
}

//------------------------------------------------------------------------------
function HurtMashadar( MashadarGuide Mash, int Damage, Pawn DamageInstigator, name DamageType )
{
	local Pawn IterP;

	if( MashadarSlot[Mash.Index].MashadarHealth > 0 )
	{
		MashadarSlot[Mash.Index].MashadarHealth -= Damage;

		if( MashadarSlot[Mash.Index].MashadarHealth <= 0 )
		{
			Mash.bFullRetract = true;
			Mash.Deactivate();

			// PlaySound on death.
			if( MashadarSlot[Mash.Index].MashadarHealth <= DieHardThreshold )
			{
				Mash.PlaySlotSound( Mash.SoundTable.DieHardSoundSlot );
			}
			else
			{
				Mash.PlaySlotSound( Mash.SoundTable.DieSoftSoundSlot );
			}

			// Send Arena DeathMessages and clean up FocusPawn.
			if( ArenaMashadarPawnInterface != None )
			{
				Level.Game.Killed( DamageInstigator, ArenaMashadarPawnInterface, DamageType );

				// Clean up.
				ArenaMashadarPawnInterface.Destroy();
				ArenaMashadarPawnInterface = None;
				Mash.Destroy();
				Self.Destroy();
			}

			// Send Citadel DeathMessages and clean up FocusPawn.
			else
			{
				for( IterP = Level.PawnList; IterP != None; IterP = IterP.NextPawn )
				{
					if
					(	MashadarFocusPawn(IterP) != None 
					&&	IterP.Tag != 'AngrealSpawned'
					&&	IterP.PlayerReplicationInfo.Team == Team
					)
					{
						Level.Game.Killed( DamageInstigator, IterP, DamageType );
						IterP.Destroy();
						Mash.Destroy();
						break;
					}
				}
			}
		}
		else
		{
			// PlaySound on normal hit.
			if( Damage >= HitHardThreshold )
			{
				Mash.PlaySlotSound( Mash.SoundTable.HitHardSoundSlot );
			}
			else
			{
				Mash.PlaySlotSound( Mash.SoundTable.HitSoftSoundSlot );
			}
		}
	}
}

//------------------------------------------------------------------------------
simulated function GiveHealth( MashadarGuide Mash, int Health )
{
	if( MashadarSlot[Mash.Index].MashadarHealth > 0 &&
		MashadarSlot[Mash.Index].MashadarHealth < MashadarMaxHealth )
	{
		MashadarSlot[Mash.Index].MashadarHealth += Health;
	}
}

//------------------------------------------------------------------------------
simulated function int GetMashadarHealth( int Index )
{
	return MashadarSlot[Index].MashadarHealth;
}

//------------------------------------------------------------------------------
simulated function bool IsCloseToSeal( vector SourceLocation, optional float Radius )
{
	local Seal iSeal;
	local vector iLoc;

	// Default to SealGuardRadius.
	if( Radius == 0.0 )
	{
		Radius = SealGuardRadius;
	}

	//DM( Self$"::IsCloseToSeal() Radius = "$Radius );

	// NOTE[aleiby]: Optimize using an ItemCollector or something similar to PawnLists.
	foreach AllActors( class'Seal', iSeal )
	{
		//DM( Self$"::Found "$iSeal$": Owner: "$iSeal.Owner );

		if( iSeal.Owner != None )
		{
			iLoc = iSeal.Owner.Location;
		}
		else
		{
			iLoc = iSeal.Location;
		}

		if( VSize( SourceLocation - iLoc ) <= Radius )
		{
			return true;
		}
	}

	return false;
}

//------------------------------------------------------------------------------
// Mashadar may not activate themselves.  
// They must do so through this function.
//------------------------------------------------------------------------------
simulated function RequestActivation( MashadarGuide Mash, Actor DesiredVictim )
{
	local int i;
	local int GuardID;
	local Pawn IterP;
	
	//DM( Mash$" requesting activation to go after "$DesiredVictim );
	
	// Find the first non-active mashadar slot with health left.
	for( i = 0; i < MaxActiveMashadar; i++ )
	{
		if( MashadarSlot[i].Active == 0 && MashadarSlot[i].MashadarHealth > 0 )
		{
			MashadarSlot[i].Active = 1;
			Mash.Index = i;

			if( ArenaMashadarPawnInterface != None )
			{
				Mash.Instigator = ArenaMashadarPawnInterface;
			}
			else
			{
				for( IterP = Level.PawnList; IterP != None; IterP = IterP.NextPawn )
				{
					if
					(	MashadarFocusPawn(IterP) != None 
					&&	IterP.Tag != 'AngrealSpawned'
					&&	IterP.PlayerReplicationInfo.Team == Team
					)
					{
						Mash.Instigator = IterP;
						break;
					}
				}
			}

			Mash.Activate();
			//DM( "Activating MashadarGuide: "$Mash );
			return;	// No need to go on.
		}
	}

/*OBE: Orders are automatic now, so Mashadar doesn't need to obey orders.
	// Validate input.
	if( DesiredVictim == None )
	{
		//DM( Self$"::RequestActivation() -- Invalid input." );
		return;
	}

	// If there weren't any free mashadar slots, see if we need to activate it 
	// anyway for it to guard a point/actor.
	GuardID = ClaimGuard( DesiredVictim );
	//DM( "Claiming guard id: "$GuardID );
	if( GuardID != class'MashadarGuide'.default.GuardID )
	{
		Mash.GuardID = GuardID;
		Mash.Activate();
		//DM( "Activating MashadarGuide (for guarding purposes): "$Mash );
		return;
	}

	// If there are seals to guard, we had better protect them.
	//DM( "Seal guard check.  SealGuardCount: "$SealGuardCount );
	if( SealGuardCount > 0 && IsCloseToSeal( DesiredVictim.Location ) )
	{
		DecrementSealGuardCount();
		Mash.GuardID = class'MashadarGuide'.default.GuardSealID;
		Mash.Activate();
		//DM( "Activating MashadarGuide (to guard a seal): "$Mash );
		return;
	}
*/
}

//------------------------------------------------------------------------------
// Notification for when a Mashadar is deactivated.
//------------------------------------------------------------------------------
simulated function MashadarDeactivated( MashadarGuide Mash )
{
	//DM( "DeActivating MashadarGuide: "$Mash );
	MashadarSlot[ Mash.Index ].Active = 0;
	if( Mash.GuardID != class'MashadarGuide'.default.GuardID )
	{
		ReleaseClaim( Mash.GuardID );
		Mash.GuardID = class'MashadarGuide'.default.GuardID;
	}
}

////////////
// Orders //
////////////

//------------------------------------------------------------------------------
simulated function IncrementSealGuardCount()
{
	SealGuardCount++;
	////DM( Self$"::IncrementSealGuardCount(): "$SealGuardCount );
}

//------------------------------------------------------------------------------
simulated function DecrementSealGuardCount()
{
	SealGuardCount--;
	////DM( Self$"::DecrementSealGuardCount(): "$SealGuardCount );
}

//------------------------------------------------------------------------------
simulated function int AddGuardPoint( vector Loc )
{
	local int i;
	local int GuardID;

	////DM( Self$"::AddGuardPoint(): "$Loc );

	GuardID = class'MashadarGuide'.default.GuardID;

	for( i = 0; i < ArrayCount(GuardData); i++ )
	{
		if( GuardData[i].Valid == 0 )
		{
			GuardData[i].GuardPoint = Loc;
			//if( GuardData[i].GuardActor != None ) { GuardData[i].GuardActor.DetachDestroyObserver( Self ); }
			GuardData[i].GuardActor = None;
			GuardData[i].Valid = 1;
			GuardID = i;
			break;
		}
	}

	////DM( Self$"::GuardID = "$i );

	return GuardID;
}

//------------------------------------------------------------------------------
// Returns the GuardID of the newly added guard data or class'MashadarGuide'.default.GuardID (-1) on failure.
//------------------------------------------------------------------------------
simulated function int AddGuardActor( Actor Other )
{
	local int i;
	local int GuardID;

	////DM( Self$"::AddGuardActor(): "$Other );

	GuardID = class'MashadarGuide'.default.GuardID;

	for( i = 0; i < ArrayCount(GuardData); i++ )
	{
		if( GuardData[i].Valid == 0 )
		{
			//if( GuardData[i].GuardActor != None ) { GuardData[i].GuardActor.DetachDestroyObserver( Self ); }
			GuardData[i].GuardActor = Other;
			//if( GuardData[i].GuardActor != None ) { GuardData[i].GuardActor.AttachDestroyObserver( Self ); }
			GuardData[i].GuardPoint = vect(0,0,0);
			GuardData[i].Valid = 1;
			GuardID = i;
			break;
		}
	}

	////DM( Self$"::GuardID = "$i );

	return GuardID;
}

//------------------------------------------------------------------------------
simulated function RemoveGuardPoint( vector Loc, optional bool bRemoveAllOccurances )
{
	local int i;

	////DM( Self$"::RemoveGuardPoint(): "$Loc );

	for( i = 0; i < ArrayCount(GuardData); i++ )
	{
		if
		(	GuardData[i].Valid == 1
		&&	GuardData[i].GuardActor == None
		&&	class'Util'.static.VectAproxEqual( GuardData[i].GuardPoint, Loc, GUARD_POINT_ALLOWANCE )
		)
		{
			GuardData[i].GuardPoint = vect(0,0,0);
			GuardData[i].Valid = 0;

			////DM( Self$"::GuardID = "$i );

			// Should we continue looking for matches?
			if( !bRemoveAllOccurances ) break;
		}
	}
}

//------------------------------------------------------------------------------
simulated function RemoveGuardActor( Actor Other, optional bool bRemoveAllOccurances )
{
	local int i;

	////DM( Self$"::RemoveGuardActor(): "$Other );

	for( i = 0; i < ArrayCount(GuardData); i++ )
	{
		if
		(	GuardData[i].Valid == 1
		&&	GuardData[i].GuardActor == Other
		)
		{
			//if( GuardData[i].GuardActor != None ) { GuardData[i].GuardActor.DetachDestroyObserver( Self ); }
			GuardData[i].GuardActor = None;
			GuardData[i].GuardPoint = vect(0,0,0);
			GuardData[i].Valid = 0;

			////DM( Self$"::GuardID = "$i );
			
			// Should we continue looking for matches?
			if( !bRemoveAllOccurances ) break;
		}
	}
}

/*
//------------------------------------------------------------------------------
simulated function SubjectDestroyed( Object Subject )
{
	RemoveGuardActor( Subject );
	Super.SubjectDestroyed( Subject );
}
*/

//------------------------------------------------------------------------------
simulated function ResetGuardData( int GuardID )
{
	////DM( Self$"::ResetGuardData(): "$GuardID );
	////DM( Self$"GuardActor: "$GuardData[ GuardID ].GuardActor$"GuardPoint: "$GuardData[ GuardID ].GuardPoint$"Claimed: "$GuardData[ GuardID ].Claimed$"Valid: "$GuardData[ GuardID ].Valid );

	// Validate input.
	if( GuardID < 0 || GuardID >= ArrayCount(GuardData) )
	{
		warn( "GuardID out of range." );
		return;
	}

	//if( GuardData[i].GuardActor != None ) { GuardData[i].GuardActor.DetachDestroyObserver( Self ); }
	GuardData[ GuardID ].GuardActor = None;
	GuardData[ GuardID ].GuardPoint = vect(0,0,0);
	GuardData[ GuardID ].Claimed = 0;
	GuardData[ GuardID ].Valid = 0;
}

//------------------------------------------------------------------------------
// Use to get the guard actor or point indicated by the given GuardID.
// GuardPoint is only valid if GuardActor is None.
// If the function returns false, GuardActor, GuardPoint and bClaimed 
// are not valid.
//------------------------------------------------------------------------------
simulated function bool GetGuardData
(	int			GuardID, 
	out Actor	GuardActor, 
	out vector	GuardPoint,
	out byte	Claimed	// (1=true,0=false)
)
{
	// Validate input.
	if( GuardID < 0 || GuardID >= ArrayCount(GuardData) )
	{
		warn( "GuardID out of range." );
		return false;
	}

	GuardActor = GuardData[ GuardID ].GuardActor;
	GuardPoint = GuardData[ GuardID ].GuardPoint;
	Claimed    = GuardData[ GuardID ].Claimed;
	return       GuardData[ GuardID ].Valid==1;
}

//------------------------------------------------------------------------------
// Use this function to determine whether or not the actor in question is
// in a position for us to attack (relative to our guard points).
//
// Returns index of claimed Guard point/actor.
// Returns class'MashadarGuide'.default.GuardID (-1) if no valid 
// Guard point/actor is found.
//------------------------------------------------------------------------------
simulated function int ClaimGuard( Actor Other, optional float Radius )
{
	local int i;
	local vector Loc;

	// Default to GuardRadius.
	if( Radius == 0.0 )
	{
		Radius = GuardRadius;
	}

	// See if Other is within Radius units of any of our guard points or actors.
	for( i = 0; i < ArrayCount(GuardData); i++ )
	{
		if( GuardData[i].Valid == 1 && GuardData[i].Claimed == 0 )
		{
			if( GuardData[i].GuardActor != None )
			{
				Loc = GetActorLocation( GuardData[i].GuardActor );
			}
			else
			{
				Loc = GuardData[i].GuardPoint;
			}

			if( VSize( Other.Location - Loc ) <= Radius )
			{
				GuardData[i].Claimed = 1;
				return i;
			}
		}
	}

	return class'MashadarGuide'.default.GuardID;
}

//------------------------------------------------------------------------------
simulated static function vector GetActorLocation( Actor Other )
{
	local vector Loc;

	if( Other != None )
	{
		Loc = Other.Location;

		// If someone is carrying this item, use the location of that person instead.
		if( Inventory(Other) != None && Inventory(Other).Owner != None )
		{
			Loc = Other.Owner.Location;
		}
	}

	return Loc;
}

//------------------------------------------------------------------------------
// You must release any claims made with ClaimGuard using this function when
// you are done attacking.
//------------------------------------------------------------------------------
simulated function ReleaseClaim( int ClaimNumber )
{
	////DM( Self$"::ReleaseClaim(): "$ClaimNumber );

	if( ClaimNumber == class'MashadarGuide'.default.GuardSealID )
	{
		IncrementSealGuardCount();
	}
	else if( ClaimNumber >= 0 && ClaimNumber < ArrayCount(GuardData) )
	{
		GuardData[ ClaimNumber ].Claimed = 0;
	}
	else
	{
		warn( "Invalid ClaimNumber." );
	}

	//ReevaluateGuardActors();
}

/* OBE
//------------------------------------------------------------------------------
// Make sure all our GuardActors are still valid.
//------------------------------------------------------------------------------
simulated function ReevaluateGuardActors()
{
	local int i;
	
	for( i = 0; i < ArrayCount(GuardData); i++ )
	{
		// DestroyObservers usage prevents us from having a valid GuardData
		// with both an invalid GuardActor and GuardPoint.
		// (IOW: If GuardData[i].Valid == 1 && GuardData[i].GuardActor == None,
		// then this GuardData must have been validated via AddGuardPoint.
		if( GuardData[i].Valid == 1 && GuardData[i].GuardActor != None )
		{
			if( Pawn(GuardData[i].GuardActor) != None && Pawn(GuardData[i].GuardActor).Health <= 0 )
			{
				ResetGuardData( i );
			}
			else if( Seal(GuardData[i].GuardActor) != None && Seal(GuardData[i].GuardActor).Owner != None )
			{
				// If the seal is not reachable by any tendrils, then we need to replace it with one that is.
			}
		}
	}
}
*/

//------------------------------------------------------------------------------
// Only return true if we want the tendril to stop guarding whatever it is 
// currently guarding.
//------------------------------------------------------------------------------
simulated function bool ShouldStopGuarding( MashadarGuide Mash )
{
	local bool bStopGuarding;
	local int GuardID;

	// Check if the thing it is chasing is still a threat to the thing it is guarding.
	if( Mash.Destination != None && Mash.GuardID != class'MashadarGuide'.default.GuardID )
	{
		if( Mash.GuardID == class'MashadarGuide'.default.GuardSealID )	// Guarding seal.
		{
			bStopGuarding = !IsCloseToSeal( Mash.Destination.Location );
		}
		else															// Guarding location or actor.
		{
			ReleaseClaim( Mash.GuardID );
			GuardID = ClaimGuard( Mash.Destination );

			//DM( "Mash.GuardID = "$Mash.GuardID$" GuardID = "$GuardID );

			// If it is no longer a threat, or it is now a threat to a different 
			// guard point/actor, it needs to release its current guard point/actor.
			if( GuardID == class'MashadarGuide'.default.GuardID )
			{
				bStopGuarding = true;
				Mash.GuardID = class'MashadarGuide'.default.GuardID;
			}
			else if( Mash.GuardID != GuardID )
			{
				bStopGuarding = true;
				ReleaseClaim( GuardID );
				Mash.GuardID = class'MashadarGuide'.default.GuardID;
			}
		}
	}

	return bStopGuarding;
}

defaultproperties
{
     MashadarMaxHealth=200
     MashadarMinHealth=150
     GuardRadius=1000.000000
     SealGuardRadius=1000.000000
     Team=255
     DieHardThreshold=25
     HitHardThreshold=25
     RemoteRole=ROLE_None
}
