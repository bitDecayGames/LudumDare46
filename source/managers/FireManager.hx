package managers;
import flixel.FlxG;
import entities.Fire;
import screens.GameScreen;

class FireManager {
    var fire:Fire;
	public function new(game:GameScreen) {
        fire = new Fire(FlxG.width / 2, FlxG.height / 2, 30);
		game.add(fire);
        fire.start();
    }
}