//=============================================================================
// QuestionerShield.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 7 $
//=============================================================================

class QuestionerShield expands WotThrowableWeapon;

// 3rd person perspective version
#exec MESH IMPORT MESH=MQuestionerShieldWT ANIVFILE=MODELS\QuestionerShield_a.3d DATAFILE=MODELS\QuestionerShield_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MQuestionerShieldWT X=-25 Y=30 Z=-10 YAW=0 ROLL=0 PITCH=96

#exec MESH SEQUENCE MESH=MQuestionerShieldWT SEQ=All     STARTFRAME=0 NUMFRAMES=1

#exec TEXTURE IMPORT NAME=MQuestionerShield0 FILE=MODELS\QuestionerShield0.PCX GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT NAME=MQuestionerShield1 FILE=MODELS\QuestionerShield1.PCX GROUP=Skins FLAGS=2 // SKIN
#exec TEXTURE IMPORT NAME=MQuestionerShield2 FILE=MODELS\QuestionerShield2.PCX GROUP=Skins FLAGS=2 // SKIN

#exec MESHMAP NEW   MESHMAP=MQuestionerShieldWT MESH=MQuestionerShieldWT
#exec MESHMAP SCALE MESHMAP=MQuestionerShieldWT X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=MQuestionerShieldWT NUM=0 TEXTURE=MQuestionerShield0

// used for decorations, projectile
#exec MESH IMPORT MESH=MQuestionerShield ANIVFILE=MODELS\QuestionerShield_a.3d DATAFILE=MODELS\QuestionerShield_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MQuestionerShield X=-25 Y=30 Z=-10 YAW=0 ROLL=0 PITCH=64

#exec MESH SEQUENCE MESH=MQuestionerShield SEQ=All     STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MQuestionerShield MESH=MQuestionerShield
#exec MESHMAP SCALE MESHMAP=MQuestionerShield X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=MQuestionerShield NUM=0 TEXTURE=MQuestionerShield0

var() float	ThrowShieldMinDistance;
var() float	ThrowShieldMaxDistance;
var() float	ThrowShieldMinOdds;
var() float	ThrowShieldMaxOdds;



function DetermineWeaponUsage( Actor UsingActor, GoalAbstracterInterf AttackGoal )
{
	local float Odds;
	local float AttackGoalDistance;

	Super.DetermineWeaponUsage( UsingActor, AttackGoal );
	if( DeterminedWeaponUsage == WU_Projectile )
	{
		//the weapon should be used as a projectile weapon
		//have odds of throwing shield increase smoothly with distance from max
		AttackGoal.GetGoalDistance( Self, AttackGoalDistance, Self );

		Odds = class'Util'.static.RandDistance( AttackGoalDistance, ThrowShieldMinDistance, ThrowShieldMaxDistance, ThrowShieldMinOdds, ThrowShieldMaxOdds );
		if( FRand() <= Odds )
		{
			//the weapon can not be used
			DeterminedWeaponUsage = WU_Projectile;
		}
		else
		{
			//the weapon will not be used
			DeterminedWeaponUsage = WU_None;
		}
	}
}

defaultproperties
{
     ThrowShieldMinDistance=128.000000
     ThrowShieldMaxDistance=4096.000000
     ThrowShieldMinOdds=0.500000
     ThrowShieldMaxOdds=0.010000
     MaxMeleeRange=65.000000
     MeleeEffectiveness=1.000000
     MinProjectileRange=256.000000
     MaxProjectileRange=10000.000000
     ProjectileEffectiveness=2.000000
     WotWeaponProjectileType=Class'WOTPawns.QuestShieldProjectile'
     Health=1000
     DamageSkin0=Texture'WOTPawns.Skins.MQuestionerShield0'
     DamageSkin1=Texture'WOTPawns.Skins.MQuestionerShield1'
     DamageSkin2=Texture'WOTPawns.Skins.MQuestionerShield2'
     TossedDecorationTypeString="WOTDecorations.Dec_QuestionerShield"
     DestroyedSoundString="WOTPawns.Shield_Destroyed1"
     PickupViewMesh=Mesh'WOTPawns.MQuestionerShieldWT'
     ThirdPersonMesh=Mesh'WOTPawns.MQuestionerShieldWT'
     bDirectional=True
     Style=STY_Masked
     Mesh=Mesh'WOTPawns.MQuestionerShieldWT'
     ScaleGlow=2.000000
     CollisionRadius=18.000000
     CollisionHeight=2.000000
}
