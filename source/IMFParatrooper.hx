package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxRandom;

class IMFParatrooper extends Entity
{
	private static var WALK_SPEED:Float = 64;
	private static var RUN_SPEED:Float = 128;
	private var landingMark:Float;
	private var lethalKill:Bool = true;
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0, Direction:Int=FlxObject.RIGHT) 
	{
		super(X, Y, Z);
	
        loadGraphic("assets/images/IMFParatrooper.png", true, 220, 215, false);
		animation.add("descending", [4], 1, true);
		animation.add("landing", [5, 6, 7, 8, 9, 0, 1, 2, 3], 10, false);
		animation.add("death", [10, 11, 12, 13, 14, 15, 14, 15, 14, 15], 10, false);
		
		setFacingFlip(FlxObject.LEFT, true, false); 
		setFacingFlip(FlxObject.RIGHT, false, false); 
		
		changeState(Entity.State.DESCENDING);
		
		facing = Direction;
		health = 3;
	}
	
	override public function changeState(newState:Entity.State):Void
	{
		if (newState == Entity.State.DESCENDING)
		{
			velocity.x = 0;
			animation.play("descending");
			velocity.y = FlxRandom.intRanged(100, 150);
			landingMark = FlxRandom.intRanged(550, 750); 
		}
		else if (newState == Entity.State.LANDED)
		{
			velocity.y = 0;
			animation.play("landing");		
		}
		else if (newState == Entity.State.DYING)
		{
			FlxG.sound.play("GoonDie" + FlxRandom.intRanged(1, 5));
			animation.play("death");
			Globals.globalGameState.objectToss(this, "IMFGoon");
		}
		
		super.changeState(newState);
	}
	
    override public function update():Void
	{
		if (currentState == Entity.State.DESCENDING)
		{
			if (z >= landingMark)
			{
				changeState(Entity.State.LANDED);
				var chute:Parachute = new Parachute(x + 45, y, z);
				Globals.globalGameState.displayList.add(chute);
			}
		}
		else if (currentState == Entity.State.LANDED)
		{
			if (animation.finished)
			{
				var x_offset:Float;
				velocity.x = 0;
				
				if (facing == FlxObject.RIGHT)
					x_offset = 54;
				else 
					x_offset = 52;
					
				var imfGoon:IMFGoon = new IMFGoon(x + x_offset, z - 130, z, facing); 
				imfGoon.health = health;
				imfGoon.changeState(Entity.State.CHASING);
				Globals.globalGameState.displayList.add(imfGoon);
				Globals.globalGameState.entities.add(imfGoon);
				lethalKill = false;
				kill();
			}
			else
			{
				if (facing == FlxObject.RIGHT)
					velocity.x = RUN_SPEED;
				else
					velocity.x = -RUN_SPEED;				
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
		
		z = y + frameHeight;	
		
		super.update();
	}
	
	override public function kill():Void
	{
		if (lethalKill)
		{
			Globals.globalGameState.updateScore(scoreValue);
			Globals.killsCount++;
			Globals.globalGameState.waveData.currentIMFGoons--;	
		}
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