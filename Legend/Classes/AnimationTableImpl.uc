//=============================================================================
// AnimationTableImpl.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 8 $
//=============================================================================

class AnimationTableImpl expands AnimationTableInterf abstract;

#exec Texture Import File=Textures\S_AnimationTable.pcx GROUP=Icons Name=S_AnimationTable Mips=Off Flags=2

var(WOTAnims) AnimInfoT		AnimList[50];		// list of all anims for this class

enum EAnimPlayType
{
	APT_Play,
	APT_Loop,
	APT_TweenPlay,
	APT_TweenLoop,
	APT_Tween,
};



static function bool AnimIsValidForGameType( Actor SourceActor, EGameType GameType )
{
	return true;
}



static function ProcessAnim( Actor SourceActor, int SelectedIndex, float Multiplier, float TweenToTime, EAnimPlayType AnimPlayType )
{
	local float AnimRate; 
//	local string strType; // testing

	AnimRate = default.AnimList[SelectedIndex].EAnimInfo.AnimRate;
	if( AnimRate ~= 0.0 )
	{
		AnimRate = DefaultAnimRate;
	}

	if( TweenToTime ~= 0.0 )
	{
		// use properties tween to time
		TweenToTime = default.AnimList[SelectedIndex].EAnimInfo.AnimTweenToTime;

		if( TweenToTime ~= 0.0 )
		{
			// not set in properties use default
			TweenToTime = DefaultAnimTweenToTime;
		}
	}

	switch( AnimPlayType )
	{
		case APT_Play:
			SourceActor.PlayAnim( default.AnimList[SelectedIndex].EAnimInfo.AnimName, Multiplier*AnimRate );
			break;

		case APT_Loop: 
			SourceActor.LoopAnim( default.AnimList[SelectedIndex].EAnimInfo.AnimName, Multiplier*AnimRate );
			break;

		case APT_TweenPlay:
			SourceActor.PlayAnim( default.AnimList[SelectedIndex].EAnimInfo.AnimName, Multiplier*AnimRate, TweenToTime );
			break;

		case APT_TweenLoop: 
			SourceActor.LoopAnim( default.AnimList[SelectedIndex].EAnimInfo.AnimName, Multiplier*AnimRate, TweenToTime  );
			break;

		case APT_Tween:
			SourceActor.TweenAnim( default.AnimList[SelectedIndex].EAnimInfo.AnimName, Multiplier*TweenToTime );
			break;

		default:
			SourceActor.Warn( "Bogus situation in ProcessAnim for " $ SourceActor.Name );
			break;
	}

/*
//testing-begin:
	strType = "None";
	switch( AnimPlayType )
	{
		case APT_Play:
			strType = "Play";
			break;

		case APT_Loop: 
			strType = "Loop";
			break;

		case APT_TweenPlay:
			strType = "TweenPlay";
			break;

		case APT_TweenLoop: 
			strType = "TweenLoop";
			break;

		case APT_Tween:
			strType = "Tween";
			break;

		default:
			SourceActor.Warn( "Bogus situation in ProcessAnim for " $ SourceActor.Name );
			break;
	}

	if( SourceActor.IsA( 'PlayerPawn' ) && ( instr(Caps(string(SourceActor)), "ENTRY") == -1 ) )
	{
		SourceActor.log( SourceActor.Level.TimeSeconds $ ": " $ SourceActor $ " (" $ SourceActor.Mesh $ ")" $ " " $ default.class $ ": " $ strType $ ": " $ default.AnimList[SelectedIndex].EAnimInfo.AnimName $ " Rate:" $ Multiplier*AnimRate );
	}
//testing-end:
*/
}



// filter has to leave at least one entry and must adjust MatchingEntries, NumMatchingAnims and TotalOdds if anything filtered
static function FilterMatchingAnims( Actor SourceActor, 
									 out int MatchingEntries[10], 
									 out int NumMatchingAnims, 
								     out float TotalOdds, 
									 name LookupName );



static function int PickRandomSlotAnim( Actor SourceActor, name LookupName, bool bNotSlot )
{
	local int AnimIndex;
	local int NumMatchingAnims;
	local float TotalOdds;
	local float RandVal;
	local int MatchingEntries[10];
	local Name CurrentName;
	local int SelectedIndex;
	local int MaxMatchingAnims;

	NumMatchingAnims = 0;
	TotalOdds = 0.0;
	SelectedIndex = -1;
	MaxMatchingAnims = ArrayCount(default.AnimList);
	for( AnimIndex=0; AnimIndex<MaxMatchingAnims; AnimIndex++ )
	{
		if( bNotSlot )
		{
			// given name is a specific animation so look for this
			CurrentName = default.AnimList[AnimIndex].EAnimInfo.AnimName;

			if( CurrentName == LookupName )
			{
				MatchingEntries[NumMatchingAnims] = AnimIndex;
				TotalOdds += default.AnimList[AnimIndex].AnimOdds;
				NumMatchingAnims++;

				// done -- should only be 1 match
				break;
			}
		}
		else
		{
			// given name is for a slot -- look for matching slots
			CurrentName = default.AnimList[AnimIndex].AnimSlot;

			if( CurrentName == LookupName && 
				AnimIsValidForGameType( SourceActor, default.AnimList[AnimIndex].GameType ) )
			{
				// slot name isn't empty and it matches given slot name and
				// Anim is allowed for the current type of game
				MatchingEntries[NumMatchingAnims] = AnimIndex;
				TotalOdds += default.AnimList[AnimIndex].AnimOdds;
				NumMatchingAnims++;

				if( NumMatchingAnims >= MaxMatchingAnims )
				{
					break;
				}
			}
		}
	}

	if( NumMatchingAnims >= 1 && TotalOdds >= 0.0 )
	{
		if( NumMatchingAnims == 1 )
		{
			// Special case: if only 1 Anim, it's odds determine whether it
			// is played at all. This makes an AnimSlotTimerList unnecessary.
			// If bNotSlot is set, always select this anim (ignore odds -- 
			// these were used when *picking* the anim).
			if( bNotSlot || (FRand() < TotalOdds) )
			{
				SelectedIndex = MatchingEntries[0];
			}
		}
		else
		{
			// 2 or more anims and one of these will be used
			FilterMatchingAnims( SourceActor, MatchingEntries, NumMatchingAnims, TotalOdds, LookupName );

			if( NumMatchingAnims == 1 )
			{
				// anims must have been filtered -- must play the only remaining anim
				RandVal = 0.0;
			}
			else
			{
				RandVal = FRand() * TotalOdds;
			}

			TotalOdds = 0.0;
			for( AnimIndex=0; AnimIndex<NumMatchingAnims; AnimIndex++ )
			{
				TotalOdds += default.AnimList[ MatchingEntries[AnimIndex] ].AnimOdds;

				if( TotalOdds >= RandVal )
				{
					SelectedIndex = MatchingEntries[AnimIndex];
					break;
				}
			}

			// note: this test should go here -- its possible for there to 
			// be no selected anim in the above branch
			if( SelectedIndex == -1 )
			{
				SourceActor.Warn( "PlayRandomSlotAnim: no animation selected for: " $ LookupName $ "(" $ bNotSlot $ ")" );
			}
		}
	}
	else
	{
		// error: no Anims for the given slot found in the AnimTable or odds total 0.0

		if( NumMatchingAnims == 0 )
		{
	  		SourceActor.Warn( "No " $ LookupName $ " slot for " $ SourceActor.Name );
		}
		else
		{
			SourceActor.Warn( "PlayRandomSlotAnim: total odds for " $ LookupName $ " are <= 0.0 for " $ default.Name );
		}
	}

	return SelectedIndex;
}



static function ProcessRandomSlotAnim( Actor SourceActor, name LookupName, float Multiplier, float TweenToTime, EAnimPlayType AnimPlayType, bool bNotSlot )
{
	local int SelectedIndex;

	SelectedIndex = PickRandomSlotAnim( SourceActor, LookupName, bNotSlot );

	if( SelectedIndex != -1 )
	{
		ProcessAnim( SourceActor, SelectedIndex, Multiplier, TweenToTime, AnimPlayType );
	}
}



static function ProcessSlotAnim( Actor SourceActor, name LookupName, float Multiplier, float TweenToTime, EAnimPlayType AnimPlayType, bool bNotSlot )
{
	if( LookupName != '' )
	{
		if( Multiplier ~= 0.0 )
		{
			Multiplier = 1.0;
		}

	 	ProcessRandomSlotAnim( SourceActor, LookupName, Multiplier, TweenToTime, AnimPlayType, bNotSlot );
	}
	else
	{
		class'util'.static.BMWarnR( SourceActor, " PlaySlotAnim: no slot given!" );
	}
}



static function PlaySlotAnim( Actor SourceActor, name LookupName, optional float RateMultiplier, optional bool bNotSlot )
{
	ProcessSlotAnim( SourceActor, LookupName, RateMultiplier, 0.0, APT_Play, bNotSlot  );
}



static function LoopSlotAnim( Actor SourceActor, name LookupName, optional float RateMultiplier, optional bool bNotSlot )
{
	ProcessSlotAnim( SourceActor, LookupName, RateMultiplier, 0.0, APT_Loop, bNotSlot  );
}



static function TweenPlaySlotAnim( Actor SourceActor, name LookupName, optional float RateMultiplier, optional float TweenToTime, optional bool bNotSlot )
{
	ProcessSlotAnim( SourceActor, LookupName, RateMultiplier, TweenToTime, APT_TweenPlay, bNotSlot  );
}



static function TweenLoopSlotAnim( Actor SourceActor, name LookupName, optional float RateMultiplier, optional float TweenToTime, optional bool bNotSlot )
{
	ProcessSlotAnim( SourceActor, LookupName, RateMultiplier, TweenToTime, APT_TweenLoop, bNotSlot  );
}



static function TweenSlotAnim( Actor SourceActor, name LookupName, optional float TweenToTime, optional bool bNotSlot )
{
	ProcessSlotAnim( SourceActor, LookupName, 1.0, TweenToTime, APT_Tween, bNotSlot );
}



static function CheckAnim( Actor SourceActor, Name Anim )
{
	local int NumFrames;
	local string WarnString;

	NumFrames = SourceActor.GetAnimFrames( Anim );

	if( NumFrames == 0 )
	{
		WarnString = "CheckAnim: WARNING sequence " $ Anim $ " not found in " $ SourceActor.Name $ "!";

		SourceActor.warn( WarnString );
	}
}



static function PerformSelfTest( Actor SourceActor )
{
	local int AnimIndex;

	class'util'.static.BMLog( SourceActor, "" );
	class'util'.static.BMLog( SourceActor, default.Class $ " AnimTable self-test begin!" );

	for( AnimIndex=0; AnimIndex<ArrayCount(default.AnimList); AnimIndex++ )
	{
		if( default.AnimList[AnimIndex].AnimSlot != '' /*&& (AnimList[AnimIndex].GameType != GT_None)*/ )
		{
			CheckAnim( SourceActor, default.AnimList[AnimIndex].EAnimInfo.AnimName );
  		}
  	}
	class'util'.static.BMLog( SourceActor, default.Class $ " AnimTable self-test end!" );
	class'util'.static.BMLog( SourceActor, "" );
}

//=============================================================================
// See comments in AnimationTableInterf.uc.

static function Name PickSlotAnim( Actor SourceActor, name LookupName )
{
	local int SelectedIndex;

	SelectedIndex = PickRandomSlotAnim( SourceActor, LookupName, false );

	if( SelectedIndex != -1 )
	{
		return default.AnimList[ SelectedIndex ].EAnimInfo.AnimName;
	}
	else
	{
		return '';
	}
}

defaultproperties
{
     Texture=Texture'Legend.Icons.S_AnimationTable'
}
