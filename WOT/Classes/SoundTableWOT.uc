//=============================================================================
// SoundTableWOT.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 2 $
//=============================================================================

class SoundTableWOT expands SoundTableImpl abstract;

// NOTE: slots which are added here should also go into VerifySlot for testing
// and the following constant should be updated to reflect the number of slots.
const NumSoundTableSlots				= 46;

// WOTPlayers
const NumTauntSoundSlots				= 6;

const Taunt1SoundSlot					= 'Taunt1';					// player taunts
const Taunt2SoundSlot					= 'Taunt2';
const Taunt3SoundSlot					= 'Taunt3';
const Taunt4SoundSlot					= 'Taunt4';
const Taunt5SoundSlot					= 'Taunt5';
const Taunt6SoundSlot					= 'Taunt6';

// WOTPlayers and WOTPawns
const DieHardSoundSlot					= 'DieHard';				// cool movie
const DieSoftSoundSlot					= 'DieSoft';
const DrownSoundSlot					= 'Drown';
const GaspSoundSlot						= 'Gasp';
const HitHardSoundSlot					= 'HitHard';
const HitSoftSoundSlot					= 'HitSoft';
const JumpSoundSlot						= 'Jump';
const LandHardSoundSlot					= 'LandHard';
const LandSoftSoundSlot					= 'LandSoft';

// Grunts
const AcceptOrdersSoundSlot				= 'AcceptOrders';
const AcquiredSoundSlot					= 'Acquired';				// played before attacking 
const AwaitingOrdersSoundSlot       	= 'AwaitingOrders';
const BreathSoundSlot					= 'Breath';
const LookSoundSlot  					= 'Look';
const MeleeKilledEnemyTauntSoundSlot	= 'MeleeKilledEnemyTaunt';	// reaction to killing enemy
const MeleeHitEnemyTauntSoundSlot  		= 'MeleeHitEnemyTaunt';		// reaction to hitting enemy with melee weapon (e.g. laugh)
const Misc1SoundSlot		  			= 'Misc1';	   				// misc slot #1
const Misc2SoundSlot		  			= 'Misc2';	   				// misc slot #2
const Misc3SoundSlot		  			= 'Misc3';	   				// misc slot #3
const Misc4SoundSlot		  			= 'Misc4';	   				// misc slot #4
const Misc5SoundSlot		  			= 'Misc5';	   				// misc slot #5
const PatrolSoundSlot					= 'Patrol';				
const ShowRespectSoundSlot   			= 'ShowRespect';			// cower/salute/curtsy etc.
const SearchingSoundSlot				= 'Searching';				
const SeeEnemySoundSlot					= 'SeeEnemy';				
const SeekingRefugeSoundSlot			= 'SeekingRefuge';			
const WaitingRandomSoundSlot			= 'WaitingRandom';			// random sounds when waiting

// Captains
const GiveOrdersSoundSlot				= 'GiveOrders';				
const OrderGetHelpSoundSlot        		= 'OrderGetHelp';       
const OrderGuardSoundSlot				= 'OrderGuard';				
const OrderGuardSealSoundSlot			= 'OrderGuardSeal';
const OrderKillIntruderSoundSlot 		= 'OrderKillIntruder';
const OrderSoundAlarmSoundSlot   		= 'OrderSoundAlarm';		

// Champions
const RecoverSoundSlot					= 'Recover';				

// Weapons (played through Pawn code)
const WeaponMeleeAttackSoundSlot		= 'WeaponMeleeAttack';		// sound of sword slashes etc.
const WeaponMeleeHitEnemySoundSlot		= 'WeaponMeleeHitEnemy';	// sound of weapon hitting enemy

const WeaponMeleeDrawSoundSlot			= 'WeaponMeleeDraw';
const WeaponMeleeSheathSoundSlot		= 'WeaponMeleeSheath';
const WeaponRangedDrawSoundSlot			= 'WeaponRangedDraw';
const WeaponRangedSheathSoundSlot		= 'WeaponRangedSheath';



function bool SoundIsValidForGameType( Actor SourceActor, EGameType GameType )
{
	local bool bIsValid;

	switch( GameType )
	{
		case GT_All:
			bIsValid = true;
			break;

		case GT_SinglePlayer:
			bIsValid = !Level.Game.IsA( 'giCombatBase' );
			break;

		case GT_MultiPlayer:
			bIsValid = Level.Game.IsA( 'giCombatBase' );
			break;

		case GT_Battle:
			bIsValid = Level.Game.IsA( 'giMPBattle' );
			break;
			
		case GT_Battle:
			bIsValid = Level.Game.IsA( 'giMPArena' );
			break;
			
		case GT_None:
			bIsValid = false;
			break;

		default:
			warn( "SoundIsValidForGameType: invalid GameType" );
			bIsValid = true;
	}

	return bIsValid;
}



static function Name GetTauntSlot( int nIndex )
{
	if( nIndex == -1 )
	{
		nIndex = Rand( NumTauntSoundSlots ) + 1;
	}

	switch( nIndex )
	{
		case 1:
			return Taunt1SoundSlot;
		case 2:
			return Taunt2SoundSlot;
		case 3:
			return Taunt3SoundSlot;
		case 4:
			return Taunt4SoundSlot;
		case 5:
			return Taunt5SoundSlot;
		case 6:
			return Taunt6SoundSlot;
		default:
			return '';
	}
}



// testing:
function Name GetSlotFromIndex( int nIndex )
{
	local Name ReturnedName;

	switch( nIndex )
	{
		case 1:
			ReturnedName = Taunt1SoundSlot;
			break;
		case 2:
			ReturnedName = Taunt2SoundSlot;
			break;
		case 3:
			ReturnedName = Taunt3SoundSlot;
			break;
		case 4:
			ReturnedName = Taunt4SoundSlot;
			break;
		case 5:
			ReturnedName = Taunt5SoundSlot;
			break;
		case 6:
			ReturnedName = Taunt6SoundSlot;
			break;
		case 7:
			ReturnedName = DieHardSoundSlot;
			break;
		case 8:
			ReturnedName = DieSoftSoundSlot;
			break;
		case 9:
			ReturnedName = DrownSoundSlot;
			break;
		case 10:
			ReturnedName = GaspSoundSlot;
			break;
		case 11:
			ReturnedName = HitHardSoundSlot;
			break;
		case 12:
			ReturnedName = HitSoftSoundSlot;
			break;
		case 13:
			ReturnedName = JumpSoundSlot;
			break;
		case 14:
			ReturnedName = LandHardSoundSlot;
			break;
		case 15:
			ReturnedName = LandSoftSoundSlot;
			break;
		case 16:
			ReturnedName = AcceptOrdersSoundSlot;
			break;
		case 17:
			ReturnedName = AcquiredSoundSlot;
			break;
		case 18:
			ReturnedName = AwaitingOrdersSoundSlot;
			break;
		case 19:
			ReturnedName = BreathSoundSlot;
			break;
		case 20:
			ReturnedName = LookSoundSlot;
			break;
		case 21:
			ReturnedName = MeleeKilledEnemyTauntSoundSlot;
			break;
		case 22:
			ReturnedName = MeleeHitEnemyTauntSoundSlot;
			break;
		case 23:
			ReturnedName = Misc1SoundSlot;
			break;
		case 24:
			ReturnedName = Misc2SoundSlot;
			break;
		case 25:
			ReturnedName = Misc3SoundSlot;
			break;
		case 26:
			ReturnedName = Misc4SoundSlot;
			break;
		case 27:
			ReturnedName = Misc5SoundSlot;
			break;
		case 28:
			ReturnedName = PatrolSoundSlot;
			break;
		case 29:
			ReturnedName = ShowRespectSoundSlot;
			break;
		case 30:
			ReturnedName = SearchingSoundSlot;
			break;
		case 31:
			ReturnedName = SeeEnemySoundSlot;
			break;
		case 32:
			ReturnedName = SeekingRefugeSoundSlot;
			break;
		case 33:
			ReturnedName = WaitingRandomSoundSlot;
			break;
		case 34:
			ReturnedName = GiveOrdersSoundSlot;
			break;
		case 35:
			ReturnedName = OrderGetHelpSoundSlot;
			break;
		case 36:
			ReturnedName = OrderGuardSoundSlot;
			break;
		case 37:
			ReturnedName = OrderGuardSealSoundSlot;
			break;
		case 38:
			ReturnedName = OrderKillIntruderSoundSlot;
			break;
		case 39:
			ReturnedName = OrderSoundAlarmSoundSlot;
			break;
		case 40:
			ReturnedName = RecoverSoundSlot;
			break;
		case 41:
			ReturnedName = WeaponMeleeAttackSoundSlot;
			break;
		case 42:
			ReturnedName = WeaponMeleeHitEnemySoundSlot;
			break;
		case 43:
			ReturnedName = WeaponMeleeDrawSoundSlot;
			break;
		case 44:
			ReturnedName = WeaponMeleeSheathSoundSlot;
			break;
		case 45:
			ReturnedName = WeaponRangedDrawSoundSlot;
			break;
		case 46:
			ReturnedName = WeaponRangedSheathSoundSlot;
			break;
		default:
			Warn( Self $ "::GetSlotFromIndex: Invalid index!" );
			ReturnedName = '';
	}

	return ReturnedName;
}



// testing:
function bool VerifySlot( Name SoundSlot )
{
	local int Index;
	local bool bRetVal;

	bRetVal = false;
	for( Index=1; Index<=NumSoundTableSlots; Index++ )
	{
		if( GetSlotFromIndex( Index ) == SoundSlot )
		{
			bRetVal = true;
			break;
		}
	}

	return bRetVal;
}


// testing:
function bool VerifySlots()
{
	local Name SoundSlot;
	local int Index1;
	local int Index2;
	local bool bMatch;

	for( Index1=1; Index1<=NumSoundTableSlots; Index1++ )
	{
		SoundSlot = GetSlotFromIndex( Index1 );

		if( DoTestSlot(SoundSlot) )
		{
			bMatch = false;
			for( Index2=0; Index2<ArrayCount(SoundList); Index2++ )
			{
				if( SoundList[Index2].SoundSlot == SoundSlot )
				{
					bMatch = true;
					break;
				}
			}		
	
			if( !bMatch )
			{
	  			log( "  No " $ SoundSlot $ " slot for " $ Name );
			}
		}
	}
}



// testing:
function bool DoTestSlot( Name SoundSlot )
{
	local bool bRetVal;

	if( (instr( caps(string(Name)), "SOUNDTABLEAESSEDAI")   != -1 ) || 
		(instr( caps(string(Name)), "SOUNDTABLEFORSAKEN")   != -1 ) || 
		(instr( caps(string(Name)), "SOUNDTABLEHOUND")      != -1 ) || 
		(instr( caps(string(Name)), "SOUNDTABLEWHITECLOAK") != -1 ) )
	{
		switch( SoundSlot )
		{
			case Taunt1SoundSlot:
			case Taunt2SoundSlot:
			case Taunt3SoundSlot:
			case Taunt4SoundSlot:
			case Taunt5SoundSlot:
			case Taunt6SoundSlot:
			case DieHardSoundSlot:
			case DieSoftSoundSlot:
			case DrownSoundSlot:
			case GaspSoundSlot:
			case HitHardSoundSlot:
			case HitSoftSoundSlot:
			case JumpSoundSlot:
			case LandHardSoundSlot:
			case LandSoftSoundSlot:
				bRetVal = true;
				break;

			default:
				bRetVal = false;
		}
	}
	else
	{
		switch( SoundSlot )
		{
			// these slots should never apply to NPCs
			case Taunt1SoundSlot:
			case Taunt2SoundSlot:
			case Taunt3SoundSlot:
			case Taunt4SoundSlot:
			case Taunt5SoundSlot:
			case Taunt6SoundSlot:
			case Misc1SoundSlot:
			case Misc2SoundSlot:
			case Misc3SoundSlot:
			case Misc4SoundSlot:
			case Misc5SoundSlot:
				bRetVal = false;
				break;

			default:
				bRetVal = true;
		}
	}

	return bRetVal;
}

defaultproperties
{
}
