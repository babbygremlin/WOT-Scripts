//=============================================================================
// Questioner.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 4 $
//=============================================================================

// The champion for the Whitecloak. This is a skin variant of the Soldier

class Questioner expands ShieldUser;

#exec TEXTURE IMPORT NAME=Jquestioner1 FILE=MODELS\Questioner1.PCX GROUP=Skins FLAGS=2 
#exec TEXTURE IMPORT FILE=Icons\Champions\H_QuestionerDisguise.PCX GROUP=UI MIPS=Off

const ReflectedSoundSlot				= 'Reflected';



function Trigger( Actor Other, Pawn EventInstigator )
{
	Super.Trigger( Other, EventInstigator );
	if( ( Other != None ) && Other.IsA( 'ShieldReturnToSenderReflector' ) )
	{
		//reflector deflected a projectile
		MySoundTable.PlaySlotSound( Self, ReflectedSoundSlot, VolumeMultiplier, RadiusMultiplier, PitchMultiplier, MySoundSlotTimerList );
	}
}

defaultproperties
{
     AttackRunShieldDamage=10.000000
     AttackRunSwipeDamage=15.000000
     AttackRunLungeDamage=15.000000
     ShieldReflectorInventoryProxyClass=Class'WOTPawns.QuestionerShield'
     bShieldReflectorLeadWhenReflecting=True
     DefaultWeaponType=Class'WOTPawns.QuestionerShield'
     MeleeWeaponType=Class'WOTPawns.QuestionerShield'
     RangedWeaponType=Class'WOTPawns.QuestionerShield'
     DisguiseIcon=Texture'WOTPawns.UI.H_QuestionerDisguise'
     GroundSpeedMin=650.000000
     GroundSpeedMax=650.000000
     HealthMPMin=500.000000
     HealthMPMax=500.000000
     HealthSPMin=500.000000
     HealthSPMax=500.000000
     TextureHelperClass=Class'WOTPawns.PCMaleTextureHelper'
     SoundTableClass=Class'WOTPawns.SoundTableQuestioner'
     SoundSlotTimerListClass=Class'WOTPawns.SoundSlotTimerListQuestioner'
     AnimationTableClass=Class'WOTPawns.AnimationTableSoldier'
     CarcassType=Class'WOT.WOTCarcassHumanoid'
     HandlerFactoryClass=Class'WOTPawns.RangeHandlerFactoryQuestioner'
     GoalSuggestedSpeeds(0)=650.000000
     GoalSuggestedSpeeds(2)=650.000000
     GoalSuggestedSpeeds(3)=650.000000
     GoalSuggestedSpeeds(4)=650.000000
     GoalSuggestedSpeeds(5)=650.000000
     GoalSuggestedSpeeds(6)=162.500000
     DurationNotifierClasses(3)=Class'WOTPawns.DefensiveDetectorQuestioner'
     MeleeRange=50.000000
     GroundSpeed=650.000000
     WaterSpeed=160.000000
     Health=500
     Mesh=LodMesh'WOTPawns.Soldier'
     DrawScale=1.200000
     MultiSkins(1)=Texture'WOTPawns.Skins.Jquestioner1'
     MultiSkins(2)=Texture'WOTPawns.Skins.Jquestioner1'
     MultiSkins(3)=Texture'WOTPawns.Skins.Jquestioner1'
     MultiSkins(4)=Texture'WOTPawns.Skins.Jquestioner1'
     MultiSkins(5)=Texture'WOTPawns.Skins.Jquestioner1'
     CollisionRadius=17.000000
     Mass=200.000000
}
