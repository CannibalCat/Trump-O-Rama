package ;

import flixel.FlxG;
import flixel.util.FlxPoint;
import flixel.util.FlxVelocity;
import flixel.util.FlxRandom;

class HealthPickup extends Entity
{
	public function new(X:Float=0, Y:Float=0, Z:Float=0) 
	{
		super(X, Y, Z);
		
		loadGraphic("assets/images/HealthPickup.png", true, 42, 80, false);
		animation.add("default", [0, 1, 2, 3, 4, 5, 6, 7, 6, 5, 4, 3, 2, 1], 16, true);
		animation.play("default");
		
		currentState = Entity.State.IDLE;
	}
	
	override public function changeState(newState:Entity.State):Void
	{
		if (newState == Entity.State.COLLECTED)
		{
			var phraseChoice = FlxRandom.intRanged(1, 3, [Globals.lastPhraseSelection]);
			Globals.lastPhraseSelection = phraseChoice;
			switch phraseChoice
			{
				case 1:
					FlxG.sound.play("TheBest");
					
				case 2:
					FlxG.sound.play("NothingBetter");
					
				case 3:
					FlxG.sound.play("FavoriteFood");
			}
		}
		
		super.changeState(newState);
	}
	
    override public function update():Void
    {
		if (currentState == Entity.State.COLLECTED)
		{
			FlxVelocity.moveTowardsPoint(this, new FlxPoint(FlxG.camera.scroll.x + 100, 0), 1000);
					
			if (y <= 0)
			{
				if (Globals.globalGameState.player.health < 5)
				{
					if (Globals.globalGameState.player.health == 1)
						Globals.globalGameState.healthBar[0].color = 0x00FF00;
					Globals.globalGameState.player.health++;
					if (Globals.globalGameState.player.health > 5)
						Globals.globalGameState.player.health = 5;
					Globals.playerHealth = Globals.globalGameState.player.health;
					Globals.globalGameState.healthBar[Std.int(Globals.globalGameState.player.health - 1)].revive();
				}
				kill();
			}			
		}
		
		z = y + frameHeight;
		super.update();
	}
}