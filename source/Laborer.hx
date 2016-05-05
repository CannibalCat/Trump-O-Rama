package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxVelocity;
import flixel.system.FlxSound;

class Laborer extends Entity
{
	private static var WALK_SPEED:Float = 64;
	private static var RUN_SPEED:Float = 125;
	private var panicRange:Int = 200;
	private var wanderTimer:Float = 0;
	private var wanderThreshold:Float = 6;
	private var noMeGusta:FlxSound;
	private var ayeYaYey:FlxSound;
	private var noEsBueno:FlxSound;
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0, Direction:Int=FlxObject.RIGHT) 
	{
		super(X, Y, Z);
		
        loadGraphic("assets/images/Laborer.png", true, 64, 106, false);
		animation.add("idle", [9], 1, true);
		animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		animation.add("run", [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 20, true);
		animation.add("death", [22, 23, 24, 25, 26, 25, 26, 25, 26], 10, false);
		animation.add("captured", [20, 21], 16, true);
		
		noMeGusta = FlxG.sound.load("assets/sounds/NoMeGusta.wav", 1);
		ayeYaYey = FlxG.sound.load("assets/sounds/AyeYaYey.wav", 1);
		noEsBueno = FlxG.sound.load("assets/sounds/NoEsBueno.wav", 1);
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		velocity.x = 0;
		velocity.y = 0;
		
		currentState = Entity.State.IDLE;
		
		facing = Direction;
		scoreValue = 100;
		health = 2;
	}
	
	override public function changeState(newState:Entity.State):Void
	{
		if (newState == Entity.State.EVADING)
		{
			if (FlxRandom.chanceRoll(60))
			{
				if (FlxRandom.chanceRoll(80))
					ayeYaYey.play();
				else 
					noMeGusta.play();

				Globals.globalGameState.displayList.add(new Exclaimation((x + frameWidth / 2) - 26, y - 36, z, Exclaimation.Phrase.GENERAL, this));
			}
			
			animation.play("run", true, -1);
		}
		else if (newState == Entity.State.RUNNING_AWAY)
		{
			if (FlxRandom.chanceRoll(50))
			{
				noEsBueno.play();
				Globals.globalGameState.displayList.add(new Exclaimation((x + frameWidth / 2) - 26, y - 36, z, Exclaimation.Phrase.GENERAL, this));
			}
			animation.play("run", true, -1);
		}
		else if (newState == Entity.State.WANDERING)
		{
			if (FlxRandom.chanceRoll(50))
				velocity.x = WALK_SPEED;
			else
				velocity.x = -WALK_SPEED;	
				
			animation.play("walk", true, -1);
		}
		else if (newState == Entity.State.IDLE)
			animation.play("idle");
		else if (newState == Entity.State.DYING)
		{
			if (noMeGusta.playing)
				noMeGusta.stop();
				
			if (ayeYaYey.playing)
				ayeYaYey.stop();
				
			if (noEsBueno.playing)
				noEsBueno.stop();
				
			FlxG.sound.play("MaleDie");
			animation.play("death");
		}
	
		super.changeState(newState);
	}
	
    override public function update():Void
	{
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
			
			if (velocity.x > 0)
				facing = FlxObject.RIGHT;
			else if (velocity.x < 0)
				facing = FlxObject.LEFT;
			
			if (target != null && target.alive)
			{
				if (FlxMath.distanceBetween(this, target) < panicRange)
					changeState(Entity.State.EVADING);
			}
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
		else if (currentState == Entity.State.RUNNING_AWAY)
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
					
				if (FlxMath.distanceBetween(this, target) > panicRange * 4)
					changeState(Entity.State.WANDERING);
			}			
		}
		else if (currentState == Entity.State.IDLE)
		{
			velocity.x = 0;
			velocity.y = 0;
		}
		else if (currentState == Entity.State.COLLECTED)
		{
			facing = FlxObject.RIGHT;
			
			animation.play("captured");
			FlxVelocity.moveTowardsPoint(this, new FlxPoint(FlxG.camera.scroll.x + 950, 0), 1000);
					
			if (y <= 0)
			{
				kill();
				Globals.capturedLaborCount++;
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
		
		if (currentState != Entity.State.COLLECTED)
		{
			if (y + frameHeight <= Globals.horizonLimit || y + frameHeight >= FlxG.camera.bounds.height)
				velocity.y = - velocity.y;

			if (x + frameWidth < 0 || x > FlxG.camera.bounds.width)
				super.kill();
		}
		
		z = y + frameHeight;

		super.update();
	}
	
	override public function kill():Void
	{
		if (noMeGusta.playing)
			noMeGusta.stop();
			
		if (ayeYaYey.playing)
			ayeYaYey.stop();
			
		if (noEsBueno.playing)
			noEsBueno.stop();
			
		if (currentState == Entity.State.DYING)
		{
			Globals.globalGameState.updateApprovalRating(1);
			Globals.globalGameState.updateScore(scoreValue);
			Globals.killsCount++;
		}
		else if (currentState == Entity.State.COLLECTED)
			Globals.globalGameState.updateApprovalRating(2);
			
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