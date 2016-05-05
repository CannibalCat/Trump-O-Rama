package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.system.FlxSound;

class Bandito extends Entity
{
	private static var WALK_SPEED:Float = 96;
	private static var RUN_SPEED:Float = 128;
	private static var shootingRange:Int = 400;
	private static var panicRange:Int = 150;
	private static var shotInterval:Float = 0;
	private var firingPistol:Int;
	private var idleCounter:Float = 0;
	private var shotClock:Float = 0;
	private var wanderTimer:Float = 0;
	private var wanderThreshold:Float = 4;
	private var okShoot:Bool = false;
	private var randomShot:Bool = false;
	private var ayeChihuahua:FlxSound;
	private var bulletOffsets:Array<Array<Int>> = [[ 53, 59, 57, 53, 49, 53, 59, 57, 52, 48],	// Top Pistol
												   [ 70, 76, 74, 70, 66, 70, 76, 74, 69, 65]];	// Bottom Pistol
												   
	private var bulletOffset(get, never):Int;
	private function get_bulletOffset():Int
	{
		var frameOffset:Int;
		
		if (animation.curAnim != null && animation.curAnim.name != "idle")
			frameOffset = bulletOffsets[firingPistol][animation.curAnim.curFrame];
		else
			frameOffset = bulletOffsets[firingPistol][5];

		return frameOffset;
	}
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0, Direction:Int=FlxObject.RIGHT) 
	{
		super(X, Y, Z);
		
        loadGraphic("assets/images/Bandito.png", true, 136, 162, false);
		animation.add("idle", [15], 1, true);
		animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		animation.add("run", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20, true);
		animation.add("attack", [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 10, true);
		animation.add("death", [20, 21, 22, 23, 24, 25, 24, 25, 24, 25], 10, false);
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		velocity.x = 0;
		velocity.y = 0;
		
		currentState = Entity.State.IDLE;
		
		ayeChihuahua = FlxG.sound.load("assets/sounds/Laborer00.wav", 1);
		
		facing = Direction;
		scoreValue = 250;
		health = 3;
		firingPistol = 0;
	}
	
	override public function changeState(newState:Entity.State):Void
	{
		if (newState == Entity.State.EVADING)
		{
			ayeChihuahua.play();
			Globals.globalGameState.displayList.add(new Exclaimation((x + frameWidth / 2) - 26, y - 15, z, Exclaimation.Phrase.GENERAL, this));
			animation.play("run", true, -1);
		}
		else if (newState == Entity.State.WANDERING)
		{
			if (facing == FlxObject.RIGHT)
				velocity.x = WALK_SPEED;
			else
				velocity.x = -WALK_SPEED;	
				
			animation.play("walk", true, -1);		
		}
		else if (newState == Entity.State.SHOOTING)
			animation.play("attack");
		else if (newState == Entity.State.IDLE || newState == Entity.State.IDLE_SHOOTING)
			animation.play("idle");
		else if (newState == Entity.State.DYING)
		{
			if (ayeChihuahua.playing)
				ayeChihuahua.stop();
			FlxG.sound.play("Aye");
			animation.play("death");
			Globals.globalGameState.objectToss(this, "Bandito");
		}
	
		super.changeState(newState);
	}

    override public function update():Void
	{
		if (currentState == Entity.State.SHOOTING)
		{
			shotClock += FlxG.elapsed;
			if (shotClock > shotInterval)
			{
				shotClock = 0;
				okShoot = true;
			}
				
			if (facing == FlxObject.RIGHT)
				velocity.x = WALK_SPEED;
			else 
				velocity.x = -WALK_SPEED;
				
			if (target != null && FlxMath.distanceBetween(this, target) > 400)	
			{
				if (x < target.x)
					facing = FlxObject.RIGHT;
				else
					facing = FlxObject.LEFT;
			}
				
			if (FlxRandom.chanceRoll(20) && okShoot)
			{
				shoot();
				firingPistol++;
				if (firingPistol > 1)
					firingPistol = 0;
			}
		}
		else if (currentState == Entity.State.WANDERING)
		{
			shotClock += FlxG.elapsed;
			if (shotClock > shotInterval)
				randomShot = true;
				
			wanderTimer += FlxG.elapsed;
			if (wanderTimer > wanderThreshold)
			{
				wanderTimer = 0;
				wanderThreshold = FlxRandom.floatRanged(4, 12);
				
				if (facing == FlxObject.RIGHT)
					velocity.x = WALK_SPEED;
				else
					velocity.x = -WALK_SPEED;	
				
				if (FlxRandom.chanceRoll(75))
					velocity.y = 0;
				else if (FlxRandom.chanceRoll(50))
					velocity.y = WALK_SPEED;	
				else
					velocity.y = -WALK_SPEED;
			}
			
			if (target != null && randomShot)
			{
				if (FlxRandom.chanceRoll(1) && 
					FlxMath.distanceBetween(this, target) < shootingRange && 
					FlxMath.distanceBetween(this, target) > 200)
					changeState(Entity.State.IDLE_SHOOTING);
				
				randomShot = false;
				okShoot = true;
			}
			
			if (target != null && target.alive)
			{
				if (FlxRandom.chanceRoll(1) && FlxMath.distanceBetween(this, target) < panicRange)
					changeState(Entity.State.EVADING);
			}
			
			if (velocity.x > 0)
				facing = FlxObject.RIGHT;
			else if (velocity.x < 0)
				facing = FlxObject.LEFT;
		}
		else if (currentState == Entity.State.EVADING)
		{
			if (target == null)
				changeState(Entity.State.WANDERING);
			else
			{
				if (x > target.x)
					velocity.x = RUN_SPEED;
				else 
					velocity.x = -RUN_SPEED;

				if (z > target.z)
					velocity.y = RUN_SPEED;
				else
					velocity.y = -RUN_SPEED;
				
				if (velocity.x > 0)
					facing = FlxObject.RIGHT;
				else if (velocity.x < 0)
					facing = FlxObject.LEFT;
				
				if (FlxMath.distanceBetween(this, target) > panicRange * 2)
					changeState(Entity.State.WANDERING);
			}
		}
		else if (currentState == Entity.State.IDLE)
		{
			velocity.x = 0;
			velocity.y = 0;
		}
		else if (currentState == Entity.State.IDLE_SHOOTING)
		{
			shotClock += FlxG.elapsed;
			if (shotClock > 1)
				okShoot = true;
				
			if (okShoot)
			{
				shoot();
				firingPistol++;
				if (firingPistol > 1)
					firingPistol = 0;
			}
				
			velocity.x = 0;
			velocity.y = 0;
			
			idleCounter += FlxG.elapsed;
			if (idleCounter >= 2.5)
			{
				idleCounter = 0;
				changeState(Entity.State.WANDERING);
			}
			
			if (target != null)
			{
				if (x < target.x)
					facing = FlxObject.RIGHT;
				else
					facing = FlxObject.LEFT;
			}
		}
		else if (currentState == Entity.State.DYING)
		{
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
			
		if (x + frameWidth < 0 || x > FlxG.camera.bounds.width || 
			x < FlxG.camera.scroll.x - FlxG.width || x > FlxG.camera.scroll.x + (FlxG.width * 2))
		{
			Globals.globalGameState.waveData.currentBanditos--;
			super.kill();
		}
		
		z = y + frameHeight;
		
		super.update();
	}
	
	private function shoot():Void
	{
		var bullet = Globals.globalGameState.enemyBullets.recycle();
		
		if (facing == FlxObject.RIGHT)
		{
			if (firingPistol == 0)
			{
				Globals.globalGameState.displayList.add(new BanditoMuzzleFlash(x + frameWidth + 2, y, z, this, firingPistol)); 
				bullet.reset(x + frameWidth + 20, y + bulletOffset);
			}
			else
			{
				Globals.globalGameState.displayList.add(new BanditoMuzzleFlash((x + frameWidth) - 2, y, z, this, firingPistol)); 
				bullet.reset(((x + frameWidth) - 2) + 18, y + bulletOffset);
			}
		}
		else 
		{
			if (firingPistol == 0)
			{
				Globals.globalGameState.displayList.add(new BanditoMuzzleFlash((x - bullet.frameWidth) + 2, y, z, this, firingPistol)); 
				bullet.reset(((x - bullet.frameWidth) + 2) - 18, y + bulletOffset);
			}
			else
			{
				Globals.globalGameState.displayList.add(new BanditoMuzzleFlash(x - bullet.frameWidth - 2, y, z, this, firingPistol)); 
				bullet.reset(x - bullet.frameWidth - 20, y + bulletOffset);
			}
		}
		bullet.z = z;
		bullet.facing = facing;
		FlxG.sound.play("EnemyGunShot");
		okShoot = false;
		shotClock = 0;
		shotInterval = FlxRandom.floatRanged(1, 3);
	}
	
	override public function hurt(damage:Float):Void
	{
		FlxG.sound.play("FleshHit");
		
		health = health - damage;
		if (health <= 0)
			changeState(Entity.State.DYING);
	}
	
	override public function kill():Void
	{
		if (ayeChihuahua.playing)
			ayeChihuahua.stop();
		Globals.globalGameState.updateScore(scoreValue);
		Globals.globalGameState.updateApprovalRating(1);
		Globals.killsCount++;
		Globals.globalGameState.waveData.currentBanditos--;
		super.kill();
	}
}