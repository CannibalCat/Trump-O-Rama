package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;

class IMFGoon extends Entity
{
	private static var WALK_SPEED:Float = 64;
	private static var RUN_SPEED:Float = 128;
	private static var panicRange:Int = 100;
	private static var safeRange:Int = 500;
	private var wanderTimer:Float = 0;
	private var wanderThreshold:Float = 6;
	private var targetFocus:FlxPoint;
	private var shotClock:Float = 0;
	private var shotInterval:Float = 0;
	private var idleCounter:Float = 0;
	private var okShoot:Bool;
	private var bulletOffsets:Array<Int> = [ 37, 41, 42, 38, 34, 38, 44, 42, 38, 33 ];
	private var muzzleOffsets:Array<Int> = [ 33, 37, 38, 34, 30, 34, 40, 38, 34, 29 ];
	
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
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0, Direction:Int=FlxObject.RIGHT) 
	{
		super(X, Y, Z);
		
        loadGraphic("assets/images/IMFGoon.png", true, 114, 130, false);
		animation.add("idle", [5], 1, true);
		animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		animation.add("run", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20, true);
		animation.add("run_over", [16, 16, 16, 16, 17, 18, 17, 18, 17, 18], 10, false);
		animation.add("death", [10, 11, 12, 13, 14, 15, 14, 15, 14, 15], 10, false);
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		velocity.x = 0;
		velocity.y = 0;
		
		currentState = Entity.State.IDLE;
		
		facing = Direction;
		targetFocus = new FlxPoint(0, 0);
		scoreValue = 250;
		health = 3;
	}

    override public function update():Void
	{
		if (this.animation.curAnim != null && this.animation.curAnim.name != "idle")
			offset_y = y + muzzleOffsets[animation.curAnim.curFrame];
		else
			offset_y = y + muzzleOffsets[5];
		
		if (facing == FlxObject.RIGHT)
			offset_x = x + frameWidth + 1;
		else
			offset_x = x - 19;
			
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
			
			if (velocity.x > 0)
				facing = FlxObject.RIGHT;
			else if (velocity.x < 0)
				facing = FlxObject.LEFT;
		} 
		else if (currentState == Entity.State.SHOOTING)
		{
			if (target != null && target.alive)
			{
				seekTarget();
				if (FlxMath.distanceBetween(this, target) > safeRange)
					changeState(Entity.State.CHASING);				
			}
			else
			{
				if (facing == FlxObject.RIGHT)
					velocity.x = WALK_SPEED;
				else 
					velocity.x = -WALK_SPEED;			
			}
				
			if (FlxRandom.chanceRoll(25) && okShoot)
				shoot();
		}
		else if (currentState == Entity.State.CHASING)
		{
			if (target != null && target.alive)
			{
				seekTarget();
				if (FlxMath.distanceBetween(this, target) < safeRange)
					changeState(Entity.State.SHOOTING);
			}
			else
			{
				if (facing == FlxObject.RIGHT)
					velocity.x = RUN_SPEED;
				else 
					velocity.x = -RUN_SPEED;			
			}
		}
		else if (currentState == Entity.State.EVADING)
		{
			if (facing == FlxObject.RIGHT)
				velocity.x = RUN_SPEED;
			else 
				velocity.x = -RUN_SPEED;	

			if (target != null && target.alive)
			{
				if (FlxMath.distanceBetween(this, target) > safeRange)
					changeState(Entity.State.SHOOTING);
			}
		}
		else if (currentState == Entity.State.IDLE)
		{
			idleCounter += FlxG.elapsed;
			if (idleCounter >= 2)
			{
				idleCounter = 0;
				changeState(Entity.State.EVADING);
			}
			
			if (FlxRandom.chanceRoll(25) && okShoot)
				shoot();
			
			if (target != null)
			{
				if (FlxMath.distanceBetween(this, target) < panicRange)
					changeState(Entity.State.EVADING);
				else if (FlxMath.distanceBetween(this, target) > safeRange / 2)
					changeState(Entity.State.SHOOTING);
			}
			
			velocity.x = 0;
			velocity.y = 0;
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
		else if (currentState == Entity.State.RUN_OVER)
		{
			if (animation.curAnim != null && animation.curAnim.curFrame >= 4)
			{
				velocity.x = 0;
				velocity.y = 0;
			}
			
			if (animation.finished)
			{
				Globals.globalGameState.waveData.currentIMFGoons--;
				super.kill();
			}
		}
		
		if (z <= Globals.horizonLimit) 
		{
			if (currentState == Entity.State.CHASING)
				velocity.y = RUN_SPEED;
			else
				velocity.y = WALK_SPEED;
		}
		else if (z >= FlxG.camera.bounds.height)
		{
			if (currentState == Entity.State.CHASING)
				velocity.y = -RUN_SPEED;
			else
				velocity.y = -WALK_SPEED;			
		}
			
		if (x + frameWidth < 0 || x > FlxG.camera.bounds.width || 
			x < FlxG.camera.scroll.x - FlxG.width || x > FlxG.camera.scroll.x + (FlxG.width * 2))
		{
			Globals.globalGameState.waveData.currentIMFGoons--;
			super.kill();
		}
		
		z = y + frameHeight;
		
		super.update();
	}
	
	private function shoot():Void
	{
		Globals.globalGameState.displayList.add(new MuzzleFlash(offset_x, offset_y, z, this)); 
		var bullet = Globals.globalGameState.enemyBullets.recycle();
		if (facing == FlxObject.RIGHT)
			bullet.reset(x + frameWidth + 19, y + bulletOffset);
		else 
			bullet.reset(x - 57, y + bulletOffset);
		bullet.z = z;
		bullet.facing = facing;
		FlxG.sound.play("UziBurst");
		okShoot = false;
		shotClock = 0;
		shotInterval = FlxRandom.floatRanged(1, 3);
	}
	
	override public function changeState(newState:Entity.State):Void
	{
		if (newState == Entity.State.SHOOTING) 
		{
			targetFocus = getTargetFocusPoint();
			animation.play("run");
		}
		else if (newState == Entity.State.IDLE)
			animation.play("idle");
		else if (newState == Entity.State.EVADING || newState == Entity.State.CHASING)
			animation.play("run", true, 4);
		else if (newState == Entity.State.DYING)
		{
			FlxG.sound.play("GoonDie" + FlxRandom.intRanged(1, 5));
			animation.play("death");
			Globals.globalGameState.objectToss(this, "IMFGoon");
		}
		else if (newState == Entity.State.RUN_OVER)
		{
			FlxG.sound.play("GoonDie" + FlxRandom.intRanged(1, 5));
			animation.play("run_over");
			Globals.globalGameState.objectToss(this, "IMFGoon");
		}
		else if (newState == Entity.State.WANDERING)
		{
			target = null;
			
			if (facing == FlxObject.RIGHT)
				velocity.x = WALK_SPEED;
			else
				velocity.x = -WALK_SPEED;	
			
			animation.play("walk", true, -1);
		}
	
		super.changeState(newState);
	}
	
	private function getTargetFocusPoint():FlxPoint
	{
		var focusPoint:FlxPoint = new FlxPoint();
		
		focusPoint.x = FlxRandom.intRanged(-25, 25);
		focusPoint.y = FlxRandom.intRanged(-10, 10);
		
		return focusPoint;
	}
	
	private function seekTarget():Void
	{
		if (x < target.x - 250 + targetFocus.x)
			velocity.x = RUN_SPEED;
		else if (x > target.x + 250 + targetFocus.x)
			velocity.x = -RUN_SPEED;		
		else
			velocity.x = 0;
			
		if (z < target.z - 20 + targetFocus.y)
			velocity.y = RUN_SPEED;
		else if (z > target.z + 20 + targetFocus.y)
			velocity.y = -RUN_SPEED;
		else 
			velocity.y = 0;
		
		if (velocity.x < 0)
			facing = FlxObject.LEFT;
		else if (velocity.x > 0)
			facing = FlxObject.RIGHT;	
			
		if (velocity.x == 0 && velocity.y == 0)
			changeState(Entity.State.IDLE);
	}
	
	override public function kill():Void
	{
		Globals.globalGameState.updateScore(scoreValue);
		Globals.killsCount++;
		Globals.globalGameState.waveData.currentIMFGoons--;
		super.kill();
	}
	
	override public function hurt(damage:Float):Void
	{
		FlxG.sound.play("FleshHit");
		
		health = health - damage;
		if (health <= 0)
			changeState(Entity.State.DYING);
	}	
}
