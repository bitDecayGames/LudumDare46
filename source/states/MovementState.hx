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
import flixel.FlxG;
import flixel.FlxState;
import sorting.HitboxSorter;

class MovementState extends FlxState
{
	var player:Player;
	var playerGroup:FlxGroup;
	
	var filters:Array<BitmapFilter> = [];
	var shader = new NightShader();
	
	var increasing:Bool = true;

	var treeGroup:TreeGroup;
	var sortGroup:FlxSpriteGroup;

	override public function create():Void
	{
		super.create();
		FlxG.debugger.visible = true;
		FlxG.debugger.drawDebug = true;
		
		sortGroup = new FlxSpriteGroup(0);
		// sortGroup.sort(HitboxSorter.sort);
		sortGroup.sort(FlxSort.byY, FlxSort.ASCENDING);
		add(sortGroup);

		playerGroup = new FlxGroup(1);
		// add(playerGroup);

		player = new Player();
		playerGroup.add(player);
		sortGroup.add(player);

		treeGroup = new TreeGroup();
		// add(treeGroup);
		treeGroup.spawn(2);
		treeGroup.forEach(t -> sortGroup.add(t));


		camera.filtersEnabled = true;
		filters.push(new ShaderFilter(shader));
		camera.bgColor = FlxColor.TRANSPARENT;
		camera.setFilters(filters);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		FlxG.collide(playerGroup, treeGroup);
		
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

	private static function pixelPerfect(a: FlxSprite, b: FlxSprite): Bool {
		return FlxCollision.pixelPerfectCheck(a, b, 1);
	}
}
