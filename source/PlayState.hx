package ;

import flixel.addons.display.FlxBackdrop;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxSort;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	public var waveData:WaveData;
	public var specialAttackTimer:FlxTimer;
	public var missileTimer:FlxTimer;
	public var specialAttackActive = false;
	public var player:Player;
	public var palin:Palin;
	public var level:TiledLevel;
	public var startText:FlxText;
	public var startSubText:FlxText;
	public var pauseText:FlxText;
	public var specialAttackText:FlxText;
	public var stampedeRumble:FlxSound;
	public var healthBar:Array<FlxSprite>;
	public var enemyBullets:FlxTypedGroup<EnemyBullet>;
	public var playerBullets:FlxTypedGroup<PlayerBullet>;
	public var playerRockets:FlxTypedGroup<Rocket>;
	public var entities:FlxTypedGroup<Entity>;
	public var pickups:FlxTypedGroup<Entity>;
	public var displayList:FlxTypedGroup<Entity>;
	public var stampede:FlxTypedGroup<Redneck>;
	public var missiles:FlxTypedGroup<Missile>;
	public var shrapnel:FlxTypedGroup<Shrapnel>;
	public var chopper:Chopper;
	public var gameOver:Bool = false;

	private var spawnTimer:FlxTimer;
	private var transitionTimer:FlxTimer;
	private var trumpLetsGo:FlxSound;
	private var lampPosts:FlxTypedGroup<Entity>;
	private var bimbos:FlxTypedGroup<Bimbo>;
	private var backgroundDrones:FlxTypedGroup<BackgroundDrone>;
	private var maxApprovalText:FlxText;
	private var extraLifeText:FlxText;
	private var scoreText:FlxText;
	private var approvalRatingText:FlxText;
	private var laborTallyText:FlxText;
	private var killsTallyText:FlxText;
	private var savedTallyText:FlxText;
	private var rocketCountText:FlxText;
	private var hudGroup:FlxGroup;
	private var hudGraphic:FlxSprite;
	private var objectiveMarker:FlxSprite;
	private var skyBackground:FlxSprite;
	private var radarLine:FlxSprite;
	private var radarFrame:FlxSprite;
	private var percentSign:FlxSprite;
	private var citySkyline:FlxBackdrop;
	private var startTimer:Float = 4;
	private var waveTimer:Float = 0;
	private var maxApprovalTimer:Float = 0;
	private var laborer:Laborer;
	private var bimbo:Bimbo;
	private var banker:Banker;
	private var panther:Panther;
	private var superPanther:SuperPanther;
	private var bandito:Bandito;
	private var niqabi:Niqabi;
	private var cleric:Cleric;
	private var imfGoon:IMFGoon;
	private var imfParatrooper:IMFParatrooper;
	private var imfTruck:IMFTruck;
	private var chopperFloor:SubEntity;
	private var daisyCutter:DaisyCutter;
	private var rocketLauncher:RocketLauncher;
	private var healthPickup:HealthPickup;
	private var exitArrow:LevelExit;
	private var radarScreen:FlxSprite;
	private var bimboBlip:FlxSprite;
	private var clericBlip:FlxSprite;
	private var laborerBlip:FlxSprite;
	private var bankerBlip:FlxSprite;
	private var niqabiBlip:FlxSprite;
	private var convertBlip:FlxSprite;
	private var banditoBlip:FlxSprite;
	private var pantherBlip:FlxSprite;
	private var truckBlip:FlxSprite;
	private var panicBlip:FlxSprite;
	private var trumpBlip:FlxSprite;
	private var palinBlip:FlxSprite;
	private var chunkEmitter:FlxEmitter;
	private var bloodEmitter:FlxEmitter;
	private var moneyEmitter:FlxEmitter;
	private var objectEmitter:FlxEmitter;
	private var staminaBar:FlxBar;
	private var palinArrow:ArrowHighlight;
	
	override public function create():Void
	{
		Globals.globalGameState = this;
		
		if (FlxG.sound.music != null && FlxG.sound.music.playing)
			FlxG.sound.music.stop();
			
		waveData = new WaveData(Globals.currentWave);
		
		pickups = new FlxTypedGroup<Entity>();
		entities = new FlxTypedGroup<Entity>();
		displayList = new FlxTypedGroup<Entity>();
		lampPosts = new FlxTypedGroup<Entity>();
		bimbos = new FlxTypedGroup<Bimbo>();
		hudGroup = new FlxGroup();
		
		if (waveData.mapStyle == WaveData.MapStyle.DAY)
		{
			skyBackground = new FlxSprite(0, 91, "assets/images/SkyBackground1.png"); 
			citySkyline = new FlxBackdrop("assets/images/CitySkyline1.png", 0.25, 0, true, false); 
		}
		else if (waveData.mapStyle == WaveData.MapStyle.DUSK)
		{
			skyBackground = new FlxSprite(0, 91, "assets/images/SkyBackground2.png"); 
			citySkyline = new FlxBackdrop("assets/images/CitySkyline2.png", 0.25, 0, true, false); 
		}
		else if (waveData.mapStyle == WaveData.MapStyle.OVERCAST)
		{
			skyBackground = new FlxSprite(0, 91, "assets/images/SkyBackground3.png"); 
			citySkyline = new FlxBackdrop("assets/images/CitySkyline3.png", 0.25, 0, true, false); 
		}
		else if (waveData.mapStyle == WaveData.MapStyle.SUNSET)
		{
			skyBackground = new FlxSprite(0, 91, "assets/images/SkyBackground4.png"); 
			citySkyline = new FlxBackdrop("assets/images/CitySkyline2.png", 0.25, 0, true, false); 
		}

		skyBackground.scrollFactor.set(0, 0);
		add(skyBackground);
		citySkyline.setPosition(0, 128);
		add(citySkyline);
		
		// Add drones into background
		backgroundDrones = new FlxTypedGroup<BackgroundDrone>();
		var newBackgroundDrone:BackgroundDrone;
		var droneYPos:Float = 0;
		var droneXPos:Float = 0;
		for (i in 0...3)
		{
			switch i
			{
				case 0:
					droneYPos = 200;
					
				case 1:
					droneYPos = 250;
					
				case 2:
					droneYPos = 300;
			}
			
			droneXPos = FlxRandom.floatRanged(150, Globals.WORLD_WIDTH - 150);
			newBackgroundDrone = new BackgroundDrone();
			newBackgroundDrone.setPosition(droneXPos, droneYPos);
			newBackgroundDrone.facing = (FlxRandom.chanceRoll(50) ? FlxObject.RIGHT : FlxObject.LEFT);
			backgroundDrones.add(newBackgroundDrone);			
		}
		add(backgroundDrones);
		
		// Load tilemap level
		level = new TiledLevel("assets/data/Map" + Globals.currentWave + ".tmx"); 
		add(level.backgroundTiles);
		
		enemyBullets = new FlxTypedGroup<EnemyBullet>(Globals.maxEnemyBullets);
		playerBullets = new FlxTypedGroup<PlayerBullet>(Globals.maxPlayerBullets);
		playerRockets = new FlxTypedGroup<Rocket>(Globals.maxPlayerRockets);
		stampede = new FlxTypedGroup<Redneck>(Globals.stampedeCount);
		shrapnel = new FlxTypedGroup<Shrapnel>(Globals.maxShrapnelShards);
		missiles = new FlxTypedGroup<Missile>(6);
		
		// Setup street lamps 
		if (Globals.currentWave != 25)
		{
			var lampPost:Entity;
			for (i in 0...16)
			{
				lampPost = new Entity(150 + (512 * i), 160, 160 + 408);
				if (waveData.mapStyle == WaveData.MapStyle.DAY || waveData.mapStyle == WaveData.MapStyle.OVERCAST)
					lampPost.loadGraphic("assets/images/StreetLamp.png", false, 70, 408, false); 
				else 
					lampPost.loadGraphic("assets/images/StreetLampLit.png", false, 70, 408, false); 
				lampPosts.add(lampPost);
				displayList.add(lampPost);
			}
		}
		
		// Initialize shrapnel pool
		var shrapnelShard:Shrapnel;
		for (i in 0...Globals.maxShrapnelShards)
		{
			shrapnelShard = new Shrapnel();
			shrapnel.add(shrapnelShard);
			shrapnelShard.kill();
		}		
		
		// Initialize player bullets pool
		var bullet:PlayerBullet;
		for (i in 0...Globals.maxPlayerBullets)
		{
			bullet = new PlayerBullet();
			playerBullets.add(bullet);
			bullet.kill();
		}
		
		// Initialize enemy bullets pool
		var enemyBullet:EnemyBullet;
		for (i in 0...Globals.maxEnemyBullets)
		{
			enemyBullet = new EnemyBullet();
			enemyBullets.add(enemyBullet);
			enemyBullet.kill();
		}
		
		// Initialize player rockets pool
		var rocket:Rocket;
		for (i in 0...Globals.maxPlayerRockets)
		{
			rocket = new Rocket();
			playerRockets.add(rocket);
			rocket.kill();
		}
		
		// Initialize redneck stampede pool
		var redneck:Redneck;
		for (i in 0...Globals.stampedeCount)
		{
			redneck = new Redneck();
			stampede.add(redneck);
			redneck.kill();
		}
		
		// Initialize missile pool
		var missile:Missile;
		for (i in 0...6)
		{
			missile = new Missile();
			missiles.add(missile);
			missile.kill();
		}
		
		// Place player into scene at starting position
		player = new Player(100, 500, 500);
		displayList.add(player);
		
		// Setup camera parameters
		FlxG.camera.setBounds(0, 0, Globals.WORLD_WIDTH, Globals.WORLD_HEIGHT, true);
		FlxG.camera.antialiasing = false;
		FlxG.camera.follow(player, FlxCamera.STYLE_PLATFORMER);
		
		hudGraphic = new FlxSprite(0, 0, "assets/images/HUD.png");
		hudGroup.add(hudGraphic);
	
		radarLine = new FlxSprite(257, 10, "assets/images/RadarLine.png");
		radarLine.velocity.y = 32;
		hudGroup.add(radarLine);
		
		radarFrame = new FlxSprite(247, 0, "assets/images/RadarFrame.png");
		hudGroup.add(radarFrame);
		
		percentSign = new FlxSprite(230, 69, "assets/images/PercentSign.png"); 
		hudGroup.add(percentSign);
		
		radarScreen = new FlxSprite(257, 26); 
		radarScreen.makeGraphic(512, 63, 0x00000000, false); 
		hudGroup.add(radarScreen);
		
		objectiveMarker = new FlxSprite(715, 46, "assets/images/MapObjectiveMarker.png");
		hudGroup.add(objectiveMarker);
		
		scoreText = new FlxText(32, 12, 214, StringTools.lpad(Std.string(Globals.playerScore), "0", 2)); 
		scoreText.setFormat(Globals.WILLIAMS_FONT, 32, 0xFFFFFF, "right");
		scoreText.antialiasing = false;
		hudGroup.add(scoreText);
		
		healthBar = new Array<FlxSprite>();
		for (i in 0...5)
		{
			var newBar = new FlxSprite(18 + (i * 45), 43, "assets/images/LifeBlock.png"); 
			newBar.color = 0x00FF00;
			hudGroup.add(newBar);
			healthBar.push(newBar);
			newBar.kill();
		}
		
		if (Globals.currentWave == 25)
		{
			Globals.playerLives = 1;
			Globals.playerHealth = 5;
			Globals.playerApprovalRating = 0;
			player.health = 5;
		}
		
		for (i in 0...Std.int(player.health))
		{
			healthBar[i].color = 0x00FF00;
			healthBar[i].revive();
		}
			
		staminaBar = new FlxBar(17, 57, FlxBar.FILL_LEFT_TO_RIGHT, 223, 6); 
		staminaBar.setRange(0, 100);
		staminaBar.createFilledBar(0xFF404040, 0xFFFF0000);
		hudGroup.add(staminaBar);
		
		approvalRatingText = new FlxText(193, 65, 60, "000"); 
		approvalRatingText.setFormat(Globals.MICRO_FONT, 24, 0xFF0000);
		approvalRatingText.antialiasing = false;
		hudGroup.add(approvalRatingText);
		
		extraLifeText = new FlxText(955, 18, 70, StringTools.lpad(Std.string(Globals.playerLives), "0", 2));
		extraLifeText.setFormat(Globals.WILLIAMS_FONT, 32, 0xFFFFFF);
		extraLifeText.antialiasing = false;
		hudGroup.add(extraLifeText);
		
		rocketCountText = new FlxText(955, 50, 70, StringTools.lpad(Std.string(Globals.playerRockets), "0", 2));
		rocketCountText.setFormat(Globals.WILLIAMS_FONT, 32, 0xFF0000);
		rocketCountText.antialiasing = false;
		hudGroup.add(rocketCountText);
	
		laborTallyText = new FlxText(855, 18, 60, "000");
		laborTallyText.setFormat(Globals.MICRO_FONT, 24, 0xFF0000);
		laborTallyText.antialiasing = false;
		hudGroup.add(laborTallyText);
		
		killsTallyText = new FlxText(855, 39, 60, "000");
		killsTallyText.setFormat(Globals.MICRO_FONT, 24, 0xFF0000);
		killsTallyText.antialiasing = false;
		hudGroup.add(killsTallyText);
		
		savedTallyText = new FlxText(855, 60, 60, "000");
		savedTallyText.setFormat(Globals.MICRO_FONT, 24, 0xFF0000);
		savedTallyText.antialiasing = false;
		hudGroup.add(savedTallyText);
		
		loadEntities(Globals.currentWave);
		
		pauseText = new FlxText(0, 0, FlxG.width, "GAME PAUSED"); 
		pauseText.setFormat(Globals.TEXT_FONT, 72, 0xFFFFFF, "center", FlxText.BORDER_SHADOW, 0x000000);
		pauseText.borderSize = 4;
		pauseText.antialiasing = false;
		pauseText.visible = false;
		hudGroup.add(pauseText);
	
		specialAttackText = new FlxText(0, 0, FlxG.width); 
		specialAttackText.setFormat(Globals.TEXT_FONT, 72, 0xFFFFFF, "center", FlxText.BORDER_SHADOW, 0x000000);
		specialAttackText.borderSize = 4;
		specialAttackText.antialiasing = false;
		specialAttackText.visible = false;
		hudGroup.add(specialAttackText);
		
		if (Globals.currentWave == 25)
			startText = new FlxText(0, 0, FlxG.width, "TRUMP PLAZA");
		else
			startText = new FlxText(0, 0, FlxG.width, "EXCLUSION ZONE " + Globals.currentZone);
		startText.setPosition((FlxG.width / 2) - (startText.width / 2), FlxG.height / 2  - 60);
		startText.setFormat(Globals.TEXT_FONT, 72, 0xFFFFFF, "center", FlxText.BORDER_SHADOW, 0x000000);
		startText.borderSize = 4;
		startText.antialiasing = false;
		startText.visible = false;
		hudGroup.add(startText);
		
		startSubText = new FlxText(0, 0, FlxG.width, "WAVE " + Globals.currentWave);
		startSubText.setPosition((FlxG.width / 2) - (startSubText.width / 2), FlxG.height / 2);
		startSubText.setFormat(Globals.TEXT_FONT, 72, 0xFFFFFF, "center", FlxText.BORDER_SHADOW, 0x000000);
		startSubText.borderSize = 4;
		startSubText.antialiasing = false;
		startSubText.visible = false;
		hudGroup.add(startSubText);
		
		maxApprovalText = new FlxText(0, 0, FlxG.width, "APPROVAL RATING AT 100%\nSPECIAL ATTACK READY");
		maxApprovalText.setPosition((FlxG.width / 2) - (maxApprovalText.width / 2), 125);
		maxApprovalText.setFormat(Globals.TEXT_FONT, 36, 0xFFFFFF, "center", FlxText.BORDER_SHADOW, 0x000000);
		maxApprovalText.borderSize = 4;
		maxApprovalText.antialiasing = false;
		maxApprovalText.visible = false;
		hudGroup.add(maxApprovalText);
		
		hudGroup.setAll("scrollFactor", FlxPoint.get(0, 0));
		hudGroup.setAll("cameras", [FlxG.camera]);
		
		add(displayList);
		add(hudGroup);
		
		bimboBlip = new FlxSprite();
		bimboBlip.loadGraphic("assets/images/BimboBlip.png", false, 4, 4, false);
		
		clericBlip = new FlxSprite();
		clericBlip.loadGraphic("assets/images/ClericBlip.png", false, 4, 4, false);
		
		laborerBlip = new FlxSprite();
		laborerBlip.loadGraphic("assets/images/LaborerBlip.png", false, 4, 4, false);
		
		bankerBlip = new FlxSprite();
		bankerBlip.loadGraphic("assets/images/BankerBlip.png", false, 4, 4, false);
		
		niqabiBlip = new FlxSprite();
		niqabiBlip.loadGraphic("assets/images/NiqabiBlip.png", false, 4, 4, false);
		
		convertBlip = new FlxSprite();
		convertBlip.loadGraphic("assets/images/ConvertBlip.png", false, 4, 4, false);
		
		banditoBlip = new FlxSprite();
		banditoBlip.loadGraphic("assets/images/BanditoBlip.png", false, 4, 4, false);
		
		pantherBlip = new FlxSprite();
		pantherBlip.loadGraphic("assets/images/PantherBlip.png", false, 4, 4, false);
		
		truckBlip = new FlxSprite();
		truckBlip.loadGraphic("assets/images/TruckBlip.png", false, 8, 4, false);
		
		panicBlip = new FlxSprite();
		panicBlip.makeGraphic(4, 4, 0xFFFFFFFF, false);
				
		trumpBlip = new FlxSprite();
		trumpBlip.makeGraphic(4, 4, 0xFFFFFFFF, false);
		
		palinBlip = new FlxSprite();
		palinBlip.makeGraphic(4, 4, 0xFFFFFFFF, false);
		
		trumpLetsGo = FlxG.sound.load("assets/sounds/LetsGo.wav", 1);
		stampedeRumble = FlxG.sound.load("assets/sounds/Stampede.wav", 1, true);
		
		FlxG.cameras.fade(0xFF000000, 1, true);
		FlxG.sound.play("StartGrowl");
		
		spawnTimer = new FlxTimer(waveData.spawnFrequency, spawnEntities, 0);
		
		Globals.pauseGame = false;
		
		super.create();
	}

	override public function destroy():Void
	{
		waveData = null;
		trumpLetsGo = null;
		stampedeRumble = null;
		level = null;
		objectiveMarker = null;
		scoreText = null;
		approvalRatingText = null;
		startText = null;
		startSubText = null;
		extraLifeText = null;
		rocketCountText = null;
		pauseText = null;
		specialAttackText = null;
		hudGraphic = null;
		hudGroup = null;
		player = null;
		playerBullets = null;
		enemyBullets = null;
		entities = null;
		pickups = null;
		stampede = null;
		backgroundDrones = null;
		missiles = null;
		shrapnel = null;
		healthPickup = null;
		rocketLauncher = null;
		displayList = null;
		healthBar = null;
		radarLine = null;
		radarFrame = null;
		percentSign = null;
		laborTallyText = null;
		killsTallyText = null;
		savedTallyText = null;
		laborer = null;
		bimbo = null;
		banker = null;
		panther = null;
		superPanther = null;
		bandito = null;
		niqabi = null;
		cleric = null;
		imfGoon = null;
		imfParatrooper = null;
		imfTruck = null;
		chopper = null;
		chopperFloor = null;
		daisyCutter = null;
		exitArrow = null;
		radarScreen = null;
		bimboBlip = null;
		clericBlip = null;
		laborerBlip = null;
		bankerBlip = null;
		niqabiBlip = null;
		convertBlip = null;
		banditoBlip = null;
		pantherBlip = null;
		truckBlip = null;
		panicBlip = null;
		trumpBlip = null;
		palinBlip = null;
		chunkEmitter = null;
		bloodEmitter = null;
		moneyEmitter = null;
		objectEmitter = null;
		lampPosts = null;
		bimbos = null;
		staminaBar = null;
		palinArrow = null;
		
		if (specialAttackTimer != null)
			specialAttackTimer.destroy();
		if (missileTimer != null)
			missileTimer.destroy();
		if (spawnTimer != null)
			spawnTimer.destroy();
		if (transitionTimer != null)
			transitionTimer.destroy();

		super.destroy();
	}

	override public function update():Void
	{
		waveTimer += FlxG.elapsed;
		
		ColorCycler.Update();
		
		updateHUD();
		
		if (startTimer < 3 && startTimer > 0)
		{
			if (Globals.pauseGame)
				startText.visible = false;
			else 
				startText.visible = true;
		}
		if (startTimer < 2 && startTimer > 0)
		{
			if (Globals.pauseGame)
				startSubText.visible = false;
			else
				startSubText.visible = true;
		}
		else if (startTimer <= 0)
		{
			startText.kill();
			startSubText.kill();
			startTimer = 0;
		}
		
		if (specialAttackActive)
		{
			specialAttackText.setPosition((FlxG.width / 2) - (specialAttackText.width / 2), FlxG.height / 2  - 60);
			specialAttackText.color = ColorCycler.WilliamsUltraFlash;
			
			if (Globals.pauseGame)
			{
				specialAttackText.visible = false;
				specialAttackTimer.active = false;
				FlxG.camera.stopFX();
			}
			else 
			{
				if (!gameOver)
					specialAttackText.visible = true;
				else
					specialAttackText.visible = false;
				
				if (!specialAttackTimer.active)
					specialAttackTimer.active = true;
			}
		}
		
		if (Globals.pauseGame)
		{
			pauseText.setPosition((FlxG.width / 2) - (pauseText.width / 2), FlxG.height / 2  - 60);
			pauseText.color = ColorCycler.WilliamsUltraFlash;
			player.update();
			return;
		}
		
		super.update();
		
		if (FlxG.keys.justPressed.ESCAPE)
		{
			Globals.pauseGame = true;
			persistentUpdate = true;
			if (player != null && player.alive)
				player.isSprintActive = false;
			openSubState(new GameExitState());			
		}
		
		if (startTimer > 0)
		{
			startTimer -= FlxG.elapsed;
			startText.color = ColorCycler.WilliamsFlash5;
			startSubText.color = ColorCycler.WilliamsUltraFlash;
		}
		
		for (obj in pickups)
		{
			if (obj.alive)
				displayList.add(obj);
		}		
		
		for (obj in enemyBullets)
		{
			if (obj.alive)
				displayList.add(obj);
		}
		
		for (obj in playerBullets)
		{
			if (obj.alive)
				displayList.add(obj);
		}
		
		for (obj in playerRockets)
		{
			if (obj.alive)
				displayList.add(obj);
		}
				
		displayList.sort(sortByZ);
		checkCollisions();
		displayList.forEachDead(buryDead);
		
		if (gameOver)
			return;
		
		if (player.health == 0)
		{
			if (Globals.playerLives <= 0)
			{
				Globals.playerLives = 0;
				gameOver = true;
				Globals.validatePlayerScore = true; 
				if (Globals.currentWave != 25)
				{
					persistentUpdate = true;
					openSubState(new GameOverState());
				}
				else
				{
					FlxG.sound.play("TrumpNoNoNoNo");
					FlxG.cameras.fade(0xFFFFFFFF, 4, false, onFinalDeathFade);
				}
			}
		}
	}
	
	private function onFinalDeathFade():Void
	{
		FlxTween.tween(FlxG.sound, { volume:0 }, 1);
		transitionTimer = new FlxTimer(3, onTransitionTimerDone, 1);
	}
	
	private function onTransitionTimerDone(timer:FlxTimer):Void
	{
		FlxG.switchState(new ParadiseState());
	}
	
	override public function draw():Void
	{
		drawRadar();
		super.draw();
	}
	
	private inline function sortByZ(order:Int, o1:Entity, o2:Entity):Int
    {
        return FlxSort.byValues(order, o1.z, o2.z);
    }
	
	private function spawnEntities(timer:FlxTimer=null):Void
	{
		if (Globals.pauseGame)
			return;
			
		var spawnFacing:Int = FlxObject.LEFT;
		var spawn_x:Float = 0;
		var spawn_y:Float = 0;
		var leftSpawnOK:Bool = (player.x >= (FlxG.width * 0.5));
		var rightSpawnOK:Bool = (player.x <= (FlxG.camera.bounds.width - (FlxG.width * 0.5)));
		var viewportLeftEdge:Float = FlxG.camera.scroll.x;
		var viewportRightEdge:Float = FlxG.camera.scroll.x + FlxG.width;
		
		if (waveData.maxPanthers != 0)
		{
			var spawnCount:Int = waveData.maxPanthers - waveData.currentPanthers;
			for (i in 0...spawnCount)
			{
				if (leftSpawnOK && rightSpawnOK)
				{
					spawnFacing = (FlxRandom.chanceRoll(50) ? FlxObject.LEFT : FlxObject.RIGHT);
					if (spawnFacing == FlxObject.LEFT)
						spawn_x = viewportLeftEdge - (FlxG.width * 0.5) - (i * 25);
					else
						spawn_x = viewportRightEdge + (FlxG.width * 0.5) + (i * 25);
				}
				else if (leftSpawnOK && !rightSpawnOK)
				{
					spawn_x = viewportLeftEdge - (FlxG.width * 0.5) - (i * 25);
					spawnFacing = FlxObject.LEFT;
				}
				else if (!leftSpawnOK && rightSpawnOK)
				{
					spawn_x = viewportRightEdge + (FlxG.width * 0.5) + (i * 25);
					spawnFacing = FlxObject.LEFT;
				}
					
				spawn_y = FlxRandom.intRanged(400, 600); 
				panther = new Panther(spawn_x, spawn_y, spawn_y + 144, spawnFacing);
				panther.changeState(Entity.State.CHASING);
				displayList.add(panther);
				entities.add(panther);
				waveData.currentPanthers++;
			}
		}
		
		if (waveData.maxSuperPanthers != 0)
		{
			var spawnCount:Int = waveData.maxSuperPanthers - waveData.currentSuperPanthers;
			for (i in 0...spawnCount)
			{
				if (leftSpawnOK && rightSpawnOK)
				{
					spawnFacing = (FlxRandom.chanceRoll(50) ? FlxObject.LEFT : FlxObject.RIGHT);
					if (spawnFacing == FlxObject.LEFT)
						spawn_x = viewportLeftEdge - (FlxG.width * 0.5) - (i * 25);
					else
						spawn_x = viewportRightEdge + (FlxG.width * 0.5) + (i * 25);
				}
				else if (leftSpawnOK && !rightSpawnOK)
				{
					spawn_x = viewportLeftEdge - (FlxG.width * 0.5) - (i * 25);
					spawnFacing = FlxObject.LEFT;
				}
				else if (!leftSpawnOK && rightSpawnOK)
				{
					spawn_x = viewportRightEdge + (FlxG.width * 0.5) + (i * 25);
					spawnFacing = FlxObject.LEFT;
				}
					
				spawn_y = FlxRandom.intRanged(400, 600); 
				superPanther = new SuperPanther(spawn_x, spawn_y, spawn_y + 144, spawnFacing);
				superPanther.changeState(Entity.State.WANDERING);
				displayList.add(superPanther);
				entities.add(superPanther);
				waveData.currentSuperPanthers++;
			}	
		}
		
		if (waveData.maxNiqabis != 0)
		{
			var spawnCount:Int = waveData.maxNiqabis - waveData.currentNiqabis;
			
			if (Globals.currentWave != 25)
			{
				for (i in 0...spawnCount)
				{
					if (leftSpawnOK && rightSpawnOK)
					{
						spawnFacing = (FlxRandom.chanceRoll(50) ? FlxObject.LEFT : FlxObject.RIGHT);
						if (spawnFacing == FlxObject.LEFT)
							spawn_x = viewportLeftEdge - (FlxG.width * 0.5) - (i * 25);
						else
							spawn_x = viewportRightEdge + (FlxG.width * 0.5) + (i * 25);
					}
					else if (leftSpawnOK && !rightSpawnOK)
					{
						spawn_x = viewportLeftEdge - (FlxG.width * 0.5) - (i * 25);
						spawnFacing = FlxObject.LEFT;
					}
					else if (!leftSpawnOK && rightSpawnOK)
					{
						spawn_x = viewportRightEdge + (FlxG.width * 0.5) + (i * 25);
						spawnFacing = FlxObject.LEFT;
					}
					
					spawn_y = FlxRandom.intRanged(400, 600); 
					niqabi = new Niqabi(spawn_x, spawn_y, spawn_y + 122, spawnFacing);
					niqabi.changeState(Entity.State.WANDERING);
					displayList.add(niqabi);
					entities.add(niqabi);
					waveData.currentNiqabis++;
				}	
			}
			else
			{
				if (spawnCount >= waveData.maxNiqabis * 0.5 && (imfTruck == null || !imfTruck.alive) && waveTimer > 8)
				{
					spawn_x = viewportRightEdge + (FlxG.width * 0.5);
					spawn_y = FlxRandom.intRanged(400, 500); 
					imfTruck = new IMFTruck(spawn_x, spawn_y, spawn_y + 196, spawnCount);
					imfTruck.changeState(Entity.State.DRIVING);
					displayList.add(imfTruck);
					entities.add(imfTruck);
					waveData.currentNiqabis += spawnCount;
				}
			}
		}

		if (waveData.maxBanditos != 0)
		{		
			var spawnCount:Int = waveData.maxBanditos - waveData.currentBanditos;
			if (spawnCount > 0)
			{
				if (leftSpawnOK && rightSpawnOK)
				{
					spawnFacing = (FlxRandom.chanceRoll(50) ? FlxObject.LEFT : FlxObject.RIGHT);
					if (spawnFacing == FlxObject.LEFT)
						spawn_x = viewportLeftEdge - (FlxG.width * 0.5);
					else
						spawn_x = viewportRightEdge + (FlxG.width * 0.5);
				}
				else if (leftSpawnOK && !rightSpawnOK)
				{
					spawn_x = viewportLeftEdge - (FlxG.width * 0.5);
					spawnFacing = FlxObject.LEFT;
				}
				else if (!leftSpawnOK && rightSpawnOK)
				{
					spawn_x = viewportRightEdge + (FlxG.width * 0.5);
					spawnFacing = FlxObject.LEFT;
				}
				
				spawn_y = FlxRandom.intRanged(400, 500); 
				
				for (i in 0...spawnCount)
				{
					bandito = new Bandito(spawn_x, spawn_y, spawn_y + 162, spawnFacing);
					bandito.changeState(Entity.State.SHOOTING);
					displayList.add(bandito);
					entities.add(bandito);
					spawn_y += 25;
					spawn_x += 25;
					waveData.currentBanditos++;
				}	
			}
		}

		if (waveData.maxClerics != 0)
		{	
			var spawnCount:Int = waveData.maxClerics - waveData.currentClerics;
			for (i in 0...spawnCount)
			{
				if (leftSpawnOK && rightSpawnOK)
				{
					spawnFacing = (FlxRandom.chanceRoll(50) ? FlxObject.LEFT : FlxObject.RIGHT);
					if (spawnFacing == FlxObject.LEFT)
						spawn_x = viewportLeftEdge - (FlxG.width * 0.5) - (i * 25);
					else
						spawn_x = viewportRightEdge + (FlxG.width * 0.5) + (i * 25);
				}
				else if (leftSpawnOK && !rightSpawnOK)
				{
					spawn_x = viewportLeftEdge - (FlxG.width * 0.5) - (i * 25);
					spawnFacing = FlxObject.LEFT;
				}
				else if (!leftSpawnOK && rightSpawnOK)
				{
					spawn_x = viewportRightEdge + (FlxG.width * 0.5) + (i * 25);
					spawnFacing = FlxObject.LEFT;
				}
				
				spawn_y = FlxRandom.intRanged(400, 600); 
				cleric = new Cleric(spawn_x, spawn_y, spawn_y + 158, spawnFacing);
				cleric.changeState(Entity.State.WANDERING);
				displayList.add(cleric);
				entities.add(cleric);
				waveData.currentClerics++;
			}	
		}
		
		if (waveData.maxIMFGoons != 0 && waveTimer > 6)
		{	
			var spawnCount:Int = waveData.maxIMFGoons - waveData.currentIMFGoons;
			var spawnStart:Float = (viewportLeftEdge + FlxG.width * 0.5) - (((spawnCount - 1) * 100) / 2);
			for (i in 0...spawnCount)
			{
				spawn_x = (spawnStart + (i * 100));
				spawnFacing = FlxObject.RIGHT;
				spawn_y = FlxRandom.intRanged(-400, -200); 
				imfParatrooper = new IMFParatrooper(spawn_x, spawn_y, spawn_y + 215, spawnFacing);
				displayList.add(imfParatrooper);
				entities.add(imfParatrooper);
				waveData.currentIMFGoons++;
			}	
		}
	}
	
	private function drawRadar():Void
	{
		FlxSpriteUtil.fill(radarScreen, 0x00000000);
		
		for (i in 0...entities.length)
		{
			var entity = entities.members[i];
			var entityClassName = Type.getClassName(Type.getClass(entity));
			
			if (!entity.alive)
				continue;
				
			var x_pos:Int = Std.int(entity.x / 16);
			var y_pos:Int = Std.int((entity.z - Globals.horizonLimit) / 4);
			
			panicBlip.color = ColorCycler.RedYellowFlash;
				
			if (entityClassName == "Bimbo")
			{
				if (entity.currentState == Entity.State.EVADING)
					radarScreen.stamp(panicBlip, x_pos, y_pos);
				else
					radarScreen.stamp(bimboBlip, x_pos, y_pos);
			}
			else if (entityClassName == "Cleric")
				radarScreen.stamp(clericBlip, x_pos, y_pos);
			else if (entityClassName == "Laborer")
				radarScreen.stamp(laborerBlip, x_pos, y_pos);
			else if (entityClassName == "IMFGoon" || entityClassName == "IMFParatrooper")
				radarScreen.stamp(bankerBlip, x_pos, y_pos);
			else if (entityClassName == "Banker")
			{
				if (entity.currentState == Entity.State.EVADING)
					radarScreen.stamp(panicBlip, x_pos, y_pos);
				else
					radarScreen.stamp(bankerBlip, x_pos, y_pos);
			}
			else if (entityClassName == "Niqabi")
				radarScreen.stamp(niqabiBlip, x_pos, y_pos);
			else if (entityClassName == "Convert")
				radarScreen.stamp(convertBlip, x_pos, y_pos);
			else if (entityClassName == "Bandito")
				radarScreen.stamp(banditoBlip, x_pos, y_pos);
			else if (entityClassName == "Panther" || entityClassName == "SuperPanther")
				radarScreen.stamp(pantherBlip, x_pos, y_pos);
			else if (entityClassName == "IMFTruck")
				radarScreen.stamp(truckBlip, x_pos, y_pos);
		}
		
		if (!player.isInChopper)
		{
			trumpBlip.color = ColorCycler.BluePulse;
			radarScreen.stamp(trumpBlip, Std.int(player.x / 16), Std.int((player.z - Globals.horizonLimit) / 4));
		}
		
		if (palin != null && palin.alive)
		{
			palinBlip.color = ColorCycler.RedPulse;
			radarScreen.stamp(palinBlip, Std.int(palin.x / 16), Std.int((palin.z - Globals.horizonLimit) / 4));
		}
		
		if (radarLine.y >= 87)
			radarLine.y = 10;
	}
	
	private function checkCollisions():Void
	{
		if (stampede.countLiving() > 0 && !Globals.pauseGame)
		{
			FlxG.overlap(stampede, entities, mobAttack);	
			FlxG.camera.shake(0.005, 1, null, true, FlxCamera.SHAKE_VERTICAL_ONLY);
			if (!stampedeRumble.playing)
			{
				stampedeRumble.play();
				stampedeRumble.fadeIn(1, 0, 1);
			}
		}
		else 
		{
			if (stampedeRumble.playing)
			{
				stampedeRumble.fadeOut(2, 0);
				if (stampedeRumble.getActualVolume() <= 0.1)
					stampedeRumble.stop();
			}
		}
		
		if (missiles.countLiving() > 0)
			FlxG.overlap(missiles, entities, missileAttack);
			
		if (Globals.currentWave == 25)
		{
			if (imfTruck != null && imfTruck.alive)
				FlxG.overlap(imfTruck, entities, truckAttack);
		}
		
		// Player/Palin vs enemy bullets
		for (i in 0...enemyBullets.length)
		{
			var bullet = enemyBullets.members[i];
				
			if (!bullet.alive)
				continue;
			
			// Check for street lamp collisions 
			for (j in 0...lampPosts.length)
			{
				var post = lampPosts.members[j];
				
				if (!post.isOnScreen())
					continue;
					
				if (FlxCollision.pixelPerfectCheck(bullet, post) && 
						bullet.z >= post.z - 10 && bullet.z <= post.z + 10) 
				{
					FlxG.sound.play("MetalClank");
					if (bullet.facing == FlxObject.LEFT)
						displayList.add(new BulletSpark(post.x + 60, bullet.y - (bullet.frameHeight / 2), post.z, bullet.facing));
					else
						displayList.add(new BulletSpark((post.x + 60) - 22, bullet.y - (bullet.frameHeight / 2), post.z, bullet.facing));
					bullet.kill();
				}
			}
			
			// Check for player hit
			if (!FlxSpriteUtil.isFlickering(player) && player.alive && !player.isInChopper && player.currentState != Entity.State.JUMPING)
			{
				if (FlxG.overlap(bullet, player) && 
					bullet.z >= player.z - 20 && bullet.z <= player.z + 20) 
				{
					if (Globals.currentWave != 25)
						healthBar[Std.int(player.health - 1)].kill();
						
					player.hurt(1);
	
					if (bullet.facing == FlxObject.LEFT)	
					{
						if (player.x > 50)
							FlxTween.tween(player, { x:player.x - 50 }, .1);
						else
							FlxTween.tween(player, { x:player.x - player.x }, .1);
					}
					else
					{
						if (player.x + player.width < FlxG.camera.bounds.width - 50)
							FlxTween.tween(player, { x:player.x + 50 }, .1);
						else
							FlxTween.tween(player, { x:player.x + (FlxG.camera.bounds.width - player.x - player.width) }, .1);
					}
						
					bullet.kill();
				}
			}
			
			// Check for Palin hit (if active and alive)
			if (palin != null && palin.alive && palin.currentState != Entity.State.WANDERING && 
				palin.currentState != Entity.State.DYING)
			{
				if (FlxCollision.pixelPerfectCheck(bullet, palin) && 
					bullet.z >= palin.z - 20 && bullet.z <= palin.z + 20) 
				{
					palin.hurt(1);
	
					if (bullet.facing == FlxObject.LEFT)	
					{
						if (palin.x > 50)
							FlxTween.tween(palin, { x:palin.x - 50 }, .1);
						else
							FlxTween.tween(palin, { x:palin.x - palin.x }, .1);
					}
					else
					{
						if (palin.x + palin.width < FlxG.camera.bounds.width - 50)
							FlxTween.tween(palin, { x:palin.x + 50 }, .1);
						else
							FlxTween.tween(palin, { x:palin.x + (FlxG.camera.bounds.width - palin.x - palin.width) }, .1);
					}
						
					bullet.kill();
				}				
			}
		}
		
		// Player vs entities
		for (i in 0...entities.length)
		{
			var entity = entities.members[i];
			var entityClassName = Type.getClassName(Type.getClass(entity));
			
			if (!entity.alive)
				continue;
				
			if (palin != null && palin.alive && palin.currentState != Entity.State.WANDERING)
				assignTarget("Palin", palin);

			if (entityClassName == "Cleric" || entityClassName == "SuperPanther") 
			{
				if (entity.target == null)
					assignTarget(entityClassName, entity);
			}
			else if (entityClassName != "Bimbo" && entityClassName != "Banker")
			{
				if (!player.isInChopper)
					entity.target = player;
				else
					entity.target = null;
			}
				
			if (entityClassName == "Banker")
			{
				for (i in 0...enemyBullets.length)
				{
					var bullet = enemyBullets.members[i];
						
					if (!bullet.alive)
						continue;

					if (FlxG.overlap(bullet, entity) && 
						bullet.z >= entity.z - 20 && bullet.z <= entity.z + 20 &&
						entity.target != null && entity.currentState != Entity.State.DYING && entity.currentState != Entity.State.COLLECTED) 
					{						
						entity.hurt(1);
						displayList.add(new BloodSplatter(entity.origin.x, entity.origin.y, entity.z + 1, entity, BloodSplatter.SplatterType.SPLASH));
						if (entity.alive && entity.currentState != Entity.State.EVADING && entity.currentState != Entity.State.DYING)
						{
							entity.facing == bullet.facing;
							entity.changeState(Entity.State.EVADING);				
						}
						bullet.kill();
					}
				}
			}
			
			if (player.alive)
			{
				// Check for proximity to entity capture points
				if (player.z >= entity.z - 10 && player.z <= entity.z + 10 &&
					FlxG.overlap(entity, player))
				{
					if (entityClassName == "Laborer" && 
						entity.currentState != Entity.State.COLLECTED && entity.currentState != Entity.State.DYING)
					{
						entity.changeState(Entity.State.COLLECTED);
						FlxG.sound.play("Pickup");
						trumpLetsGo.play(true);
					}
					else if (entityClassName == "Bimbo" && 
							 entity.currentState != Entity.State.COLLECTED && entity.currentState != Entity.State.DYING && 
							 entity.currentState != Entity.State.TRANSFORMING) 
					{
						entity.changeState(Entity.State.COLLECTED);
						FlxG.sound.play("Pickup");
					}
					else if (entityClassName == "Banker" && 
							 entity.currentState != Entity.State.COLLECTED && entity.currentState != Entity.State.DYING)
					{
						entity.changeState(Entity.State.COLLECTED);
						FlxG.sound.play("CashIn");
					}
				}
				
				if (entityClassName == "Bimbo" && player.whistleTimer <= 0 && 
					entity.currentState != Entity.State.TRANSFORMING)
				{
					if (FlxMath.distanceBetween(player, entity) < player.whistleRange)
						player.whistle();
				}
			}
		}
		
		// Player bullet collisions 
		for (i in 0...playerBullets.length)
		{
			var bullet = playerBullets.members[i];
			
			if (!bullet.alive)
				continue;
				
			for (j in 0...lampPosts.length)
			{
				var post = lampPosts.members[j];
				
				if (!post.isOnScreen())
					continue;
					
				if (FlxCollision.pixelPerfectCheck(bullet, post) && 
						bullet.z >= post.z - 10 && bullet.z <= post.z + 10) 
				{
					FlxG.sound.play("MetalClank");
					if (bullet.facing == FlxObject.LEFT)
						displayList.add(new BulletSpark(post.x + 60, bullet.y - (bullet.frameHeight / 2), post.z, bullet.facing));
					else
						displayList.add(new BulletSpark((post.x + 60) - 22, bullet.y - (bullet.frameHeight / 2), post.z, bullet.facing));
					bullet.kill();
				}
			}
				
			for (j in 0...entities.length)
			{
				var entity = entities.members[j];
				var entityClassName = Type.getClassName(Type.getClass(entity));
				
				if (!entity.alive)
					continue;

				if (entityClassName != "Banker" && entityClassName != "Bimbo" && entityClassName != "IMFTruck" &&
					entity.currentState != Entity.State.DYING && entity.currentState != Entity.State.COLLECTED)
				{
					if (entityClassName == "Cleric" && entity.currentState == Entity.State.RUNNING_AWAY)
					{
						if (FlxG.overlap(bullet, entity))
						{
							entity.hurt(1);
							bullet.kill();
							
							if (!entity.alive)
							{
								var center:FlxPoint = entity.getGraphicMidpoint();
								displayList.add(new Explosion(center.x - 64, entity.y, entity.z + 1, Explosion.ExplosionType.BLOOD));
								bloodBurst(center.x, entity.z - 32);
								FlxG.sound.play("GorySquish");
							}
						}
					}
					else
					{
						if (FlxCollision.pixelPerfectCheck(bullet, entity) && 
							bullet.z >= entity.z - 40 && bullet.z <= entity.z + 40) 
						{
							entity.hurt(1);
							if (entityClassName == "Cleric" && entity.health == 4)
							{
								headBurst(entity);	
								FlxG.sound.play("ClericDie");
								entity.changeState(Entity.State.RUNNING_AWAY);
							}
							displayList.add(new BloodSplatter(entity.origin.x, entity.origin.y, entity.z + 1, entity, BloodSplatter.SplatterType.SPLASH));
							if (bullet.facing == FlxObject.LEFT) 
								FlxTween.tween(entity, { x:entity.x - 25 }, 0.1); 
							else
								FlxTween.tween(entity, { x:entity.x + 25 }, 0.1); 
							bullet.kill();
							
							if (entityClassName == "Bandito" && entity.health <= 0)
							{
								if (FlxRandom.chanceRoll(25))
									banditoScatter(entity);
							}
							
							if (!entity.alive)
							{
								if (entityClassName == "Niqabi" || entityClassName == "Convert")
								{
									var center:FlxPoint = entity.getGraphicMidpoint();
									displayList.add(new ExplosionFlash(center.x - 151, entity.z - 220, entity.z - 1));
									displayList.add(new Explosion(center.x - 64, center.y - 64, entity.z + 1, Explosion.ExplosionType.FIRE));
									blowChunks(entity, false);		
									FlxG.camera.flash(0xFFFFFFFF, 0.1);
									FlxG.camera.shake(0.01, 0.5);
									FlxG.sound.play("Explosion" + FlxRandom.intRanged(1, 4));
								}
							}
							else if (entityClassName == "Laborer" && entity.currentState != Entity.State.EVADING && entity.currentState != Entity.State.DYING)
								entity.changeState(Entity.State.RUNNING_AWAY);
						}
					}
				}
			}
		}
		
		// Player rocket collisions 
		for (i in 0...playerRockets.length)
		{
			var rocket = playerRockets.members[i];
			
			if (!rocket.alive)
				continue;
				
			// Check for street lamp collisions 
			for (j in 0...lampPosts.length)
			{
				var post = lampPosts.members[j];
				
				if (!post.isOnScreen())
					continue;
					
				if (FlxCollision.pixelPerfectCheck(rocket, post) && 
						rocket.z >= post.z - 10 && rocket.z <= post.z + 10) 
				{
					FlxG.sound.play("MetalClank");
					displayList.add(new ExplosionFlash((post.x + 60) - 151, (rocket.y - (rocket.frameHeight / 2)) - 110, post.z - 1));
					displayList.add(new Explosion((post.x + 60) - 64, (rocket.y - (rocket.frameHeight / 2)) - 64, post.z, Explosion.ExplosionType.FIRE));
					FlxG.camera.flash(0xFFFFFFFF, 0.1);
					FlxG.camera.shake(0.01, 0.5);
					FlxG.sound.play("Explosion" + FlxRandom.intRanged(1, 4));
					checkBlastArea(rocket);
					rocket.kill();
				}
			}
				
			for (j in 0...entities.length)
			{
				var entity = entities.members[j];
				var entityClassName = Type.getClassName(Type.getClass(entity));
				
				if (!entity.alive) 
					continue;
				
				if (entityClassName != "Banker" && entityClassName != "Bimbo" && entityClassName != "IMFTruck")
				{
					if (FlxCollision.pixelPerfectCheck(rocket, entity) && 
						rocket.z >= entity.z - 40 && rocket.z <= entity.z + 40 && rocket.isOnScreen())
					{
						var center:FlxPoint = entity.getGraphicMidpoint();
						displayList.add(new ExplosionFlash(center.x - 151, entity.z - 220, entity.z - 1));
						displayList.add(new Explosion(center.x - 64, center.y - 64, entity.z, Explosion.ExplosionType.FIRE));
						entity.kill();
						FlxG.camera.flash(0xFFFFFFFF, 0.1);
						FlxG.camera.shake(0.01, 0.5);
						FlxG.sound.play("Explosion" + FlxRandom.intRanged(1, 4));
						
						if (entityClassName == "Cleric") 
						{
							if (entity.currentState == Entity.State.RUNNING_AWAY)
							{
								var center:FlxPoint = entity.getGraphicMidpoint();
								displayList.add(new Explosion(center.x - 64, entity.y, entity.z + 1, Explosion.ExplosionType.BLOOD));
								bloodBurst(center.x, entity.z - 32);
								FlxG.sound.play("GorySquish");
							}
							else
							{
								FlxG.sound.play("ClericDie");
								blowChunks(entity, false);
							}
						}
						else
							blowChunks(entity, false);
							
						if (entityClassName == "IMFGoon" || entityClassName == "IMFParatrooper")
							moneyBlast(center.x, entity.z - 50, 50);
							
						checkBlastArea(rocket);
						rocket.kill();
					}
				}
			}
		}
		
		// Player vs pickups
		for (i in 0...pickups.length)
		{
			var pickup = pickups.members[i];
			var pickupClassName = Type.getClassName(Type.getClass(pickup));
			
			if (!pickup.alive)
				continue;	
			
			if (player.z >= pickup.z - 10 && player.z <= pickup.z + 10 && FlxG.overlap(pickup, player))
			{
				if (pickupClassName == "RocketLauncher")
				{
					Globals.playerRockets += 5;
					if (Globals.playerRockets > 99)
						Globals.playerRockets = 99;
					FlxG.sound.play("Reload");
					pickup.kill();
				}
				else if (pickupClassName == "LevelExit")
				{
					pickup.kill();
					chopper.changeState(Entity.State.TAKING_OFF);
					FlxTween.tween(player, { x:chopper.x + 305, y:chopper.y + 56 }, 0.33, { type: FlxTween.ONESHOT, ease: FlxEase.sineOut, complete: onInsideChopper } );
					player.facing = FlxObject.LEFT;
					if (Globals.playerRockets > 0)
						player.animation.play("jump_rocket_" + Std.int(player.health));
					else
						player.animation.play("jump_" + Std.int(player.health));
					player.changeState(Entity.State.IN_CHOPPER);
				}
				else if (pickupClassName == "HealthPickup" && pickup.currentState != Entity.State.COLLECTED)
				{
					pickup.changeState(Entity.State.COLLECTED);
					FlxG.sound.play("Pickup");
				}
			}
		}
		
		// Palin pickup
		if (palin != null && palin.isOnScreen() && palin.currentState == Entity.State.WANDERING)
		{
			if (player.z >= palin.z - 10 && player.z <= palin.z + 10 && FlxG.overlap(palin, player))
			{
				Globals.palinActive = true;
				if (FlxRandom.chanceRoll(50))
					FlxG.sound.play("PalinHelpsOnTheWay");
				else
					FlxG.sound.play("PalinHangInThere");
				FlxG.sound.play("Reload");
				if (palinArrow != null && palinArrow.alive)
					palinArrow.kill();
				palin.changeState(Entity.State.FOLLOWING);
			}
		}
		
		// Player/Palin vs shrapnel
		for (i in 0...shrapnel.length)
		{
			var shard = shrapnel.members[i];
			
			if (!shard.alive)
				continue;
				
			if (!FlxSpriteUtil.isFlickering(player) && player.alive && !player.isInChopper && player.currentState != Entity.State.JUMPING)
			{
				if (FlxG.overlap(shard, player)) 
				{
					if (Globals.currentWave != 25)
						healthBar[Std.int(player.health - 1)].kill();
						
					player.hurt(1);
					
					if (shard.velocity.x < 0)	
					{
						if (player.x > 50)
							FlxTween.tween(player, { x:player.x - 50 }, .1);
						else
							FlxTween.tween(player, { x:player.x - player.x }, .1);
					}
					else if (shard.velocity.x > 0)
					{
						if (player.x + player.width < FlxG.camera.bounds.width - 50)
							FlxTween.tween(player, { x:player.x + 50 }, .1);
						else
							FlxTween.tween(player, { x:player.x + (FlxG.camera.bounds.width - player.x - player.width) }, .1);
					}
						
					shard.kill();
				}
			}
			
			// Palin shrapnel check
			if (palin != null && palin.alive && palin.currentState != Entity.State.WANDERING)
			{
				if (FlxG.overlap(shard, palin)) 
				{
					palin.hurt(1);
					
					if (shard.velocity.x < 0)	
					{
						if (palin.x > 50)
							FlxTween.tween(palin, { x:palin.x - 50 }, .1);
						else
							FlxTween.tween(palin, { x:palin.x - palin.x }, .1);
					}
					else if (shard.velocity.x > 0)
					{
						if (palin.x + palin.width < FlxG.camera.bounds.width - 50)
							FlxTween.tween(palin, { x:palin.x + 50 }, .1);
						else
							FlxTween.tween(palin, { x:palin.x + (FlxG.camera.bounds.width - palin.x - palin.width) }, .1);
					}
						
					shard.kill();
				}
			}
		}
	}
	
	private function onInsideChopper(tween:FlxTween):Void
	{
		if (Globals.playerRockets > 0)
			player.animation.play("idle_rocket_" + Std.int(player.health));
		else 
			player.animation.play("idle_" + Std.int(player.health));
			
		if (palin != null && palin.alive && palin.isOnScreen() && 
			palin.currentState != Entity.State.WANDERING)
			FlxG.sound.play("PalinOhMan");
			
		persistentUpdate = true;
		openSubState(new ExitState());
	}
	
	private inline function updateHUD():Void
	{
		objectiveMarker.color = ColorCycler.RedPulse;
		scoreText.color = ColorCycler.WilliamsFlash4; 
		extraLifeText.color = ColorCycler.BluePulse; 
		
		if (Globals.playerApprovalRating < 100)
		{
			approvalRatingText.color = 0xFFFF0000;
			percentSign.color = 0xFFFF0000;
			maxApprovalText.visible = false;
			maxApprovalTimer = 0;
		}
		else if (Globals.playerApprovalRating == 100)
		{
			approvalRatingText.color = ColorCycler.WilliamsUltraFlash;
			percentSign.color = ColorCycler.WilliamsUltraFlash;
			maxApprovalTimer += FlxG.elapsed;
			if (maxApprovalTimer >= 3)
			{
				maxApprovalText.visible = true;
				if (maxApprovalTimer >= 6)
				{
					maxApprovalText.visible = false;
					maxApprovalTimer = 0;
				}
			}
			maxApprovalText.color = ColorCycler.WilliamsUltraFlash;
		}
			
		extraLifeText.text = StringTools.lpad(Std.string(Globals.playerLives), "0", 2);
		rocketCountText.text = StringTools.lpad(Std.string(Globals.playerRockets), "0", 2);
		
		if (player.health == 1)
			healthBar[0].color = ColorCycler.RedYellowFlash;
			
		if (Globals.playerStaminaLevel > 0 && player.isSprintActive && 
			!Globals.pauseGame && !player.isInChopper && (player.velocity.x != 0 || player.velocity.y != 0))
		{
			Globals.playerStaminaLevel -= 0.4;
			if (Globals.playerStaminaLevel <= 0)
			{
				Globals.playerStaminaLevel = 0;
				player.isSprintActive = false;
			}
		}
		else if (Globals.playerStaminaLevel < 100 && !player.isSprintActive && player.alive && !Globals.pauseGame)
			Globals.playerStaminaLevel += 0.2;
		
		staminaBar.currentValue = Globals.playerStaminaLevel;
			
		laborTallyText.text = StringTools.lpad(Std.string(Globals.capturedLaborCount), "0", 3);
		killsTallyText.text = StringTools.lpad(Std.string(Globals.killsCount), "0", 3);
		savedTallyText.text = StringTools.lpad(Std.string(Globals.savedBankerCount + Globals.savedBimboCount), "0", 3);
		approvalRatingText.text = StringTools.lpad(Std.string(Globals.playerApprovalRating), "0", 3);
	}
	
	public function updateScore(value:Int):Void
	{
		if (gameOver)
			return;
			
		Globals.playerScore += value;
		scoreText.text = Std.string(Globals.playerScore);
		if (Globals.playerScore >= Globals.extraLifeThreshold && Globals.currentWave != 25)
		{
			FlxG.sound.play("ExtraLife");
			Globals.playerLives++;
			if (Globals.playerLives > 99)
				Globals.playerLives = 99;
			Globals.extraLifeThreshold += Globals.extraLifeInterval;
		}
	}
	
	public function updateApprovalRating(value:Int):Void
	{
		if (Globals.playerApprovalRating != 100)
		{
			Globals.playerApprovalRating += value; 
			
			if (Globals.playerApprovalRating >= 100)
			{
				FlxG.sound.play("Yeah");
				Globals.playerApprovalRating = 100;
			}
			else if (Globals.playerApprovalRating <= 0)
				Globals.playerApprovalRating = 0;
		}
	}
	
	private function assignTarget(entityName:String, chasingEntity:Entity):Void
	{
		for (i in 0...entities.length)
		{
			var targetEntity = entities.members[i];
			var entityClassName = Type.getClassName(Type.getClass(targetEntity));
			
			if (!targetEntity.alive)
				continue;	
			
			if (((entityName == "Cleric" && entityClassName == "Bimbo") || 
				(entityName == "SuperPanther" && entityClassName == "Banker")) && 
				 targetEntity.target == null && chasingEntity.target == null && 
				 chasingEntity.isOnScreen() && targetEntity.isOnScreen())
			{
				targetEntity.target = chasingEntity;
				chasingEntity.target = targetEntity;
			}
			else if (entityName == "Palin" && chasingEntity.target == null && targetEntity.isOnScreen() && 
					 entityClassName != "Bimbo" && entityClassName != "Banker" && entityClassName != "Laborer")
			{
				chasingEntity.target = targetEntity;			
			}
		}
	}
	
	private function mobAttack(redNeck:FlxObject, entity:FlxObject):Void
	{
		var entityName = Type.getClassName(Type.getClass(entity));
		
		if (entityName == "Cleric" || entityName == "Panther" || 
			entityName == "SuperPanther" || entityName == "Niqabi" ||
			entityName == "Laborer" || entityName == "Bandito" || entityName == "Convert")
			{
				var deadEntity = cast(entity, Entity);
				blowChunks(deadEntity, true);
				entity.kill();	
				deadEntity = null;
			}
	}
	
	private function truckAttack(truck:FlxObject, entity:FlxObject):Void
	{
		var truckEntity = cast(truck, Entity);
		var deadEntity = cast(entity, Entity);
		var entityName = Type.getClassName(Type.getClass(entity));
		
		if (deadEntity.currentState != Entity.State.JUMPING && 
			deadEntity.currentState != Entity.State.DESCENDING &&
			deadEntity.currentState != Entity.State.LANDED &&
			deadEntity.currentState != Entity.State.RUN_OVER &&
			truckEntity.z >= deadEntity.z - 40 && truckEntity.z <= deadEntity.z + 40 &&
			truckEntity.velocity.x != 0) 
		{
			if (Math.abs(truckEntity.velocity.x) >= 375 || entityName == "Niqabi")
			{
				blowChunks(deadEntity, true);
				entity.kill();
			}
			else 
			{
				FlxG.sound.play("BodyThud");
				deadEntity.changeState(Entity.State.RUN_OVER);
			}
		}
		
		deadEntity = null;
		truckEntity = null;
	}
	
	private function missileAttack(missile:FlxObject, entity:FlxObject):Void
	{
		var entityName = Type.getClassName(Type.getClass(entity));
		
		if (entityName == "Cleric" || entityName == "Panther" || 
			entityName == "SuperPanther" || entityName == "Niqabi" ||
			entityName == "Laborer" || entityName == "Bandito" || entityName == "Convert")
			{
				var deadEntity = cast(entity, Entity);
				var center:FlxPoint = deadEntity.getGraphicMidpoint();
				displayList.add(new ExplosionFlash(center.x - 151, deadEntity.z - 220, deadEntity.z - 1));
				displayList.add(new Explosion(center.x - 64, center.y - 64, deadEntity.z, Explosion.ExplosionType.FIRE));
				FlxG.sound.play("Explosion" + FlxRandom.intRanged(1, 4));
				FlxG.camera.flash(0xFFFFFFFF, 0.1);
				FlxG.camera.shake(0.01, 0.5);
				if ((entityName == "Cleric" && deadEntity.currentState != Entity.State.RUNNING_AWAY) || entityName != "Cleric")
					blowChunks(deadEntity, false);
				else 
					bloodBurst(center.x, deadEntity.z - 64);
				entity.kill();	
				deadEntity = null;
			}
	}
	
	private function banditoScatter(entityKilled:Entity):Void
	{
		for (i in 0...entities.length)
		{
			var entity = entities.members[i];
			var entityName = Type.getClassName(Type.getClass(entity));
			
			if (!entity.alive || entity.currentState == Entity.State.DYING)
				continue;
			
			if (entityName == "Bandito" && entity.isOnScreen() && 
				entity.currentState == Entity.State.SHOOTING && FlxMath.distanceBetween(entityKilled, entity) < 250)
				entity.changeState(Entity.State.EVADING);
		}		
	}
	
	private function checkBlastArea(explosiveDevice:Entity):Void
	{
		var killCount:Int = 0;
		
		for (i in 0...entities.length)
		{
			var entity = entities.members[i];
			var entityName = Type.getClassName(Type.getClass(entity));
			
			if (!entity.alive)
				continue;
			
			if (entityName == "Cleric" || entityName == "Panther" || 
				entityName == "SuperPanther" || entityName == "Niqabi" || entityName == "Convert" ||
				entityName == "Laborer" || entityName == "Bandito" || entityName == "IMFGoon") 
			{
				if (FlxMath.distanceBetween(explosiveDevice, entity) < 150)
				{
					blowChunks(entity, true);
					if (entityName == "IMFGoon")
						moneyBlast(entity.x + (entity.frameWidth / 2), entity.z - 50, 50);
					entity.kill();	
					killCount++;
				}
				else if (entityName == "Bandito" && entity.isOnScreen())
					entity.changeState(Entity.State.EVADING);
			}
		}
		
		if (killCount > 2 && FlxRandom.chanceRoll(40))
			FlxG.sound.play("TrumpSitDown");
	}
	
	public function blowChunks(entity:Entity, showBloodBurst:Bool=false)
	{
		var center:FlxPoint = entity.getGraphicMidpoint();
		var entityName = Type.getClassName(Type.getClass(entity));
		
		if (showBloodBurst)
		{
			displayList.add(new Explosion(center.x - 64, center.y - 64, entity.z + 1, Explosion.ExplosionType.BLOOD));
			FlxG.sound.play("Squish");
		}
		
		chunkEmitter = new FlxEmitter(0, 0, 8);
		chunkEmitter.x = center.x;
		chunkEmitter.y = center.y;
		
		for (i in 0...8) 
		{
			var particle:FlxParticle = new FlxParticle();
			switch entityName
			{
				case "Cleric":
					particle.loadGraphic("assets/images/ClericChunks.png", true, 64, 64, false);
					
				case "Panther":
					particle.loadGraphic("assets/images/PantherChunks.png", true, 64, 64, false);
					
				case "SuperPanther":
					particle.loadGraphic("assets/images/PantherChunks.png", true, 64, 64, false);
					
				case "IMFGoon":
					particle.loadGraphic("assets/images/IMFGoonChunks.png", true, 64, 64, false);
					
				case "IMFParatrooper":
					particle.loadGraphic("assets/images/IMFGoonChunks.png", true, 64, 64, false);
					
				case "Bandito":
					particle.loadGraphic("assets/images/BanditoChunks.png", true, 64, 64, false);
					
				case "Niqabi":
					particle.loadGraphic("assets/images/NiqabiChunks.png", true, 32, 42, false);
					
				case "Convert":
					particle.loadGraphic("assets/images/ConvertChunks.png", true, 32, 42, false);
					
				case "Laborer":
					particle.loadGraphic("assets/images/LaborerChunks.png", true, 32, 32, false);
			}
			particle.animation.add("none", [i], 1, false);
			particle.animation.play("none");
			particle.elasticity = 0.3;
			particle.angularVelocity = 1080;
			particle.visible = false;
			chunkEmitter.add(particle);
		}
		
		chunkEmitter.setXSpeed(-150, 150);
		chunkEmitter.setYSpeed(-400, -200);
		chunkEmitter.bounce = 0.4;
		chunkEmitter.gravity = 300;
		
		add(chunkEmitter);
		chunkEmitter.start(true, 3, 0, 0, 0);
		
		bloodBurst(center.x, center.y);
	}
	
	public function bloodBurst(x_pos:Float, y_pos:Float):Void
	{
		bloodEmitter = new FlxEmitter(0, 0, 25);
		bloodEmitter.x = x_pos;
		bloodEmitter.y = y_pos;
		
		for (i in 0...25) 
		{
			var particle:FlxParticle = new FlxParticle();
			particle.loadGraphic("assets/images/BloodParticles.png", true, 16, 16, false);
			particle.animation.add("none", [i], 1, false);
			particle.animation.play("none");
			particle.elasticity = 0.3;
			particle.angularVelocity = 1080;
			particle.visible = false;
			bloodEmitter.add(particle);
		}
		
		bloodEmitter.setXSpeed(-150, 150);
		bloodEmitter.setYSpeed(-400, -200);
		bloodEmitter.gravity = 400; 
		
		add(bloodEmitter);
		bloodEmitter.start(false, 3, 0.01, 25);		
	}
	
	private function headBurst(entity:Entity)
	{
		var center:FlxPoint = entity.getGraphicMidpoint();
		
		displayList.add(new Explosion(center.x - 96, entity.y - 22, entity.z + 1, Explosion.ExplosionType.HEAD));
		FlxG.sound.play("Splat");
		
		chunkEmitter = new FlxEmitter(0, 0, 8);
		chunkEmitter.x = center.x;
		chunkEmitter.y = entity.y + 36;
		
		for (i in 0...8) 
		{
			var particle:FlxParticle = new FlxParticle();
			particle.loadGraphic("assets/images/HeadChunks.png", true, 48, 48, false);
			particle.animation.add("none", [i], 1, false);
			particle.animation.play("none");
			particle.elasticity = 0.3;
			particle.angularVelocity = 1080;
			particle.visible = false;
			chunkEmitter.add(particle);
		}
		
		chunkEmitter.setXSpeed(-150, 150);
		chunkEmitter.setYSpeed(-400, -200);
		chunkEmitter.bounce = 0.4;
		chunkEmitter.gravity = 300;
		
		add(chunkEmitter);
		chunkEmitter.start(true, 3, 0, 0, 0);
		
		bloodEmitter = new FlxEmitter(0, 0, 25);
		bloodEmitter.x = center.x;
		bloodEmitter.y = entity.y + 36;
		
		for (i in 0...25) 
		{
			var particle:FlxParticle = new FlxParticle();
			particle.loadGraphic("assets/images/BloodParticles.png", true, 16, 16, false);
			particle.animation.add("none", [i], 1, false);
			particle.animation.play("none");
			particle.elasticity = 0.3;
			particle.angularVelocity = 1080;
			particle.visible = false;
			bloodEmitter.add(particle);
		}
		
		bloodEmitter.setXSpeed(-150, 150);
		bloodEmitter.setYSpeed(-400, -200);
		bloodEmitter.gravity = 400; 
		
		add(bloodEmitter);
		bloodEmitter.start(false, 3, 0.01, 25);
	}
	
	private inline function buryDead(object:Entity):Void
	{
		if (Type.getClassName(Type.getClass(object)) != "Player")
			displayList.remove(object, true);
	}
	
	public function moneyBurst(x_pos:Float, y_pos:Float, amount:Int):Void
	{
		moneyEmitter = new FlxEmitter(0, 0, amount);
		moneyEmitter.x = x_pos;
		moneyEmitter.y = y_pos;
		
		for (i in 0...amount) 
		{
			var particle:FlxParticle = new FlxParticle();
			particle.loadGraphic("assets/images/Cash.png", true, 12, 12, false);
			particle.animation.add("float", [0, 1, 2, 1], 4, true);
			particle.animation.play("float", true, -1);
			particle.visible = false;
			moneyEmitter.add(particle);
		}
		
		moneyEmitter.setXSpeed(-25, 25);
		moneyEmitter.setYSpeed(-85, -100);
		moneyEmitter.gravity = 75;
		moneyEmitter.setRotation(0, 0);
		
		add(moneyEmitter);
		moneyEmitter.start(false, 12, 0.06, amount);		
	}
	
	public function moneyBlast(x_pos:Float, y_pos:Float, amount:Int):Void
	{
		moneyEmitter = new FlxEmitter(0, 0, amount);
		moneyEmitter.x = x_pos;
		moneyEmitter.y = y_pos;
		
		for (i in 0...amount) 
		{
			var particle:FlxParticle = new FlxParticle();
			particle.loadGraphic("assets/images/Cash.png", true, 12, 12, false);
			particle.animation.add("float", [0, 1, 2, 1], 4, true);
			particle.animation.play("float", true, -1);
			particle.visible = false;
			moneyEmitter.add(particle);
		}
		
		moneyEmitter.setXSpeed(-125, 125);
		moneyEmitter.setYSpeed(-250, 25);
		moneyEmitter.gravity = 125;
		moneyEmitter.particleDrag.set(100, 50);
		moneyEmitter.setRotation(0, 0);
		
		add(moneyEmitter);
		moneyEmitter.start(true, 12, 0.06, amount);		
	}
	
	public function objectToss(entity:Entity, entityName:String)
	{
		var center:FlxPoint = entity.getGraphicMidpoint();
		
		objectEmitter = new FlxEmitter();
		objectEmitter.x = center.x;
		objectEmitter.y = center.y;
		
		if (entityName == "Bandito")
		{
			for (i in 0...2) 
			{
				var particle:FlxParticle = new FlxParticle();
				particle.loadGraphic("assets/images/Pistol.png", false, 44, 22, false);
				particle.visible = false;
				objectEmitter.add(particle);
			}
		}
		else if (entityName == "IMFGoon")
		{
			var particle:FlxParticle = new FlxParticle();
			particle.loadGraphic("assets/images/Uzi.png", false, 38, 24, false);
			particle.visible = false;
			objectEmitter.add(particle);		
			
			var particle:FlxParticle = new FlxParticle();
			particle.loadGraphic("assets/images/Briefcase.png", false, 48, 28, false);
			particle.visible = false;
			objectEmitter.add(particle);
		}
		else if (entityName == "Player")
		{
			if (!player.alive)
			{
				var particle:FlxParticle = new FlxParticle();
				particle.loadGraphic("assets/images/AssaultRifle.png", false, 92, 32, false);
				particle.visible = false;
				objectEmitter.add(particle);
			}

			if ((Globals.playerRockets > 0 && !player.alive) || (Globals.playerRockets == 0 && player.alive))
			{
				var particle:FlxParticle = new FlxParticle();
				particle.loadGraphic("assets/images/RocketLauncher.png", false, 78, 28, false);
				particle.visible = false;
				objectEmitter.add(particle);
			}			
		}
		else
		{
			var particle:FlxParticle = new FlxParticle();
			switch entityName
			{
				case "Panther":
					particle.loadGraphic("assets/images/AK.png", false, 80, 28, false);
					
				case "SuperPanther":
					particle.loadGraphic("assets/images/AK.png", false, 80, 28, false);
					
				case "Banker":
					particle.loadGraphic("assets/images/Briefcase.png", false, 48, 28, false);
					
				case "Palin":
					particle.loadGraphic("assets/images/AK47.png", false, 86, 30, false);
			}
			
			particle.visible = false;
			objectEmitter.add(particle);
		}
		
		objectEmitter.setXSpeed(-75, 75);
		objectEmitter.setYSpeed( -400, -200);
		objectEmitter.setRotation(360, 720);
		objectEmitter.gravity = 600; 
		
		add(objectEmitter);
		objectEmitter.start(true, 3, 0, 0, 0);
	}
	
	public function specialAttack():Void
	{
		specialAttackText.setPosition((FlxG.width / 2) - (specialAttackText.width / 2), FlxG.height / 2  - 60);
		specialAttackText.visible = true;	
		specialAttackActive = true;
		
		if (!Globals.maxApproval)
			Globals.playerApprovalRating = 0;

		FlxG.sound.play("WantSome");
		
		if (FlxRandom.chanceRoll(50)) 
		{
			specialAttackTimer = new FlxTimer(5, specialAttackComplete, 1);
			specialAttackText.text = "TRUMP SUPPORTERS!";
			
			var redneck:Redneck;
			for (i in 0...Globals.stampedeCount)
			{
				redneck = stampede.recycle();
				redneck.x = FlxG.camera.scroll.x + FlxRandom.intRanged(-900, -100);
				redneck.y = FlxRandom.intRanged(530, Globals.WORLD_HEIGHT - redneck.frameHeight);
				redneck.z = redneck.y + redneck.frameHeight;
				displayList.add(redneck);
			}
		}
		else
		{
			var megaDrone = new MegaDrone();
			megaDrone.x = FlxG.camera.scroll.x - megaDrone.frameWidth;
			megaDrone.y = 300;
			megaDrone.facing = FlxObject.RIGHT;
			displayList.add(megaDrone);
						
			specialAttackTimer = new FlxTimer(5, specialAttackComplete, 1);
			missileTimer = new FlxTimer(1.5, launchMissiles, 1);
			specialAttackText.text = "DRONE ATTACK!";
		}
	}
	
	private function launchMissiles(timer:FlxTimer):Void
	{
		FlxG.sound.play("DroneFlyBy");
		
		var missile:Missile;
		for (i in 0...6)
		{
			missile = missiles.recycle();
			missile.y = 460 + (i * 50);
			if (i % 2 == 0)
			{
				missile.x = FlxG.camera.scroll.x + FlxG.width + FlxRandom.intRanged(100, 900);
				missile.facing = FlxObject.LEFT;
			}
			else
			{
				missile.x = FlxG.camera.scroll.x + FlxRandom.intRanged(-900, -100);
				missile.facing = FlxObject.RIGHT;
			}
			
			displayList.add(missile);
		}	
		
		missileTimer.destroy();		
	}
	
	private function specialAttackComplete(timer:FlxTimer):Void
	{
		specialAttackActive = false;
		specialAttackText.visible = false;
		specialAttackTimer.destroy();
	}
	
	override public function onFocusLost():Void 
	{
		if (!Globals.pauseGame)
		{
			Globals.lostScreenFocus = true;
			pauseText.visible = true;
			Globals.pauseGame = true;	
			FlxG.sound.pause();
			if (stampedeRumble.playing)
				stampedeRumble.stop();
		}
			
		super.onFocusLost();
	}
	
	override public function onFocus():Void 
	{
		if (Globals.pauseGame && Globals.lostScreenFocus)
		{
			pauseText.visible = false;
			Globals.lostScreenFocus = false;
			Globals.pauseGame = false;
			FlxG.sound.resume();
		}
			
		super.onFocus();
	}
	
	private function loadEntities(waveNumber:Int):Void
	{
		var spawnFacing:Int = FlxObject.LEFT;
		var spawn_x:Float = 0;
		var spawn_y:Float = 0;
		
		if (waveNumber != 25)
		{
			if (waveData.Bimbos > 0)
			{
				for (i in 0...waveData.Bimbos)
				{
					spawnFacing = (FlxRandom.chanceRoll(50) ? FlxObject.LEFT : FlxObject.RIGHT);
					spawn_x = (FlxG.width * 0.5) + (i * 350);
					spawn_y = FlxRandom.intRanged(400, 600); 
					bimbo = new Bimbo(spawn_x, spawn_y, spawn_y + 150, spawnFacing);
					bimbo.changeState(Entity.State.WANDERING);
					displayList.add(bimbo);
					entities.add(bimbo);
					if (waveNumber >= 1 && waveNumber <= 4)
						displayList.add(new ArrowHighlight((bimbo.x + bimbo.frameWidth / 2) - 30, bimbo.y - 88, bimbo.z, ArrowHighlight.ArrowType.RESCUE, 2, bimbo));
				}
			}
		}
		else
		{
			for (i in 0...waveData.Bimbos)
			{
				spawnFacing = FlxObject.LEFT;
				spawn_x = FlxG.camera.scroll.x + FlxG.width + FlxRandom.intRanged(100, 900);
				spawn_y = FlxRandom.intRanged(530, Globals.WORLD_HEIGHT - 150);
				bimbo = new Bimbo(spawn_x, spawn_y, spawn_y + 150, spawnFacing);
				bimbo.changeState(Entity.State.RUNNING_AWAY);
				displayList.add(bimbo);
				bimbos.add(bimbo);
			}
		}
		
		if (waveData.Laborers > 0)
		{
			for (i in 0...waveData.Laborers)
			{
				spawnFacing = (FlxRandom.chanceRoll(50) ? FlxObject.LEFT : FlxObject.RIGHT);
				spawn_x = (FlxG.width * 0.5) + (i * 350);
				spawn_y = FlxRandom.intRanged(450, 600); 
				laborer = new Laborer(spawn_x, spawn_y, spawn_y + 106, spawnFacing);
				laborer.changeState(Entity.State.WANDERING);
				displayList.add(laborer);
				entities.add(laborer);
				if (waveNumber >= 1 && waveNumber <= 4)
					displayList.add(new ArrowHighlight((laborer.x + laborer.frameWidth / 2) - 30, laborer.y - 86, laborer.z, ArrowHighlight.ArrowType.CAPTURE, 2, laborer));
			}
		}
		
		if (waveData.Bankers > 0)
		{
			for (i in 0...waveData.Bankers)
			{
				spawnFacing = (FlxRandom.chanceRoll(50) ? FlxObject.LEFT : FlxObject.RIGHT);
				spawn_x = (FlxG.width * 0.5) + (i * 350);
				spawn_y = FlxRandom.intRanged(400, 600); 
				banker = new Banker(spawn_x, spawn_y, spawn_y + 158, spawnFacing);
				banker.changeState(Entity.State.WANDERING);
				displayList.add(banker);
				entities.add(banker);
				if (waveNumber >= 1 && waveNumber <= 4)
					displayList.add(new ArrowHighlight((banker.x + banker.frameWidth / 2) - 30, banker.y - 60, banker.z, ArrowHighlight.ArrowType.RESCUE, 2, banker));
			}
		}
		
		spawnEntities();
		
		if (Globals.palinAlwaysActive)
		{
			palin = new Palin(400, 600, 600 + 152, player);
			displayList.add(palin);
		}
		else
		{
			if (waveNumber != 25)
			{
				if (!Globals.palinActive)
				{
					if (FlxRandom.chanceRoll(40))
					{
						spawn_x = FlxRandom.intRanged(2048, 6144); 
						spawn_y = FlxRandom.intRanged(400, 600); 
						palin = new Palin(spawn_x, spawn_y, spawn_y + 152, player);
						palinArrow = new ArrowHighlight((palin.x + palin.frameWidth / 2) - 30, palin.y - 88, palin.z, ArrowHighlight.ArrowType.ASSIST, -1, palin);
						displayList.add(palinArrow);
						Globals.palinHealth = 15;
						displayList.add(palin);			
					}
				}
				else
				{
					palin = new Palin(400, 600, 600 + 152, player);
					displayList.add(palin);			
				}
			}
		}
		
		if (Globals.currentZone >= 4)
		{
			for (i in 0...2)
			{
				if (i == 0)
					spawn_x = FlxRandom.intRanged(512, 4096); 
				else 
					spawn_x = FlxRandom.intRanged(4096, 7680); 
				spawn_y = FlxRandom.intRanged(550, 650); 
				rocketLauncher = new RocketLauncher(spawn_x, spawn_y, spawn_y + 28);
				pickups.add(rocketLauncher);				
			}
		}
		else
		{
			spawn_x = FlxRandom.intRanged(512, 4096); 
			spawn_y = FlxRandom.intRanged(550, 650); 
			rocketLauncher = new RocketLauncher(spawn_x, spawn_y, spawn_y + 28);
			pickups.add(rocketLauncher);
		}
		
		if (Globals.currentWave != 25)
		{
			var healthPickupCount = FlxRandom.intRanged(4, 6);
			for (i in 0...healthPickupCount)
			{
				spawn_x = 1024 + (1024 * i);
				spawn_y = FlxRandom.intRanged(500, 675); 
				healthPickup = new HealthPickup(spawn_x, spawn_y, spawn_y + 80);
				pickups.add(healthPickup);
			}
			
			chopper = new Chopper(7200, 400, 400 + 270);
			displayList.add(chopper);
			
			if (Globals.currentWave % 4 == 0)
			{
				daisyCutter = new DaisyCutter(7415, 530, 530 + 108, chopper);
				displayList.add(daisyCutter);
			}
			
			chopperFloor = new SubEntity(7428, 621, 621, chopper, 225, 171);
			chopperFloor.loadGraphic("assets/images/ChopperFloor.png", false, 184, 22, false);
			displayList.add(chopperFloor);
			
			exitArrow = new LevelExit(7500, 640, 640 + 102);
			exitArrow.loadGraphic("assets/images/UpArrow.png", true, 60, 102, false);
			exitArrow.animation.add("default", [0, 1, 2, 3, 4, 5], 12, true);
			exitArrow.animation.play("default");
			pickups.add(exitArrow);
			displayList.add(exitArrow);
		}
	}
}