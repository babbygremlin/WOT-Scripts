//=============================================================================
// WhiteCloak.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 6 $
//=============================================================================

class WhiteCloak expands WOTPlayer;

//=============================================================================

#exec MESH IMPORT MESH=Whitecloak ANIVFILE=MODELS\Whitecloak_a.3D DATAFILE=MODELS\Whitecloak_d.3D X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Whitecloak X=-40 Y=25 Z=10 YAW=0 ROLL=0

#exec MESH SEQUENCE MESH=WhiteCloak SEQ=All        STARTFRAME=0 NUMFRAMES=217
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=ATTACK     STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=ATTACKRUN  STARTFRAME=2 NUMFRAMES=14     // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=ATTACKRUNL STARTFRAME=17 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=ATTACKRUNR STARTFRAME=32 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=ATTACKWALK STARTFRAME=47 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=BREATH     STARTFRAME=61 NUMFRAMES=3		Group=Waiting
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=DEATHF     STARTFRAME=64 NUMFRAMES=21
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=DEATHR     STARTFRAME=85 NUMFRAMES=35
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=FALL       STARTFRAME=120 NUMFRAMES=1
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=HITB       STARTFRAME=121 NUMFRAMES=1		Group=TakeHit
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=HITBHARD   STARTFRAME=121 NUMFRAMES=7		Group=TakeHit
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=HITF       STARTFRAME=128 NUMFRAMES=1		Group=TakeHit
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=HITFHARD   STARTFRAME=128 NUMFRAMES=7		Group=TakeHit
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=JUMP       STARTFRAME=135 NUMFRAMES=1
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=LANDED     STARTFRAME=136 NUMFRAMES=10		Group=Landing
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=LOOK       STARTFRAME=146 NUMFRAMES=3		Group=Waiting
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=RUN        STARTFRAME=150 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=RUNL       STARTFRAME=165 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=RUNR       STARTFRAME=180 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=SWIM       STARTFRAME=194 NUMFRAMES=8
#exec MESH SEQUENCE MESH=WhiteCloak SEQ=WALK       STARTFRAME=203 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching

#exec TEXTURE IMPORT NAME=Whi_Base FILE=MODELS\Whi_Base.PCX FAMILY=Skins FLAGS=2

#exec MESHMAP NEW   MESHMAP=Whitecloak MESH=Whitecloak
#exec MESHMAP SCALE MESHMAP=Whitecloak X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Whitecloak NUM=1 TEXTURE=Whi_Base
#exec MESHMAP SETTEXTURE MESHMAP=Whitecloak NUM=2 TEXTURE=Whi_Base
#exec MESHMAP SETTEXTURE MESHMAP=WhiteCloak NUM=3 TEXTURE=Whi_Base

//=============================================================================

#exec TEXTURE IMPORT FILE=Icons\Players\H_WhiteCloak0.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Players\H_WhiteCloak1.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Players\H_WhiteCloak2.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Players\H_WhiteCloak3.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Players\H_WhiteCloakDisguise.PCX GROUP=UI MIPS=Off

//=============================================================================

#exec MESH NOTIFY MESH=Whitecloak SEQ=Walk			TIME=0.27 FUNCTION=PlayMovementSound 
#exec MESH NOTIFY MESH=Whitecloak SEQ=Walk			TIME=0.73 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Whitecloak SEQ=AttackWalk	TIME=0.27 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Whitecloak SEQ=AttackWalk	TIME=0.73 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Whitecloak SEQ=Run			TIME=0.33 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Whitecloak SEQ=Run			TIME=0.87 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Whitecloak SEQ=AttackRun		TIME=0.33 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Whitecloak SEQ=AttackRun		TIME=0.87 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Whitecloak SEQ=RunL			TIME=0.45 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Whitecloak SEQ=RunL			TIME=0.72 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Whitecloak SEQ=RunR			TIME=0.72 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Whitecloak SEQ=RunR			TIME=0.45 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Whitecloak SEQ=AttackRunL	TIME=0.45 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Whitecloak SEQ=AttackRunL	TIME=0.72 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Whitecloak SEQ=AttackRunR	TIME=0.72 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Whitecloak SEQ=AttackRunR	TIME=0.45 FUNCTION=PlayMovementSound

#exec MESH NOTIFY MESH=Whitecloak SEQ=DeathF		TIME=0.48 FUNCTION=TransitionToCarcassNotification
#exec MESH NOTIFY MESH=Whitecloak SEQ=DeathR		TIME=0.83 FUNCTION=TransitionToCarcassNotification

defaultproperties
{
     TextureHelperClass=Class'WOTPawns.PCMaleTextureHelper'
     SoundTableClass=Class'WOTPawns.SoundTableWhitecloak'
     AnimationTableClass=Class'WOTPawns.AnimationTableWhitecloak'
     DefaultAngrealInventory=Class'Angreal.AngrealInvAirBurst'
     HealthIcons(0)=Texture'WOTPawns.UI.H_WhiteCloak0'
     HealthIcons(1)=Texture'WOTPawns.UI.H_WhiteCloak1'
     HealthIcons(2)=Texture'WOTPawns.UI.H_WhiteCloak2'
     HealthIcons(3)=Texture'WOTPawns.UI.H_WhiteCloak3'
     DisguiseIcon=Texture'WOTPawns.UI.H_WhiteCloakDisguise'
     PlayerColor=PC_Gold
     TeamDescription="Whitecloak"
     AnimSequence=Breath
     Skin=Texture'WOTPawns.Whi_Base'
     Mesh=LodMesh'WOTPawns.Whitecloak'
     DrawScale=1.080000
     MultiSkins(1)=Texture'WOTPawns.Whi_Base'
     MultiSkins(2)=Texture'WOTPawns.Whi_Base'
     MultiSkins(3)=Texture'WOTPawns.Whi_Base'
}
