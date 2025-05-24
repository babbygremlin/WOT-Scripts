//------------------------------------------------------------------------------
// ReflectorInstaller.uc
// $Author: Mfox $
// $Date: 1/05/00 2:27p $
// $Revision: 2 $
//
// Description:	Installs Reflectors in the castor.
//------------------------------------------------------------------------------
// How to use this class:
//
// + Subclass.
// + Set ReflectorClass in default proporties.
// + Set Duration in default proporties -- Dur==0 means that the Reflector
//   will never uninstall itself.
// + Any other funky stuff you want to do.
// + Don't forget to set up the AngrealInventory related default proporties.
//------------------------------------------------------------------------------
// How this class works:
//
//------------------------------------------------------------------------------
class ReflectorInstaller expands AngrealInventory;

// How long does this effect last?
// This number gets used for all the reflectors installed.
// That way they will all get uninstalled at the same time.
var() float Duration;
//var float NextCastTime;

// The reflector to install. 
var() class<Reflector> ReflectorClasses[10];

// The type of Installer to use.
var() class<InstallReflectorEffect> InstallRefEffectClass;

// Our persistant installer.
var InstallReflectorEffect Installer;

function Cast()
{
	local int i;
/*
	// Enforce duration.
	if( Level.TimeSeconds < NextCastTime )
		return;

	NextCastTime = Level.TimeSeconds + Duration;
*/
	Installer = InstallReflectorEffect( class'Invokable'.static.GetInstance( Self, InstallRefEffectClass ) );
	Installer.SetSourceAngreal( Self );

	// Set its victim to be our owner so the reflectors will be 
	// installed in him/her.
	Installer.SetVictim( Pawn(Owner) );
	
	for( i = 0; 
	     i < ArrayCount(ReflectorClasses) &&
		 ReflectorClasses[i] != None; 
		 i++ )
	{
		// Initialize it with the appropriate Reflector and lifespan
		Installer.Initialize( ReflectorClasses[i], Duration );
	
		
		// Pass it off to our owner for processing.
		if( WOTPlayer(Owner) != None )
		{
			WOTPlayer(Owner).ProcessEffect( Installer );
		}
		else if( WOTPawn(Owner) != None )
		{
			WOTPawn(Owner).ProcessEffect( Installer );
		}
	}

	Super.Cast();
	UseCharge();
}
/*
//------------------------------------------------------------------------------
function float GetPriority()
{
	if( Level.TimeSeconds < NextCastTime )
	{
		return 0.0;
	}
	else
	{
		return Super.GetPriority();
	}
}
*/

defaultproperties
{
     InstallRefEffectClass=Class'Angreal.InstallReflectorEffect'
     Priority=20.000000
}
