//=============================================================================
// Alarm.uc
// $Author: Rovrevik $
// $Date: 10/01/99 1:08a $
// $Revision: 7 $
//=============================================================================
class Alarm expands Trap;

#exec MESH IMPORT MESH=Alarm ANIVFILE=MODELS\Alarm\TrapAlarm_a.3D DATAFILE=MODELS\Alarm\TrapAlarm_d.3D X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Alarm X=0 Y=0 Z=0 YAW=64 ROLL=-64
#exec MESH SEQUENCE MESH=Alarm SEQ=All      STARTFRAME=0   NUMFRAMES=1
#exec MESH SEQUENCE MESH=Alarm SEQ=Waiting  STARTFRAME=0   NUMFRAMES=1
#exec TEXTURE IMPORT NAME=AlarmTex FILE=MODELS\Alarm\TrapAlarm.PCX GROUP=Skins
#exec MESHMAP NEW   MESHMAP=Alarm MESH=Alarm
#exec MESHMAP SCALE MESHMAP=Alarm X=0.15 Y=0.15 Z=0.15
#exec MESHMAP SETTEXTURE MESHMAP=Alarm NUM=1 TEXTURE=AlarmTex

#exec AUDIO IMPORT FILE=Sounds\Alarm\ActivateAM.wav			GROUP=Alarm

var vector		ThreatLocation;		// will be set externally by Captain
var Actor		ThreatActor;		// will be set externally by Captain
var() int       AlarmDelay;			// Time between alarm gongs

function ActivateAlarm( Actor Other )
{
}

function bool CalcLocation( out vector HitLocation, out vector HitNormal ) 
{
	if( HitNormal.Z != 0.0 )
	{
		return false;
	}

	return Super.CalcLocation( HitLocation, HitNormal );
}

function bool DeployResource( vector HitLocation, vector HitNormal )
{
	if( !CalcLocation( HitLocation, HitNormal ) )
	{
		return false;
	}
	SetRotation( rotator(HitNormal) );
	SetLocation( HitLocation );

	return ValidateTrap();
}

auto state Waiting
{
	function ActivateAlarm( Actor Other )
	{
		class'Util'.static.TriggerRadiusInstances( Self, class'Pawn', Pawn(Other), '', SoundRadius * 16.0 );
		GotoState( GetStateName(), 'Sound' );
	}

	function TakeDamage( int Damage, Pawn InstigatedBy, vector HitLocation, vector Momentum, name DamageType )
	{
		Touch( InstigatedBy );
	}

	function Bump( Actor Other )
	{
		Touch( Other );
	}

	function Touch( Actor Other )
	{
		if( Other == None )
			return;

		if( IsInactive( None ) ) // don't indicate who touched the alarm (ring for everyone)
			return;

		if( !Other.IsA( 'Pawn' ) )
			return;

		if( !Pawn(Other).bIsPlayer )
			//only players can activate an alarm by touching it
			return;

		ActivateAlarm( Other );
	}

Begin:
	LoopAnim( 'Waiting' );
	Stop;

Sound:
	Disable( 'Bump' );
	PlaySound( Sound( DynamicLoadObject( ActivatingSoundName, class'Sound' ) ) );
	Sleep( AlarmDelay );
	Enable( 'Bump' );
}

// end of Alarm.uc

defaultproperties
{
     AlarmDelay=3
     HeightAboveFloor=80
     SeparationDistance=32
     TrapRadius=56
     ActivatingSoundName="WOTTraps.Alarm.ActivateAM"
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=Mesh'WOTTraps.Alarm'
     SoundRadius=255
     bProjTarget=True
}
