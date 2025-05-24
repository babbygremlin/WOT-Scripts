//=============================================================================
// SealAltar.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 13 $
//=============================================================================
class SealAltar expands KeyPoint;

#exec AUDIO IMPORT FILE=Sounds\Notification\PlaceSeal.wav	GROUP=Notification
#exec AUDIO IMPORT FILE=Sounds\Notification\CaptureSeal.wav	GROUP=Notification

var() byte Team;		// =255 don't care, otherwise limit access
var() int SealGoal;		// number of seals that must be placed to win the game
var() name WinEvent;	// event triggered when AnnounceWinningTeam is called

var BattleInfo Battle;

var seal Seals[4];

var localized String CaptureNotificationStr;

function PreBeginPlay()
{
	// make sure the goal is achievable
	assert( SealGoal <= ArrayCount(Seals) );

	Super.PreBeginPlay();
}

function PostBeginPlay()
{
	local BattleInfo B;

	Super.PostBeginPlay();

	// identify the battle configuration data for this game
	foreach AllActors( class'BattleInfo', B )
	{
		Battle = B;
		break;
	}
	if( Battle == None )
	{
		warn( Self$".PostBeginPlay() unable to locate BattleInfo object within this level." );
	}

}

function Reset( int Count )
{
	local int i;

	for( i = 0; i < ArrayCount(Seals); i++ )
	{
		if( Seals[i] != None )
		{
			Seals[i].Destroy();
			Seals[i] = None;
		}
	}

	Battle.ResetTeamSealCount( Team );

	SealGoal = Count;
}

function bool CheckForWinner()
{
	local int i, Count;

	if( Battle != None )
	{
		Count = Battle.GetTeamSealCount( Team );
	}
	else
	{
		Count = 0;
		for( i = 0; i < ArrayCount(Seals); i++ )
		{
			if( Seals[i] != None )
			{
				Count++;
			}
		}
	}

	return Count >= SealGoal;
}

function PlaceSeal( seal Seal, optional bool bForce )
{
	local int i;
	local WOTPlayer Player;
	
	Player = WOTPlayer(Seal.Owner);

    // Only accept seals from altar's team
	if( !bForce && Team != 255 && ( Player == None || Player.PlayerReplicationInfo.Team != Team ) )
        return;

	for( i = 0; i < ArrayCount(Seals); i++ )
	{
		if( Seals[i] == None )
		{
			if( Player != None )
			{
        		Pawn(Seal.Owner).DeleteInventory( Seal );
			}
       	
			// center seals on the altar filling in from left to right
			Seal.SetLocation( 
				Location 
				+ ( CollisionHeight + Seal.CollisionHeight / 2 ) * vect(0,0,1) 
				+ vector(Rotation) * Seal.default.CollisionRadius * ( i * 2 - ( SealGoal-1 ) ) 
			);
			Seal.SetRotation( Rotation );

			Seal.bHeldItem = false; // added to fix Seal disappearing after 45s problem
			Seal.RespawnTime = 0.0; // don't respawn
			Seal.GotoState( 'PickUp', 'Dropped' );
            Seal.SetPhysics( PHYS_None ); // don't rotate on altars
			Seal.SetCollision( false, false, false ); // use the altar to pick up the seal
            Seal.RemoteRole = ROLE_DumbProxy; // transmit position from server to client
            Seal.SetOwner( Self );

			if( Seal.ControllingTeam == Team )
			{
				PlaySound( Sound'WOT.Notification.PlaceSeal' );
			}
			else if( !bForce )
			{
				SendCaptureNotification( Player );
			}
			Seal.SetControllingTeam( Player );

			Seals[i] = Seal;

			break;
		}
	}
}

function SendCaptureNotification( WOTPlayer Player )
{
	local Pawn P;

	for( P = Level.PawnList; P != None; P = P.nextPawn )
	{
		if( WOTPlayer(P) != None )
		{
			WOTPlayer(P).ClientPlaySound( Sound'WOT.Notification.CaptureSeal' );
			WOTPlayer(P).CenterMessage( Player.TeamDescription $ CaptureNotificationStr,, true );
		}
	}
}

function Seal FindSeal()
{
	local int i;
	local seal S;
	
	// find the last seal on the altar
	for( i = ArrayCount(Seals) - 1; i >= 0; i-- )
	{
		if( Seals[i] != None )
		{
			return Seals[i];
		}
	}
	
	return None;
}

function RemoveSeal( Seal S )
{
	local int i;

	for( i = ArrayCount(Seals) - 1; i >= 0; i-- )
	{
		if( Seals[i] == S )
		{
			Seals[i] = None;
			break;
		}
	}
}

function AnnounceWinningTeam()
{
	local SealAltar A;

	foreach AllActors( class'SealAltar', A )
		A.GotoState( 'GameEnded' );

	if( giMPBattle(Level.Game) != None )
		giMPBattle(Level.Game).WinningTeam = Team;

	Level.Game.EndGame( "AltarFilled" );
}

auto state Active
{
	function bool ValidSealTouch( Pawn P, Seal S )
	{
		return Level.Game.PickupQuery( P, S );
	}

	function Touch( actor Other )
	{
		local WOTPlayer Player;
		local seal Seal;
		local Actor A;

		Player = WOTPlayer(Other);

		// ignore collisions with all non-player objects
		if( Player == None )
			return;

		// get the seal from the pawn (if he has one)
		Seal = Seal(Player.FindInventoryType( class'Seal' ));
		if( Seal != None )
		{
			// Trigger this event any time a seal is placed
			if( Event != '' )
			{
				foreach AllActors( class 'Actor', A, Event )
				{
					A.Trigger( Self, Player );
				}
			}

			PlaceSeal( Seal );
            class'Util'.static.TriggerAllInstances( Seal, class'Pawn', None, Seal.OwnershipChangedEvent );
            if( CheckForWinner() )
			{
				// trigger the WinEvent when this team wins
				if( WinEvent != '' )
				{
					foreach AllActors( class 'Actor', A, WinEvent )
					{
						A.Trigger( Self, Player );
					}
				}

				AnnounceWinningTeam();
			}
            else
			{
				// "de-bounce" seal handling behavior
                GotoState( 'Inactive' );
			}
		}
		else
		{
			// if the pawn isn't carrying a seal, and there's a seal on the altar, give it to him
			Seal = FindSeal();
			if( Seal != None )
			{
				// disallow pickups if the game isn't ready
				if( ValidSealTouch( Player, Seal ) )
				{
					// give the seal to the pawn
					RemoveSeal( Seal );
					Seal.Touch( Player );
					GotoState( 'Inactive' );
				}
			}
		}
	}
}

state Inactive
{
Begin:
	Sleep( 1.0 );
	GotoState( 'Active' );
}

state GameEnded
{
}

// end of SealAltar.uc

defaultproperties
{
     Team=255
     SealGoal=4
     CaptureNotificationStr=" captured a seal."
     bStatic=False
     bNoDelete=True
     bDirectional=True
     bEdShouldSnap=True
     CollisionRadius=48.000000
     CollisionHeight=1.000000
     bCollideActors=True
     bCollideWorld=True
}
