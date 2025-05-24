//=============================================================================
// Crow.
// $Author: Mfox $
// $Date: 8/31/99 10:14p $
// $Revision: 2 $
//=============================================================================
class Crow expands WOTDecoration;

#exec MESH IMPORT MESH=Crow ANIVFILE=MODELS\Crow_a.3d DATAFILE=MODELS\Crow_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=Crow X=0 Y=0 Z=0 Yaw=-64

#exec MESH SEQUENCE MESH=Crow SEQ=All  STARTFRAME=0 NUMFRAMES=16
#exec MESH SEQUENCE MESH=Crow SEQ=CROW STARTFRAME=0 NUMFRAMES=16

#exec TEXTURE IMPORT NAME=JCrow1 FILE=MODELS\Crow1.PCX GROUP=Skins FLAGS=2 // Crow

#exec MESHMAP NEW   MESHMAP=Crow MESH=Crow
#exec MESHMAP SCALE MESHMAP=Crow X=0.1 Y=0.1 Z=0.2

#exec MESHMAP SETTEXTURE MESHMAP=Crow NUM=1 TEXTURE=JCrow1

defaultproperties
{
     MaxAnimRate=0.500000
     MinAnimRate=0.300000
     bAutoAnimate=True
     bStatic=False
     bStasis=False
     bNetTemporary=True
     RemoteRole=ROLE_SimulatedProxy
     Mesh=Mesh'WOTDecorations.Crow'
     bCollideActors=False
     bBlockActors=False
     bBlockPlayers=False
}
