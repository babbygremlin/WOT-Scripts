//=============================================================================
// PropertyFlipper.uc
// $Author: Mfox $
// $Date: 1/05/00 2:37p $
// $Revision: 3 $
//=============================================================================

//------------------------------------------------------------------------------
// Description:	Use this to modify any variable of any Actor at runtime via
//              a trigger.
//------------------------------------------------------------------------------
// Basic Instructions:
// 
// Set the Event to the object's Tag you wish to modify.
// 
// Note: Only the first object you link to will be affected.  If you need to 
// affect multiple objects, use multiple PropertyFlippers.
// 
// There are three InitialStates that you can set:
// 
// + TriggerToggle
// + TriggerControl
// + TriggerTimed (note associated TriggerDuration)
// 
// These are self explanatory.
// 
// Under the PropertyFlipper section in the default properties, you will see 
// a bunch of variables.
// 
// + PropertyName - set this to the name of the variable you wish to modify 
//   (i.e. DrawScale).  Just type it in -- spelling counts.
// + PropertyType - set this to the type of property you are modifying 
//   (i.e. float, Texture, Sound, etc.)
// + XXXValue (FloatValue, TextureValue, SoundValue, etc) - set this to the 
//   value you wish your variable to be modified too.  These are basically for 
//   easy of use.  Rather than making you type in 
//   "Texture'Angreal.Effects.GreenExplosion'" you can simply select the texture 
//   in the texture browser, and then click USE in the variable box.
// 
// Notes:
// 
// If I didn't include the type of variable you want to modify (i.e. an enumeration 
// like Style), you can use StringValue to hack it into submission.  
// 
// Example:
// + Set PropertyName to Style.
// + Set PropertyType to TYPE_String.
// + Set StringValue to STY_Translucent.  
// 
// This will not work for constant variables like Physics and Location, however, 
// I have added a PropertyType for Physics, and I can add more for other constant 
// variables if you find you need to modify them.
// 
// This will not work for Static actors.  If you can't figure out why your 
// PropertyFlipper isn't working, make sure to check that the Actor you are trying 
// to modify isn't static.  Also make sure you didn't spell the PropertyName wrong.
//------------------------------------------------------------------------------

class PropertyFlipper expands KeyPoint;

var() enum TPropType
{
	TYPE_Bool,
	TYPE_Float,
	TYPE_Int,
	TYPE_Byte,
	TYPE_Vector,
	TYPE_Rotator,
	TYPE_String,
	TYPE_Texture,
	TYPE_Sound,
	TYPE_Physics,
	TYPE_Collision	// No property name needed.
} PropertyType;

var() string PropertyName;

var() bool			BoolValue;
var() float			FloatValue;
var() int			IntValue;
var() byte			ByteValue;
var() vector		VectorValue;
var() rotator		RotatorValue;
var() string		StringValue;
var() Texture		TextureValue;
var() Sound			SoundValue;
var() EPhysics		PhysicsValue;
var() float			CollisionRadiusValue;	// No property name needed.
var() float			CollisionHeightValue;	// No property name needed.

var string		OldPropertyText;
var EPhysics	OldPhysics;
var float		OldCollisionRadius;
var float		OldCollisionHeight;

var() float TriggerDuration;

var bool bOn;

//------------------------------------------------------------------------------
simulated state() TriggerToggle
{
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		if( !bOn )	Set();
		else		Reset();

		bOn = !bOn;
	}
}

//------------------------------------------------------------------------------
simulated state() TriggerControl
{
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		Set();
	}

	simulated function UnTrigger( Actor Other, Pawn EventInstigator )
	{
		Reset();
	}
}

//------------------------------------------------------------------------------
simulated state() TriggerTimed
{
	simulated function Trigger( Actor Other, Pawn EventInstigator )
	{
		Set();
		SetTimer( TriggerDuration, false );
	}

	simulated function Timer()
	{
		Reset();
	}
}

//------------------------------------------------------------------------------
simulated function Set()
{
	local Actor IterA;

	if( Event != '' )
	{
		foreach AllActors( class'Actor', IterA, Event )
		{
			OldPropertyText = IterA.GetPropertyText( PropertyName );

			switch( PropertyType )
			{
			case TYPE_Bool:
				IterA.SetPropertyText( PropertyName, string(BoolValue) );
				break;

			case TYPE_Float:
				IterA.SetPropertyText( PropertyName, string(FloatValue) );
				break;

			case TYPE_Int:
				IterA.SetPropertyText( PropertyName, string(IntValue) );
				break;

			case TYPE_Byte:
				IterA.SetPropertyText( PropertyName, string(ByteValue) );
				break;

			case TYPE_Vector:
				IterA.SetPropertyText( PropertyName, string(VectorValue) );
				break;

			case TYPE_Rotator:
				IterA.SetPropertyText( PropertyName, string(RotatorValue) );
				break;

			case TYPE_String:
				IterA.SetPropertyText( PropertyName, StringValue );
				break;

			case TYPE_Texture:
				IterA.SetPropertyText( PropertyName, string(TextureValue) );
				break;

			case TYPE_Sound:
				IterA.SetPropertyText( PropertyName, string(SoundValue) );
				break;

			case TYPE_Physics:
				OldPhysics = IterA.Physics;
				IterA.SetPhysics( PhysicsValue );
				break;

			case TYPE_Collision:
				OldCollisionRadius = IterA.CollisionRadius;
				OldCollisionHeight = IterA.CollisionHeight;
				IterA.SetCollisionSize( CollisionRadiusValue, CollisionHeightValue );
				break;

			default:
				warn( "Unhandled PropertyType." );
				break;
			}

			break;	// Only work for one.
		}
	}
}

//------------------------------------------------------------------------------
simulated function Reset()
{
	local Actor IterA;
	
	if( Event != '' )
	{
		foreach AllActors( class'Actor', IterA, Event )
		{
			if( PropertyType == TYPE_Physics )
			{
				IterA.SetPhysics( OldPhysics );
			}
			else if( PropertyType == TYPE_Collision )
			{
				IterA.SetCollisionSize( OldCollisionRadius, OldCollisionHeight );
			}
			else
			{
				IterA.SetPropertyText( PropertyName, OldPropertyText );
			}
			break;	// Only work for one.
		}
	}
}

defaultproperties
{
     bStatic=False
     InitialState=TriggerControl
}
