package states;

import audio.BitdecaySoundBank;
import entities.Tree;
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
	var playerHitboxes:FlxGroup;

	var sortGroup:FlxSpriteGroup;
	
	var filters:Array<BitmapFilter> = [];
	var shader = new NightShader();
	
	var increasing:Bool = true;
	
	public var bitdecaySoundBank:BitdecaySoundBank;

	override public function create():Void
	{
		super.create();
		// FlxG.debugger.visible = true;
		FlxG.debugger.drawDebug = true;
		
		sortGroup = new FlxSpriteGroup(0);
		add(sortGroup);
		playerHitboxes = new FlxGroup(0);
		add(playerHitboxes);

		playerGroup = new FlxGroup(0);

		player = new Player(playerHitboxes);
		playerGroup.add(player);
		sortGroup.add(player);

		treeGroup = new TreeGroup();
		treeGroup.spawn(2);
		treeGroup.forEach(t -> sortGroup.add(t));

		itemGroup = new FlxGroup(0);
		
		camera.filtersEnabled = true;
		filters.push(new ShaderFilter(shader));
		camera.bgColor = FlxColor.WHITE;
		camera.setFilters(filters);
		
		bitdecaySoundBank = new BitdecaySoundBank();
		bitdecaySoundBank.PlaySong(BitdecaySongs.ZombieFuel);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		sortGroup.sort(HitboxSorter.sort, FlxSort.ASCENDING);
		
		// Environment restrictions
		FlxG.collide(playerGroup, treeGroup);
		FlxG.collide(itemGroup, treeGroup);

		// Environment interactions
		FlxG.collide(playerGroup, itemGroup);
		FlxG.overlap(playerHitboxes, treeGroup, hitTree);
		FlxG.overlap(playerHitboxes, itemGroup, handlePlayerHit);
		
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

	private function hitTree(player: FlxSprite, tree: Tree) {
		if (tree.hasLog) {
			var newLog = tree.spawnLog();
			itemGroup.add(newLog);
			sortGroup.add(newLog);
		}
	}

	private static function handlePlayerHit(player: FlxSprite, item: FlxSprite) {
		item.kill();
	}
}
