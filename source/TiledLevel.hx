package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.tiled.TiledMap;
import flixel.addons.editors.tiled.TiledObject;
import flixel.addons.editors.tiled.TiledObjectGroup;
import flixel.addons.editors.tiled.TiledTileSet;
import haxe.io.Path;

class TiledLevel extends TiledMap
{
	private inline static var PATH_LEVEL_TILESHEETS = "assets/images/";
	
	// Array of tilemaps used for collision
	public var foregroundTiles:FlxGroup;
	public var backgroundTiles:FlxGroup;
	private var collidableTileLayers:Array<FlxTilemap>;
	
	public function new(tiledLevel:Dynamic)
	{
		super(tiledLevel);
		
		foregroundTiles = new FlxGroup();
		backgroundTiles = new FlxGroup();
		
		FlxG.camera.setBounds(0, 0, fullWidth, fullHeight, true);
		
		// Load Tile Maps
		for (tileLayer in layers)
		{
			var tileSheetName:String = tileLayer.properties.get("tileset");
			
			if (tileSheetName == null)
				throw "'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";
				
			var tileSet:TiledTileSet = null;
			for (ts in tilesets)
			{
				if (ts.name == tileSheetName)
				{
					tileSet = ts;
					break;
				}
			}
			
			if (tileSet == null)
				throw "Tileset '" + tileSheetName + " not found.";
				
			var imagePath = new Path(tileSet.imageSource);
			var processedPath = PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;
			
			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.tileScaleHack = 1.0;
			tilemap.widthInTiles = width;
			tilemap.heightInTiles = height;
			tilemap.loadMap(tileLayer.tileArray, processedPath, tileSet.tileWidth, tileSet.tileHeight, 0, 1, 1, 1);
			
			// NOTE: add 'scrollfactor" as a custom property to tile layer(s) for parallax scrolling, etc.
			if (tileLayer.properties.contains("scrollfactor"))
			{
				var scrollFactor:Float = Std.parseFloat(tileLayer.properties.get("scrollfactor"));
				tilemap.scrollFactor.set(scrollFactor, scrollFactor);
			}
			
			if (tileLayer.properties.contains("nocollide"))
			{
				backgroundTiles.add(tilemap);
			}
			else
			{
				if (collidableTileLayers == null)
					collidableTileLayers = new Array<FlxTilemap>();
				
				foregroundTiles.add(tilemap);
				collidableTileLayers.push(tilemap);
			}
		}
	}
	
	public function loadObjects(state:PlayState)
	{
		for (group in objectGroups)
		{
			for (o in group.objects)
			{
				loadObject(o, group, state);
			}
		}
	}
	
	private function loadObject(o:TiledObject, g:TiledObjectGroup, state:PlayState)
	{
		var x:Int = o.x;
		var y:Int = o.y;
		
		// objects in tiled are aligned bottom-left (top-left in flixel)
		if (o.gid != -1)
			y -= g.map.getGidOwner(o.gid).tileHeight;
		
/*		switch (o.type.toLowerCase())
		{
			case "floor":
				var floor = new FlxObject(x, y, o.width, o.height);
				state.floor = floor;
				
			case "exit":
				// Create the level exit
				var exit = new FlxSprite(x, y);
				exit.makeGraphic(32, 32, 0xff3f3f3f);
				exit.exists = false;
				state.exit = exit;
				state.add(exit);
		}*/
	}
	
	public function collideWithLevel(obj:FlxObject, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool
	{
		if (collidableTileLayers != null)
		{
			for (map in collidableTileLayers)
			{
				return FlxG.overlap(map, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate);
			}
		}
		return false;
	}
}