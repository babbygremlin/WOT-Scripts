//=============================================================================
// AesSedaiBot.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 8 $
//=============================================================================

class AesSedaiBot expands WOTBot;

// stubbed in for bots -- TBD
#exec MESH SEQUENCE MESH=AesSedai SEQ=LISTEN		STARTFRAME=0 NUMFRAMES=10 // NA                    
#exec MESH SEQUENCE MESH=AesSedai SEQ=REACTP		STARTFRAME=0 NUMFRAMES=10 // NA
#exec MESH SEQUENCE MESH=AesSedai SEQ=REACTPLOOP	STARTFRAME=0 NUMFRAMES=10 // NA
#exec MESH SEQUENCE MESH=AesSedai SEQ=SEEENEMY		STARTFRAME=0 NUMFRAMES=10 // NA
#exec MESH SEQUENCE MESH=AesSedai SEQ=GONG			STARTFRAME=0 NUMFRAMES=10 // NA
#exec MESH SEQUENCE MESH=AesSedai SEQ=GIVEORDERS	STARTFRAME=0 NUMFRAMES=10 // NA
#exec MESH SEQUENCE MESH=AesSedai SEQ=LANDED1		STARTFRAME=117 NUMFRAMES=10		Group=Landing

// attack sequence is currently too short to use a notification function (code in grunt will call this directly)
//#exec MESH NOTIFY MESH=AesSedai SEQ=Attack		TIME=0.50  FUNCTION=ShootRangedAmmo

defaultproperties
{
     MinOffensiveAngrealUsageInterval=5.000000
     MinDefensiveAngrealUsageInterval=4.000000
     AII_AngrealInventoryStr(0)="Angreal.AngrealInvAirBurst"
     AII_AngrealInventoryStr(1)="Angreal.AngrealInvDart"
     AII_AngrealInventoryStr(2)="Angreal.AngrealInvSeeker"
     AII_AngrealInventoryStr(3)="Angreal.AngrealInvSoulBarb"
     AII_AngrealInventoryStr(4)="Angreal.AngrealInvShift"
     AII_AngrealInventoryStr(5)="Angreal.AngrealInvRemoveCurse"
     AII_Priority(0)=1.000000
     AII_Priority(1)=6.000000
     AII_Priority(2)=5.000000
     AII_Priority(3)=9.000000
     AII_Priority(4)=9.000000
     AII_Priority(5)=10.000000
     AII_MinChargesInGroup(1)=3
     AII_MaxChargesInGroup(1)=7
     AII_MinChargeGroupInterval(5)=10.000000
     HealthMPMin=400.000000
     HealthMPMax=400.000000
     HealthSPMin=400.000000
     HealthSPMax=400.000000
     TextureHelperClass=Class'WOTPawns.PCFemaleTextureHelper'
     SoundTableClass=Class'WOTPawns.SoundTableAesSedaiBot'
     AnimationTableClass=Class'WOTPawns.AnimationTableAesSedai'
     bIsFemale=True
     Mesh=LodMesh'WOTPawns.AesSedai'
     DrawScale=0.950000
     CollisionHeight=46.000000
}
