package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxVelocity;
import flixel.system.FlxSound;

class Banker extends Entity
{
	private static var WALK_SPEED:Float = 64;
	private static var RUN_SPEED:Float = 128;
	private var moneyTimer:Float = 0;
	private var panicTimer:Float = 0;
	private var panicThreshold:Float = 2;
	private var panicRange:Int = 400;
	private var wanderTimer:Float = 0;
	private var wanderThreshold:Float = 6;
	private var runTimer:Float = 0;
	private var runThreshold:Float = 6;
	private var overHere:FlxSound;
		
	public function new(X:Float=0, Y:Float=0, Z:Float=0, Direction:Int=FlxObject.RIGHT) 
	{
		super(X, Y, Z);
		
        loadGraphic("assets/images/Banker.png", true, 112, 158, false);
		animation.add("idle", [7], 1, true);
		animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		animation.add("run", [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 20, true);
		animation.add("death", [20, 21, 22, 23, 24, 25, 24, 25, 24, 25], 10, false);
		animation.add("captured", [26, 27], 16, true);

		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		velocity.x = 0;
		velocity.y = 0;
		
		currentState = Entity.State.IDLE;
		
		overHere = FlxG.sound.load("assets/sounds/MaleOverHere.wav", 1);
		overHere.proximity(x, y, FlxG.camera.target, 3072);
		
		target = null;
		facing = Direction;
		health = 3;
	}
	
	override public function changeState(newState:Entity.State):Void
	{
		if (newState == Entity.State.EVADING) 
		{
			FlxG.sound.play("OhNo");
			Globals.globalGameState.displayList.add(new Exclaimation((x + frameWidth / 2) - 26, y - 26, z, Exclaimation.Phrase.OH_NO, this));
			animation.play("run", true, -1);	
		}
		else if (newState == Entity.State.COLLECTED)
		{
			Globals.savedBankerCount++;
			animation.play("idle");
			FlxG.sound.play("MaleThankYou");
			Globals.globalGameState.displayList.add(new Exclaimation((x + frameWidth / 2) - 26, y - 16, z, Exclaimation.Phrase.THANK_YOU, this));
		}
		else if (newState == Entity.State.WANDERING)
		{
			if (FlxRandom.chanceRoll(50))
				velocity.x = WALK_SPEED;
			else
				velocity.x = -WALK_SPEED;	
				
			animation.play("walk", true, -1);
		}
		else if (newState == Entity.State.DYING)
		{
			FlxG.sound.play("BankerDie");
			animation.play("death");
			Globals.globalGameState.moneyBurst(x + frameWidth / 2, y + frameHeight / 2, 8);
			Globals.globalGameState.objectToss(this, "Banker");
		}
	
		super.changeState(newState);
	}
	
    override public function update():Void
	{
		if (target != null && !target.alive)
			target = null;		
		
		if (currentState == Entity.State.WANDERING)
		{
			wanderTimer += FlxG.elapsed;
			if (wanderTimer > wanderThreshold)
			{
				wanderTimer = 0;
				wanderThreshold = FlxRandom.floatRanged(4, 12);
				
				overHere.play();
				Globals.globalGameState.displayList.add(new Exclaimation((x + frameWidth / 2) - 26, y - 26, z, Exclaimation.Phrase.OVER_HERE, this));
				
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
		}
		else if (currentState == Entity.State.EVADING)
		{
			if (target == null)
				changeState(Entity.State.WANDERING);
			else
			{
				panicTimer += FlxG.elapsed;
				moneyTimer += FlxG.elapsed;

				if (moneyTimer > 1.5)
				{
					Globals.globalGameState.moneyBurst(x + frameWidth / 2, y, FlxRandom.intRanged(4, 6));
					moneyTimer = 0;
				}
				
				if (panicTimer > panicThreshold)
				{
					panicTimer = 0;
					panicThreshold = FlxRandom.floatRanged(2, 6);
					FlxG.sound.play("MaleHelp");
					Globals.globalGameState.displayList.add(new Exclaimation((x + frameWidth / 2) - 26, y - 26, z, Exclaimation.Phrase.HELP, this));
				}
				
				if (x > target.x)
					velocity.x = RUN_SPEED;
				else 
					velocity.x = -RUN_SPEED;
					
					
				velocity.y = 0;

				if (velocity.x > 0)
					facing = FlxObject.RIGHT;
				else if (velocity.x < 0)
					facing = FlxObject.LEFT;
			}
		}
		else if (currentState == Entity.State.COLLECTED)
		{
			facing = FlxObject.RIGHT;
			animation.play("captured");
			FlxVelocity.moveTowardsPoint(this, new FlxPoint(FlxG.camera.scroll.x + 950, 0), 1000);
			if (y <= 0)
				kill();
		}
		else if (currentState == Entity.State.DYING)
		{
			if (overHere.playing)
				overHere.stop();
				
			if (animation.curAnim != null && animation.curAnim.curFrame >= 4)
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
		if (currentState == Entity.State.DYING)
			Globals.globalGameState.updateApprovalRating(-10);
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