//=============================================================================
// TrollocAxeProjectile.
//=============================================================================

class TrollocAxeProjectile expands TrollocAxeProjectileBase;

#exec MESH IMPORT MESH=MTrollocAxeProjectile ANIVFILE=MODELS\TrollocAxe1_a.3d DATAFILE=MODELS\TrollocAxe1_d.3d X=0 Y=0 Z=0 MLOD=0
#exec MESH ORIGIN MESH=MTrollocAxeProjectile X=0 Y=0 Z=0

#exec MESH SEQUENCE MESH=MTrollocAxeProjectile SEQ=All         STARTFRAME=0 NUMFRAMES=1
#exec MESH SEQUENCE MESH=MTrollocAxeProjectile SEQ=TROLLOC_AXE STARTFRAME=0 NUMFRAMES=1

#exec MESHMAP NEW   MESHMAP=MTrollocAxeProjectile MESH=MTrollocAxeProjectile
#exec MESHMAP SCALE MESHMAP=MTrollocAxeProjectile X=0.1 Y=0.1 Z=0.2

defaultproperties
{
     PitchSpinRate=300000
     speed=1200.000000
     MaxSpeed=1200.000000
     Mesh=Mesh'WOTPawns.MTrollocAxeProjectile'
     MultiSkins(1)=Texture'WOTPawns.Skins.TWolf'
}
