package;

import flixel.FlxG;
import flixel.system.debug.FlxDebugger;
import flixel.FlxGame;
import openfl.display.Sprite;
import states.ParticleState;

class Main extends Sprite
{
	public function new()
	{
		super();
		FlxG.debugger.visible = true;
		FlxG.debugger.drawDebug = true;
		addChild(new FlxGame(0, 0, ParticleState));
	}
}
