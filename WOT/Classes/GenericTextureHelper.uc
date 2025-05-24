//=============================================================================
// GenericTextureHelper.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 10 $
//=============================================================================

class GenericTextureHelper expands LegendActorComponent;

#exec Texture Import File=Textures\S_TextureHelper.pcx Name=S_TextureHelper GROUP=Icons Mips=Off Flags=2

//=============================================================================
// GenericTextureHelper:
//
// Provides support for texture specific sounds and effects when a Pawn moves
// (runs, walks, strafes, lands) on a surface.
//
// Each sound is played with slightly randomized volume and pitch in order to
// maximize the realism.
//
// The textures passed to this class originate in the WalkTexture event. You
// can use this event to track the texture which is currently under a Pawn.
// Note that when in the air, there is no current texture, so the landing 
// sound is played just after impact with the ground (the first non-None 
// texture event) as soon as the first non-None texture notification is
// received.
//
// Sounds and impact effects are specified through the properties associated
// with this class (see below). These can be edited either in this (or a
// derived) .uc file, or through the UnrealEd properties editor. Sounds and
// Effects are specified through the MovementEffects properties. See the
// EffectInfoT structure definition below for a description of each of the
// fields.
//
// If a new sound is added, it should be #exec'd in using the same format as
// is used for the sounds used in this class (see below). These should be 
// placed near the top of the file for the class which uses these sounds.
//
// It is possible that the per-sound Volume and Pitch fields may be removed.
// At present, the Odds fields are not used and may also be removed.
//
// The base volume and pitch multipliers can be used to control the overall
// volume and pitch for an entire GenericTextureHelper class. For example,
// for the BATrolloc, an early experiment with using the default sounds with
// slightly higher volume and slighely lower pitch was somewhat successful. 
// For the best results, the actual sounds themselves should either be 
// modified outside of the Unreal engine (e.g. with SoundForge) or replaced
// with more suitable sounds. 
//
// The identical sounds are used for all running and walking (with/without
// strafing and/or attacking) movements. If the Pawn's speed is less than
// RunningSoundSpeed, the volume of the sound is reduced by 
// WalkVolumeMultiplier. The values of PitchVariancePercent and 
// VolumeVariancePercent can be used to control how much the pitch and volume
// is randomly varied for each sound before playing it. Setting these to +/- 
// 30% and 50% respectively seems to work fairly well.
// 
// Unless the defaults for this class are changed, the properties for this 
// class will not normally be edited. Instead, subclass this class and make
// any necessary changes to the subclass. Set the TextureHelperClass field
// for Pawn classes which should use the new subclass to the name of the new
// subclass (currently all PCs and NPCs have their own GenericTextureHelper
// which overrides nothing for now, except for the base pitch and/or volume
// in the case of female or lighter/heavier characters so all PC/NPC texture
// specific events can be placed in these).
//
// For example, to have specific texture effects/sounds for the Minion:
//
// 1) Create a class called NPCMinionTextureHelper (this is the naming 
// convention which I've been using) which expands this class. 
//
// 2) Either edit the default properties section or open up UnrealEd and glom 
// in the damage types which you want to handle/override. IMO, the easiest way
// to do this, at least to get things set up is to cut and paste the default 
// TextureEffects properties for this class into the new class then edit things 
// as needed and rebuild the package which the new class resides in. For small 
// tweaks, using UnrealEd may be your best bet.
//
// 3) Set the TextureHelperClass for the Minion (in the Minion properties) to
// NPCMinionTextureHelper.
//
// Note that the GenericTextureHelper is accessed through the Pawn's 
// AssetsHelper member which contains the GenericAssetsHelper class to use. 
// The GenericAssetsHelper class is basically a wrapper for the 
// GenericTextureHelper class(es) (and it may wrap other assets-tracking
// classes in the near future.
//
//=============================================================================
// Level Design Issues
//
// The texture is identified by first checking the current texture's
// FootstepSound property. If this isn't set or is invalid, the first few 
// characters in the texture's name are parsed in order to identify it.
// See the function ConvertTextureName for a comprehensive list of textures 
// which are currently handled. There are currently 13 different textures,
// but several of these are mapped to by multiple texture name prefixes.
//
// Note that if a texture isn't recognized, the Stone sound is played by
// default.
//
//=============================================================================
// Additional Notes
//
// Groups of similar sounds (e.g. 4 run on wood sounds) can be given odds in
// the properites, but these aren't used at present (each sound is just as 
// likely to be used as the others).
//
// Some maps can result in Texture=None because of a bug in the tracing code.
// For now, when this happens, the stone sound is played by default.
//
// With other maps, the texture under a pawn may be determined incorrectly,
// particularly if the map contains coplanar brushes. This is easy to see
// with a contrived test map (just create several coplanar blocks with several
// textures). In practice, it does not seem to occur often with "real" levels.
// At this point we are taking a wait and see approach. If necessary, we will
// try to fix the bug in the engine code which is responsible for the 
// WalkTexture notification.
//
// There is a nasty UnrealEd bug. Properties which are structs that contain 
// other structs can crash the editor and/or don't work properly.
//
// At present, every sound can have its own effect. In many cases (e.g. for the
// 4 runwalk sounds), a single effect per texture would probably due, and if 
// it wasn't for the above bug, this could be done. This is basically a space
// optimization though, and probably won't get done in the near future.
// 
// One advantage of the way things are set up at present is that it is 
// possible to have different effects for running/walking vs landing.
//
//=============================================================================

#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\DeckL.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\DeckL2.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\DeckR.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\DeckR2.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\EarthL.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\EarthL2.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\EarthR.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\EarthR2.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\GrassL.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\GrassL2.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\GrassR.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\GrassR2.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\GravelL.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\GravelL2.wav	GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\GravelR.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\GravelR2.wav	GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\LeavesL.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\LeavesL2.wav	GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\LeavesR.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\LeavesR2.wav	GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\MarbleL.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\MarbleL2.wav	GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\MarbleR.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\MarbleR2.wav	GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\MetalL2.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\MetalR.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\MudL.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\MudL2.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\MudR.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\MudR2.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\PuddleL.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\PuddleL2.wav	GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\PuddleR.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\PuddleR2.wav	GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\RugL2.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\RugR2.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\StoneL.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\StoneL2.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\StoneR.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\StoneR2.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\WoodL.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\WoodL2.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\WoodR.wav		GROUP=Running
#exec AUDIO IMPORT FILE=Sounds\Pawn\Running\WoodR2.wav		GROUP=Running

#exec AUDIO IMPORT FILE=Sounds\Pawn\Landed\Deck.wav			GROUP=Landed
#exec AUDIO IMPORT FILE=Sounds\Pawn\Landed\Earth.wav		GROUP=Landed
#exec AUDIO IMPORT FILE=Sounds\Pawn\Landed\Grass.wav		GROUP=Landed
#exec AUDIO IMPORT FILE=Sounds\Pawn\Landed\Gravel.wav		GROUP=Landed
#exec AUDIO IMPORT FILE=Sounds\Pawn\Landed\Leaves.wav		GROUP=Landed
#exec AUDIO IMPORT FILE=Sounds\Pawn\Landed\Marble.wav		GROUP=Landed
#exec AUDIO IMPORT FILE=Sounds\Pawn\Landed\Metal.wav		GROUP=Landed
#exec AUDIO IMPORT FILE=Sounds\Pawn\Landed\Mud.wav			GROUP=Landed
#exec AUDIO IMPORT FILE=Sounds\Pawn\Landed\Puddle.wav		GROUP=Landed
#exec AUDIO IMPORT FILE=Sounds\Pawn\Landed\Rug.wav			GROUP=Landed
#exec AUDIO IMPORT FILE=Sounds\Pawn\Landed\Stone.wav		GROUP=Landed
#exec AUDIO IMPORT FILE=Sounds\Pawn\Landed\Wood.wav			GROUP=Landed



// animation groups associated with sound/effect for a texture
enum ESoundGroup
{
	SG_None,
	SG_End,					// end of list marker (gaps in list are ignored)
	SG_Landed,				// landed on texture group
	SG_RunWalk				// RunWalk is used for strafing and/or attacking while running/walking as well
};

const MaxMatches = 4;		// up to this many sounds per movement catagory per texture

// supported texture types
enum ESoundTexture
{
	ST_None,
	ST_Deck,				// "hollow" wood surface, e.g. a dock, barrel
	ST_Dirt,  
	ST_Grass,  
	ST_Gravel, 
	ST_Leaves, 
	ST_Marble, 
	ST_Metal,  
	ST_Mud,
	ST_Puddle,
	ST_Rug,
	ST_Stone,  
	ST_Wood,				// "solid" wood surface, e.g. a solid wood floor
	ST_All					// play sound/effect no matter what the surface is
};

struct EffectInfoT
{
	var() ESoundGroup		Group;								// group to which sound belongs
	var() ESoundTexture		Texture;							// texture on which sound plays
	var() string			SoundStr;   						// name of actual sound to play
	var() float				Volume;								// Volume to use
	var() float				Pitch;								// Pitch to use
	var() float				Odds;								// Odds of sound being used (within a group)
	var() string			EffectName;							// if set, name of class to spawn along with sound
};

var(WOTTextures)		EffectInfoT	MovementEffects[96];		// all texture-specific sounds
var(WOTTextures)		float		BasePitch;					// pitch multiplier
var(WOTTextures)		float		BaseVolume;					// volume multiplier
var(WOTTextures)		float		PlaySoundRadius;			// radius to use with PlaySound
var(WOTTextures)		float       RunningSoundSpeed;			// below this speed walking sounds used (lower volume)
var(WOTTextures)		float       PitchVariancePercent;		// percentage to vary final pitch by +/-
var(WOTTextures)		float       VolumeVariancePercent;		// percentage to vary final volume by +/-
var(WOTTextures)		float       WalkVolumeMultiplier;		// multiplier for volume when walking vs running

static function DoTextureEffect( Actor A, ESoundSlot Slot, sound Sound, float Volume, float Pitch, class<Actor> EffectC )
{
	A.PlaySound( Sound, Slot, Volume, false, default.PlaySoundRadius, Pitch );

	// 0.1 is way too quiet, not difficulty dependent
	A.MakeNoise( FClamp( Volume, 0.0, 1.0) );

	if( EffectC != None )
	{
		A.Spawn( EffectC,,, A.Location - vect(0,0,1)*A.CollisionHeight );
	}
}

//=============================================================================

static function ESoundTexture ConvertTextureName( string TexString )
{
	// check for special cases first:
	if( Left(TexString, 3) == "RUG" )
	{
		return ST_Rug;
	}
	else if( Left(TexString, 8) == "DIRTPEBB" )
	{
		return ST_Gravel;	
	}
	else if( Left(TexString, 8) == "DIRTLEAV" )
	{
		return ST_Leaves;	
	}

	switch( Left(TexString, 4) )
	{
		case "DECK":
			return ST_Deck;

		case "DIRT":
		case "PATH":
		case "SILT":
			return ST_Dirt;

		case "FABR":
		case "TPST":
			return ST_Rug;

		case "GRAS":
		case "GRSS":
			return ST_Grass;

		case "GRAV":
			return ST_Gravel; 

		case "LEAF":
			return ST_Leaves; 

		case "MARB":
		case "TILE":
			return ST_Marble;

		case "METL":
			return ST_Metal;  

		case "MUDD":
			return ST_Mud;  

		case "WATR":
			return ST_Puddle;

		case "sDav": 
		case "STON":
		case "ROCK":
		case "BLOK":
		case "BRIK":
		case "MOSA":
		case "SLTE": 
		case "SFLO":
		case "COBB":
			return ST_Stone;  

		case "WOOD":
			return ST_Wood;

		default:
			return ST_None;
	}
}

//=============================================================================

static function string GetGroupString( ESoundGroup SoundGroup )
{
	local string strGroup;

	switch( SoundGroup )
	{
		case SG_None:
			strGroup = "None";
			break;
		case SG_Landed:
			strGroup = "Landed";
			break;
		case SG_RunWalk:
			strGroup = "RunWalk";
			break;
		default:
			strGroup = "Error";
	}

	return strGroup;
}

//=============================================================================

static function string GetTextureString( ESoundTexture TextureGroup )
{
	local string strTexture;

	switch( TextureGroup )
	{
		case ST_None:
			strTexture = "None";
			break;
		case ST_Deck:
			strTexture = "Deck";
			break;
		case ST_Dirt:  
			strTexture = "Dirt";
			break;
		case ST_Grass:  
			strTexture = "Grass";
			break;
		case ST_Gravel: 
			strTexture = "Gravel";
			break;
		case ST_Leaves: 
			strTexture = "Leaves";
			break;
		case ST_Marble: 
			strTexture = "Marble";
			break;
		case ST_Metal:  
			strTexture = "Metal";
			break;
		case ST_Mud:
			strTexture = "Mud";
			break;
		case ST_Puddle:
			strTexture = "Puddle";
			break;
		case ST_Rug:
			strTexture = "Rug";
			break;
		case ST_Stone:  
			strTexture = "Stone";
			break;
		case ST_Wood:
			strTexture = "Wood";
			break;
		default:
			strTexture = "Error";
	}

	return strTexture;
}

//=============================================================================

static function TextureError( coerce string strMsg, ESoundGroup SoundGroup, ESoundTexture SoundTexture )
{
	local string strSound;
	local string strTexture;

	strSound	= GetGroupString( SoundGroup );
	strTexture	= GetTextureString( SoundTexture );
}

//=============================================================================
// ConvertTexture:
//
// If texture's FootstepSound field is set, try to use this as the *type* of 
// texture and only if this isn't recognized will we try to figure this out
// from the texture name. This lets LDs use the FootstepSound field to hack
// in the texture type without renaming all of these for textures who's names
// don't match the recognized prefixes.

static function ESoundTexture ConvertTexture( Texture T )
{
	local string TexString;
	local ESoundTexture retVal;

	if( T.FootstepSound != None)
	{
		// need to take the *right* 4 chars because
		// in many cases this gets set to, say FootStubA.(All).DIRT
		retVal = ConvertTextureName( Caps( Right( String( T.FootstepSound ), 4 ) ) );
	}

	if( retVal == ST_None )
	{
		// try texture name
		retVal = ConvertTextureName( Caps( Left( String( T.Name ), 16 ) ) );
	}
	
	if( retVal == ST_None )
	{
		// default to stone sound
		retVal = ST_Stone;  
	}

	return retVal;
}		

//=============================================================================
// LookUpSound:
//
// TBD: use EffectInfoT.Odds to weight likelihood of each sound being played.
// (See code in grunt.uc PickAnim for this.)

static function int LookUpSound( ESoundGroup SoundGroup, ESoundTexture SoundTexture )
{
	local int SoundIndex;
	local int NumMatches;
	local int Matches[4]; // should match MaxMatches above &%&^%* lack of constants for array sizes
	
	// need to identify sounds which match given SoundGroup and SoundTexture
	for( SoundIndex=0; SoundIndex<ArrayCount(default.MovementEffects) && default.MovementEffects[SoundIndex].Group != SG_End && NumMatches<MaxMatches; SoundIndex++ )
	{
		if( default.MovementEffects[SoundIndex].Group == SoundGroup && (default.MovementEffects[SoundIndex].Texture == SoundTexture || default.MovementEffects[SoundIndex].Texture == ST_All) )
		{
			Matches[NumMatches++] = SoundIndex;
		}
	}

	// pick one of the choices randomly (odds not used)
	if( NumMatches != 0 )
	{
		SoundIndex = Rand( NumMatches );
		return Matches[SoundIndex];
	}
	else
	{
		TextureError( "LookUpSound", SoundGroup, SoundTexture );
		return -1;
	}

}	

//=============================================================================

static function bool GetTextureParameters( ESoundGroup SoundGroup, ESoundTexture SoundTexture, out Sound SoundOut, out float VolumeOut, out float PitchOut, out class<Actor> EffectOut )
{
	local int SoundIndex;
	local class<Actor> A;

	SoundIndex = LookUpSound( SoundGroup, SoundTexture );
		
	if( SoundIndex != -1)
	{
		if( default.MovementEffects[ SoundIndex ].SoundStr != "" )
		{
			SoundOut	= Sound( DynamicLoadObject( default.MovementEffects[ SoundIndex ].SoundStr, class'Sound' ) );
		}

		if( SoundOut == None )
		{
			warn( "GetTextureParameters: no sound for " $ SoundTexture $ " Group: " $ SoundGroup );
		}

		VolumeOut	= default.MovementEffects[ SoundIndex ].Volume * default.BaseVolume;
		PitchOut	= default.MovementEffects[ SoundIndex ].Pitch * default.BasePitch;

		if( default.MovementEffects[SoundIndex].EffectName != "" )
		{
			EffectOut	= class<Actor>( DynamicLoadObject( default.MovementEffects[SoundIndex].EffectName, class'Class' ) );
		}

		return true;
	}

	return false;
}

//=============================================================================
// DetermineTextureEffect:
//
// Look up the effects for the given SoundGroup which matches the given Surface
// and apply these (play the sound, spawn the effect). If the surface is None
// (can and does happen due to a bug in the WalkTexture callback), the Stone
// effects are used by default.
//
// The final volume (before it is randomly varied) is scaled by 
// VolumeMultiplier.

static function DetermineTextureEffect( Actor A, ESoundGroup SoundGroup, Texture Surface, float VolumeMultiplier )
{
	local Sound Sound;
	local float Volume;
	local float Pitch;
	local class<Actor> EffectC;
	local ESoundTexture SoundTexture;

	if( Surface != None)
	{
		SoundTexture = ConvertTexture( Surface );
	}
	else
	{
		// pathological case -- occasionally the surface be "none"
		SoundTexture = ST_Stone; 
	}

	if( SoundTexture != ST_None )
	{
		if( GetTextureParameters( SoundGroup, SoundTexture, Sound, Volume, Pitch, EffectC ) )
		{
			Volume *= VolumeMultiplier;

			// vary the pitch a bit
			Pitch = class'Util'.static.PerturbFloatPercent( Pitch, default.PitchVariancePercent );

			// vary the volume a bit
			Volume = class'Util'.static.PerturbFloatPercent( Volume, default.VolumeVariancePercent );

			// class'util'.static.BMLog( A, Surface $ ": " $ GetTextureString(SoundTexture) $ " S:" $ Sound $ " V:" $ Volume $ " P:" $ Pitch $ " E:" $ EffectC );
			
			DoTextureEffect( A, SLOT_Interact, Sound, Volume, Pitch, EffectC );
		}
		else
		{
			TextureError( "DetermineTextureEffect", SoundGroup, SoundTexture );
		}
	}
}

//=============================================================================

static function HandleLandingOnTexture( Actor A, Texture LandingTexture, float ImpactVelocity )
{
	local float VolumeMultiplier;

	if( Pawn(A) == None )
	{
		return;
	}

	// landed volume increases with impact velocity
	VolumeMultiplier = ImpactVelocity/Pawn(A).JumpZ;
	VolumeMultiplier = 0.005 * A.Mass * VolumeMultiplier * VolumeMultiplier;

	DetermineTextureEffect( A, SG_Landed, LandingTexture, VolumeMultiplier );
}

//=============================================================================

static function HandleMovingOnTexture( Actor A, Texture MovingTexture )
{
	local float VolumeMultiplier;

	// if walking, sound is quieter
	VolumeMultiplier = 1.0;

	if( VSize(A.Velocity) < default.RunningSoundSpeed )
	{
		VolumeMultiplier = default.WalkVolumeMultiplier;
	}

	DetermineTextureEffect( A, SG_RunWalk, MovingTexture, VolumeMultiplier );
}

//=============================================================================

defaultproperties
{
     MovementEffects(0)=(Group=SG_RunWalk,Texture=ST_Deck,SoundStr="WOT.DeckL",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(1)=(Group=SG_RunWalk,Texture=ST_Deck,SoundStr="WOT.DeckL2",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(2)=(Group=SG_RunWalk,Texture=ST_Deck,SoundStr="WOT.DeckR",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(3)=(Group=SG_RunWalk,Texture=ST_Deck,SoundStr="WOT.DeckR2",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(4)=(Group=SG_RunWalk,Texture=ST_Dirt,SoundStr="WOT.EarthL",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(5)=(Group=SG_RunWalk,Texture=ST_Dirt,SoundStr="WOT.EarthL2",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(6)=(Group=SG_RunWalk,Texture=ST_Dirt,SoundStr="WOT.EarthR",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(7)=(Group=SG_RunWalk,Texture=ST_Dirt,SoundStr="WOT.EarthR2",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(8)=(Group=SG_RunWalk,Texture=ST_Grass,SoundStr="WOT.GrassL",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(9)=(Group=SG_RunWalk,Texture=ST_Grass,SoundStr="WOT.GrassL2",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(10)=(Group=SG_RunWalk,Texture=ST_Grass,SoundStr="WOT.GrassR",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(11)=(Group=SG_RunWalk,Texture=ST_Grass,SoundStr="WOT.GrassR2",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(12)=(Group=SG_RunWalk,Texture=ST_Gravel,SoundStr="WOT.GravelL",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(13)=(Group=SG_RunWalk,Texture=ST_Gravel,SoundStr="WOT.GravelL2",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(14)=(Group=SG_RunWalk,Texture=ST_Gravel,SoundStr="WOT.GravelR",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(15)=(Group=SG_RunWalk,Texture=ST_Gravel,SoundStr="WOT.GravelR2",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(16)=(Group=SG_RunWalk,Texture=ST_Leaves,SoundStr="WOT.LeavesL",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(17)=(Group=SG_RunWalk,Texture=ST_Leaves,SoundStr="WOT.LeavesL2",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(18)=(Group=SG_RunWalk,Texture=ST_Leaves,SoundStr="WOT.LeavesR",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(19)=(Group=SG_RunWalk,Texture=ST_Leaves,SoundStr="WOT.LeavesR2",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(20)=(Group=SG_RunWalk,Texture=ST_Marble,SoundStr="WOT.MarbleL",Volume=1.000000,Pitch=0.800000,Odds=1.000000)
     MovementEffects(21)=(Group=SG_RunWalk,Texture=ST_Marble,SoundStr="WOT.MarbleL2",Volume=1.000000,Pitch=0.800000,Odds=1.000000)
     MovementEffects(22)=(Group=SG_RunWalk,Texture=ST_Marble,SoundStr="WOT.MarbleR",Volume=1.000000,Pitch=0.800000,Odds=1.000000)
     MovementEffects(23)=(Group=SG_RunWalk,Texture=ST_Marble,SoundStr="WOT.MarbleR2",Volume=1.000000,Pitch=0.800000,Odds=1.000000)
     MovementEffects(25)=(Group=SG_RunWalk,Texture=ST_Metal,SoundStr="WOT.MetalL2",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(26)=(Group=SG_RunWalk,Texture=ST_Metal,SoundStr="WOT.MetalR",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(28)=(Group=SG_RunWalk,Texture=ST_Mud,SoundStr="WOT.MudL",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(29)=(Group=SG_RunWalk,Texture=ST_Mud,SoundStr="WOT.MudL2",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(30)=(Group=SG_RunWalk,Texture=ST_Mud,SoundStr="WOT.MudR",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(31)=(Group=SG_RunWalk,Texture=ST_Mud,SoundStr="WOT.MudR2",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(32)=(Group=SG_RunWalk,Texture=ST_Puddle,SoundStr="WOT.PuddleL",Volume=1.000000,Pitch=1.000000,Odds=1.000000,EffectName="ParticleSystems.WaterSplash")
     MovementEffects(33)=(Group=SG_RunWalk,Texture=ST_Puddle,SoundStr="WOT.PuddleL2",Volume=1.000000,Pitch=1.000000,Odds=1.000000,EffectName="ParticleSystems.WaterSplash")
     MovementEffects(34)=(Group=SG_RunWalk,Texture=ST_Puddle,SoundStr="WOT.PuddleR",Volume=1.000000,Pitch=1.000000,Odds=1.000000,EffectName="ParticleSystems.WaterSplash")
     MovementEffects(35)=(Group=SG_RunWalk,Texture=ST_Puddle,SoundStr="WOT.PuddleR2",Volume=1.000000,Pitch=1.000000,Odds=1.000000,EffectName="ParticleSystems.WaterSplash")
     MovementEffects(37)=(Group=SG_RunWalk,Texture=ST_Rug,SoundStr="WOT.RugL2",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(39)=(Group=SG_RunWalk,Texture=ST_Rug,SoundStr="WOT.RugR2",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(40)=(Group=SG_RunWalk,Texture=ST_Stone,SoundStr="WOT.StoneL",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(41)=(Group=SG_RunWalk,Texture=ST_Stone,SoundStr="WOT.StoneL2",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(42)=(Group=SG_RunWalk,Texture=ST_Stone,SoundStr="WOT.StoneR",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(43)=(Group=SG_RunWalk,Texture=ST_Stone,SoundStr="WOT.StoneR2",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(44)=(Group=SG_RunWalk,Texture=ST_Wood,SoundStr="WOT.WoodL",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(45)=(Group=SG_RunWalk,Texture=ST_Wood,SoundStr="WOT.WoodL2",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(46)=(Group=SG_RunWalk,Texture=ST_Wood,SoundStr="WOT.WoodR",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(47)=(Group=SG_RunWalk,Texture=ST_Wood,SoundStr="WOT.WoodR2",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(48)=(Group=SG_Landed,Texture=ST_Deck,SoundStr="WOT.Deck",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(49)=(Group=SG_Landed,Texture=ST_Dirt,SoundStr="WOT.Earth",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(50)=(Group=SG_Landed,Texture=ST_Grass,SoundStr="WOT.Grass",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(51)=(Group=SG_Landed,Texture=ST_Gravel,SoundStr="WOT.Gravel",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(52)=(Group=SG_Landed,Texture=ST_Leaves,SoundStr="WOT.Leaves",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(53)=(Group=SG_Landed,Texture=ST_Marble,SoundStr="WOT.Marble",Volume=1.000000,Pitch=0.800000,Odds=1.000000)
     MovementEffects(54)=(Group=SG_Landed,Texture=ST_Metal,SoundStr="WOT.Metal",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(55)=(Group=SG_Landed,Texture=ST_Mud,SoundStr="WOT.Mud",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(56)=(Group=SG_Landed,Texture=ST_Puddle,SoundStr="WOT.Puddle",Volume=1.000000,Pitch=1.000000,Odds=1.000000,EffectName="ParticleSystems.WaterSplash")
     MovementEffects(57)=(Group=SG_Landed,Texture=ST_Rug,SoundStr="WOT.Rug",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(58)=(Group=SG_Landed,Texture=ST_Stone,SoundStr="WOT.Stone",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     MovementEffects(59)=(Group=SG_Landed,Texture=ST_Wood,SoundStr="WOT.Wood",Volume=1.000000,Pitch=1.000000,Odds=1.000000)
     BasePitch=1.000000
     BaseVolume=1.000000
     RunningSoundSpeed=200.000000
     PitchVariancePercent=30.000000
     VolumeVariancePercent=50.000000
     WalkVolumeMultiplier=0.500000
     DebugCategoryName=GenericTextureHelper
     Texture=Texture'WOT.Icons.S_TextureHelper'
}
