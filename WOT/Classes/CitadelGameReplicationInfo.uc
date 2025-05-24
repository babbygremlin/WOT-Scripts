//=============================================================================
// CitadelGameReplicationInfo.
//=============================================================================
class CitadelGameReplicationInfo expands GameReplicationInfo;

var() config int SealGoal;

replication
{
	reliable if( Role == ROLE_Authority )
		SealGoal;
}

defaultproperties
{
     SealGoal=4
}
