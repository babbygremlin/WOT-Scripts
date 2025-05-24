//=============================================================================
// ForsakenBot.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 7 $
//=============================================================================

class ForsakenBot expands WOTBot;

// stubbed in for bots -- TBD
#exec MESH SEQUENCE MESH=Forsaken SEQ=LISTEN		STARTFRAME=0 NUMFRAMES=1 // NA                    
#exec MESH SEQUENCE MESH=Forsaken SEQ=REACTP		STARTFRAME=0 NUMFRAMES=1 // NA
#exec MESH SEQUENCE MESH=Forsaken SEQ=REACTPLOOP	STARTFRAME=0 NUMFRAMES=1 // NA
#exec MESH SEQUENCE MESH=Forsaken SEQ=SEEENEMY		STARTFRAME=0 NUMFRAMES=1 // NA
#exec MESH SEQUENCE MESH=Forsaken SEQ=GONG			STARTFRAME=0 NUMFRAMES=1 // NA
#exec MESH SEQUENCE MESH=Forsaken SEQ=GIVEORDERS	STARTFRAME=0 NUMFRAMES=1 // NA
#exec MESH SEQUENCE MESH=Forsaken SEQ=LANDED1		STARTFRAME=123 NUMFRAMES=1		Group=Landing

// attack sequence is currently too short to use a notification function (code in grunt will call this directly)
//#exec MESH NOTIFY MESH=Forsaken  SEQ=Attack		TIME=0.50  FUNCTION=ShootRangedAmmo

defaultproperties
{
     MinOffensiveAngrealUsageInterval=2.000000
     MinDefensiveAngrealUsageInterval=1.000000
     AII_AngrealInventoryStr(0)="Angreal.AngrealInvAirBurst"
     AII_AngrealInventoryStr(1)="Angreal.AngrealInvDart"
     AII_AngrealInventoryStr(2)="Angreal.AngrealInvFireball"
     AII_AngrealInventoryStr(3)="Angreal.AngrealInvSeeker"
     AII_AngrealInventoryStr(4)="Angreal.AngrealInvReflect"
     AII_AngrealInventoryStr(5)="Angreal.AngrealInvDecay"
     AII_AngrealInventoryStr(6)="Angreal.AngrealInvEarthTremor"
     AII_AngrealInventoryStr(7)="Angreal.AngrealInvSwapPlaces"
     AII_AngrealInventoryStr(8)="Angreal.AngrealInvSoulBarb"
     AII_AngrealInventoryStr(9)="Angreal.AngrealInvRemoveCurse"
     AII_AngrealInventoryStr(10)="Angreal.AngrealInvEarthShield"
     AII_AngrealInventoryStr(11)="Angreal.AngrealInvFireShield"
     AII_AngrealInventoryStr(12)="Angreal.AngrealInvMinion"
     AII_Priority(0)=1.000000
     AII_Priority(1)=4.000000
     AII_Priority(2)=5.000000
     AII_Priority(3)=4.000000
     AII_Priority(4)=8.000000
     AII_Priority(5)=3.000000
     AII_Priority(6)=6.000000
     AII_Priority(7)=7.000000
     AII_Priority(8)=10.000000
     AII_Priority(9)=9.000000
     AII_Priority(10)=10.000000
     AII_Priority(11)=9.000000
     AII_Priority(12)=10.000000
     AII_MinChargesInGroup(1)=2
     AII_MaxChargesInGroup(1)=6
     AII_MinChargeGroupInterval(6)=15.000000
     AII_MinChargeGroupInterval(9)=10.000000
     HealthMPMin=800.000000
     HealthMPMax=800.000000
     HealthSPMin=800.000000
     HealthSPMax=800.000000
     TextureHelperClass=Class'WOTPawns.PCMaleTextureHelper'
     SoundTableClass=Class'WOTPawns.SoundTableForsakenBot'
     AnimationTableClass=Class'WOTPawns.AnimationTableForsaken'
     Mesh=LodMesh'WOTPawns.Forsaken'
     DrawScale=0.670000
     CollisionHeight=46.000000
}
