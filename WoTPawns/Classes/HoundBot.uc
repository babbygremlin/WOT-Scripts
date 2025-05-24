//=============================================================================
// HoundBot.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 6 $
//=============================================================================

class HoundBot expands WOTBot;

// stubbed in for bots -- TBD
#exec MESH SEQUENCE MESH=Hound SEQ=LISTEN		STARTFRAME=1 NUMFRAMES=1 // NA
#exec MESH SEQUENCE MESH=Hound SEQ=REACTP		STARTFRAME=1 NUMFRAMES=1 // NA
#exec MESH SEQUENCE MESH=Hound SEQ=REACTPLOOP   STARTFRAME=1 NUMFRAMES=1 // NA
#exec MESH SEQUENCE MESH=Hound SEQ=SEEENEMY     STARTFRAME=1 NUMFRAMES=1 // NA
#exec MESH SEQUENCE MESH=Hound SEQ=GONG			STARTFRAME=1 NUMFRAMES=1 // NA
#exec MESH SEQUENCE MESH=Hound SEQ=GIVEORDERS   STARTFRAME=1 NUMFRAMES=1 // NA
#exec MESH SEQUENCE MESH=Hound SEQ=LANDED1		STARTFRAME=127 NUMFRAMES=1		Group=Landing

// attack sequence is currently too short to use a notification function (code in grunt will call this directly)
//#exec MESH NOTIFY MESH=Hound SEQ=Attack     TIME=0.50  FUNCTION=ShootRangedAmmo

defaultproperties
{
     MinOffensiveAngrealUsageInterval=5.000000
     MinDefensiveAngrealUsageInterval=3.000000
     AII_AngrealInventoryStr(0)="Angreal.AngrealInvAirBurst"
     AII_AngrealInventoryStr(1)="Angreal.AngrealInvFireball"
     AII_AngrealInventoryStr(2)="Angreal.AngrealInvDart"
     AII_AngrealInventoryStr(3)="Angreal.AngrealInvFork"
     AII_AngrealInventoryStr(4)="Angreal.AngrealInvShift"
     AII_Priority(0)=1.000000
     AII_Priority(1)=5.000000
     AII_Priority(2)=4.000000
     AII_Priority(3)=5.000000
     AII_Priority(4)=7.000000
     AII_MinChargesInGroup(2)=2
     AII_MaxChargesInGroup(2)=6
     HealthMPMin=150.000000
     HealthMPMax=150.000000
     HealthSPMin=150.000000
     HealthSPMax=150.000000
     TextureHelperClass=Class'WOTPawns.PCMaleTextureHelper'
     SoundTableClass=Class'WOTPawns.SoundTableHoundBot'
     AnimationTableClass=Class'WOTPawns.AnimationTableHound'
     Mesh=LodMesh'WOTPawns.Hound'
     DrawScale=1.447080
     CollisionHeight=46.000000
}
