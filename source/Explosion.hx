package ;

enum ExplosionType
{
	FIRE;
	BLOOD;
	HEAD;
}

class Explosion extends Entity
{
	public function new(X:Float=0, Y:Float=0, Z:Float=0, type:ExplosionType) 
	{
		super(X, Y, Z);
		
		if (type == FIRE)
		{
			loadGraphic("assets/images/Explosion.png", true, 128, 128, false);
			animation.add("explode", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], 25, false);
		}
		else if (type == BLOOD)
		{
			loadGraphic("assets/images/BloodBurst.png", true, 128, 128, false);
			animation.add("explode", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9], 18, false);		
		}
		else 
		{
			loadGraphic("assets/images/HeadBurst.png", true, 192, 94, false);
			animation.add("explode", [0, 1, 2, 3, 2, 1, 0], 32, false);			
		}
		
		animation.play("explode");
	}
	
	override public function update():Void
	{
		if (animation.finished)
			kill();
			
		super.update();
	}
}