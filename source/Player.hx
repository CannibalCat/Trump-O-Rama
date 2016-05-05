package;
 
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxCamera;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.XboxButtonID;
import flixel.input.gamepad.LogitechButtonID;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;

class Player extends Entity
{
	public var whistleTimer:Float = 0;
	public var whistleRange:Int = 100;
	public var isInChopper:Bool = false;
	public var isSprintActive:Bool = false;
	
    private static var SPEED:Float = 175; 
	private static var RUN_SPEED:Float = 250;
	private var requireSprintTrigger:Bool = false;
	private var hitCounter:Int = 0;
	private var reviveTimer:Float = 0;
	private var remainingRumbleTime:Float = 0;
	private var bulletOffsets:Array<Int> = [ 55, 53, 49, 45, 49, 55, 53, 49, 45, 49 ];
	private var muzzleOffsets:Array<Int> = [ 50, 48, 44, 40, 44, 50, 48, 44, 40, 44 ];
	private var rocketOffsets:Array<Int> = [ 71, 69, 65, 61, 65, 71, 69, 65, 61, 65 ];
	
	private var gamepad(get, never):FlxGamepad;
	private function get_gamepad():FlxGamepad 
	{
		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
		
		if (gamepad == null)
			gamepad = FlxG.gamepads.getByID(0);
			
		return gamepad;
	}
	
	private var bulletOffset(get, never):Int;
	private function get_bulletOffset():Int
	{
		var frameOffset:Int;
		
		if (this.animation.curAnim != null && 
			this.animation.curAnim.name != "idle_1" &&
			this.animation.curAnim.name != "idle_2" &&
			this.animation.curAnim.name != "idle_3" &&
			this.animation.curAnim.name != "idle_4" &&
			this.animation.curAnim.name != "idle_5" &&
			this.animation.curAnim.name != "idle_rocket_1" &&
			this.animation.curAnim.name != "idle_rocket_2" &&
			this.animation.curAnim.name != "idle_rocket_3" &&
			this.animation.curAnim.name != "idle_rocket_4" &&
			this.animation.curAnim.name != "idle_rocket_5")
			frameOffset = bulletOffsets[this.animation.curAnim.curFrame];
		else
			frameOffset = bulletOffsets[4];
			
		return frameOffset;
	}
	
	private var rocketOffset(get, never):Int;
	private function get_rocketOffset():Int
	{
		var frameOffset:Int;
		
		if (this.animation.curAnim != null && 
			this.animation.curAnim.name != "idle_rocket_1" &&
			this.animation.curAnim.name != "idle_rocket_2" &&
			this.animation.curAnim.name != "idle_rocket_3" &&
			this.animation.curAnim.name != "idle_rocket_4" &&
			this.animation.curAnim.name != "idle_rocket_5")
			frameOffset = rocketOffsets[this.animation.curAnim.curFrame];
		else
			frameOffset = rocketOffsets[4];
			
		return frameOffset;
	}

    public function new(X:Float=0, Y:Float=0, Z:Float=0)
    {
        super(X, Y, Z);
		
 		loadGraphic("assets/images/Trump.png", true, 216, 144, false);
		animation.add("jump_5", [3], 1, true);
		animation.add("jump_4", [13], 1, true);
		animation.add("jump_3", [23], 1, true);
		animation.add("jump_2", [33], 1, true);
		animation.add("jump_1", [43], 1, true);
		animation.add("jump_rocket_5", [53], 1, true);
		animation.add("jump_rocket_4", [63], 1, true);
		animation.add("jump_rocket_3", [73], 1, true);
		animation.add("jump_rocket_2", [83], 1, true);
		animation.add("jump_rocket_1", [93], 1, true);
		animation.add("idle_5", [4], 1, true);
		animation.add("idle_4", [14], 1, true);
		animation.add("idle_3", [24], 1, true);
		animation.add("idle_2", [34], 1, true);
		animation.add("idle_1", [110, 111, 112, 113, 114, 115, 116, 117, 118, 119], 14, true);
		animation.add("idle_rocket_5", [54], 1, true);
		animation.add("idle_rocket_4", [64], 1, true);
		animation.add("idle_rocket_3", [74], 1, true);
		animation.add("idle_rocket_2", [84], 1, true);
		animation.add("idle_rocket_1", [120, 121, 122, 123, 124, 125, 126, 127, 128, 129], 14, true); 
		animation.add("walk_5", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 14, true);
		animation.add("walk_4", [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 14, true);
		animation.add("walk_3", [20, 21, 22, 23, 24, 25, 26, 27, 28, 29], 14, true);
		animation.add("walk_2", [30, 31, 32, 33, 34, 35, 36, 37, 38, 39], 14, true);
		animation.add("walk_1", [40, 41, 42, 43, 44, 45, 46, 47, 48, 49], 14, true);
		animation.add("walk_rocket_5", [50, 51, 52, 53, 54, 55, 56, 57, 58, 59], 14, true);
		animation.add("walk_rocket_4", [60, 61, 62, 63, 64, 65, 66, 67, 68, 69], 14, true);
		animation.add("walk_rocket_3", [70, 71, 72, 73, 74, 75, 76, 77, 78, 79], 14, true);
		animation.add("walk_rocket_2", [80, 81, 82, 83, 84, 85, 86, 87, 88, 89], 14, true);
		animation.add("walk_rocket_1", [90, 91, 92, 93, 94, 95, 96, 97, 98, 99], 14, true);
		animation.add("run_5", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20, true);
		animation.add("run_4", [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 20, true);
		animation.add("run_3", [20, 21, 22, 23, 24, 25, 26, 27, 28, 29], 20, true);
		animation.add("run_2", [30, 31, 32, 33, 34, 35, 36, 37, 38, 39], 20, true);
		animation.add("run_1", [40, 41, 42, 43, 44, 45, 46, 47, 48, 49], 20, true);
		animation.add("run_rocket_5", [50, 51, 52, 53, 54, 55, 56, 57, 58, 59], 20, true);
		animation.add("run_rocket_4", [60, 61, 62, 63, 64, 65, 66, 67, 68, 69], 20, true);
		animation.add("run_rocket_3", [70, 71, 72, 73, 74, 75, 76, 77, 78, 79], 20, true);
		animation.add("run_rocket_2", [80, 81, 82, 83, 84, 85, 86, 87, 88, 89], 20, true);
		animation.add("run_rocket_1", [90, 91, 92, 93, 94, 95, 96, 97, 98, 99], 20, true);
		animation.add("death", [100, 101, 102, 103, 104, 105, 104, 105, 104, 105], 10, false);
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		FlxSpriteUtil.flicker(this, 2, Globals.playerFlickerRate, true); 
		
		changeState(Entity.State.IDLE);
		
		// Shrink bounding box and recenter
		width = 100;
		height = 144;
		centerOffsets(true);
		centerOrigin();
		
		health = Globals.playerHealth;
    }
	
	override public function reset(x:Float, y:Float):Void
	{
		FlxSpriteUtil.flicker(this, 2, Globals.playerFlickerRate, true);
		health = 5;	
		z = y + frameHeight;
		changeState(Entity.State.IDLE);
		reviveTimer = 0;
		
		for (i in 0...5)
		{
			Globals.globalGameState.healthBar[i].color = 0x00FF00;
			Globals.globalGameState.healthBar[i].revive();
		}
		
		isSprintActive = false;
		Globals.playerStaminaLevel = 100;
		Globals.playerHealth = 5;
		
		super.reset(x, y); 
	}
	
	override public function changeState(newState:Entity.State):Void
	{
		if (newState == Entity.State.DYING)
		{
			FlxG.sound.play("PlayerDie");
			Globals.playerLives--;	
			animation.play("death");
			alive = false;
			isSprintActive = false;
			Globals.playerStaminaLevel = 0;
			Globals.globalGameState.objectToss(this, "Player");
		}
		else if (newState == Entity.State.IN_CHOPPER)
		{
			if (Globals.globalGameState.palin != null && Globals.globalGameState.palin.alive && 
				 Globals.globalGameState.palin.isOnScreen() && Globals.globalGameState.palin.currentState != Entity.State.WANDERING)
				FlxG.sound.play("TrumpSorry");
				
			isInChopper = true;
		}
		
		super.changeState(newState);
	}
	
    override public function update():Void
    {
        velocity.x = 0;
        velocity.y = 0;

		if (currentState != Entity.State.DYING)
		{
			if (animation.curAnim != null && 
				animation.curAnim.name != "idle_1" &&
				animation.curAnim.name != "idle_2" &&
				animation.curAnim.name != "idle_3" &&
				animation.curAnim.name != "idle_4" &&
				animation.curAnim.name != "idle_5" &&
				animation.curAnim.name != "idle_rocket_1" &&
				animation.curAnim.name != "idle_rocket_2" &&
				animation.curAnim.name != "idle_rocket_3" &&
				animation.curAnim.name != "idle_rocket_4" &&
				animation.curAnim.name != "idle_rocket_5")
				offset_y = y + muzzleOffsets[animation.curAnim.curFrame];
			else 
				offset_y = y + muzzleOffsets[4];
				
			if (facing == FlxObject.RIGHT)
				offset_x = (x - offset.x) + frameWidth + 2;
			else
				offset_x = x - offset.x - 22; 
		}
		
		// Pause game toggle
		if ((FlxG.keys.justPressed.P || gamepad.justPressed(7) || gamepad.justPressed(LogitechButtonID.TEN)) && 
			!Globals.globalGameState.gameOver)
		{
			Globals.pauseGame = !Globals.pauseGame;
			Globals.globalGameState.pauseText.setPosition((FlxG.width / 2) - (Globals.globalGameState.pauseText.width / 2), FlxG.height / 2  - 60);
			Globals.globalGameState.pauseText.visible = Globals.pauseGame;
			if (Globals.pauseGame)
			{
				FlxG.sound.pause();
				if (Globals.globalGameState.stampedeRumble.playing)
					Globals.globalGameState.stampedeRumble.stop();
			}
			else
				FlxG.sound.resume();
		}
		
		if (isInChopper && !Globals.pauseGame)
		{
			super.update();
			return;
		}
			
		if (Globals.pauseGame)
			return;
			
		if (currentState != Entity.State.DYING)
		{
			if (whistleTimer > 0)
				whistleTimer -= FlxG.elapsed;
			
			// Player movement
			if (FlxG.keys.pressed.LEFT || gamepad.getAxis(XboxButtonID.LEFT_ANALOGUE_X) < 0 || gamepad.dpadLeft)
				moveLeft();
			else if (FlxG.keys.pressed.RIGHT || gamepad.getAxis(XboxButtonID.LEFT_ANALOGUE_X) > 0 || gamepad.dpadRight)
				moveRight();
				
			if (FlxG.keys.pressed.UP || gamepad.getAxis(XboxButtonID.LEFT_ANALOGUE_Y) < 0 || gamepad.dpadUp)
				moveUp();
			else if (FlxG.keys.pressed.DOWN || gamepad.getAxis(XboxButtonID.LEFT_ANALOGUE_Y) > 0 || gamepad.dpadDown)
				moveDown();
				
			// Player sprint/run
			var sprintTrigger:Bool = false;
			if (requireSprintTrigger && (FlxG.keys.justPressed.SHIFT || gamepad.justPressed(3)))
			{
				sprintTrigger = true;
				requireSprintTrigger = false;
			}
			else if (!requireSprintTrigger && (FlxG.keys.pressed.SHIFT || gamepad.pressed(3)))
				sprintTrigger = true;
				
			if (sprintTrigger && Globals.playerStaminaLevel > 0 && (velocity.x != 0 || velocity.y != 0))
				isSprintActive = true;
				
			if (FlxG.keys.justReleased.SHIFT || gamepad.justReleased(3) || (velocity.x == 0 && velocity.y == 0))
				isSprintActive = false;
				
			if ((FlxG.keys.pressed.SHIFT || gamepad.pressed(3)) && Globals.playerStaminaLevel == 0)
			{
				isSprintActive = false;
				requireSprintTrigger = true;
			}

			// Player shoot rifle
			if (FlxG.keys.justPressed.Z || gamepad.justPressed(0))
			{
				if (facing == FlxObject.LEFT)
					shootLeft();
				else
					shootRight();
			}
			
			// Player shoot rocket
			if (FlxG.keys.justPressed.X || gamepad.justPressed(1))
			{
				if (Globals.playerRockets > 0)
				{
					if (facing == FlxObject.LEFT)
						shootRocketLeft();
					else
						shootRocketRight(); 
					
					if (!Globals.unlimitedRockets)
					{
						Globals.playerRockets--;
						if (Globals.playerRockets == 0)
							Globals.globalGameState.objectToss(this, "Player");
					}
				}
				else
					FlxG.sound.play("Error");
			}
			
			// Player "Special" attack
			if (FlxG.keys.justPressed.C || gamepad.justPressed(2))
			{
				if (Globals.playerApprovalRating == 100)
					Globals.globalGameState.specialAttack();
				else 
					FlxG.sound.play("Error");
			}
			
			if (velocity.x == 0 && velocity.y == 0) 
			{
				if (Globals.playerRockets > 0)
					animation.play("idle_rocket_" + Std.int(health));
				else
					animation.play("idle_" + Std.int(health));
			}
			else
			{
				if (Globals.playerRockets > 0)
				{
					if (!isSprintActive)
						animation.play("walk_rocket_" + Std.int(health));
					else 
						animation.play("run_rocket_" + Std.int(health));
				}
				else
				{
					if (!isSprintActive)
						animation.play("walk_" + Std.int(health));
					else
						animation.play("run_" + Std.int(health));
				}
			}
		}
		else
		{
			if (Globals.playerLives > 0)
			{
				reviveTimer += FlxG.elapsed;
				if (reviveTimer > 2)
					reset(x, y);
			}
		}
		
        super.update();
		
		z = y + frameHeight;
    }
	
    private function shootRight():Void
	{
		Globals.globalGameState.displayList.add(new PlayerMuzzleFlash(offset_x, offset_y, z, this)); 
		var bullet = Globals.globalGameState.playerBullets.recycle();
		bullet.x = (x - offset.x) + frameWidth + 24;
		bullet.y = y + bulletOffset;
		bullet.z = z;
		bullet.facing = FlxObject.RIGHT;
		FlxG.sound.play("GunShot");
    }
	
	private function shootLeft():Void
	{
		Globals.globalGameState.displayList.add(new PlayerMuzzleFlash(offset_x, offset_y, z, this)); 
		var bullet = Globals.globalGameState.playerBullets.recycle();
		bullet.x = x - offset.x - bullet.frameWidth - 22;
		bullet.y = y + bulletOffset;
		bullet.z = z;
		bullet.facing = FlxObject.LEFT;
		FlxG.sound.play("GunShot");
    }
	
	private function shootRocketRight():Void
	{
		var rocket = Globals.globalGameState.playerRockets.recycle();
		rocket.x = (x - offset.x) + frameWidth - 35; 
		rocket.y = y + rocketOffset; 
		rocket.z = z;
		rocket.facing = FlxObject.RIGHT;
		FlxG.sound.play("RocketLaunch");
    }
	
	private function shootRocketLeft():Void
	{
		var rocket = Globals.globalGameState.playerRockets.recycle();
		rocket.x = (x - offset.x - rocket.frameWidth) + 35;
		rocket.y = y + rocketOffset;
		rocket.z = z;
		rocket.facing = FlxObject.LEFT;
		FlxG.sound.play("RocketLaunch");
    }
	
    private function moveRight():Void
	{
		if (x + width >= FlxG.camera.bounds.width)
			velocity.x = 0;
		else
		{
			if (!isSprintActive)
				velocity.x += SPEED;
			else 
				velocity.x += RUN_SPEED;
		}
			
		facing = FlxObject.RIGHT;
    }
 
    private function moveLeft():Void
	{
		if (x <= 0)
			velocity.x = 0;
		else
		{
			if (!isSprintActive)
				velocity.x -= SPEED;
			else 
				velocity.x -= RUN_SPEED;
		}
			
		facing = FlxObject.LEFT;
    }
 
    private function moveUp():Void
	{
		if (y + frameHeight <= Globals.horizonLimit)
			velocity.y = 0;
		else
		{
			if (!isSprintActive)
				velocity.y -= SPEED;
			else 
				velocity.y -= RUN_SPEED;
		}
    }
 
    private function moveDown():Void
	{
		if (y + frameHeight >= FlxG.camera.bounds.height)
			velocity.y = 0;
		else
		{
			if (!isSprintActive)
				velocity.y += SPEED;
			else
				velocity.y += RUN_SPEED;
		}
    }
	
	override public function hurt(damage:Float):Void
	{
		FlxG.sound.play("FleshHit");
		
		if (!Globals.playerGodMode)
		{
			if (Globals.currentWave != 25)
			{
				health -= damage;
				Globals.playerHealth -= damage;
			}
			else
			{
				hitCounter++;
				if (hitCounter == 20)
				{
					Globals.globalGameState.healthBar[Std.int(health - 1)].kill();
					hitCounter = 0;
					health -= damage;
					Globals.playerHealth -= damage;		
				}
			}
		}
			
		if (health <= 0)
			changeState(Entity.State.DYING);
		else
		{
			Globals.globalGameState.displayList.add(new BloodSplatter(x + offset.x, y + origin.y, z + 1, this, BloodSplatter.SplatterType.SPLASH));
			FlxG.sound.play("PlayerHit" + FlxRandom.intRanged(1, 2));			
		}
	}	
	
	public function whistle():Void
	{
		FlxG.sound.play("Whistle");	
		Globals.globalGameState.displayList.add(new Hearts(x + offset.x, y, z, this));
		whistleTimer = 4;
	}
}