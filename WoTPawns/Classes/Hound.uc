//=============================================================================
// Hound.uc
// $Author: Mfox $
// $Date: 1/05/00 2:38p $
// $Revision: 8 $
//=============================================================================

class Hound expands WOTPlayer;

//=============================================================================

#exec MESH IMPORT MESH=Hound ANIVFILE=MODELS\Hound_a.3d DATAFILE=MODELS\Hound_d.3d X=0 Y=0 Z=0
#exec MESH ORIGIN MESH=Hound X=-20 Y=0 Z=3

#exec MESH SEQUENCE MESH=Hound SEQ=All        STARTFRAME=0 NUMFRAMES=231
#exec MESH SEQUENCE MESH=Hound SEQ=ATTACK     STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Hound SEQ=ATTACKRUN  STARTFRAME=2 NUMFRAMES=14     // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=Hound SEQ=ATTACKRUNL STARTFRAME=17 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=Hound SEQ=ATTACKRUNR STARTFRAME=32 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=Hound SEQ=ATTACKWALK STARTFRAME=47 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=Hound SEQ=BREATH     STARTFRAME=61 NUMFRAMES=10		Group=Waiting
#exec MESH SEQUENCE MESH=Hound SEQ=DEATHB     STARTFRAME=71 NUMFRAMES=20
#exec MESH SEQUENCE MESH=Hound SEQ=DEATHF     STARTFRAME=91 NUMFRAMES=20
#exec MESH SEQUENCE MESH=Hound SEQ=DODGELEFT  STARTFRAME=111 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Hound SEQ=DODGERIGHT STARTFRAME=112 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Hound SEQ=FALL       STARTFRAME=113 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Hound SEQ=HITB       STARTFRAME=115 NUMFRAMES=1		Group=TakeHit
#exec MESH SEQUENCE MESH=Hound SEQ=HITBHARD   STARTFRAME=114 NUMFRAMES=7		Group=TakeHit
#exec MESH SEQUENCE MESH=Hound SEQ=HITF       STARTFRAME=121 NUMFRAMES=1		Group=TakeHit
#exec MESH SEQUENCE MESH=Hound SEQ=HITFHARD   STARTFRAME=121 NUMFRAMES=7		Group=TakeHit
#exec MESH SEQUENCE MESH=Hound SEQ=JUMP       STARTFRAME=128 NUMFRAMES=1
#exec MESH SEQUENCE MESH=Hound SEQ=LANDED     STARTFRAME=129 NUMFRAMES=10		Group=Landing
#exec MESH SEQUENCE MESH=Hound SEQ=LOOK       STARTFRAME=139 NUMFRAMES=20		Group=Waiting
#exec MESH SEQUENCE MESH=Hound SEQ=RUN        STARTFRAME=160 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=Hound SEQ=RUNL       STARTFRAME=175 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=Hound SEQ=RUNR       STARTFRAME=190 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching
#exec MESH SEQUENCE MESH=Hound SEQ=SWIM       STARTFRAME=204 NUMFRAMES=12
#exec MESH SEQUENCE MESH=Hound SEQ=WALK       STARTFRAME=217 NUMFRAMES=14    // ANIFIX: Cutting out a frame to prevent hitching

#exec TEXTURE IMPORT NAME=Hou_Base FILE=MODELS\Hou_Base.PCX GROUP=Skins FLAGS=2 // hound 1

#exec MESHMAP NEW   MESHMAP=Hound MESH=Hound
#exec MESHMAP SCALE MESHMAP=Hound X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Hound NUM=1 TEXTURE=Hou_Base
#exec MESHMAP SETTEXTURE MESHMAP=Hound NUM=2 TEXTURE=Hou_Base
#exec MESHMAP SETTEXTURE MESHMAP=Hound NUM=3 TEXTURE=Hou_Base
#exec MESHMAP SETTEXTURE MESHMAP=Hound NUM=4 TEXTURE=Hou_Base

//=============================================================================

#exec TEXTURE IMPORT FILE=Icons\Players\H_Hound0.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Players\H_Hound1.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Players\H_Hound2.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Players\H_Hound3.PCX GROUP=UI MIPS=Off
#exec TEXTURE IMPORT FILE=Icons\Players\H_HoundDisguise.PCX GROUP=UI MIPS=Off

//=============================================================================

#exec MESH NOTIFY MESH=Hound SEQ=Walk		TIME=0.25 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Hound SEQ=Walk		TIME=0.75 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Hound SEQ=AttackWalk TIME=0.25 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Hound SEQ=AttackWalk TIME=0.75 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Hound SEQ=Run		TIME=0.27 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Hound SEQ=Run		TIME=0.73 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Hound SEQ=AttackRun	TIME=0.27 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Hound SEQ=AttackRun	TIME=0.73 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Hound SEQ=RunL		TIME=0.80 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Hound SEQ=RunL		TIME=0.47 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Hound SEQ=RunR		TIME=0.73 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Hound SEQ=RunR		TIME=0.40 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Hound SEQ=AttackRunL	TIME=0.80 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Hound SEQ=AttackRunL	TIME=0.47 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Hound SEQ=AttackRunR	TIME=0.73 FUNCTION=PlayMovementSound
#exec MESH NOTIFY MESH=Hound SEQ=AttackRunR	TIME=0.40 FUNCTION=PlayMovementSound

#exec MESH NOTIFY MESH=Hound SEQ=DeathB		TIME=0.75 FUNCTION=TransitionToCarcassNotification
#exec MESH NOTIFY MESH=Hound SEQ=DeathF		TIME=0.75 FUNCTION=TransitionToCarcassNotification

defaultproperties
{
     TextureHelperClass=Class'WOTPawns.PCMaleTextureHelper'
     SoundTableClass=Class'WOTPawns.SoundTableHound'
     AnimationTableClass=Class'WOTPawns.AnimationTableHound'
     DefaultAngrealInventory=Class'Angreal.AngrealInvAirBurst'
     IllusionAnimSequence=Breath
     IllusionAnimRate=0.020000
     HealthIcons(0)=Texture'WOTPawns.UI.H_Hound0'
     HealthIcons(1)=Texture'WOTPawns.UI.H_Hound1'
     HealthIcons(2)=Texture'WOTPawns.UI.H_Hound2'
     HealthIcons(3)=Texture'WOTPawns.UI.H_Hound3'
     DisguiseIcon=Texture'WOTPawns.UI.H_HoundDisguise'
     PlayerColor=PC_Purple
     TeamDescription="Hound"
     AnimSequence=Breath
     Texture=None
     Skin=Texture'WOTPawns.Skins.Hou_Base'
     Mesh=LodMesh'WOTPawns.Hound'
     DrawScale=1.447080
     MultiSkins(1)=Texture'WOTPawns.Skins.Hou_Base'
     MultiSkins(2)=Texture'WOTPawns.Skins.Hou_Base'
     MultiSkins(3)=Texture'WOTPawns.Skins.Hou_Base'
     MultiSkins(4)=Texture'WOTPawns.Skins.Hou_Base'
}
