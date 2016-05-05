package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.system.FlxSound;
import flixel.system.FlxCollisionType;

class IMFTruck extends Entity
{
	private static var SPEED:Float = 400;
	private var spawnTotal:Int;
	private var spawnCount:Int;
	private var elapsedTime:Float = 0;
	private var siren:FlxSound;
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0, spawnTotal:Int) 
	{
		super(X, Y, Z);
		
		loadGraphic("assets/images/IMFTruck.png", true, 410, 196, false);
		animation.add("stop", [6, 7, 8, 9, 10, 11], 12, true);
		animation.add("drive", [0, 1, 2, 3, 4, 5], 12, true);
		animation.play("drive");
		
		siren = FlxG.sound.load("assets/sounds/TruckSiren.wav", 1, true, true); 
		siren.proximity(x, y, FlxG.camera.target, 2048);
		siren.play();
		
		this.spawnTotal = spawnTotal;
		immovable = true;
		facing = FlxObject.LEFT;
	}
	
	override public function changeState(newState:Entity.State):Void
	{
		if (newState == Entity.State.ACCELERATING)
			animation.play("drive");
		else if (newState == Entity.State.BRAKING) 
		{
			if (siren.playing)
				siren.stop();
				
			FlxG.sound.play("TruckSqueal");
			animation.play("stop");
		}
		else if (newState == Entity.State.IDLE)
			animation.play("stop");

		super.changeState(newState);
	}
	
    override public function update():Void
    {
		var screenCenter = FlxG.camera.scroll.x + (FlxG.width * 0.5);
		
		if (currentState == Entity.State.DRIVING)
		{
			velocity.x = -SPEED;    
			if (x <= screenCenter)
				changeState(Entity.State.BRAKING);
		}
		else if (currentState == Entity.State.UNLOADING)
		{
			velocity.x = 0;

			elapsedTime += FlxG.elapsed;
			if (elapsedTime >= 1)
			{
				var niqabi:Niqabi = new Niqabi((x + frameWidth) - 80, z - 50 - 122, z - 50);
				niqabi.changeState(Entity.State.JUMPING);
				niqabi.target = Globals.globalGameState.player;
				niqabi.landingLine = z;
				Globals.globalGameState.displayList.add(niqabi);
				Globals.globalGameState.entities.add(niqabi);
				spawnCount++;
				if (spawnCount == spawnTotal)
					changeState(Entity.State.ACCELERATING);
				elapsedTime = 0;
			}
		}
		else if (currentState == Entity.State.ACCELERATING)
		{
			velocity.x -= 15;
			if (velocity.x >= 400)
				velocity.x = 400;
		}
		else if (currentState == Entity.State.BRAKING)
		{
			velocity.x += 4;    
			if (velocity.x >= 0)
			{
				velocity.x = 0;
				changeState(Entity.State.UNLOADING);			
			}
		}
		else if (currentState == Entity.State.IDLE)
		{
			velocity.x = 0;
		}
			
		if (x + frameWidth < 0)
			kill();
			
		z = y + frameHeight;
		
		siren.update();
		
		super.update();
    }
	
	override public function destroy():Void 
	{
		siren = null;
		super.destroy();
	}
}