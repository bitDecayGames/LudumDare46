package states;

import flixel.util.FlxSort;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxCollision;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxColor;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
import shaders.NightShader;
import entities.Player;
import entities.TreeGroup;
import entities.TreeLog;
import flixel.FlxG;
import flixel.FlxState;
import sorting.HitboxSorter;

class MovementState extends FlxState
{
	var player:Player;
	var playerGroup:FlxGroup;
	var treeGroup:TreeGroup;
	var itemGroup:FlxGroup;

	var sortGroup:FlxSpriteGroup;
	
	var filters:Array<BitmapFilter> = [];
	var shader = new NightShader();
	
	var increasing:Bool = true;

	override public function create():Void
	{
		super.create();
		// FlxG.debugger.visible = true;
		FlxG.debugger.drawDebug = true;
		
		sortGroup = new FlxSpriteGroup(0);
		add(sortGroup);

		playerGroup = new FlxGroup(1);

		player = new Player();
		playerGroup.add(player);
		sortGroup.add(player);

		treeGroup = new TreeGroup();
		treeGroup.spawn(2);
		treeGroup.forEach(t -> sortGroup.add(t));


		itemGroup = new FlxGroup();
		var log = new TreeLog();
		log.x = 300;
		log.y = 300;
		itemGroup.add(log);
		sortGroup.add(log);

		camera.filtersEnabled = true;
		filters.push(new ShaderFilter(shader));
		camera.bgColor = FlxColor.WHITE;
		camera.setFilters(filters);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		sortGroup.sort(HitboxSorter.sort, FlxSort.ASCENDING);

		
		FlxG.collide(playerGroup, treeGroup);
		FlxG.collide(playerGroup, itemGroup, handlePlayerItemCollision);
		
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

	private static function handlePlayerItemCollision(player: FlxSprite, item: FlxSprite) {
		item.kill();
	}
}
