package ;

import flixel.FlxG;

class Hearts extends Entity
{
	private var parentReference:Entity;
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0, parentRef:Entity) 
	{
		super(X, Y, Z);
		
		parentReference = parentRef;
		
		loadGraphic("assets/images/Hearts.png", true, 32, 32, false);
		animation.add("default", [0, 1, 2, 3, 4, 5, 6, 7], 8, false);
		animation.callback = animCallBack;
		animation.play("default");	
		
		x = parentReference.x + parentReference.offset.x - frameWidth;
		y = parentReference.y - frameHeight;
	}
	
	override public function update():Void
    {
		setPosition(parentReference.x + parentReference.offset.x - frameWidth, parentReference.y - frameHeight);
		
		if (animation.finished)
			this.kill();
			
		super.update();		
	}
	
	private function animCallBack(animationName:String, currentFrame:Int, currentFrameIndex:Int)
	{
		if (currentFrame >= 5)
			FlxG.sound.play("Pop");
	}
}