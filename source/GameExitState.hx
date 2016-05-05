package ;

import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxColor;
import flash.system.System;

class GameExitState extends FlxSubState
{
	private var blackBox:FlxSprite;
	private var exitGame:Bool = false;
	private var elapsedTime:Float = 0;
	private var playerPrompt:Bool = false;
	private var promptText:FlxText;
	private var yesText:FlxText;
	private var noText:FlxText;
	private var noKey:FlxSprite;
	private var yesKey:FlxSprite;
	
	public function new(BGColor:Int=FlxColor.TRANSPARENT) 
	{
		super(BGColor);
		
		blackBox = new FlxSprite(0, 0, "assets/images/BlackBox.png");
		blackBox.setPosition(FlxG.camera.scroll.x + (FlxG.width / 2) - (blackBox.width / 2), (FlxG.height / 2) - (blackBox.height / 2));
		add(blackBox);
		
		promptText = new FlxText(0, 0, FlxG.width, "EXIT GAME?");
		promptText.setPosition(FlxG.camera.scroll.x + (FlxG.width / 2) - (promptText.width / 2), 275);
		promptText.setFormat(Globals.TEXT_FONT, 60, 0xFFFFFF, "center");
		promptText.antialiasing = false;
		promptText.visible = false;
		add(promptText);
		
		yesText = new FlxText(0, 0, FlxG.width, "YES");
		yesText.setPosition(FlxG.camera.scroll.x + 518, 350);
		yesText.setFormat(Globals.TEXT_FONT, 60, 0x00FF00);
		yesText.antialiasing = false;
		yesText.visible = false;
		add(yesText);
		
		yesKey = new FlxSprite(0, 0, "assets/images/Key_Y.png");
		yesKey.setPosition(FlxG.camera.scroll.x + 418, 345);
		yesKey.visible = false;
		add(yesKey);
		
		noText = new FlxText(0, 0, FlxG.width, "NO");
		noText.setPosition(FlxG.camera.scroll.x + 518, 425);
		noText.setFormat(Globals.TEXT_FONT, 60, 0xFF0000);
		noText.antialiasing = false;
		noText.visible = false;
		add(noText);

		noKey = new FlxSprite(0, 0, "assets/images/Key_N.png");
		noKey.setPosition(FlxG.camera.scroll.x + 418, 420);
		noKey.visible = false;
		add(noKey);
		
		FlxTween.tween(blackBox.scale, { x:32, y:32 }, 1.5, { type: FlxTween.ONESHOT, ease: FlxEase.quadIn, complete: promptPlayer } );
	}
	
	private function promptPlayer(tween:FlxTween):Void
	{
		playerPrompt = true;
	}
	
	private function closePrompt():Void
	{
		FlxTween.tween(blackBox.scale, { x:1, y:1 }, 1.5, { type: FlxTween.ONESHOT, ease: FlxEase.quadOut, complete: onPromptClose } );
	}
	
	private function onPromptClose(tween:FlxTween):Void
	{
		blackBox.kill();
		close();
	}
	
	override public function destroy():Void
	{
		blackBox = null;
		promptText = null;
		yesText = null;
		noText = null;
		noKey = null;
		yesKey = null;
		super.destroy();
	}
	
	override public function update():Void
	{
		elapsedTime += FlxG.elapsed;
		
		if (playerPrompt)
		{
			promptText.visible = true;
			yesText.visible = true;
			yesKey.visible = true;
			noText.visible = true;
			noKey.visible = true;
			promptText.color = ColorCycler.WilliamsUltraFlash;
			
			if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.N)
			{
				exitGame = false;
				promptText.visible = false;
				yesText.visible = false;
				yesKey.visible = false;
				noText.visible = false;
				noKey.visible = false;
				playerPrompt = false;
				closePrompt();
			}
			else if (FlxG.keys.justPressed.Y)
			{
				exitGame = true;
				promptText.visible = false;
				yesText.visible = false;
				yesKey.visible = false;
				noText.visible = false;
				noKey.visible = false;
				playerPrompt = false;
				closePrompt();
			}
		}
			
		super.update();
	}
	
	override public function close():Void 
	{
		super.close();
		Globals.pauseGame = false;
		if (exitGame)
		{
			if (Type.getClassName(Type.getClass(this._parentState)) == "PlayState")
			{
				Globals.resetCheatValues();
				FlxG.switchState(new HighScoresState());
			}
			else
				System.exit(0);
		}
	}
}