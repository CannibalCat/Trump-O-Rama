package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxMath;
import flixel.util.FlxRandom;
import flixel.util.FlxPoint;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

class Cleric extends Entity
{
	private static var WALK_SPEED:Float = 72;
	private static var RUN_SPEED:Float = 165; 
	private static var conversionRange:Int = 50; 
	private var wanderTimer:Float = 0;
	private var wanderThreshold:Float = 6;
	private var tongueEmitter:FlxEmitter;
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0, Direction:Int=FlxObject.RIGHT) 
	{
		super(X, Y, Z);
		
        loadGraphic("assets/images/Cleric.png", true, 72, 158, false);
		animation.add("idle", [5], 1, true);
		animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		animation.add("run", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20, true);
		animation.add("headless", [11, 12, 13, 14, 15, 16, 17, 18, 19, 10], 20, true);
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		velocity.x = 0;
		velocity.y = 0;
		
		currentState = Entity.State.IDLE;
		
		target = null;
		facing = Direction;
		scoreValue = 0;
		health = 8;
	}
	
	public function tongueAttack(x:Float, y:Float, facing:Int):Void
	{
		tongueEmitter = new FlxEmitter(x, y, 25);
		
		if (facing == FlxObject.LEFT)
			tongueEmitter.setXSpeed(-50, -25);
		else
			tongueEmitter.setXSpeed(25, 50);
			
		tongueEmitter.setYSpeed( -25, 25);
		tongueEmitter.setRotation(0, 0);
		tongueEmitter.setAlpha(1, 1, 0, 0);
		tongueEmitter.gravity = 0;
		
		for (i in 0...25)
		{
			var tongue = new FlxParticle();
			tongue.loadGraphic("assets/images/ClericTongue.png", true, 14, 10, false);
			tongue.animation.add("default", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
			tongue.animation.play("default");
			tongue.setFacingFlip(FlxObject.LEFT, true, false); 
			tongue.setFacingFlip(FlxObject.RIGHT, false, false); 
			tongue.facing = facing;
			tongueEmitter.add(tongue);
			tongue.kill();
		}
		
		Globals.globalGameState.add(tongueEmitter);
		tongueEmitter.start(false, 1, 0.1, 25);
	}
	
 	override public function changeState(newState:Entity.State):Void
	{
		if (newState == Entity.State.CHASING)
		{
			if (FlxRandom.chanceRoll(30))
			{
				FlxG.sound.play("ClericAkbar");
				Globals.globalGameState.displayList.add(new Exclaimation((x + frameWidth / 2) - 30, y - 36, z, Exclaimation.Phrase.ALLAHU_AKBAR, this));
			}
				
			animation.play("run", true, -1);
		}
		else if (newState == Entity.State.ATTACKING)
		{
			if (facing == FlxObject.RIGHT)
				tongueAttack(x + 65, y + 70, FlxObject.RIGHT);
			else
				tongueAttack(x + 10, y + 70, FlxObject.LEFT);
				
			target.changeState(Entity.State.TRANSFORMING);
			
			animation.play("idle");
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
		else if (newState == Entity.State.RUNNING_AWAY) 
		{
			if (target != null)
				target.target = null;
				
			target = null;
			if (FlxRandom.chanceRoll(50))
				velocity.x = RUN_SPEED;
			else
				velocity.x = -RUN_SPEED;	
				
			height -= 68;
			offset.y = 68;
			y += offset.y;
			centerOrigin();
				
			animation.play("headless", true, -1);			
		}
		else if (newState == Entity.State.IDLE) 
			animation.play("idle");
	
		super.changeState(newState);
	}
	
    override public function update():Void
	{
		z = y + height;
		
		if (currentState == Entity.State.WANDERING)
		{
			wanderTimer += FlxG.elapsed;
			if (wanderTimer > wanderThreshold)
			{
				wanderTimer = 0;
				wanderThreshold = FlxRandom.floatRanged(4, 12);
				
				if (FlxRandom.chanceRoll(50))
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
				changeState(Entity.State.CHASING);
			
			if (velocity.x > 0)
				facing = FlxObject.RIGHT;
			else if (velocity.x < 0)
				facing = FlxObject.LEFT;
		}
		else if (currentState == Entity.State.CHASING)
		{
			if (x < target.x)
				velocity.x = RUN_SPEED;
			else if (x > target.x) 
				velocity.x = -RUN_SPEED;	
			else
				velocity.x = 0;
				
			if (z < target.z - 20)
				velocity.y = RUN_SPEED;
			else if (z > target.z + 20)
				velocity.y = -RUN_SPEED;
			else 
				velocity.y = 0;
				
			if (velocity.x > 0)
				facing = FlxObject.RIGHT;
			else if (velocity.x < 0)
				facing = FlxObject.LEFT;
			
			if (target != null && target.alive)
			{
				if (FlxMath.distanceBetween(this, target) < conversionRange)
					changeState(Entity.State.ATTACKING);
			}
			else 
				changeState(Entity.State.WANDERING);
				
			if (target != null && (target.currentState == Entity.State.COLLECTED || !target.alive))
				changeState(Entity.State.WANDERING);
		}
		else if (currentState == Entity.State.ATTACKING)
		{
			velocity.x = 0;
			velocity.y = 0;
			
			if (target == null || !target.alive)
				changeState(Entity.State.WANDERING);
		}
		else if (currentState == Entity.State.RUNNING_AWAY)
		{
			wanderTimer += FlxG.elapsed;
			if (wanderTimer > wanderThreshold)
			{
				wanderTimer = 0;
				wanderThreshold = FlxRandom.floatRanged(4, 12);
				
				if (FlxRandom.chanceRoll(50))
					velocity.x = RUN_SPEED;
				else
					velocity.x = -RUN_SPEED;
				
				if (FlxRandom.chanceRoll(75))
					velocity.y = 0;
				else if (FlxRandom.chanceRoll(50))
					velocity.y = RUN_SPEED;	
				else
					velocity.y = -RUN_SPEED;
			}
			
			if (velocity.x > 0)
				facing = FlxObject.RIGHT;
			else if (velocity.x < 0)
				facing = FlxObject.LEFT;	
		}
		else if (currentState == Entity.State.IDLE)
		{
			velocity.x = 0;
			velocity.y = 0;
			
			if (target != null)
			{
				if (x < target.x)
					facing = FlxObject.RIGHT;
				else if (x > target.x)
					facing = FlxObject.LEFT;
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
			Globals.globalGameState.waveData.currentClerics--;
			super.kill();
		}
		
		super.update();
	}
	
	override public function kill():Void
	{
		Globals.globalGameState.updateApprovalRating(1);
		Globals.killsCount++;
		Globals.globalGameState.waveData.currentClerics--;
		if (tongueEmitter != null)
			tongueEmitter.kill();
		target = null;
		super.kill();
	}
	
	override public function hurt(damage:Float):Void
	{
		super.hurt(damage);
		FlxG.sound.play("FleshHit");
	}
}