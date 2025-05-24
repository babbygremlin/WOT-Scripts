//=============================================================================
// GenericDamageHelper.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//=============================================================================

class GenericDamageHelper expands LegendActorComponent;

#exec Texture Import File=Textures\S_DamageHelper.pcx GROUP=Icons Name=S_DamageHelper Mips=Off Flags=2

//=============================================================================
// GenericDamageHelper:
//
// Provides support for creature/damagetype-specific damage effects whenever
// a pawn takes damage. (TBD: this definitely includes when the pawn is hit
// by a projectile, but do we want to include damage from falling, traps etc.
// here?). At present, any action which results in a call to TakeDamage for
// a pawn and a subsequent call to TakeHit (i.e. the Pawn really does get
// damaged/hit) will result in a call to the HandleDamage function implemented
// below. If the given DamageName has been given a specific effect in the
// properites this will be used, otherwise the default effect will be used.
//
// Damage effects are specified through properties associated
// with this class (see below). These can be edited either in the .uc file for
// this (or a derived) class, or through properties in UnrealEd. Effects
// are specified through the DamageEffects properties. See the
// DamageInfoT structure definition below for a description of each of the
// fields.
//
// The properties for this class should become fairly static at some point.
// To have creature-specific effects, subclass this class and make
// any necessary changes to the subclass. Set the DamageHelperClass field
// for Pawn classes which should use the new subclass to the name of the new
// subclass.
//
// For example, to have specific damage effects for the Minion:
//
// 1) Create a class called NPCMinionDamageHelper (this is the naming 
// convention which I've been using) which expands this class. 
//
// 2) Either edit the default properties section or open up UnrealEd and glom 
// in the damage types which you want to handle/override. IMO, the easiest way
// to do this, at least to get things set up is to cut and paste the default 
// DamageEffects properties for this class into the new class then edit things 
// as needed and rebuild the package which the new class resides in. For small 
// tweaks, using UnrealEd may be your best bet.
//
// 3) Set the DamageHelperClass for the Minion (in the Minion properties) to
// NPCMinionDamageHelper.
//
// Note that the GenericDamageHelper is accessed through the Pawn's 
// AssetsHelper member which contains the name of the GenericAssetsHelper class 
// to use. The GenericAssetsHelper class is basically a wrapper for the 
// GenericDamageHelper and other assets-related classes.
//
// Every Pawn in a level will have its own (unique) instance of a
// GenericAssetsHelper, but all Pawns of the same class will share the 
// common GenericDamageHelper for that class. 
//
// The GetInstance function in the GenericDamageHelper class ensures that 
// only a single instance of each type of GenericDamageHelper is created.
//
// Currently the damage effect to use is identified through the
// DamageName parameter passed to the HandleDamage function. If the given
// type isn't (yet?) handled, the default damage effect will be used.
//=============================================================================
//
//=============================================================================
// Additional Notes
//
// Groups of similar damage effects (e.g. 4 'burned' effects) can be given odds
// in the DamageInfo properites, but these aren't used at present (each effect
// is just as likely to be used as the others).
//=============================================================================

const MaxMatches			= 2;		// up to this many effects per damage type 

struct DamageInfoT
{
	var() Name				Name;							// type of damage (from list above)
	var() string			EffectName;						// if set, name of class to spawn
};

var(WOTDamage)	DamageInfoT	DamageEffects[32];				// 32 per PC/NPC should be plenty!
var(WOTDamage)  float       DamageEffectOffsetMult;			// multiplier for offset of damage location along vector from actor location to hit location
var(WOTDamage)  float       DamageClampMin;					// clamp min damage for scaling blood volume
var(WOTDamage)  float       DamageClampMax;					// clamp max damage for scaling blood volume
var(WOTDamage)  float		BaseDamageLevel;				// blood volume is scaled around this amount of damage

//=============================================================================

static function DoDamageEffects( Actor A, float Damage, vector HitLocation, class<Actor> EffectC )
{
	local Actor AEffect;
	local ParticleSprayer Sprayer;
	local Vector EffectVector;
	local Rotator EffectRotation;
	local Vector DirectionVector;

	if( EffectC != None )
	{
		// set the rotation so effect sprays along vector from center of actor through hit location?
		EffectVector		= HitLocation - A.Location;
		DirectionVector		= Normal(EffectVector);
		DirectionVector.Z	= 0.707; // angle spray upward at 45 degrees
		EffectRotation		= rotator( DirectionVector );

		// spawning at the hit location is problematic -- blood often seems 
		// to come out of thin air -- so spawn at center of hit actor +
		// PC/NPC-specific offset along vector towards hit location?

		AEffect = A.Spawn( EffectC,,, A.Location + VSize(EffectVector)*default.DamageEffectOffsetMult*Normal(EffectVector), EffectRotation ); 

		Sprayer = ParticleSprayer(AEffect);

		if( Sprayer != None)
		{
			// in case the effect lasts for a while, make sure the effect follows the pawn around
			// Sprayer.SetFollowActor( A );

			// volume is proportional to damage done as a percent of creature's initial health

			// make sure damage done isn't ridiculous ==> too many decals
			Damage = Clamp( Damage, default.DamageClampMin, default.DamageClampMax );

			Sprayer.Volume = (Damage/default.BaseDamageLevel) * Sprayer.default.Volume;
		}
	}

	if( Pawn(A) != None && Pawn(A).HeadRegion.Zone.bWaterZone )
	{
		A.Spawn( class'BubbleSpawner', A,, A.Location, A.Rotation );
	}
}

//=============================================================================
// LookUpDamage:

static function int LookUpDamage( Name DamageName )
{
	local int Index;
	local int NumMatches;
	local int Matches[4]; // should match MaxMatches above &%&^%* lack of constants for array sizes
	local int RetVal;
	
	RetVal = -1;
	if( DamageName != '' )
	{
		// need to identify all entries which match given DamageName
		for( Index=0; Index<ArrayCount(default.DamageEffects) && NumMatches<MaxMatches; Index++ )
		{
			if( default.DamageEffects[Index].Name == DamageName )
			{
				Matches[NumMatches++] = Index;
			}
		}
	
		// pick one of the choices randomly (odds not used)
		if( NumMatches != 0 )
		{
			Index = Rand( NumMatches );
			RetVal = Matches[Index];
		}
	}
	
	return RetVal;
}	

//=============================================================================
// GetDamageParameters:
// 
// If the damage type isn't found defaults to using the default damage effect.

static function bool GetDamageParameters( Name DamageName, out class<Actor> Effect )
{
	local int Index;

	Index = LookUpDamage( DamageName );
		
	if( Index != -1 )
	{
		Effect	= class<Actor>( DynamicLoadObject( default.DamageEffects[Index].EffectName, class'Class' ) );
		return true;
	}
	else
	{
		// zapped warning -- angreal now uses elemental damage names which aren't recognized
		// warn( "LookUpDamage -- no entry matches: " $ DamageName );

		// use default effect (entry 0)
		Effect	= class<Actor>( DynamicLoadObject( default.DamageEffects[0].EffectName, class'Class' ) );
		return true;
	}
	
	return false;
}

//=============================================================================
// Find entry(entries) in DamageEffects which match the given DamageName (if 
// any) then spawn the effect class.

static function HandleDamage( Actor A, float Damage, vector HitLocation, name DamageName )
{
	local class<Actor> EffectC;

	if( DamageName == '' )
	{
		// warn( "HandleDamage -- DamageName not set!" );
	}

	if( GetDamageParameters( DamageName, EffectC ) )
   	{
		DoDamageEffects( A, Damage, HitLocation, EffectC );
	}
}

//=============================================================================

defaultproperties
{
     DamageEffects(0)=(Name=Default,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(1)=(Name=blown,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(2)=(Name=blownup,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(3)=(Name=burned,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(4)=(Name=exploded,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(5)=(Name=chopped,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(6)=(Name=pierced,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(7)=(Name=skewered,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(8)=(Name=sliced,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(9)=(Name=diced,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(10)=(Name=jabbed,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(11)=(Name=shot,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(12)=(Name=punched,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(13)=(Name=cutup,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(14)=(Name=swiped,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(15)=(Name=slashed,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(16)=(Name=hacked,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(17)=(Name=whipped,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(18)=(Name=Fell,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(19)=(Name=tossed,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(20)=(Name=continuous,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(21)=(Name=hurt,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(22)=(Name=balefired,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(23)=(Name=stomped,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(24)=(Name=smashed,EffectName="ParticleSystems.BloodDamageRed1")
     DamageEffects(25)=(Name=Drowned)
     DamageEffectOffsetMult=0.500000
     DamageClampMax=500.000000
     BaseDamageLevel=25.000000
     Texture=Texture'WOT.Icons.S_DamageHelper'
}
