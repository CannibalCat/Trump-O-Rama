package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxRandom;

class Redneck extends Entity
{
	private static var RUN_SPEED:Float = 250; 
	private var wanderTimer:Float = 0;
	private var wanderThreshold:Float = 2;
	private var yellTimer:Float = 0;
	private var yellThreshold:Float = 2;
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0) 
	{
		super(X, Y, Z);
		
        loadGraphic("assets/images/Redneck.png", true, 70, 138, false);
		animation.add("Bubba", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 20, true);
		animation.add("Earl", [10, 11, 12, 13, 14, 15, 16, 17, 18, 19], 20, true);
		animation.add("Jethro", [20, 21, 22, 23, 24, 25, 26, 27, 28, 29], 20, true);
		
		velocity.x = 0;
		velocity.y = 0;
		
		switch FlxRandom.intRanged(1, 3)
		{
			case 1:
				animation.play("Bubba", true, -1);
				
			case 2:
				animation.play("Earl", true, -1);
				
			case 3:
				animation.play("Jethro", true, -1);
		}
		
		facing = FlxObject.RIGHT;
	}
	
    override public function update():Void
	{
		z = y + frameHeight;
		
		velocity.x = RUN_SPEED;
		
		yellTimer += FlxG.elapsed;
		if (yellTimer > yellThreshold)
		{
			yellTimer = 0;
			yellThreshold = FlxRandom.floatRanged(2, 4);
			if (FlxRandom.chanceRoll(25))
			{
				switch FlxRandom.intRanged(1, 3) 
				{
					case 1:
						FlxG.sound.play("YeeHaa");
					
					case 2:
						FlxG.sound.play("WoooHaaa");				
						
					case 3:
						FlxG.sound.play("YipYipYipYip");
				}
			}
		}
		
		wanderTimer += FlxG.elapsed;
		if (wanderTimer > wanderThreshold)
		{
			wanderTimer = 0;
			wanderThreshold = FlxRandom.floatRanged(1, 3);
			
			if (FlxRandom.chanceRoll(25))
				velocity.y = RUN_SPEED;	
			else if (FlxRandom.chanceRoll(25))
				velocity.y = -RUN_SPEED;
			else 
				velocity.y = 0;
		}
		
		if (z <= Globals.horizonLimit) 
				velocity.y = RUN_SPEED;
		else if (z >= FlxG.camera.bounds.height)
				velocity.y = -RUN_SPEED;
		
		if (x >= FlxG.camera.scroll.x + FlxG.width)
			kill();
			
		super.update();
	}
}