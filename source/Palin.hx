package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.ui.FlxBar;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.system.FlxSound;

class Palin extends Entity
{
	private static var WANDER_SPEED:Float = 96;
	private static var WALK_SPEED:Float = 175;
	private static var RUN_SPEED:Float = 250;
	private static var guardDistance_x:Int = 150;
	private static var guardDistance_y:Int = 75;
	private var healthBar:FlxBar;
	private var wanderTimer:Float = 0;
	private var wanderThreshold:Float = 6;
	private var shotClock:Float = 0;
	private var shotInterval:Float = 0.2;
	private var okShoot:Bool;
	private var parentReference:Entity;
	private var ohMan:FlxSound;
	private var dogGoneIt:FlxSound;
	private var wooHaa:FlxSound;
	private var america:FlxSound;
	private var darnRight:FlxSound;
	private var bulletOffsets:Array<Int> = [ 53, 59, 57, 53, 48, 53, 61, 55, 52, 47 ];
	private var muzzleOffsets:Array<Int> = [ 48, 54, 52, 48, 43, 48, 56, 50, 47, 42 ];
	
	private var bulletOffset(get, never):Int;
	private function get_bulletOffset():Int
	{
		var frameOffset:Int;
		
		if (this.animation.curAnim != null && this.animation.curAnim.name != "idle")
			frameOffset = bulletOffsets[this.animation.curAnim.curFrame];
		else
			frameOffset = bulletOffsets[5];
			
		return frameOffset;
	}
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0, parentRef:Entity) 
	{
		super(X, Y, Z);
		
		parentReference = parentRef;
		
        loadGraphic("assets/images/Palin.png", true, 218, 152, false);
		animation.add("idle", [5], 1, true);
		animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 14, true);
		animation.add("run", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20, true);
		animation.add("wander", [15, 16, 17, 18, 19, 20, 21, 22, 23, 24], 14, true);
		animation.add("death", [10, 11, 12, 13, 14, 13, 14, 13, 14], 10, false);
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		velocity.x = 0;
		velocity.y = 0;
		
		ohMan = FlxG.sound.load("assets/sounds/PalinOhMan.wav", 1);
		dogGoneIt = FlxG.sound.load("assets/sounds/PalinDogGoneIt.wav", 1);
		wooHaa = FlxG.sound.load("assets/sounds/PalinWooHaa.wav", 1);
		america = FlxG.sound.load("assets/sounds/PalinAmerica.wav", 1);
		darnRight = FlxG.sound.load("assets/sounds/PalinDarnRight.wav", 1);
		
		healthBar = new FlxBar(0, 0, FlxBar.FILL_LEFT_TO_RIGHT, 30, 6, this, "health", 0, 15, false); 
		healthBar.createFilledBar(0xFF404040, 0xFF00FF00);
		
		if (Globals.palinAlwaysActive || Globals.palinActive)
		{
			changeState(Entity.State.FOLLOWING);
			facing = parentReference.facing;
		}
		else 
			changeState(Entity.State.WANDERING);
			
		if (facing == FlxObject.RIGHT)	
			healthBar.trackParent(100, -10);
		else 
			healthBar.trackParent(75, -10);
		
		target = null;
		
		if (Globals.palinActive)
			health = Globals.palinHealth;
		else
			health = 15;
	}
	
 	override public function changeState(newState:Entity.State):Void
	{
		if (newState == Entity.State.FOLLOWING)
		{
			target = null;
			animation.play("walk", true, -1);	
		}
		else if (newState == Entity.State.WANDERING)
		{
			if (FlxRandom.chanceRoll(50))
				velocity.x = WANDER_SPEED;
			else
				velocity.x = -WANDER_SPEED;	
				
			animation.play("wander");
		}
		else if (newState == Entity.State.IDLE)
			animation.play("idle");
		else if (newState == Entity.State.CHASING)
		{
			target = null;
			animation.play("run", true, -1);				
		}
		else if (newState == Entity.State.SHOOTING)
		{
			if (FlxRandom.chanceRoll(40) && !wooHaa.playing && !america.playing && !darnRight.playing)
			{
				var phraseChoice = FlxRandom.intRanged(1, 3);
				switch phraseChoice
				{
					case 1:
						wooHaa.play();
						
					case 2:
						america.play();
						
					case 3:
						darnRight.play();
				}
			}
				
			animation.play("idle");
		}
		else if (newState == Entity.State.DYING)
		{
			FlxG.sound.play("PalinDeath"); 
			animation.play("death");
			Globals.palinActive = false;
			Globals.globalGameState.objectToss(this, "Palin");
		}
		
		super.changeState(newState);
	}

    override public function update():Void
	{
		if (this.animation.curAnim != null && this.animation.curAnim.name != "idle")
			offset_y = y + muzzleOffsets[animation.curAnim.curFrame];
		else
			offset_y = y + muzzleOffsets[5];
		
		if (facing == FlxObject.RIGHT)
			offset_x = x + frameWidth;
		else
			offset_x = x - 22 + 3;
			
		shotClock += FlxG.elapsed;
		if (shotClock > shotInterval)
			okShoot = true;
			
		if (currentState == Entity.State.WANDERING)
		{
			wanderTimer += FlxG.elapsed;
			if (wanderTimer > wanderThreshold)
			{
				wanderTimer = 0;
				wanderThreshold = FlxRandom.floatRanged(4, 12);
				
				if (FlxRandom.chanceRoll(50))
					velocity.x = WANDER_SPEED;
				else
					velocity.x = -WANDER_SPEED;
				
				if (FlxRandom.chanceRoll(75))
					velocity.y = 0;
				else if (FlxRandom.chanceRoll(50))
					velocity.y = WANDER_SPEED;	
				else
					velocity.y = -WANDER_SPEED;
			}
			
			if (velocity.x > 0)
				facing = FlxObject.RIGHT;
			else if (velocity.x < 0)
				facing = FlxObject.LEFT;			
		}
		if (currentState == Entity.State.FOLLOWING)
		{
			animation.play("walk");	
			if (target != null && target.alive && target.isOnScreen())
				changeState(Entity.State.CHASING);
			else
				seekPlayer();
		}
		else if (currentState == Entity.State.SHOOTING)
		{
			if (target != null && target.alive && target.isOnScreen())
			{
				if (x > target.x)
					facing = FlxObject.LEFT;
				else if (x < target.x)
					facing = FlxObject.RIGHT;
			}
			else
			{
				if (facing == FlxObject.RIGHT)
					velocity.x = RUN_SPEED;
				else 
					velocity.x = -RUN_SPEED;			
			}
				
			if (okShoot)
				shoot();
				
			if (target != null && (!target.alive || !target.isOnScreen()))
			{
				target = null;
				changeState(Entity.State.FOLLOWING);
			}
		}
		else if (currentState == Entity.State.CHASING)
		{
			animation.play("walk");	
			
			if (target != null && target.alive && target.isOnScreen())
			{
				seekTarget();
			
				if (okShoot)
					shoot();
			}
			else 
				changeState(Entity.State.FOLLOWING);
		}
		else if (currentState == Entity.State.IDLE)
		{
			velocity.x = 0;
			velocity.y = 0;
			
			if (x > parentReference.x + guardDistance_x || x < parentReference.x - guardDistance_x ||
				z > parentReference.z + guardDistance_y || z < parentReference.z - guardDistance_y)
				changeState(Entity.State.FOLLOWING);
				
			if (target != null && target.alive && target.isOnScreen())
				changeState(Entity.State.CHASING);
		}
		else if (currentState == Entity.State.DYING)
		{
			if (ohMan.playing)
				ohMan.stop();
				
			if (dogGoneIt.playing)
				dogGoneIt.stop();
			
			if (animation.curAnim != null && animation.curAnim.curFrame >= 4)
			{
				velocity.x = 0;
				velocity.y = 0;
			}
			
			if (animation.finished)
				kill();
		}
		
		if (y + frameHeight <= Globals.horizonLimit ||
			y + frameHeight >= FlxG.camera.bounds.height)
			velocity.y = - velocity.y;
			
		if (x <= 0 || x + frameWidth >= FlxG.camera.bounds.width)
		{
			velocity.x = -velocity.x;
			if (facing == FlxObject.RIGHT)
				facing = FlxObject.LEFT;
			else
				facing = FlxObject.RIGHT;
		}
		
		z = y + frameHeight;

		if (health <= 10 && health > 5)
			healthBar.createFilledBar(0xFF404040, 0xFFFFFF00);
		else if (health <= 5)
			healthBar.createFilledBar(0xFF404040, 0xFFFF0000);
		
		if (facing == FlxObject.RIGHT)	
			healthBar.trackParent(100, -10);
		else 
			healthBar.trackParent(85, -10);			
			
		healthBar.update();
		super.update();
	}
	
	override public function draw():Void
	{
		if (currentState != Entity.State.WANDERING && currentState != Entity.State.DYING)
			healthBar.draw();	
			
		super.draw();
	}
	
	private function shoot():Void
	{
		Globals.globalGameState.displayList.add(new PlayerMuzzleFlash(offset_x, offset_y, z, this)); 
		var bullet = Globals.globalGameState.playerBullets.recycle();
		if (facing == FlxObject.RIGHT)
			bullet.reset(x + frameWidth + 24, y + bulletOffset);
		else 
			bullet.reset(x - bullet.frameWidth - 24, y + bulletOffset);
		bullet.y = y + bulletOffset;
		bullet.z = z;
		bullet.facing = facing;
		FlxG.sound.play("GunShot");
		okShoot = false;
		shotClock = 0;
	}
	
	private function seekPlayer():Void
	{
		if (x < parentReference.x - guardDistance_x)
			velocity.x = isOnScreen() ? WALK_SPEED : RUN_SPEED;
		else if (x > parentReference.x + guardDistance_x)
			velocity.x = isOnScreen() ? -WALK_SPEED : -RUN_SPEED;	
		else
			velocity.x = 0;
			
		if (z < parentReference.z - guardDistance_y)
			velocity.y = isOnScreen() ? WALK_SPEED : RUN_SPEED;
		else if (z > parentReference.z + guardDistance_y)
			velocity.y = isOnScreen() ? -WALK_SPEED : -RUN_SPEED;
		else 
			velocity.y = 0;
		
		if (velocity.x < 0)
			facing = FlxObject.LEFT;
		else if (velocity.x > 0)
			facing = FlxObject.RIGHT;	
			
		if (velocity.x == 0 && velocity.y == 0)
			changeState(Entity.State.IDLE);
	}
	
	private function seekTarget():Void
	{
		if (x < target.x - 250)
			velocity.x = isOnScreen() ? WALK_SPEED : RUN_SPEED;
		else if (x > target.x + 250)
			velocity.x = isOnScreen() ? -WALK_SPEED : -RUN_SPEED;	
		else
			velocity.x = 0;
			
		if (z < target.z - 20)
			velocity.y = isOnScreen() ? WALK_SPEED : RUN_SPEED;
		else if (z > target.z + 20)
			velocity.y = isOnScreen() ? -WALK_SPEED : -RUN_SPEED;	
		else 
			velocity.y = 0;
		
		if (velocity.x < 0)
			facing = FlxObject.LEFT;
		else if (velocity.x > 0)
			facing = FlxObject.RIGHT;	
			
		if (velocity.x == 0 && velocity.y == 0)
			changeState(Entity.State.SHOOTING);
	}
	
	override public function kill():Void
	{
		if (ohMan.playing)
			ohMan.stop();
			
		if (dogGoneIt.playing)
			dogGoneIt.stop();
			
		if (wooHaa.playing)
			wooHaa.stop();

		if (america.playing)
			america.stop();

		if (darnRight.playing)
			darnRight.stop();
				
		target = null;
		super.kill();
	}
	
	override public function hurt(damage:Float):Void
	{
		FlxG.sound.play("FleshHit");

		if (FlxRandom.chanceRoll(25))
		{
			if (FlxRandom.chanceRoll(50))
			{
				if (!ohMan.playing)
					ohMan.play();
			}
			else 
			{
				if (!dogGoneIt.playing)
					dogGoneIt.play();
			}
		}
		else
			FlxG.sound.play("PalinHit" + FlxRandom.intRanged(1, 2));
		
		if (!Globals.palinAlwaysActive)
		{
			health -= damage;
			Globals.palinHealth -= damage;
		}
			
		if (health <= 0)
			changeState(Entity.State.DYING);
		else
			Globals.globalGameState.displayList.add(new BloodSplatter(x + origin.x, y + origin.y, z + 1, this, BloodSplatter.SplatterType.SPLASH));
	}	
}