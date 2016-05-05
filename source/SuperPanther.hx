package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;

class SuperPanther extends Entity
{
	private static var WALK_SPEED:Float = 64;
	private static var PURSUIT_SPEED:Float = 128;
	private static var RUN_SPEED:Float = 150;
	private static var maxEvadeRange:Int = 300;
	private static var timeToKill:Float = 4;
	private var wanderTimer:Float = 0;
	private var wanderThreshold:Float = 6;
	private var shotClock:Float = 0;
	private var shotInterval:Float = 0;
	private var elapsedPursuitTime:Float = 0;
	private var idleCounter:Float = 0;
	private var okShoot:Bool;
	private var bulletOffsets:Array<Int> = [ 61, 67, 65, 61, 57, 61, 67, 65, 61, 57 ];
	private var muzzleOffsets:Array<Int> = [ 57, 63, 61, 57, 53, 57, 63, 61, 57, 53 ];
	
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
		
        loadGraphic("assets/images/SuperPanther.png", true, 152, 144, false);
		animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		animation.add("run", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20, true);
		animation.add("attack", [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 20, true);
		animation.add("idle", [20, 21, 22, 23, 24], 10, true);
		animation.add("death", [25, 26, 27, 28, 29, 28, 29, 28, 29], 10, false);
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		velocity.x = 0;
		velocity.y = 0;
		
		currentState = Entity.State.IDLE;
		
		target = null;
		facing = Direction;
		scoreValue = 500;
		health = 3;
	}
	
 	override public function changeState(newState:Entity.State):Void
	{
		if (newState == Entity.State.CHASING)
		{
			FlxG.sound.play("MilitantYell");
			animation.play("run", true, -1);
		}
		else if (newState == Entity.State.PURSUING)
		{
			if (facing == FlxObject.RIGHT)
				velocity.x = PURSUIT_SPEED;
			else
				velocity.x = -PURSUIT_SPEED;	
				
			target.changeState(Entity.State.EVADING);
			elapsedPursuitTime = 0;
			animation.play("attack", true, -1);
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
		else if (newState == Entity.State.EVADING)
			animation.play("run", true, -1);
		else if (newState == Entity.State.DYING)
		{
			target = null;
			FlxG.sound.play("Arrgghh");
			animation.play("death");
			Globals.globalGameState.objectToss(this, "SuperPanther");
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
			offset_x = x + frameWidth - 3;
		else
			offset_x = x - 18 + 3;
			
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
			
			if (target != null && target.alive)
			{
				var targetDistance = FlxMath.distanceBetween(this, target);
				if (targetDistance <= 300) 
					changeState(Entity.State.EVADING);
				else
					changeState(Entity.State.CHASING);
			}
			
			if (velocity.x > 0)
				facing = FlxObject.RIGHT;
			else if (velocity.x < 0)
				facing = FlxObject.LEFT;
		}
		else if (currentState == Entity.State.CHASING)
		{
			if (target != null && target.alive)
			{
				seekTarget();
				var targetDistance = FlxMath.distanceBetween(this, target);
				if (targetDistance <= 150)
					changeState(Entity.State.PURSUING);
			}
			else
			{
				if (facing == FlxObject.RIGHT)
					velocity.x = RUN_SPEED;
				else 
					velocity.x = -RUN_SPEED;			
			}
			
			if (target != null && (target.currentState == Entity.State.COLLECTED || !target.alive))
			{
				target = null;
				changeState(Entity.State.WANDERING);
			}
		}
		else if (currentState == Entity.State.PURSUING)
		{
			velocity.y = 0;
			
			elapsedPursuitTime += FlxG.elapsed;
			shotClock += FlxG.elapsed;
			if (shotClock > shotInterval && elapsedPursuitTime > timeToKill)
				okShoot = true;
				
			if (FlxRandom.chanceRoll(30) && okShoot)
				shoot();
			
			if (target != null && (target.currentState == Entity.State.COLLECTED || !target.alive))
			{
				target = null;
				changeState(Entity.State.WANDERING);
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
				if (FlxMath.distanceBetween(this, target) > maxEvadeRange)
					changeState(Entity.State.CHASING);
			}
		}
		else if (currentState == Entity.State.DYING)
		{
			if (animation.curAnim != null && animation.curAnim.curFrame >= 3)
			{
				velocity.x = 0;
				velocity.y = 0;
			}
			
			if (animation.finished)
				kill();
		}
			
		if (z <= Globals.horizonLimit) 
		{
			if (currentState == Entity.State.CHASING || currentState == Entity.State.EVADING)
				velocity.y = RUN_SPEED;
			else if (currentState == Entity.State.PURSUING)
				velocity.y = PURSUIT_SPEED;
			else
				velocity.y = WALK_SPEED;
		}
		else if (z >= FlxG.camera.bounds.height)
		{
			if (currentState == Entity.State.CHASING || currentState == Entity.State.EVADING)
				velocity.y = -RUN_SPEED;
			else if (currentState == Entity.State.PURSUING)
				velocity.y = -PURSUIT_SPEED;
			else
				velocity.y = -WALK_SPEED;			
		}
			
		if (x + frameWidth < 0 || x > FlxG.camera.bounds.width || 
			x < FlxG.camera.scroll.x - FlxG.width || x > FlxG.camera.scroll.x + (FlxG.width * 2))
		{
			Globals.globalGameState.waveData.currentSuperPanthers--;
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
			bullet.reset(x + frameWidth + 2, y + bulletOffset);
		else 
			bullet.reset(x - bullet.frameWidth - 2, y + bulletOffset);
		bullet.z = z;
		bullet.facing = facing;
		FlxG.sound.play("EnemyGunShot");
		okShoot = false;
		shotClock = 0;
		shotInterval = FlxRandom.floatRanged(1, 3);
	}
	
	private function seekTarget():Void
	{
		if (x + frameWidth < target.x)
			velocity.x = RUN_SPEED;
		else if (x > target.x + target.frameWidth)
			velocity.x = -RUN_SPEED;		
			
		if (z < target.z - 5) 
			velocity.y = RUN_SPEED;
		else if (z > target.z + 5) 
			velocity.y = -RUN_SPEED;
		else 
			velocity.y = 0;
		
		if (velocity.x < 0)
			facing = FlxObject.LEFT;
		else if (velocity.x > 0)
			facing = FlxObject.RIGHT;	
	}
	
	override public function kill():Void
	{
		Globals.globalGameState.updateScore(scoreValue);
		Globals.globalGameState.updateApprovalRating(1);
		Globals.killsCount++;
		Globals.globalGameState.waveData.currentSuperPanthers--;
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

