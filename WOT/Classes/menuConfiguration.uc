//=============================================================================
// menuConfiguration.uc
//=============================================================================
class menuConfiguration expands menuLong;

const MENU_Brightness			= 1;	// [ 0 - 10 ]
const MENU_ToggleFullScreen		= 2;	//
const MENU_SelectResolution		= 3;	// [ 320x240 | 640x480 | 800x600 | 1024x768... ]
const MENU_AdvancedOptions		= 4;
const MENU_DisableVSync			= 5;	// On | Off
const MENU_MasterDetailLevel	= 6;	// [ 0:Gimp, 1:Limp, 2:Pimp ]
const MENU_TextureDetail		= 7;	// High | Medium | Low
const MENU_DetailTextures		= 8;	// On | Off
const MENU_GeometryDetail		= 9;	// High | Low
const MENU_MaxDetailLevel		= 10;	// [ 0 - 4 ]
const MENU_MaxNumDecals			= 11;	// [ 0 - 4095 ]
const MENU_ParticleDensity		= 12;	// [ 0 - 255 ]
const MENU_VolumetricLighting	= 13;	// On | Off
const MENU_SoundQuality			= 14;	// High | Low
const MENU_SoundVolume			= 15;	// [ 0 - 255 ]
const MENU_MusicVolume			= 16;	// [ 0 - 255 ]
const MENU_PlayMusic			= 17;	// On | Off

var float Brightness;
var string CurrentRes;
var string AvailableRes;
var string Resolutions[200];
var int resNum;
var bool bDisableVSync;
var byte MasterDetailLevel;
var string TextureDetail;
var bool DetailTextures;
var bool bLowDetailGeometry;
var byte MaxDetailLevel;
var int MaxNumDecals;
var byte ParticleDensity;
var bool bVolumetricLighting;
var bool bLowSoundQuality;
var int SoundVolume;
var int MusicVolume;
var bool bPlayMusic;

var string MenuValues[17];
var localized string NotApplicableStr;

//=============================================================================

function class<MasterDetail> GetDetailClass( byte N )
{
	switch( N )
	{
	case 0: return class'MasterDetailGimp';
	case 1: return class'MasterDetailLimp';
	case 2: return class'MasterDetailPimp';
	}
	assert( false ); // this should never happen
}

//=============================================================================

function SetDetailLevel( byte N )
{
	local class<MasterDetail> D;

	D = GetDetailClass( N );

	TextureDetail = D.default.TextureDetail;
	PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.ViewportManager TextureDetail "$TextureDetail );

	DetailTextures = D.default.DetailTextures;
	PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.GameRenderDevice DetailTextures "$ DetailTextures );

	bLowDetailGeometry = D.default.bLowDetailGeometry;
	PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.ViewportManager bLowDetailGeometry "$bLowDetailGeometry );

	MaxDetailLevel = D.default.MaxDetailLevel;
	PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.ViewportManager MaxDetailLevel "$MaxDetailLevel );

	MaxNumDecals = D.default.MaxNumDecals;
	PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.ViewportManager MaxNumDecals "$MaxNumDecals );

	ParticleDensity = D.default.ParticleDensity;
	PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.ViewportManager ParticleDensity "$ParticleDensity );

	bVolumetricLighting = D.default.bVolumetricLighting;
	PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.GameRenderDevice VolumetricLighting "$bVolumetricLighting );

	bLowSoundQuality = D.default.bLowSoundQuality;
	PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.AudioDevice LowSoundQuality "$bLowSoundQuality );

	// write-only properties

	PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.GameRenderDevice ShinySurfaces "$D.default.ShinySurfaces );
}

//=============================================================================

function bool IsDetailLevel( byte N )
{
	local class<MasterDetail> D;

	D = GetDetailClass( N );

	return	TextureDetail		== D.default.TextureDetail
		&&	DetailTextures		== D.default.DetailTextures
		&&	bLowDetailGeometry	== D.default.bLowDetailGeometry
		&&	MaxDetailLevel		== D.default.MaxDetailLevel
		&&	MaxNumDecals		== D.default.MaxNumDecals
		&&	ParticleDensity		== D.default.ParticleDensity
		&&	bVolumetricLighting	== D.default.bVolumetricLighting
		&&	bLowSoundQuality	== D.default.bLowSoundQuality;
}

//=============================================================================

function bool ProcessLeft()
{
	switch( Selection )
	{
	case MENU_Brightness:
		Brightness = FMax( 0.2, Brightness - 0.1 );
		break;
	case MENU_SelectResolution:
		ResNum--;
		if( ResNum < 0 )
		{
			ResNum = ArrayCount(Resolutions) - 1;
			while( Resolutions[ResNum] == "" )
				ResNum--;
		}
		MenuValues[ MENU_SelectResolution ] = Resolutions[ResNum];
		return true;
	case MENU_DisableVSync:
		break;
	case MENU_MasterDetailLevel:
		MasterDetailLevel = Max( 0, MasterDetailLevel - 1 );
		break;
	case MENU_TextureDetail:
		if( TextureDetail == "Medium" ) TextureDetail = "Low";
		else if( TextureDetail == "High" ) TextureDetail = "Medium";
		break;
	case MENU_DetailTextures:
	case MENU_GeometryDetail:
		break;
	case MENU_MaxDetailLevel:
		MaxDetailLevel = Max( 0, MaxDetailLevel - 1 );
		break;
	case MENU_MaxNumDecals:
		MaxNumDecals = Max( 0, MaxNumDecals - 16 );
		break;
	case MENU_ParticleDensity:
		ParticleDensity = Max( 0, ParticleDensity - 32 );
		break;
	case MENU_SoundVolume:
		SoundVolume = Max( 0, SoundVolume - 32 );
		break;
	case MENU_MusicVolume:
		MusicVolume = Max( 0, MusicVolume - 32 );
		break;
	case MENU_VolumetricLighting:
	case MENU_SoundQuality:
	case MENU_PlayMusic:
		break;
	default:
		return false;
	}

	return ProcessSelection();
}

//=============================================================================

function bool ProcessRight()
{
	switch( Selection )
	{
	case MENU_Brightness:
		Brightness = FMin( 1, Brightness + 0.1 );
		break;
	case MENU_SelectResolution:
		ResNum++;
		if( ResNum >= ArrayCount(Resolutions) || Resolutions[ResNum] == "" )
			ResNum = 0;
		MenuValues[ MENU_SelectResolution ] = Resolutions[ResNum];
		return true;
	case MENU_DisableVSync:
		break;
	case MENU_MasterDetailLevel:
		MasterDetailLevel = Min( 2, MasterDetailLevel + 1 );
		break;
	case MENU_TextureDetail:
		if( TextureDetail == "Medium" ) TextureDetail = "High";
		else if( TextureDetail == "Low" ) TextureDetail = "Medium";
		break;
	case MENU_DetailTextures:
	case MENU_GeometryDetail:
		break;
	case MENU_MaxDetailLevel:
		MaxDetailLevel = Min( 4, MaxDetailLevel + 1 ); // see UClient re: maximum
		break;
	case MENU_MaxNumDecals:
		MaxNumDecals = Min( 4095, MaxNumDecals + 16 );
		break;
	case MENU_ParticleDensity:
		ParticleDensity = Min( 255, ParticleDensity + 32 ); // see UClient re: maximum
		break;
	case MENU_SoundVolume:
		SoundVolume = Min( 255, SoundVolume + 32 );
		break;
	case MENU_MusicVolume:
		MusicVolume = Min( 255, MusicVolume + 32 );
		break;
	case MENU_VolumetricLighting:
	case MENU_SoundQuality:
	case MENU_PlayMusic:
		break;
	default:
		return false;
	}

	return ProcessSelection();
}		

//=============================================================================

function GetAvailableRes()
{
	local int p, i;
	local string ParseString;

	AvailableRes = PlayerOwner.ConsoleCommand( "GetRes" );
	resNum = 0;
	ParseString = AvailableRes;
	p = InStr( ParseString, " " );
	while( ResNum < ArrayCount(Resolutions) && p != -1 ) 
	{
		Resolutions[ResNum] = Left( ParseString, p );
		ParseString = Right( ParseString, Len( ParseString ) - p - 1 );
		p = InStr( ParseString, " " );
		ResNum++;
	}

	Resolutions[ResNum] = ParseString;
	for( i = ResNum + 1; i< ArrayCount(Resolutions); i++ )
	{
		Resolutions[i] = "";
	}

	CurrentRes = PlayerOwner.ConsoleCommand( "GetCurrentRes" );
	MenuValues[ MENU_SelectResolution ] = CurrentRes;
	for( i = 0; i < ResNum+1; i++ )
	{
		if( MenuValues[ MENU_SelectResolution ] ~= Resolutions[i] )
		{
			ResNum = i;
			return;
		}
	}
	ResNum = 0;
	MenuValues[ MENU_SelectResolution ] = Resolutions[0];
}

//=============================================================================

function bool ProcessSelection()
{
	switch( Selection )
	{
	case MENU_Brightness:
		PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.ViewportManager Brightness "$Brightness );
		PlayerOwner.ConsoleCommand( "FLUSH" );
		break;
	case MENU_ToggleFullScreen:
		PlayerOwner.ConsoleCommand( "TOGGLEFULLSCREEN" );
		CurrentRes = PlayerOwner.ConsoleCommand( "GetCurrentRes" );
		GetAvailableRes();
		break;
	case MENU_SelectResolution:
		PlayerOwner.ConsoleCommand( "SetRes "$MenuValues[ MENU_SelectResolution ] );
		CurrentRes = PlayerOwner.ConsoleCommand( "GetCurrentRes" );
		GetAvailableRes();
		break;
	case MENU_AdvancedOptions:
		PlayerOwner.ConsoleCommand( "PREFERENCES" );
		break;
	case MENU_DisableVSync:
		bDisableVSync = !bDisableVSync;
		PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.GameRenderDevice DisableVSync "$bDisableVSync );
		break;
	case MENU_MasterDetailLevel:
		SetDetailLevel( MasterDetailLevel );
		PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.ViewportManager MasterDetailLevel "$MasterDetailLevel );
		break;
	case MENU_TextureDetail:
		PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.ViewportManager TextureDetail "$TextureDetail );
		break;
	case MENU_DetailTextures:
		DetailTextures = !DetailTextures;
		PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.GameRenderDevice DetailTextures "$DetailTextures );
		break;
	case MENU_GeometryDetail:
		bLowDetailGeometry = !bLowDetailGeometry;
		PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.ViewportManager bLowDetailGeometry "$bLowDetailGeometry );
		break;
	case MENU_MaxDetailLevel:
		PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.ViewportManager MaxDetailLevel "$MaxDetailLevel );
		break;
	case MENU_MaxNumDecals:
		PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.ViewportManager MaxNumDecals "$MaxNumDecals );
		break;
	case MENU_ParticleDensity:
		PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.ViewportManager ParticleDensity "$ParticleDensity );
		break;
	case MENU_VolumetricLighting:
		bVolumetricLighting = !bVolumetricLighting;
		PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.GameRenderDevice VolumetricLighting "$bVolumetricLighting );
		break;
	case MENU_SoundQuality:
		bLowSoundQuality = !bLowSoundQuality;
		PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.AudioDevice LowSoundQuality "$bLowSoundQuality );
		break;
	case MENU_SoundVolume:
		PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.AudioDevice SoundVolume "$SoundVolume );
		break;
	case MENU_MusicVolume:
		PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.AudioDevice MusicVolume "$MusicVolume );
		PlayerOwner.ConsoleCommand( "MP3 VOLUME" );
		break;
	case MENU_PlayMusic:
		bPlayMusic = !bPlayMusic;
		PlayerOwner.ConsoleCommand( "set ini:Engine.Engine.AudioDevice UseMP3Music "$bPlayMusic );
		if( bPlayMusic && Level.MP3Filename != "" )
		{
			PlayerOwner.ConsoleCommand( "MP3 START "$ Level.MP3Filename );
		}
		else
		{
			PlayerOwner.ConsoleCommand( "MP3 STOP" );
		}
		break;
	default:
		return false;
	}

	return true;
}

//=============================================================================

function DrawOptions( Canvas C )
{
	local int i;

	for( i=1; i<=MenuLength; i++ )
	{
		MenuList[i] = Default.MenuList[i];
	}

	DrawList( C, LC_Left );
}

//=============================================================================

function string GetResolutionStr()
{
	if( CurrentRes == "" )
	{
		GetAvailableRes();
	}
	else if( AvailableRes == "" )
	{
		GetAvailableRes();
	}

	if( MenuValues[ MENU_SelectResolution ] ~= CurrentRes )
	{
		return "["$MenuValues[ MENU_SelectResolution ]$"]";
	}
	else
	{
		return " "$MenuValues[ MENU_SelectResolution ];
	}
}

//=============================================================================

function string GetDisableVSyncStr()
{
	bDisableVSync = bool( PlayerOwner.ConsoleCommand( "get ini:Engine.Engine.GameRenderDevice DisableVSync" ) );

	return GetOnOffStr( !bDisableVSync );
}

//=============================================================================

function string GetMasterDetailLevelStr()
{
	MasterDetailLevel = byte( PlayerOwner.ConsoleCommand( "get ini:Engine.Engine.ViewportManager MasterDetailLevel" ) );
	
	if( IsDetailLevel( MasterDetailLevel ) )
	{
		return GetLowMediumHighStr( MasterDetailLevel );
	}
	else
	{
		return NotApplicableStr;
	}
}

//=============================================================================

function string GetTextureDetailLevelStr()
{
	TextureDetail = PlayerOwner.ConsoleCommand( "get ini:Engine.Engine.ViewportManager TextureDetail" );

	return TextureDetail;
}

//=============================================================================

function string GetDetailTexturesStr()
{
	DetailTextures = bool( PlayerOwner.ConsoleCommand( "get ini:Engine.Engine.GameRenderDevice DetailTextures" ) );

	return GetOnOffStr( DetailTextures );
}

//=============================================================================

function string GetGeometryDetailLevelStr()
{
	bLowDetailGeometry = bool( PlayerOwner.ConsoleCommand( "get ini:Engine.Engine.ViewportManager bLowDetailGeometry" ) );

	return GetHighLowStr( !bLowDetailGeometry );
}

//=============================================================================

function string GetMaxDecalsStr()
{
	MaxNumDecals = int( PlayerOwner.ConsoleCommand( "get ini:Engine.Engine.ViewportManager MaxNumDecals" ) );
	
	return ""$MaxNumDecals;
}

//=============================================================================

function string GetVolumetricLightingStr()
{
	bVolumetricLighting = bool( PlayerOwner.ConsoleCommand( "get ini:Engine.Engine.GameRenderDevice VolumetricLighting" ) );

	return GetOnOffStr( bVolumetricLighting );
}

//=============================================================================

function string GetSoundQualityStr()
{
	bLowSoundQuality = bool( PlayerOwner.ConsoleCommand( "get ini:Engine.Engine.AudioDevice LowSoundQuality" ) );

	return GetHighLowStr( !bLowSoundQuality );
}

//=============================================================================

function string GetPlayMusicStr()
{
	bPlayMusic = bool( PlayerOwner.ConsoleCommand( "get ini:Engine.Engine.AudioDevice UseMP3Music" ) );
	
	return GetOnOffStr( bPlayMusic );
}

//=============================================================================

function DrawValues( Canvas C )
{	
	MenuList[MENU_Brightness]			= " ";							// 1 slider
	MenuList[MENU_ToggleFullScreen]		= " "; 							// 2 nothing to show
	MenuList[MENU_SelectResolution]		= GetResolutionStr();			// 3
	MenuList[MENU_AdvancedOptions]		= " ";							// 4 nothing to show
	MenuList[MENU_DisableVSync]			= GetDisableVSyncStr();			// 5
	MenuList[MENU_MasterDetailLevel]	= GetMasterDetailLevelStr();	// 6
	MenuList[MENU_TextureDetail]		= GetTextureDetailLevelStr();	// 7 
	MenuList[MENU_DetailTextures]		= GetDetailTexturesStr();		// 8 
	MenuList[MENU_GeometryDetail]		= GetGeometryDetailLevelStr();	// 9
	MenuList[MENU_MaxDetailLevel]		= " ";							// 10 slider
	MenuList[MENU_MaxNumDecals]			= GetMaxDecalsStr();			// 11
	MenuList[MENU_ParticleDensity]		= " ";							// 12 slider
	MenuList[MENU_VolumetricLighting]	= GetVolumetricLightingStr();	// 13
	MenuList[MENU_SoundQuality]			= GetSoundQualityStr();			// 14
	MenuList[MENU_SoundVolume]			= " ";							// 15 slider
	MenuList[MENU_MusicVolume]			= " ";							// 16 slider
	MenuList[MENU_PlayMusic]			= GetPlayMusicStr();			// 17

	DrawList( C, LC_Right );
}

//=============================================================================

function DrawMenu( Canvas C )
{
	DrawOptions( C );

	DrawValues( C );
	
	// Brightness
	Brightness = float( PlayerOwner.ConsoleCommand( "get ini:Engine.Engine.ViewportManager Brightness" ) );
	DrawSlider( C, RightMenuListOffsetX, MenuListPosY[MENU_Brightness], 10 * Brightness - 2, 0, 1, MENU_Brightness );

	// Decoration Detail
	MaxDetailLevel = byte( PlayerOwner.ConsoleCommand( "get ini:Engine.Engine.ViewportManager MaxDetailLevel" ) );
	DrawSlider( C, RightMenuListOffsetX, MenuListPosY[MENU_MaxDetailLevel], MaxDetailLevel * 2, 0, 1, MENU_MaxDetailLevel );

	// Particle Density
	ParticleDensity = byte( PlayerOwner.ConsoleCommand( "get ini:Engine.Engine.ViewportManager ParticleDensity" ) );
	DrawSlider( C, RightMenuListOffsetX, MenuListPosY[MENU_ParticleDensity], ParticleDensity, 0, 32, MENU_ParticleDensity );
	
	// Sound Volume
	SoundVolume = int( PlayerOwner.ConsoleCommand( "get ini:Engine.Engine.AudioDevice SoundVolume" ) );
	DrawSlider( C, RightMenuListOffsetX, MenuListPosY[MENU_SoundVolume], SoundVolume, 0, 32, MENU_SoundVolume );

	// Music Volume
	MusicVolume = int( PlayerOwner.ConsoleCommand( "get ini:Engine.Engine.AudioDevice MusicVolume" ) );
	DrawSlider( C, RightMenuListOffsetX, MenuListPosY[MENU_MusicVolume], MusicVolume, 0, 32, MENU_MusicVolume );

	// Draw help panel
	DrawHelpPanel( C );
}

defaultproperties
{
     bMenuHelp=True
     bLargeFont=False
     MenuLength=17
}
