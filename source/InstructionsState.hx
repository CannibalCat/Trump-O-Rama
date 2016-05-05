package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.LogitechButtonID;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import flixel.util.FlxVelocity;
import flixel.addons.text.FlxTypeText;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

enum Phase
{
	MOVEMENT_LEFT;
	MOVEMENT_RIGHT;
	SPRINT_RIGHT;
	SPRINT_LEFT;
	SHOOT;
	ROCKET;
	BANKER;
	BANKER_PICKUP;
	SHOOT_PANTHER;
	BIMBO;
	BIMBO_PICKUP;
	NIQABI;
	NIQABI_EXPLODE;
	LABORER;
	PALIN;
	STEAK;
	STEAK_PICKUP;
	ROCKET_LAUNCHER;
	NONE;
}

class InstructionsState extends FlxState
{
	private var chunkEmitter:FlxEmitter;
	private var bloodEmitter:FlxEmitter;
	private var delayTimer:FlxTimer;
	private var shotTimer:FlxTimer;
	private var currentPhase:Phase;
	private var instructionsScreen:FlxSprite;
	private var movementControls:FlxSprite;
	private var shootControls:FlxSprite;
	private var rocketControls:FlxSprite;
	private var specialControls:FlxSprite;
	private var sprintControls:FlxSprite;
	private var player:Entity;
	private var bullet:PlayerBullet;
	private var rocket:Rocket;
	private var smokeEmitter:FlxEmitter;
	private var banker:Entity;
	private var superPanther:Entity;
	private var panther:Entity;
	private var cleric:Entity;
	private var bimbo:Entity;
	private var niqabi:Entity;
	private var laborer:Entity;
	private var bandito:Entity;
	private var palin:Entity;
	private var trumpSteak:Entity;
	private var rocketLauncher:Entity;
	private var movementText:FlxTypeText;
	private var shootText:FlxTypeText;
	private var rocketText:FlxTypeText;
	private var specialText:FlxTypeText;
	private var sprintText:FlxTypeText;
	private var bankerText:FlxTypeText;
	private var pantherText:FlxTypeText;
	private var bimboText:FlxTypeText;
	private var niqabiText:FlxTypeText;
	private var laborerText:FlxTypeText;
	private var palinText:FlxTypeText;
	private var steakText:FlxTypeText;
	private var rocketLauncherText:FlxTypeText;
	private var continueText:FlxText;
	private var exitDialogActive:Bool = false;
	private var pickups:FlxTypedGroup<Entity>;
	private var entities:FlxTypedGroup<Entity>;
	private var bullets:FlxTypedGroup<Entity>;
	private var shards:FlxTypedGroup<Shrapnel>;
	private var fuseCounter:Float = 0;
	
	private var gamepad(get, never):FlxGamepad;
	private function get_gamepad():FlxGamepad 
	{
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		
		if (gamepad == null)
			gamepad = FlxG.gamepads.getByID(0);

		return gamepad;
	}
	
	override public function create():Void
	{
		FlxG.camera.bgColor = 0xFF08105A;
		
		instructionsScreen = new FlxSprite(0, 0, "assets/images/InstructionsScreen.png");
		add(instructionsScreen); 
		
		pickups = new FlxTypedGroup<Entity>();
		add(pickups);
		
		entities = new FlxTypedGroup<Entity>();
		add(entities);
		
		bullets = new FlxTypedGroup<Entity>();
		add(bullets);
		
		shards = new FlxTypedGroup<Shrapnel>();
		add(shards);
		
		player = new Entity();
		player.loadGraphic("assets/images/Trump.png", true, 216, 144, false);
		player.animation.add("idle_rocket", [54], 1, true);
		player.animation.add("walk_rocket", [50, 51, 52, 53, 54, 55, 56, 57, 58, 59], 14, true);
		player.animation.add("run_rocket", [50, 51, 52, 53, 54, 55, 56, 57, 58, 59], 20, true);
		player.setFacingFlip(FlxObject.LEFT, true, false); 
		player.setFacingFlip(FlxObject.RIGHT, false, false); 
		player.setPosition(50, 550);
		player.animation.play("idle_rocket");
		add(player);
		
		banker = new Entity();
        banker.loadGraphic("assets/images/Banker.png", true, 112, 158, false);
		banker.animation.add("run", [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 20, true);
		banker.animation.add("captured", [26, 27], 16, true);
		banker.setFacingFlip(FlxObject.LEFT, true, false); 
		banker.setFacingFlip(FlxObject.RIGHT, false, false); 
		banker.facing = FlxObject.LEFT;
		banker.setPosition(600, 550);
		banker.visible = false;
		pickups.add(banker);
		
		superPanther = new Entity();
        superPanther.loadGraphic("assets/images/SuperPanther.png", true, 152, 144, false);
		superPanther.animation.add("idle", [20, 21, 22, 23, 24], 10, true);
		superPanther.animation.add("attack", [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 20, true);
		superPanther.animation.add("death", [25, 26, 27, 28, 29, 28, 29, 28, 29], 10, false);
		superPanther.setFacingFlip(FlxObject.LEFT, true, false); 
		superPanther.setFacingFlip(FlxObject.RIGHT, false, false); 
		superPanther.facing = FlxObject.LEFT;
		superPanther.health = 4;
		superPanther.setPosition(750, 550);
		superPanther.visible = false;
		entities.add(superPanther);
		
		bimbo = new Entity();
		bimbo.loadGraphic("assets/images/Bimbo.png", true, 86, 150, false);
		bimbo.animation.add("idle", [5], 1, true);
		bimbo.animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		bimbo.animation.add("run", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20, true);
		bimbo.animation.add("captured", [11, 12], 16, true);
		bimbo.setFacingFlip(FlxObject.LEFT, true, false); 
		bimbo.setFacingFlip(FlxObject.RIGHT, false, false); 
		bimbo.facing = FlxObject.LEFT;
		bimbo.setPosition(650, 550);
		bimbo.visible = false;
		entities.add(bimbo);
		
		cleric = new Entity();
		cleric.loadGraphic("assets/images/Cleric.png", true, 72, 158, false);
		cleric.animation.add("idle", [5], 1, true);
		cleric.animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		cleric.animation.add("run", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20, true);
		cleric.setFacingFlip(FlxObject.LEFT, true, false); 
		cleric.setFacingFlip(FlxObject.RIGHT, false, false); 
		cleric.facing = FlxObject.LEFT;
		cleric.setPosition(800, 550);
		cleric.visible = false;
		entities.add(cleric);
		
		niqabi = new Entity();
		niqabi.loadGraphic("assets/images/Niqabi.png", true, 72, 122, false);
		niqabi.animation.add("idle", [5], 1, true);
		niqabi.animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		niqabi.animation.add("attack", [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 20, true);
		niqabi.animation.add("exploding", [20, 21], 15, true);
		niqabi.setFacingFlip(FlxObject.LEFT, true, false); 
		niqabi.setFacingFlip(FlxObject.RIGHT, false, false); 
		niqabi.facing = FlxObject.RIGHT;
		niqabi.setPosition(100, 550);
		niqabi.visible = false;
		entities.add(niqabi);		
		
		laborer = new Entity();
        laborer.loadGraphic("assets/images/Laborer.png", true, 64, 106, false);
		laborer.animation.add("idle", [9], 1, true);
		laborer.animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		laborer.animation.add("run", [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 20, true);
		laborer.animation.add("captured", [20, 21], 16, true);
		laborer.setFacingFlip(FlxObject.LEFT, true, false); 
		laborer.setFacingFlip(FlxObject.RIGHT, false, false); 
		laborer.facing = FlxObject.RIGHT;
		laborer.setPosition(50, 550);
		laborer.visible = false;
		entities.add(laborer);
		
		palin = new Entity();
		palin.loadGraphic("assets/images/Palin.png", true, 218, 152, false);
		palin.animation.add("idle", [20], 1, true);
		palin.animation.add("idle_weapon", [5], 1, true);
		palin.animation.add("wander", [15, 16, 17, 18, 19, 20, 21, 22, 23, 24], 14, true);
		palin.animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 14, true);
		palin.setFacingFlip(FlxObject.LEFT, true, false); 
		palin.setFacingFlip(FlxObject.RIGHT, false, false); 
		palin.facing = FlxObject.LEFT;
		palin.setPosition(800, 550);
		palin.visible = false;
		entities.add(palin);
		
		trumpSteak = new Entity();
		trumpSteak.loadGraphic("assets/images/HealthPickup.png", true, 42, 80, false);
		trumpSteak.animation.add("default", [0, 1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 1], 16, true);
		trumpSteak.animation.play("default");
		trumpSteak.setPosition(300, 550);
		trumpSteak.visible = false;
		entities.add(trumpSteak);
		
		rocketLauncher = new Entity();
		rocketLauncher.loadGraphic("assets/images/RocketLauncherPickup.png", true, 78, 112, false);
		rocketLauncher.animation.add("default", [0, 1, 2, 3, 4, 5], 15, true);
		rocketLauncher.animation.play("default");
		rocketLauncher.setPosition(100, 550);
		rocketLauncher.visible = false;
		entities.add(rocketLauncher);
		
		movementControls = new FlxSprite(0, 0, "assets/images/PlayMovement.png");
		movementControls.setPosition(65, 175);
		add(movementControls); 
		
		movementText = new FlxTypeText(440, 200, 0, "MOVE TRUMP WITH THE KEYBOARD\nARROW KEYS OR USE THE GAMEPAD\nLEFT ANALOG STICK / D-PAD.", 36, false);
		movementText.font = Globals.TEXT_FONT;
		movementText.showCursor = false;
		movementText.autoErase = false;
		movementText.antialiasing = false;
		movementText.color = 0xFFFFFF;
		movementText.setBorderStyle(FlxText.BORDER_SHADOW, 0x404040, 4);
		add(movementText);

		shootControls = new FlxSprite(0, 0, "assets/images/PlayShoot.png");
		shootControls.setPosition(65 + 86, 175 + 39);
		shootControls.visible = false;
		add(shootControls); 
		
		shootText = new FlxTypeText(440, 200, 0, "SHOOT YOUR ASSAULT RIFLE\nWITH THE KEYBOARD Z KEY\nOR GAMEPAD \"A\" BUTTON.", 36, false);
		shootText.font = Globals.TEXT_FONT;
		shootText.showCursor = false;
		shootText.autoErase = false;
		shootText.antialiasing = false;
		shootText.color = 0xFFFFFF;
		shootText.setBorderStyle(FlxText.BORDER_SHADOW, 0x404040, 4);
		add(shootText);

		rocketControls = new FlxSprite(0, 0, "assets/images/PlayRocket.png");
		rocketControls.setPosition(65 + 86, 175 + 39);
		rocketControls.visible = false;
		add(rocketControls); 
		
		rocketText = new FlxTypeText(440, 200, 0, "LAUNCH ROCKETS (IF EQUIPPED)\nWITH THE KEYBOARD X KEY\nOR GAMEPAD \"B\" BUTTON.", 36, false);
		rocketText.font = Globals.TEXT_FONT;
		rocketText.showCursor = false;
		rocketText.autoErase = false;
		rocketText.antialiasing = false;
		rocketText.color = 0xFFFFFF;
		rocketText.setBorderStyle(FlxText.BORDER_SHADOW, 0x404040, 4);
		add(rocketText);
		
		sprintControls = new FlxSprite(0, 0, "assets/images/PlaySprint.png");
		sprintControls.setPosition(81, 360);
		sprintControls.visible = false;
		add(sprintControls); 
		
		sprintText = new FlxTypeText(440, 330, 0, "YOU CAN SPRINT AS LONG AS\nYOUR STAMINA BAR IS FILLED\nUSING THE KEYBOARD SHIFT\nKEY OR GAMEPAD \"Y\" BUTTON.", 36, false);
		sprintText.font = Globals.TEXT_FONT;
		sprintText.showCursor = false;
		sprintText.autoErase = false;
		sprintText.antialiasing = false;
		sprintText.color = 0xFFFFFF;
		sprintText.setBorderStyle(FlxText.BORDER_SHADOW, 0x404040, 4);
		add(sprintText);		

		specialControls = new FlxSprite(0, 0, "assets/images/PlaySpecial.png");
		specialControls.setPosition(81, 360);
		specialControls.visible = false;
		add(specialControls); 
		
		specialText = new FlxTypeText(440, 330, 0, "LAUNCH A SPECIAL ATTACK (IF\nYOUR APPROVAL RATING IS AT\n100%) USING THE KEYBOARD C\nKEY OR GAMEPAD \"X\" BUTTON.", 36, false);
		specialText.font = Globals.TEXT_FONT;
		specialText.showCursor = false;
		specialText.autoErase = false;
		specialText.antialiasing = false;
		specialText.color = 0xFFFFFF;
		specialText.setBorderStyle(FlxText.BORDER_SHADOW, 0x404040, 4);
		add(specialText);
		
		bankerText = new FlxTypeText(90, 200, 0, "SAVE THE BANKERS FROM THE BLACK PANTHERS (THAT\nHAVE FLASHING SHADES) BY RUNNING INTO THEM.", 36, false);
		bankerText.font = Globals.TEXT_FONT;
		bankerText.showCursor = false;
		bankerText.autoErase = false;
		bankerText.antialiasing = false;
		bankerText.color = 0xFFFFFF;
		bankerText.setBorderStyle(FlxText.BORDER_SHADOW, 0x404040, 4);
		add(bankerText);
		
		pantherText = new FlxTypeText(95, 200, 0, "ENEMIES TAKE MULTIPLE SHOTS BEFORE THEY DIE...", 36, false);
		pantherText.font = Globals.TEXT_FONT;
		pantherText.showCursor = false;
		pantherText.autoErase = false;
		pantherText.antialiasing = false;
		pantherText.color = 0xFFFFFF;
		pantherText.setBorderStyle(FlxText.BORDER_SHADOW, 0x404040, 4);
		add(pantherText);
		
		bimboText = new FlxTypeText(105, 200, 0, "RESCUE BLONDES FROM THE CLERICS BEFORE THEY\nARE CONVERTED INTO NIQABIS!", 36, false);
		bimboText.font = Globals.TEXT_FONT;
		bimboText.showCursor = false;
		bimboText.autoErase = false;
		bimboText.antialiasing = false;
		bimboText.color = 0xFFFFFF;
		bimboText.setBorderStyle(FlxText.BORDER_SHADOW, 0x404040, 4);
		add(bimboText);
		
		niqabiText = new FlxTypeText(60, 200, 0, "WATCH OUT FOR NIQABIS! THEY WILL EXPLODE IN YOUR\nPROXIMITY LEAVING BEHIND A HAILSTORM OF SHRAPNEL.", 36, false);
		niqabiText.font = Globals.TEXT_FONT;
		niqabiText.showCursor = false;
		niqabiText.autoErase = false;
		niqabiText.antialiasing = false;
		niqabiText.color = 0xFFFFFF;
		niqabiText.setBorderStyle(FlxText.BORDER_SHADOW, 0x404040, 4);
		add(niqabiText);
		
		laborerText = new FlxTypeText(90, 200, 0, "CAPTURE DAY LABORERS TO HELP BUILD THE GREAT\nBORDER WALL. WORTH MORE ALIVE THAN DEAD!", 36, false);
		laborerText.font = Globals.TEXT_FONT;
		laborerText.showCursor = false;
		laborerText.autoErase = false;
		laborerText.antialiasing = false;
		laborerText.color = 0xFFFFFF;
		laborerText.setBorderStyle(FlxText.BORDER_SHADOW, 0x404040, 4);
		add(laborerText);
		
		palinText = new FlxTypeText(90, 200, 0, "GRAB PALIN, IF YOU CAN FIND HER, AS AN ALLY\nAGAINST YOUR ENEMIES BY RUNNING INTO HER\nON THE STREET.", 36, false);
		palinText.font = Globals.TEXT_FONT;
		palinText.showCursor = false;
		palinText.autoErase = false;
		palinText.antialiasing = false;
		palinText.color = 0xFFFFFF;
		palinText.setBorderStyle(FlxText.BORDER_SHADOW, 0x404040, 4);
		add(palinText);
		
		steakText = new FlxTypeText(90, 320, 0, "PICKUP TRUMP STEAKS TO INCREASE YOUR HEALTH.", 36, false);
		steakText.font = Globals.TEXT_FONT;
		steakText.showCursor = false;
		steakText.autoErase = false;
		steakText.antialiasing = false;
		steakText.color = 0xFFFFFF;
		steakText.setBorderStyle(FlxText.BORDER_SHADOW, 0x404040, 4);
		add(steakText);
		
		rocketLauncherText = new FlxTypeText(90, 370, 0, "PICKUP ROCKET LAUNCHERS TO INCREASE YOUR\nSUPPLY OF ROCKETS.", 36, false);
		rocketLauncherText.font = Globals.TEXT_FONT;
		rocketLauncherText.showCursor = false;
		rocketLauncherText.autoErase = false;
		rocketLauncherText.antialiasing = false;
		rocketLauncherText.color = 0xFFFFFF;
		rocketLauncherText.setBorderStyle(FlxText.BORDER_SHADOW, 0x404040, 4);
		add(rocketLauncherText);

		continueText = new FlxText(0, 0, FlxG.width, "PRESS ENTER TO SKIP");
		continueText.setFormat(Globals.TEXT_FONT, 28, 0xFFFFFFFF, "center");
		continueText.setBorderStyle(FlxText.BORDER_SHADOW, 0x404040, 4);
		continueText.setPosition((FlxG.width / 2) - (continueText.width / 2), 720);
		continueText.antialiasing = false;
		add(continueText);		
		
		movementText.start(0.02, false, false, null, null, onMovementComplete);
		currentPhase = MOVEMENT_RIGHT;
		
		super.create();
	}
	
	private function onMovementComplete():Void
	{
		currentPhase = SPRINT_RIGHT;
		sprintControls.visible = true;
		sprintText.start(0.02, false, false, null, null, onSprintComplete);	
	}
	
	private function onSprintComplete():Void
	{
		delayTimer = new FlxTimer(3, clearMovementItems, 1);
	}
	
	private function clearMovementItems(timer:FlxTimer):Void
	{
		movementText.visible = false;
		movementControls.visible = false;
		sprintText.visible = false;
		sprintControls.visible = false;
		shootControls.visible = true;
		shootText.start(0.02, false, false, null, null, onShootComplete);	
		shotTimer = new FlxTimer(0.25, onRifleShoot, 6);
	}
	
	private function onShootComplete():Void
	{
		delayTimer = new FlxTimer(2, clearShootItems, 1);
	}
	
	private function clearShootItems(timer:FlxTimer):Void
	{
		shootText.visible = false;
		shootControls.visible = false;
		rocketControls.visible = true;
		rocketText.start(0.02, false, false, null, null, onRocketComplete);	
		shotTimer = new FlxTimer(0.25, onRocketShoot, 1);
	}
	
	private function onRocketComplete():Void
	{
		specialControls.visible = true;
		specialText.start(0.02, false, false, null, null, onSpecialComplete);	
	}
	
	private function clearRocketItems(timer:FlxTimer):Void
	{
		rocketText.visible = false;
		rocketControls.visible = false;
		specialText.visible = false;
		specialControls.visible = false;
		currentPhase = BANKER;
		bankerText.start(0.02, false, false, null, null, onBankerComplete);	
	}
	
	private function onSpecialComplete():Void
	{
		delayTimer = new FlxTimer(2, clearRocketItems, 1);
	}
	
	private function onBankerComplete():Void
	{
		delayTimer = new FlxTimer(2, clearBankerItems, 1);
	}
	
	private function clearBankerItems(timer:FlxTimer):Void
	{
		bankerText.visible = false;
		pantherText.start(0.02, false, false, null, null, onPantherComplete);	
		currentPhase = SHOOT_PANTHER;
		shotTimer = new FlxTimer(0.25, onRifleShoot, 3);
	}
	
	private function onPantherComplete():Void
	{
		delayTimer = new FlxTimer(2, clearPantherItems, 1);
	}
	
	private function clearPantherItems(timer:FlxTimer):Void
	{
		pantherText.visible = false;
		currentPhase = BIMBO;
		bimboText.start(0.02, false, false, null, null, onBimboComplete);		
	}
	
	private function onBimboComplete():Void
	{
		delayTimer = new FlxTimer(2, clearBimboItems, 1);
	}

	private function clearBimboItems(timer:FlxTimer):Void
	{
		bimboText.visible = false;
		cleric.kill();
		currentPhase = NIQABI;
		niqabiText.start(0.02, false, false, null, null, onNiqabiComplete);		
	}
	
	private function onNiqabiComplete():Void
	{
		delayTimer = new FlxTimer(2, clearNiqabiItems, 1);
	}
	
	private function clearNiqabiItems(timer:FlxTimer):Void
	{
		niqabiText.visible = false;
		currentPhase = LABORER;
		laborerText.start(0.02, false, false, null, null, onLaborerComplete);		
	}
	
	private function onLaborerComplete():Void
	{
		delayTimer = new FlxTimer(2, clearLaborerItems, 1);
	}
	
	private function clearLaborerItems(timer:FlxTimer):Void
	{
		laborerText.visible = false;
		currentPhase = PALIN;
		palin.visible = true;
		palinText.start(0.02, false, false, null, null, onPalinComplete);		
	}
	
	private function onPalinComplete():Void
	{
		currentPhase = STEAK;
		steakText.start(0.02, false, false, null, null, onSteakComplete);		
	}	
	
	private function onSteakComplete():Void
	{
		currentPhase = ROCKET_LAUNCHER;
		rocketLauncherText.start(0.02, false, false, null, null, onRocketLauncherComplete);		
	}	
	
	private function onRocketLauncherComplete():Void
	{
		delayTimer = new FlxTimer(3, clearPickupItems, 1);
	}	
	
	private function clearPickupItems(timer:FlxTimer):Void
	{
		palinText.visible = false;
		steakText.visible = false;
		rocketLauncherText.visible = false;
		FlxG.cameras.fade(0xFF000000, 2, false, onFinalFade);
	}
	
	private function onFinalFade():Void
	{
		Globals.resetGameGlobals(); 
		FlxG.switchState(new TitleState());
	}
	
	private function onCloseDialog():Void
	{
		exitDialogActive = false;
	}
	
	override public function update():Void
	{
		ColorCycler.Update();
		
		if (movementText.visible)
			movementText.color = ColorCycler.WilliamsFlash8;
			
		if (sprintText.visible)
			sprintText.color = ColorCycler.RGB;
			
		if (shootText.visible)
			shootText.color = ColorCycler.WilliamsFlash8;
			
		if (rocketText.visible)
			rocketText.color = ColorCycler.WilliamsFlash8;
			
		if (specialText.visible)
			specialText.color = ColorCycler.WilliamsUltraFlash;
			
		if (bankerText.visible)
			bankerText.color = ColorCycler.WilliamsFlash8;
			
		if (pantherText.visible)
			pantherText.color = ColorCycler.WilliamsFlash8;
			
		if (bimboText.visible)
			bimboText.color = ColorCycler.WilliamsFlash8;
			
		if (niqabiText.visible)
			niqabiText.color = ColorCycler.WilliamsFlash8;
			
		if (laborerText.visible)
			laborerText.color = ColorCycler.WilliamsFlash8;
			
		if (palinText.visible)
			palinText.color = ColorCycler.WilliamsFlash8;
			
		if (steakText.visible)
			steakText.color = ColorCycler.RGB;
			
		if (rocketLauncherText.visible)
			rocketLauncherText.color = ColorCycler.WilliamsUltraFlash;
			
		continueText.color = ColorCycler.RedPulse;
		
		if (exitDialogActive)
			return;
			
		switch currentPhase 
		{
			case MOVEMENT_RIGHT:
				player.facing = FlxObject.RIGHT;
				player.animation.play("walk_rocket");
				if (player.x > 100 && player.x < 200)
					player.velocity.y = -125;	
				else if (player.x >= 200)
					currentPhase = MOVEMENT_LEFT;
				else
				{
					player.velocity.x = 125;
					player.velocity.y = 125;	
				}
				
			case MOVEMENT_LEFT:
				player.facing = FlxObject.LEFT;
				if (player.x < 100 && player.x > 50)
					player.velocity.y = -125;
				else if (player.x <= 50)
				{
					player.facing = FlxObject.RIGHT;
					player.animation.play("idle_rocket");
					player.velocity.x = 0;
					player.velocity.y = 0;					
				}
				else
				{
					player.velocity.x = -125;
					player.velocity.y = 125;			
				}
				
			case SPRINT_RIGHT:
				player.facing = FlxObject.RIGHT;
				player.animation.play("run_rocket");
				if (player.x >= 500)
					currentPhase = SPRINT_LEFT;
				else
				{
					player.velocity.x = 225;
					player.velocity.y = 0;	
				}	
				
			case SPRINT_LEFT:
				player.animation.play("run_rocket");
				player.facing = FlxObject.LEFT;
				if (player.x <= 50)
					currentPhase = SHOOT;
				else
				{
					player.velocity.x = -225;
					player.velocity.y = 0;			
				}
				
			case SHOOT:
				player.animation.play("idle_rocket");
				player.facing = FlxObject.RIGHT;
				player.velocity.x = 0;
				player.velocity.y = 0;
				
			case ROCKET:
				smokeEmitter.x = rocket.x;
				smokeEmitter.y = rocket.y + 5;
				
			case BANKER:
				banker.visible = true;
				superPanther.visible = true;
				if (FlxG.pixelPerfectOverlap(player, banker))
				{
					banker.facing = FlxObject.RIGHT;
					banker.animation.play("captured");
					FlxVelocity.moveTowardsPoint(banker, new FlxPoint(950, 0), 1000);
					player.velocity.x = 0;
					superPanther.velocity.x = 0;
					player.animation.play("idle_rocket");
					superPanther.animation.play("idle");
					currentPhase = BANKER_PICKUP;
				}
				else 
				{
					banker.animation.play("run");
					superPanther.animation.play("attack");
					player.animation.play("walk_rocket");
					player.velocity.x = 125;
					banker.velocity.x = -125;
					superPanther.velocity.x = -130;					
				}
				
			case BANKER_PICKUP:
				if (banker.y <= 0)
				{
					banker.kill();
					currentPhase = SHOOT_PANTHER;
				}
				
			case SHOOT_PANTHER:
				for (i in 0...bullets.length)
				{
					var bullet = bullets.members[i];
					if (FlxG.pixelPerfectOverlap(bullet, superPanther))
					{
						superPanther.hurt(1);
						bullet.kill();
						if (superPanther.health == 1)
							superPanther.animation.play("death");
						else
						{
							add(new BloodSplatter(superPanther.origin.x, superPanther.origin.y, superPanther.z + 1, superPanther, BloodSplatter.SplatterType.SPLASH));
							FlxTween.tween(superPanther, { x:superPanther.x + 25 }, 0.1); 
						}
					}
				}
				
			case BIMBO:
				bimbo.visible = true;
				cleric.visible = true;
				if (FlxG.pixelPerfectOverlap(player, bimbo))
				{
					bimbo.facing = FlxObject.RIGHT;
					bimbo.animation.play("captured");
					FlxVelocity.moveTowardsPoint(bimbo, new FlxPoint(950, 0), 1000);
					player.velocity.x = 0;
					cleric.velocity.x = 0;
					player.animation.play("idle_rocket");
					cleric.animation.play("idle");
					currentPhase = BIMBO_PICKUP;
				}
				else 
				{
					bimbo.animation.play("run");
					cleric.animation.play("run");
					player.animation.play("walk_rocket");
					player.velocity.x = 125;
					bimbo.velocity.x = -125;
					cleric.velocity.x = -130;					
				}
				
			case BIMBO_PICKUP:
				if (bimbo.y <= 0)
					bimbo.kill();
				
			case NIQABI:
				niqabi.visible = true;
				if (niqabi.x >= player.x - 50)
				{
					niqabi.velocity.x = 0;
					niqabi.animation.play("exploding");
					fuseCounter += FlxG.elapsed;
					if (fuseCounter > 1)
					{
						niqabi.kill();
						explode();
						currentPhase = NIQABI_EXPLODE;
					}
				}
				else 
				{
					niqabi.animation.play("attack");
					niqabi.velocity.x = 125;
				}
				
			case NIQABI_EXPLODE:
				for (i in 0...shards.length)
				{
					var shard = shards.members[i];
					if (FlxG.pixelPerfectOverlap(shard, player)) 
					{
						FlxTween.tween(player, { x:player.x + 50 }, .1);
						add(new BloodSplatter(player.x + 100, player.y + player.origin.y, player.z + 1, player, BloodSplatter.SplatterType.SPLASH));
						shard.kill();
					}
				}
				
			case LABORER:
				laborer.visible = true;
				player.facing = FlxObject.LEFT;
				if (FlxG.pixelPerfectOverlap(player, laborer))
				{
					laborer.facing = FlxObject.RIGHT;
					laborer.animation.play("captured");
					FlxVelocity.moveTowardsPoint(laborer, new FlxPoint(950, 0), 1000);
					player.velocity.x = 0;
					player.animation.play("idle_rocket");
					currentPhase = NONE;
				}
				else 
				{
					laborer.animation.play("walk");
					player.animation.play("walk_rocket");
					player.velocity.x = -125;
					laborer.velocity.x = 64;
				}
				
			case PALIN:
				palin.visible = true;
				player.facing = FlxObject.RIGHT;
				if (FlxG.pixelPerfectOverlap(player, palin))
				{
					player.facing = FlxObject.LEFT;
					palin.animation.play("idle_weapon");
					palin.velocity.x = 0;
					player.velocity.x = 0;
					player.facing = FlxObject.LEFT;
					player.animation.play("idle_rocket");
				}
				else 
				{
					palin.animation.play("wander");
					player.animation.play("walk_rocket");
					player.velocity.x = 125;
					palin.velocity.x = -96;
				}
				
			case STEAK:
				trumpSteak.visible = true;
				player.velocity.x = -125;
				player.animation.play("walk_rocket");
				if (player.x <= 500)
				{
					palin.velocity.x = -125;
					palin.animation.play("walk");
				}
				if (FlxG.pixelPerfectOverlap(player, trumpSteak))
				{
					FlxVelocity.moveTowardsPoint(trumpSteak, new FlxPoint(100, 0), 1000);
					currentPhase = STEAK_PICKUP;
				}
				
			case STEAK_PICKUP:
				if (trumpSteak.y <= 0)
					trumpSteak.kill();
				
			case ROCKET_LAUNCHER:
				rocketLauncher.visible = true;
				if (FlxG.pixelPerfectOverlap(player, rocketLauncher))
				{
					rocketLauncher.kill();
					currentPhase = NONE;
				}
				
			case NONE:
		}
		
		if (FlxG.keys.justPressed.ESCAPE)
		{
			persistentUpdate = true;
			exitDialogActive = true;
			var exitDialog = new GameExitState();
			exitDialog.closeCallback = onCloseDialog;
			openSubState(exitDialog);
		}
			
		if (FlxG.keys.pressed.ENTER || gamepad.justPressed(7) || 
			gamepad.justPressed(LogitechButtonID.TEN))
			FlxG.cameras.fade(0xFF000000, 2, false, onFinalFade);
		
		super.update();
	}
	
	private function onRifleShoot(timer:FlxTimer):Void
	{
		bullet = new PlayerBullet();
		bullet.setPosition(player.x + player.frameWidth + 2, player.y + 49);
		player.offset_x = player.x + player.frameWidth + 2;
		player.offset_y = player.y + 44;
		add(new PlayerMuzzleFlash(player.offset_x, player.offset_y, player.y, player));
		bullets.add(bullet);
	}
	
	private function onRocketShoot(timer:FlxTimer):Void
	{
		currentPhase = ROCKET;
		rocket = new Rocket();
		rocket.setPosition(player.x + player.frameWidth - 35, player.y + 65);
		rocket.facing = FlxObject.RIGHT;
		smokeEmitter = new FlxEmitter();
		smokeEmitter.setXSpeed( -150, -100);
		smokeEmitter.setYSpeed(-30, 30);
		smokeEmitter.setAlpha(1, 1, 0, 0);
		smokeEmitter.setColor(0xFFFFFFFF, 0xFF000000);
		smokeEmitter.setScale(0.5, 1, 2, 2.5);
		smokeEmitter.gravity = 0;
		smokeEmitter.setRotation(0, 0);
		for (i in 0...125)
		{
			var smokeParticle:FlxParticle = new FlxParticle();
			smokeParticle.loadGraphic("assets/images/SmokeParticle.png", false, 15, 15, false);
			smokeParticle.visible = false; 
			smokeEmitter.add(smokeParticle);
			smokeParticle.kill();
		}
		smokeEmitter.revive();
		smokeEmitter.x = rocket.x;
		add(smokeEmitter);
		add(rocket);
		smokeEmitter.start(false, 1, 0.01);
	}
	
	private function explode():Void
	{
		var center:FlxPoint = niqabi.getGraphicMidpoint();
		add(new ExplosionFlash(center.x - 151, niqabi.z - 220, niqabi.z - 1));
		add(new Explosion(center.x - 64, center.y - 64, niqabi.z + 1, Explosion.ExplosionType.FIRE));
		blowChunks();
		FlxG.camera.flash(0xFFFFFFFF, 0.1);
		FlxG.camera.shake(0.01, 0.5);
		
		var fullCircle:Float = 2 * Math.PI;
		var interval:Float = fullCircle / 12;
		var length:Int = 350; 
		var angle:Float = 0;
		
		while (angle < fullCircle)
		{
			var shrapnel = new Shrapnel();
			shrapnel.x = center.x;
			shrapnel.y = center.y;
			shrapnel.z = niqabi.z + 1;
			shrapnel.velocity.x = length * Math.cos(angle);
			shrapnel.velocity.y = length * Math.sin(angle);
			shrapnel.visible = true;
			shards.add(shrapnel);
			angle += interval;
		}
	}
	
	public function blowChunks()
	{
		var center:FlxPoint = niqabi.getGraphicMidpoint();
		
		chunkEmitter = new FlxEmitter(0, 0, 8);
		chunkEmitter.x = center.x;
		chunkEmitter.y = center.y;
		
		for (i in 0...8) 
		{
			var particle:FlxParticle = new FlxParticle();
			particle.loadGraphic("assets/images/NiqabiChunks.png", true, 32, 42, false);
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

	override public function destroy():Void
	{
		instructionsScreen = null;
		movementControls = null;
		shootControls = null;
		rocketControls = null;
		specialControls = null;
		sprintControls = null;
		movementText = null;
		bullet = null;
		rocket = null;
		smokeEmitter = null;
		shootText = null;
		rocketText = null;
		specialText = null;
		sprintText = null;
		bankerText = null;
		pantherText = null;
		bimboText = null;
		niqabiText = null;
		laborerText = null;
		continueText = null;
		palinText = null;
		steakText = null;
		rocketLauncherText = null;
		pickups = null;
		entities = null;
		bullets = null;
		shards = null;
		banker = null;
		superPanther = null;
		bimbo = null;
		cleric = null;
		niqabi = null;
		palin = null;
		trumpSteak = null;
		rocketLauncher = null;
		bloodEmitter = null;
		chunkEmitter = null;
		laborer = null;
		if (delayTimer != null)
			delayTimer.destroy();
		if (shotTimer != null)
			shotTimer.destroy();
		
		super.destroy();
	}
}