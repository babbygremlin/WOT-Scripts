//=============================================================================
// Debug.
// $Author: Mfox $
// $Date: 1/05/00 2:36p $
// $Revision: 3 $
//=============================================================================

class Debug expands Actor native;

//#if 1 //NEW

var () const editconst int DBI_None;
var () const editconst int DBI_BehaviorDefault;
var () const editconst int DBI_BehaviorSet;
var () const editconst int DBI_BehaviorClear;
var () const editconst int DBI_BehaviorToggle;


var () const editconst int DB_None;
var () const editconst int DB_Enabled;
var () const editconst int DB_OutputLogFile;
var () const editconst int DB_OutputLogScreen;
var () const editconst int DB_CrashOnAssert;

var () const editconst int DB_PrefixObjectName;
var () const editconst int DB_PrefixObjectState;
var () const editconst int DB_PrefixDebugCategory;
var () const editconst int DB_PrefixTime;

var () const editconst Name DC_None;
var () const editconst Name DC_All;

var () const editconst Name DC_Animation;
var () const editconst Name DC_Sound;
var () const editconst Name DC_StateTransition;
var () const editconst Name DC_StateCode;

var () const editconst Name DC_Notification;
var () const editconst Name DC_EngineNotification;
var () const editconst Name DC_BehaviorTransition;

struct TExecInterfaceInfo
{
	var() string ExecCommand;
	var() int DBI_Command;
	var() int DB_Command;
};

var() int DebugBehaviors;
var() Name DisclosedCategories[ 64 ];
var () const editconst TExecInterfaceInfo DebugExecInterface[ 32 ];



/*
DBI_None = 0,
DBI_BehaviorDefault = 1
DBI_BehaviorSet = 2,
DBI_BehaviorClear = 4,
DBI_BehaviorToggle = 8

DB_None = 0;
DB_Enabled = 1;
DB_OutputLogFile = 2;
DB_OutputLogScreen = 4;
DB_CrashOnAssert = 8;
DB_PrefixObjectName = 16;
DB_PrefixObjectState = 32;
*/



//=============================================================================
// public interface
//=============================================================================

/*
DebugActor: The actor on behalf of which debugging is being performed
Display: The string that is printed to the output device
DebugCategory: The category that this debug operation pertains to

for a debug operation to be performed the debug actor must be debugable
and the debug category passed to the debug operation must be disclosed
*/

native static function DebugLog( Object DebugObject, coerce string Display, optional Name DebugCategory );
native static function DebugWarn( Object DebugObject, coerce string Display, optional Name DebugCategory );
native static function DebugAssert( Object DebugObject, bool bAssertCondition, coerce string Display, optional Name DebugCategory );
native static function DiscloseCategory( Object DebugObject, Name DebugCategory );
native static function SupressCategory( Object DebugObject, Name DebugCategory );

native static function ExecDebugBehaviorInit( Object DebugObject, string ExecCommand );
native static function DebugBehaviorInit( Object DebugObject, int DebugBehaviorInit, int NewDebugBehavior );

native static function SetDebugBehavior( Object DebugObject, int SetBehavior );
native static function ClearDebugBehavior( Object DebugObject, int ClearBehavior );
native static function ToggleDebugBehavior( Object DebugObject, int ToggleBehavior );
native static function GetDebugBehaviors( Object DebugObject, out int CurrentDebugBehaviors );
native static function SetDebugBehaviors( Object DebugObject, int NewDebugBehaviors );
native static function SetDefaultDebugBehaviors( Object DebugObject );



//=============================================================================
// public interface
//=============================================================================



/*
static function ExecDebugBehaviorInit( Object DebugObject, string ExecCommand )
{
	local int CurrentDebugExecInterfaceIdx;
	
	//Log( DebugActor $ "::" $ default.class $ "::ExecDebugBehaviorInit ExecCommand: " $ ExecCommand );
	for ( CurrentDebugExecInterfaceIdx = 0;
			( CurrentDebugExecInterfaceIdx < DebugExecInterfaceCount );
			CurrentDebugExecInterfaceIdx++ )
	{
		//Log( DebugActor $ "::" $ default.class $ "::ExecDebugBehaviorInit CurrentExecCommand: " $
		//		default.DebugExecInterface[ CurrentDebugExecInterfaceIdx ].ExecCommand );
				
		if( default.DebugExecInterface[ CurrentDebugExecInterfaceIdx ].ExecCommand == "" )
		{
			break;
		}
		else if( ExecCommand ~= default.DebugExecInterface[ CurrentDebugExecInterfaceIdx ].ExecCommand )
		{
			DebugBehaviorInit( DebugActor,
					default.DebugExecInterface[ CurrentDebugExecInterfaceIdx ].DBI_Command,
					default.DebugExecInterface[ CurrentDebugExecInterfaceIdx ].DB_Command );
			break;
		}
	}
}



static function DebugBehaviorInit( Object DebugObject, int DebugBehaviorInit, int NewDebugBehavior )
{
	//Log( DebugActor $ "::" $ default.class $ "::DebugBehaviorInit " $ DebugBehaviorInit $ ", " $ NewDebugBehavior  );
	switch( NewDebugBehavior )
	{
		case default.DB_None:
			break;
		case default.DB_Enabled:
		case default.DB_CrashOnAssert:
		case default.DB_OutputLogFile:
		case default.DB_OutputLogScreen:
		case default.DB_PrefixObjectName:
		case default.DB_PrefixObjectState:
			switch( DebugBehaviorInit )
			{
				case default.DBI_BehaviorDefault:
					SetDefaultDebugBehaviors( DebugActor );
					break;
				case default.DBI_BehaviorClear:
					ClearDebugBehavior( DebugActor, NewDebugBehavior );
					break;
				case default.DBI_BehaviorSet:
					SetDebugBehavior( DebugActor, NewDebugBehavior );
					break;
				case default.DBI_BehaviorToggle:
					ToggleDebugBehavior( DebugActor, NewDebugBehavior );
					break;
			}
			break;
		default:
			break;
	}
}
*/

//#endif

defaultproperties
{
    DBI_BehaviorDefault=1
    DBI_BehaviorSet=2
    DBI_BehaviorClear=4
    DBI_BehaviorToggle=8
    DB_Enabled=1
    DB_OutputLogFile=2
    DB_OutputLogScreen=4
    DB_CrashOnAssert=8
    DB_PrefixObjectName=16
    DB_PrefixObjectState=32
    DB_PrefixDebugCategory=64
    DB_PrefixTime=128
    DC_None=DebugCategory_None
    DC_All=DebugCategory_All
    DC_Animation=DebugCategory_Animation
    DC_Sound=DebugCategory_Sound
    DC_StateTransition=DebugCategory_StateTransition
    DC_StateCode=DebugCategory_StateCode
    DC_Notification=DebugCategory_Notification
    DC_EngineNotification=DebugCategory_EngineNotification
    DC_BehaviorTransition=DebugCategory_BehaviorTransition
    DebugExecInterface(0)=(ExecCommand="SetEnabled",DBI_Command=2,DB_Command=1),
    DebugExecInterface(1)=(ExecCommand="ClearEnabled",DBI_Command=4,DB_Command=1),
    DebugExecInterface(2)=(ExecCommand="ToggleEnabled",DBI_Command=8,DB_Command=1),
    DebugExecInterface(3)=(ExecCommand="SetLogFile",DBI_Command=2,DB_Command=2),
    DebugExecInterface(4)=(ExecCommand="ClearLogFile",DBI_Command=4,DB_Command=2),
    DebugExecInterface(5)=(ExecCommand="ToggleLogFile",DBI_Command=8,DB_Command=2),
    DebugExecInterface(6)=(ExecCommand="SetLogScreen",DBI_Command=2,DB_Command=4),
    DebugExecInterface(7)=(ExecCommand="ClearLogScreen",DBI_Command=4,DB_Command=4),
    DebugExecInterface(8)=(ExecCommand="ToggleLogScreen",DBI_Command=8,DB_Command=4),
    DebugExecInterface(9)=(ExecCommand="SetAssertCrash",DBI_Command=2,DB_Command=8),
    DebugExecInterface(10)=(ExecCommand="ClearAssertCrash",DBI_Command=4,DB_Command=8),
    DebugExecInterface(11)=(ExecCommand="ToggleAssertCrash",DBI_Command=8,DB_Command=8),
    DebugExecInterface(12)=(ExecCommand="SetDefault",DBI_Command=1,DB_Command=0),
}
