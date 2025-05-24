//=============================================================================
// Forsaken.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 6 $
//=============================================================================

class Forsaken expands WOTPlayer;

//=============================================================================

#exec MESH IMPORT MESH=Forsaken ANIVFILE=MODELS\Forsaken_a.3d DATAFILE=MODELS\Forsaken_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Forsaken X=-10 Y=0 Z=5 YAW=0

#exec MESH SEQUENCE MESH=Forsaken SEQ=All        STARTFRAME=0 NUMFRAMES=237
#exec MESH SEQUENCE MESH=Forsaken SEQ=ATTACK     STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Forsaken SEQ=ATTACKRUN  STARTFRAME=2 NUMFRAMES=14     // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=Forsaken SEQ=ATTACKRUNR STARTFRAME=17 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=Forsaken SEQ=ATTACKRUNL STARTFRAME=32 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=Forsaken SEQ=ATTACKWALK STARTFRAME=47 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=Forsaken SEQ=BREATH     STARTFRAME=61 NUMFRAMES=10		Group=Waiting
#exec MESH SEQUENCE MESH=Forsaken SEQ=DEATHB     STARTFRAME=71 NUMFRAMES=17
#exec MESH SEQUENCE MESH=Forsaken SEQ=DEATHF     STARTFRAME=88 NUMFRAMES=29
#exec MESH SEQUENCE MESH=Forsaken SEQ=DODGELEFT  STARTFRAME=117 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Forsaken SEQ=DODGERIGHT STARTFRAME=118 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Forsaken SEQ=FALL       STARTFRAME=119 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Forsaken SEQ=HITB       STARTFRAME=121 NUMFRAMES=1		Group=TakeHit
#exec MESH SEQUENCE MESH=Forsaken SEQ=HITBHARD   STARTFRAME=121 NUMFRAMES=7		Group=TakeHit
#exec MESH SEQUENCE MESH=Forsaken SEQ=HITF       STARTFRAME=127 NUMFRAMES=1		Group=TakeHit
#exec MESH SEQUENCE MESH=Forsaken SEQ=HITFHARD   STARTFRAME=127 NUMFRAMES=7		Group=TakeHit
#exec MESH SEQUENCE MESH=Forsaken SEQ=JUMP       STARTFRAME=134 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Forsaken SEQ=LANDED     STARTFRAME=135 NUMFRAMES=10	Group=Landing
#exec MESH SEQUENCE MESH=Forsaken SEQ=LOOK       STARTFRAME=145 NUMFRAMES=20	Group=Waiting
#exec MESH SEQUENCE MESH=Forsaken SEQ=RUN        STARTFRAME=166 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=Forsaken SEQ=RUNR       STARTFRAME=181 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=Forsaken SEQ=RUNL       STARTFRAME=196 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=Forsaken SEQ=SWIM       STARTFRAME=210 NUMFRAMES=12 
#exec MESH SEQUENCE MESH=Forsaken SEQ=WALK       STARTFRAME=223 NUMFRAMES=14

#exec TEXTURE IMPORT NAME=For_Base FILE=MODELS\For_Base.PCX GROUP=Skins FLAGS=2

#exec MESHMAP NEW   MESHMAP=Forsaken MESH=Forsaken
#exec MESHMAP SCALE MESHMAP=Forsaken X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Forsaken NUM=1 TEXTURE=For_Base
#exec MESHMAP SETTEXTURE MESHMAP=Forsaken NUM=2 TEXTURE=For_Base
#exec MESHMAP SETTEXTURE MESHMAP=Forsaken NUM=3 TEXTURE=For_Base

//=============================================================================

#exec TEXTURE IMPORT FILE=Icons\Players\H_Forsaken0.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Players\H_Forsaken1.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Players\H_Forsaken2.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Players\H_Forsaken3.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Players\H_ForsakenDisguise.PCX GROUP=UI MIPS=Off

//=============================================================================

#exec MESH NOTIFY MESH=Forsaken SEQ=Walk		TIME=0.25 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Forsaken SEQ=Walk		TIME=0.75 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Forsaken SEQ=AttackWalk	TIME=0.25 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Forsaken SEQ=AttackWalk	TIME=0.75 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Forsaken SEQ=Run			TIME=0.27 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Forsaken SEQ=Run			TIME=0.73 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Forsaken SEQ=AttackRun	TIME=0.27 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Forsaken SEQ=AttackRun	TIME=0.73 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Forsaken SEQ=RunL		TIME=0.80 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Forsaken SEQ=RunL		TIME=0.47 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Forsaken SEQ=RunR		TIME=0.73 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Forsaken SEQ=RunR		TIME=0.40 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Forsaken SEQ=AttackRunL	TIME=0.80 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Forsaken SEQ=AttackRunL	TIME=0.47 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Forsaken SEQ=AttackRunR	TIME=0.73 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Forsaken SEQ=AttackRunR	TIME=0.40 FUNCTION=PlayMovementSound

#exec MESH NOTIFY MESH=Forsaken SEQ=DeathB		TIME=0.76 FUNCTION=TransitionToCarcassNotification
#exec MESH NOTIFY MESH=Forsaken SEQ=DeathF		TIME=0.86 FUNCTION=TransitionToCarcassNotification

defaultproperties
{
     TextureHelperClass=Class'WOTPawns.PCMaleTextureHelper'
     SoundTableClass=Class'WOTPawns.SoundTableForsaken'
     AnimationTableClass=Class'WOTPawns.AnimationTableForsaken'
     DefaultAngrealInventory=Class'Angreal.AngrealInvAirBurst'
     HealthIcons(0)=Texture'WOTPawns.UI.H_Forsaken0'
     HealthIcons(1)=Texture'WOTPawns.UI.H_Forsaken1'
     HealthIcons(2)=Texture'WOTPawns.UI.H_Forsaken2'
     HealthIcons(3)=Texture'WOTPawns.UI.H_Forsaken3'
     DisguiseIcon=Texture'WOTPawns.UI.H_ForsakenDisguise'
     PlayerColor=PC_Red
     TeamDescription="Forsaken"
     AnimSequence=Breath
     Skin=Texture'WOTPawns.Skins.For_Base'
     Mesh=LodMesh'WOTPawns.Forsaken'
     DrawScale=0.670000
     MultiSkins(1)=Texture'WOTPawns.Skins.For_Base'
     MultiSkins(2)=Texture'WOTPawns.Skins.For_Base'
     MultiSkins(3)=Texture'WOTPawns.Skins.For_Base'
}
