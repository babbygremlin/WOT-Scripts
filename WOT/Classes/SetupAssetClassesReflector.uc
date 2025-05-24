//==============================================================================
// SetupAssetClassesReflector.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 3 $
//==============================================================================

class SetupAssetClassesReflector expands Reflector;

/*==============================================================================
Sets up asset helper classes (used for playing texture-specific sounds and 
effects) and sound table classes (used for playing all other sounds for 
PCs/NPCs).

Should NOT uninstall itself because the player can change his/her class etc.
at any time and this reflector is needed to support this.
==============================================================================*/

function SetupAssetClasses()
{
	if( WOTPlayer(Owner) != None || WOTPawn(Owner) != None )
	{
		SetupAssetHelper();

		SetupSoundTables();
	}

	Super.SetupAssetClasses();
}

//==============================================================================

function SetupAssetHelper()
{
	if( WOTPlayer(Owner) != None )
	{
		WOTPlayer(Owner).AssetsHelper = Spawn( Class'GenericAssetsHelper', Owner );
		WOTPlayer(Owner).AssetsHelper.AssignTextureHelper( WOTPlayer(Owner).TextureHelperClass );
		WOTPlayer(Owner).AssetsHelper.AssignDamageHelper( WOTPlayer(Owner).DamageHelperClass );
	}
	else
	{
		WOTPawn(Owner).AssetsHelper = Spawn( Class'GenericAssetsHelper', Owner );
		WOTPawn(Owner).AssetsHelper.AssignTextureHelper( WOTPawn(Owner).TextureHelperClass );
		WOTPawn(Owner).AssetsHelper.AssignDamageHelper( WOTPawn(Owner).DamageHelperClass );
	}
}

/*==============================================================================

==============================================================================*/

function SetupSoundTables()
{
	local SoundTableWOT						SoundTable;
	local class<SoundTableWOT>				SoundTableClass;
	local SoundSlotTimerListInterf			SoundSlotTimerList;
	local class<SoundSlotTimerListInterf>	SoundSlotTimerListClass;
	local Actor A;
	
	if( WOTPlayer(Owner) != None )
	{
		SoundTableClass			= WOTPlayer(Owner).SoundTableClass;
		SoundSlotTimerListClass = WOTPlayer(Owner).SoundSlotTimerListClass;
	}
	else
	{
		SoundTableClass			= WOTPawn(Owner).SoundTableClass;
		SoundSlotTimerListClass = WOTPawn(Owner).SoundSlotTimerListClass;
	}

	if( SoundTableClass != None )
	{
		A = None;

		// 1) try finding a SoundTable with a Tag that matches the Owner's tag
		foreach AllActors( SoundTableClass, A, Owner.Tag )
		{
			break;
		}

		if( A == None )
		{
			// 2) try finding a SoundTable with a Tag that matches the Owner's class
			foreach AllActors( SoundTableClass, A )
			{
				if( Owner.IsA( A.Tag ) )
				{
					break;
				}
				else
				{
					A = None;
				}
			}
		}
	
		if( A == None )
		{
			// 3) get standard soundtable for class (might exist already)
			SoundTable = SoundTableWOT( SoundTableClass.static.GetInstance( Owner ) );
			
			if( SoundTable == None )
			{
				warn( "SetupSoundTables: error assigning sound table for: " $ Owner );
			}
		}
		else
		{
			// use the existing SoundTable
			SoundTable = SoundTableWOT( A );
		}
	}
	else
	{
		warn( "SetupSoundTables: SoundTableClass is None for: " $ Owner );
	}

	if( SoundSlotTimerListClass != None )
	{	
		A = None;

		// 1) try finding a SoundSlotTimerList with a Tag that matches the Owner's tag
		foreach AllActors( SoundSlotTimerListClass, A, Owner.Tag )
		{
			break;
		}
	
		if( A == None )
		{
			// 2) try finding a SoundSlotTimerList with a Tag that matches the Owner's class
			foreach AllActors( SoundTableClass, A )
			{
				if( Owner.IsA( A.Tag ) )
				{
					break;
				}
				else
				{
					A = None;
				}
			}
		}

		if( A == None )
		{
			// create an instance of the class' SoundSlotTimerList
			SoundSlotTimerList = Spawn( SoundSlotTimerListClass );
			
			if( SoundSlotTimerList == None )
			{
				warn( "SetupSoundTables: error assigning sound slot timer list for: " $ Owner );
			}
		}
		else
		{
			// use the existing SoundSlotTimerList
			SoundSlotTimerList = SoundSlotTimerListInterf( A );
		}
	}
	
	// set owner
	if( WOTPlayer(Owner) != None )
	{
		WOTPlayer(Owner).SetSoundTable( SoundTable );
		WOTPlayer(Owner).SetSoundSlotTimerList( SoundSlotTimerList );
	}
	else
	{
		WOTPawn(Owner).SetSoundTable( SoundTable );
		WOTPawn(Owner).SetSoundSlotTimerList( SoundSlotTimerList );
	}
}

//==============================================================================

defaultproperties
{
     bRemovable=False
     bDisplayIcon=False
}
