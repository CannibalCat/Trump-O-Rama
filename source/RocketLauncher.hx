package ;

class RocketLauncher extends Entity
{
	public function new(X:Float=0, Y:Float=0, Z:Float=0) 
	{
		super(X, Y, Z);
		
		loadGraphic("assets/images/RocketLauncherPickup.png", true, 78, 112, false);
		animation.add("default", [0, 1, 2, 3, 4, 5], 15, true);
		animation.play("default");
	}
	
    override public function update():Void
    {
		z = y + frameHeight;
		super.update();
	}
}