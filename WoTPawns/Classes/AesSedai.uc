//=============================================================================
// AesSedai.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 7 $
//=============================================================================

class AesSedai expands WOTPlayer;

//=============================================================================

#exec MESH IMPORT MESH=AesSedai ANIVFILE=MODELS\AesSedai_a.3d DATAFILE=MODELS\AesSedai_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=AesSedai X=-60 Y=0 Z=03

#exec MESH SEQUENCE MESH=AesSedai SEQ=All        STARTFRAME=0 NUMFRAMES=236
#exec MESH SEQUENCE MESH=AesSedai SEQ=ATTACK     STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=AesSedai SEQ=ATTACKRUN  STARTFRAME=2 NUMFRAMES=14     // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=AesSedai SEQ=ATTACKRUNR STARTFRAME=17 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=AesSedai SEQ=ATTACKRUNL STARTFRAME=32 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=AesSedai SEQ=ATTACKWALK STARTFRAME=47 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=AesSedai SEQ=BREATH     STARTFRAME=61 NUMFRAMES=10		Group=Waiting
#exec MESH SEQUENCE MESH=AesSedai SEQ=DEATHF     STARTFRAME=71 NUMFRAMES=30
#exec MESH SEQUENCE MESH=AesSedai SEQ=DEATHL     STARTFRAME=101 NUMFRAMES=15
#exec MESH SEQUENCE MESH=AesSedai SEQ=DODGELEFT  STARTFRAME=116 NUMFRAMES=1
#exec MESH SEQUENCE MESH=AesSedai SEQ=DODGERIGHT STARTFRAME=117 NUMFRAMES=1
#exec MESH SEQUENCE MESH=AesSedai SEQ=FALL       STARTFRAME=118 NUMFRAMES=1
#exec MESH SEQUENCE MESH=AesSedai SEQ=HITB       STARTFRAME=119 NUMFRAMES=1		Group=TakeHit
#exec MESH SEQUENCE MESH=AesSedai SEQ=HITBHARD   STARTFRAME=119 NUMFRAMES=7		Group=TakeHit
#exec MESH SEQUENCE MESH=AesSedai SEQ=HITF       STARTFRAME=126 NUMFRAMES=1		Group=TakeHit
#exec MESH SEQUENCE MESH=AesSedai SEQ=HITFHARD   STARTFRAME=126 NUMFRAMES=7		Group=TakeHit
#exec MESH SEQUENCE MESH=AesSedai SEQ=JUMP       STARTFRAME=133 NUMFRAMES=1
#exec MESH SEQUENCE MESH=AesSedai SEQ=LANDED     STARTFRAME=134 NUMFRAMES=10	Group=Landing
#exec MESH SEQUENCE MESH=AesSedai SEQ=LOOK       STARTFRAME=144 NUMFRAMES=20	Group=Waiting
#exec MESH SEQUENCE MESH=AesSedai SEQ=RUN        STARTFRAME=165 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=AesSedai SEQ=RUNR       STARTFRAME=180 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=AesSedai SEQ=RUNL       STARTFRAME=195 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=AesSedai SEQ=SWIM       STARTFRAME=209 NUMFRAMES=12
#exec MESH SEQUENCE MESH=AesSedai SEQ=WALK       STARTFRAME=222 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching

#exec TEXTURE IMPORT NAME=Aes_Base FILE=MODELS\Aes_Base.PCX GROUP=Skins FLAGS=2 // Ajah1
#exec TEXTURE IMPORT NAME=Aes_Seat FILE=MODELS\Aes_Seat.PCX GROUP=Skins FLAGS=2 // Ajah1

#exec MESHMAP NEW   MESHMAP=AesSedai MESH=AesSedai
#exec MESHMAP SCALE MESHMAP=AesSedai X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=AesSedai NUM=1 TEXTURE=Aes_Base
#exec MESHMAP SETTEXTURE MESHMAP=AesSedai NUM=2 TEXTURE=Aes_Base

//=============================================================================

#exec TEXTURE IMPORT FILE=Icons\Players\H_AesSedai0.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Players\H_AesSedai1.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Players\H_AesSedai2.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Players\H_AesSedai3.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Players\H_AesSedaiDisguise.PCX GROUP=UI MIPS=Off

//=============================================================================

#exec MESH NOTIFY MESH=AesSedai SEQ=Walk		TIME=0.25 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=AesSedai SEQ=Walk		TIME=0.75 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=AesSedai SEQ=AttackWalk	TIME=0.25 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=AesSedai SEQ=AttackWalk	TIME=0.75 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=AesSedai SEQ=Run			TIME=0.27 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=AesSedai SEQ=Run			TIME=0.73 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=AesSedai SEQ=AttackRun	TIME=0.27 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=AesSedai SEQ=AttackRun	TIME=0.73 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=AesSedai SEQ=RunL		TIME=0.80 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=AesSedai SEQ=RunL		TIME=0.47 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=AesSedai SEQ=RunR		TIME=0.73 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=AesSedai SEQ=RunR		TIME=0.40 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=AesSedai SEQ=AttackRunL	TIME=0.80 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=AesSedai SEQ=AttackRunL	TIME=0.47 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=AesSedai SEQ=AttackRunR	TIME=0.73 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=AesSedai SEQ=AttackRunR	TIME=0.40 FUNCTION=PlayMovementSound

#exec MESH NOTIFY MESH=AesSedai SEQ=DeathF		TIME=0.37 FUNCTION=TransitionToCarcassNotification
#exec MESH NOTIFY MESH=AesSedai SEQ=DeathL		TIME=0.47 FUNCTION=TransitionToCarcassNotification

//=============================================================================

defaultproperties
{
     SkinSwitchLevel=6
     AltSkinStr="WOTPawns.Aes_Seat"
     TextureHelperClass=Class'WOTPawns.PCFemaleTextureHelper'
     SoundTableClass=Class'WOTPawns.SoundTableAesSedai'
     AnimationTableClass=Class'WOTPawns.AnimationTableAesSedai'
     DefaultAngrealInventory=Class'Angreal.AngrealInvAirBurst'
     IllusionAnimSequence=Breath
     IllusionAnimRate=0.020000
     HealthIcons(0)=Texture'WOTPawns.UI.H_AesSedai0'
     HealthIcons(1)=Texture'WOTPawns.UI.H_AesSedai1'
     HealthIcons(2)=Texture'WOTPawns.UI.H_AesSedai2'
     HealthIcons(3)=Texture'WOTPawns.UI.H_AesSedai3'
     DisguiseIcon=Texture'WOTPawns.UI.H_AesSedaiDisguise'
     TeamDescription="Aes Sedai"
     bIsFemale=True
     AnimSequence=Breath
     Texture=None
     Skin=Texture'WOTPawns.Skins.Aes_Base'
     Mesh=LodMesh'WOTPawns.AesSedai'
     DrawScale=0.950000
     MultiSkins(1)=Texture'WOTPawns.Skins.Aes_Base'
     MultiSkins(2)=Texture'WOTPawns.Skins.Aes_Base'
}
