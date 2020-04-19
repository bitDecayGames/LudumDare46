package managers;

import entities.Enemy;
import entities.enemies.ConfusedZombie;
import entities.enemies.RegularAssZombie;
import entities.enemies.HardworkingFirefighter;
import flixel.math.FlxRandom;
import entities.Player;
import audio.SoundBankAccessor;
import audio.BitdecaySoundBank;
import hitbox.HitboxSprite;
import flixel.math.FlxVector;
import entities.TreeTrunk;
import flixel.util.FlxSort;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
import shaders.NightShader;
import entities.PlayerGroup;
import entities.TreeGroup;
import flixel.FlxG;
import sorting.HitboxSorter;
import screens.GameScreen;
import managers.FireManager;
import entities.EnemyFlock;

class GameManager
{
	var hitboxMgr:HitboxManager;

	var filters:Array<BitmapFilter> = [];
	var shader = new NightShader();
	
	var increasing:Bool = true;
	
    public var bitdecaySoundBank:BitdecaySoundBank;
    
    var firepit:FlxSprite;

	public function new(game:GameScreen):Void
	{
		// FlxG.debugger.visible = true;
		FlxG.debugger.drawDebug = true;
		
		hitboxMgr = new HitboxManager(game);
	
		// TODO: Probably could put this in a better place
		hitboxMgr.addTrees(2);

		game.camera.filtersEnabled = true;
		filters.push(new ShaderFilter(shader));
		game.camera.bgColor = FlxColor.WHITE;
		game.camera.setFilters(filters);
		game.camera.zoom = 2;
		game.camera.follow(hitboxMgr.getPlayer());
		
		bitdecaySoundBank = new BitdecaySoundBank();
        
        // TODO Link to firepit, remove firepit var.
        new FireManager(game);
        var firepit = new FlxSprite(300, 300, AssetPaths.Bush__png);
		hitboxMgr.addGeneral(firepit);

        spawnEnemies();
	}

	
	public function update(elapsed:Float):Void {
		elapsed *= 0.1;
		if (increasing) {
			shader.time.value[0] = shader.time.value[0] + elapsed;
			if (shader.time.value[0] >= 1) {
				increasing = false;
			}
		} else {
			shader.time.value[0] = shader.time.value[0] - elapsed;
			if (shader.time.value[0] <= 0) {
				increasing = true;
			}
		}
	}

    private function spawnEnemies() {
        var e:Enemy;
		var rnd = new FlxRandom();
		for (i in 0...3) {
			if (i % 5 == 0) {
				e = new HardworkingFirefighter(hitboxMgr, firepit);
			} else if (i % 2 == 0) {
				e = new RegularAssZombie(hitboxMgr);
			} else {
				e = new ConfusedZombie(hitboxMgr);
			}
			e.x = 100 + i * 10;
			e.y = 100 + rnd.float(0, 10);
			hitboxMgr.addEnemy(e);
		}
    }
}
