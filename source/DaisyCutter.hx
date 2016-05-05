package ;

class DaisyCutter extends Entity
{
	private var parentReference:Entity;
	
	public function new(X:Float=0, Y:Float=0, Z:Float=0, parentRef:Entity=null) 
	{
		super(X, Y, Z);
		
		parentReference = parentRef;
		
		loadGraphic("assets/images/DaisyCutter.png", false, 224, 108, false);
	}
	
	override public function update():Void
	{
		if (parentReference != null)
			setPosition(parentReference.x + 215, parentReference.y + 80);
		
		z = y + frameHeight + 2;
		
		super.update();
	}
}