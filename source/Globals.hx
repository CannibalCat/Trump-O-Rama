package;

import flixel.FlxState;

class Globals
{
	public static inline var GAME_VERSION:Float = 1.1;
	public static inline var WORLD_WIDTH:Int = 8192;
	public static inline var WORLD_HEIGHT:Int = 768;
	public static inline var TEXT_FONT = "assets/fonts/TextFont.ttf";
	public static inline var MICRO_FONT = "assets/fonts/MicroFont.ttf";
	public static inline var WILLIAMS_FONT = "assets/fonts/WilliamsFont.ttf";
	public static inline var ATTRACT_BGM:String = "assets/music/Hail.wav";
	public static inline var NEWSFLASH_BGM:String = "assets/music/NewsFlash.wav";
	public static inline var HIGHSCORE_BGM:String = "assets/music/HighScore.wav";
	public static inline var PARADISE_BGM:String = "assets/music/Choir.wav";
	public static var textSet:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.";
	public static var globalGameState:PlayState;
	public static var lastSoundSelection:Int = 0;
	public static var lastPhraseSelection:Int = 0;
	public static var playerFlickerRate:Float = 0.07;
	public static var currentZone:Int = 1;
	public static var currentWave:Int = 1;
	public static var playerScore:Int = 0;
	public static var playerLives:Int = 5;
	public static var playerHealth:Float = 5;
	public static var playerRockets:Int = 10;
	public static var playerApprovalRating:Int = 0;
	public static var playerStaminaLevel:Float = 100;
	public static var horizonLimit:Int = 530;
	public static var extraLifeInterval:Int = 25000;
	public static var extraLifeThreshold:Int = extraLifeInterval;
	public static var stampedeCount:Int = 50;
	public static var maxShrapnelShards:Int = 125;
	public static var maxEnemyBullets:Int = 75;
	public static var maxPlayerBullets:Int = 50;
	public static var maxPlayerRockets:Int = 10;
	public static var nextWantedProfile:Int = 1;
	public static var maxWantedProfiles:Int = 5;
	public static var killsCount:Int = 0;
	public static var capturedLaborCount:Int = 0;
	public static var savedBimboCount:Int = 0;
	public static var savedBankerCount:Int = 0; 
	public static var pauseGame:Bool = false;
	public static var highScores:Array<HighScoreData>;
	public static var playerInitials:Array<String> = [ "A", "A", "A" ];
	public static var trumpismsUsed:Array<Int>;
	public static var debugModeCode:String = "6827286";
	public static var easterEggCode:String = "WANTOCO";
	public static var enteredCode:String = "";
	public static var lastHighScoreEntryNumber:Int = 0;
	public static var validatePlayerScore:Bool = false;
	public static var playerGodMode:Bool = false;
	public static var unlimitedRockets:Bool = false;
	public static var palinAlwaysActive:Bool = false;
	public static var palinActive:Bool = false;
	public static var palinHealth:Float = 15;
	public static var maxApproval:Bool = false;
	public static var lostScreenFocus:Bool = false;
	public static var analogMovementThreshold:Float = 0.2;
	public static var analogStickDelay:Float = 0;
	
	public static function resetZoneCounts():Void
	{
		capturedLaborCount = 0;
		savedBimboCount = 0;
		savedBankerCount = 0;
		killsCount = 0;
	}
	
	public static function resetCheatValues():Void
	{
		maxApproval = false;
		unlimitedRockets = false;
		palinAlwaysActive = false;
		playerGodMode = false;		
	}
	
	public static function resetGameGlobals():Void
	{
		currentZone = 1;
		currentWave = 1;
		playerScore = 0;
		if (playerGodMode)
			playerLives = 99;
		else
			playerLives = 5;
		if (unlimitedRockets)
			playerRockets = 99;
		else
			playerRockets = 10;	
		if (maxApproval)
			playerApprovalRating = 100;
		else
			playerApprovalRating = 0;
		playerStaminaLevel = 100;
		nextWantedProfile = 1;
		killsCount = 0;
		capturedLaborCount = 0;
		savedBimboCount = 0;
		savedBankerCount = 0;
		lastSoundSelection = 0;
		lastPhraseSelection = 0;
		validatePlayerScore = false;
		trumpismsUsed = [];
		palinActive = false;
		playerHealth = 5;
		palinHealth = 15;
		extraLifeThreshold = extraLifeInterval;
	}
}