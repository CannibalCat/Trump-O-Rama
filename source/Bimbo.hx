package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxVelocity;
import flixel.system.FlxSound;

class Bimbo extends Entity
{
	private static var WALK_SPEED:Float = 64;
	private static var RUN_SPEED:Float = 96;
	private static var MOB_SPEED:Float = 200;
	private var panicTimer:Float = 0;
	private var panicThreshold:Float = 2;
	private var panicRange:Int = 200;
	private var wanderTimer:Float = 0;
	private var wanderThreshold:Float = 6;
	private var transformTimer:Float = 0;
	private var yellTimer:Float = 0;
	private var yellThreshold:Float = 1;
	private var scream:FlxSound;
	private var saveMe:FlxSound;
	private var helpMe:FlxSound;
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0, Direction:Int=FlxObject.RIGHT) 
	{
		super(X, Y, Z);
		
        loadGraphic("assets/images/Bimbo.png", true, 86, 150, false);
		animation.add("idle", [5], 1, true);
		animation.add("walk", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 10, true);
		animation.add("run", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20, true);
		animation.add("transform", [5, 10], 18, true);
		animation.add("captured", [11, 12], 16, true);
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		velocity.x = 0;
		velocity.y = 0;
		
		currentState = Entity.State.IDLE; 
		
		scream = FlxG.sound.load("assets/sounds/FemaleScream.wav", 1);
		scream.proximity(x, y, FlxG.camera.target, 3072);
		
		saveMe = FlxG.sound.load("assets/sounds/FemaleSaveMe.wav", 1);
		saveMe.proximity(x, y, FlxG.camera.target, 3072);
		
		helpMe = FlxG.sound.load("assets/sounds/FemaleHelpMe.wav", 1);
		helpMe.proximity(x, y, FlxG.camera.target, 3072);
		
		target = null;
		facing = Direction;
		scoreValue = 0;
		health = 3;
	}
	
	override public function changeState(newState:Entity.State):Void
	{
		if (newState == Entity.State.EVADING)
		{
			scream.play();
			animation.play("run", true, -1);
			Globals.globalGameState.displayList.add(new Exclaimation((x + frameWidth / 2) - 26, y - 36, z, Exclaimation.Phrase.SCREAM, this));
		}
		else if (newState == Entity.State.TRANSFORMING)
		{
			FlxG.sound.play("Transform");
			animation.play("transform");
			Globals.globalGameState.displayList.add(new SpinnerEffect(x + 5, y + 15, z + 1));
		}
		else if (newState == Entity.State.COLLECTED)
		{
			Globals.savedBimboCount++;
			animation.play("idle");
			if (FlxRandom.chanceRoll(50)) 
			{
				FlxG.sound.play("FemaleThankYou"); 
				Globals.globalGameState.displayList.add(new Exclaimation((x + frameWidth / 2) - 26, y - 36, z, Exclaimation.Phrase.THANK_YOU, this));
			}
			else 
			{
				FlxG.sound.play("FemaleMyHero");
				Globals.globalGameState.displayList.add(new Exclaimation((x + frameWidth / 2) - 26, y - 36, z, Exclaimation.Phrase.MY_HERO, this));
			}
		}
		else if (newState == Entity.State.WANDERING)
		{
			if (FlxRandom.chanceRoll(50))
				velocity.x = WALK_SPEED;
			else
				velocity.x = -WALK_SPEED;			
				
			animation.play("walk", true, -1);
		}
		else if (newState == Entity.State.RUNNING_AWAY)
		{
			wanderThreshold = 2;
			animation.play("run", true, -1);
		}
	
		super.changeState(newState);
	}
	
    override public function update():Void
	{
		if (target != null && !target.alive)
			target = null;
			
		if (currentState == Entity.State.WANDERING)
		{
			if (target != null && target.alive && target.currentState != Entity.State.RUNNING_AWAY)
				changeState(Entity.State.EVADING);
			
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
		}
		else if (currentState == Entity.State.EVADING)
		{
			if (target == null)
				changeState(Entity.State.WANDERING);
			else
			{
				panicTimer += FlxG.elapsed;
				if (panicTimer > panicThreshold)
				{
					panicTimer = 0;
					panicThreshold = FlxRandom.floatRanged(2, 6);
					if (FlxRandom.chanceRoll(50))
					{
						saveMe.play();
						Globals.globalGameState.displayList.add(new Exclaimation((x + frameWidth / 2) - 26, y - 36, z, Exclaimation.Phrase.SAVE_ME, this));
					}
					else
					{
						helpMe.play();
						Globals.globalGameState.displayList.add(new Exclaimation((x + frameWidth / 2) - 26, y - 36, z, Exclaimation.Phrase.HELP_ME, this));
					}
				}
				
				if (x > target.x)
					velocity.x = RUN_SPEED;
				else if (x < target.x)
					velocity.x = -RUN_SPEED;
				else
					velocity.x = 0;

				if (z > target.z)
					velocity.y = RUN_SPEED;
				else if (z < target.z)
					velocity.y = -RUN_SPEED;
				else
					velocity.y = 0;
					
				if (velocity.x > 0)
					facing = FlxObject.RIGHT;
				else if (velocity.x < 0)
					facing = FlxObject.LEFT;
			}
		}
		else if (currentState == Entity.State.IDLE)
		{
			velocity.x = 0;
			velocity.y = 0;
			animation.play("idle");
		}
		else if (currentState == Entity.State.COLLECTED)
		{
			facing = FlxObject.RIGHT;
			animation.play("captured");
			FlxVelocity.moveTowardsPoint(this, new FlxPoint(FlxG.camera.scroll.x + 950, 0), 1000);
			if (y <= 0)
				kill();
		}
		else if (currentState == Entity.State.TRANSFORMING)
		{
			velocity.x = 0;
			velocity.y = 0;		
				
			transformTimer += FlxG.elapsed;
			if (transformTimer > 2.5)
			{
				var convert:Convert = new Convert(x, z - 146, z, facing);
				convert.changeState(Entity.State.WANDERING);
				Globals.globalGameState.displayList.add(convert);
				Globals.globalGameState.entities.add(convert);
				kill();
			}
		}
		else if (currentState == Entity.State.RUNNING_AWAY)
		{
			velocity.x = -MOB_SPEED;
			
			yellTimer += FlxG.elapsed;
			if (yellTimer > yellThreshold)
			{
				yellTimer = 0;
				yellThreshold = FlxRandom.floatRanged(2, 4);
				if (FlxRandom.chanceRoll(30))
					scream.play(); 
			}
			
			wanderTimer += FlxG.elapsed;
			if (wanderTimer > wanderThreshold)
			{
				wanderTimer = 0;
				wanderThreshold = FlxRandom.floatRanged(1, 3);
				
				if (FlxRandom.chanceRoll(25))
					velocity.y = MOB_SPEED;	
				else if (FlxRandom.chanceRoll(25))
					velocity.y = -MOB_SPEED;
				else 
					velocity.y = 0;
			}
		}
		
		z = y + frameHeight;
	
		if (currentState != Entity.State.COLLECTED)
		{
			if (z <= Globals.horizonLimit || z >= FlxG.camera.bounds.height)
				velocity.y = - velocity.y;
			
			if (x + frameWidth < 0 || x > FlxG.camera.bounds.width)
				kill();
		}
		
		super.update();
	}
	
	override public function kill():Void
	{
		if (currentState == Entity.State.COLLECTED)
			Globals.globalGameState.updateApprovalRating(2);
		
		super.kill();
	}
}