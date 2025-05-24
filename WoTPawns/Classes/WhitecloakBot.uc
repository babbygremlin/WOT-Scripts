//=============================================================================
// WhitecloakBot.
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 7 $
//=============================================================================

class WhitecloakBot expands WOTBot;

// stubbed in for bots -- TBD
#exec MESH SEQUENCE MESH=Whitecloak SEQ=LISTEN			STARTFRAME=0 NUMFRAMES=1 // NA                    
#exec MESH SEQUENCE MESH=Whitecloak SEQ=REACTP			STARTFRAME=0 NUMFRAMES=1 // NA
#exec MESH SEQUENCE MESH=Whitecloak SEQ=REACTPLOOP		STARTFRAME=0 NUMFRAMES=1 // NA
#exec MESH SEQUENCE MESH=Whitecloak SEQ=SEEENEMY		STARTFRAME=0 NUMFRAMES=1 // NA
#exec MESH SEQUENCE MESH=Whitecloak SEQ=GONG			STARTFRAME=0 NUMFRAMES=1 // NA
#exec MESH SEQUENCE MESH=Whitecloak SEQ=GIVEORDERS		STARTFRAME=0 NUMFRAMES=1 // NA
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=LANDED1			STARTFRAME=137 NUMFRAMES=1		Group=Landing

// attack sequence is currently too short to use a notification function (code in grunt will call this directly)
//#exec MESH NOTIFY MESH=WhiteCloak SEQ=Attack		TIME=0.50  FUNCTION=ShootRangedAmmo

defaultproperties
{
     MinOffensiveAngrealUsageInterval=3.000000
     MinDefensiveAngrealUsageInterval=1.000000
     AII_AngrealInventoryStr(0)="Angreal.AngrealInvAirBurst"
     AII_AngrealInventoryStr(1)="Angreal.AngrealInvDart"
     AII_AngrealInventoryStr(2)="Angreal.AngrealInvSeeker"
     AII_AngrealInventoryStr(3)="Angreal.AngrealInvFireball"
     AII_AngrealInventoryStr(4)="Angreal.AngrealInvDecay"
     AII_AngrealInventoryStr(5)="Angreal.AngrealInvTaint"
     AII_AngrealInventoryStr(6)="Angreal.AngrealInvHeal"
     AII_AngrealInventoryStr(8)="Angreal.AngrealInvAirShield"
     AII_AngrealInventoryStr(9)="Angreal.AngrealInvFireball"
     AII_AngrealInventoryStr(10)="Angreal.AngrealInvAbsorb"
     AII_AngrealInventoryStr(11)="Angreal.AngrealInvShift"
     AII_Priority(0)=1.000000
     AII_Priority(1)=3.000000
     AII_Priority(2)=5.000000
     AII_Priority(3)=4.000000
     AII_Priority(4)=7.000000
     AII_Priority(5)=8.000000
     AII_Priority(6)=5.000000
     AII_Priority(8)=10.000000
     AII_Priority(9)=4.000000
     AII_Priority(10)=9.000000
     AII_Priority(11)=7.000000
     AII_MinChargeGroupInterval(4)=25.000000
     AII_MinChargeGroupInterval(5)=50.000000
     AII_MinChargeGroupInterval(10)=30.000000
     HealthMPMin=800.000000
     HealthMPMax=800.000000
     HealthSPMin=800.000000
     HealthSPMax=800.000000
     TextureHelperClass=Class'WOTPawns.PCMaleTextureHelper'
     SoundTableClass=Class'WOTPawns.SoundTableWhitecloakBot'
     AnimationTableClass=Class'WOTPawns.AnimationTableWhitecloak'
     Mesh=LodMesh'WOTPawns.Whitecloak'
     DrawScale=1.080000
     CollisionHeight=46.000000
}
