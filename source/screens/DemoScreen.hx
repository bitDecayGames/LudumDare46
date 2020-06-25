package screens;

import flixel.math.FlxPoint;
import flixel.FlxSprite;
import entities.FireArt;
import flixel.input.mouse.FlxMouse;
import analytics.Analytics;
import flixel.util.FlxTimer;
import flixel.text.FlxBitmapText;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import openfl.filters.ShaderFilter;
import openfl.filters.BitmapFilter;
import shaders.NightShader;
import managers.HitboxManager;
import audio.SoundBankAccessor;
import transitions.SceneTransitioner;
import audio.BitdecaySoundBank;
import flixel.addons.ui.FlxUIState;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUITypedButton;
import flixel.FlxG;
import debug.TestEnemyFlock;
import debug.TestAttacks;
import debug.TestKingOfPop;
import debug.TestWaterBlast;
import managers.FireManager;
import managers.ProgressManager;
import managers.EnemySpawnManager;
import cameras.PositionAverager;

class DemoScreen extends FlxUIState {
	var filters:Array<BitmapFilter> = [];

	public var cameraFocalPoint:PositionAverager;

	public var bitdecaySoundBank:BitdecaySoundBank;
	public var transitioner:SceneTransitioner;

	var transitioning:Bool = false;

	var fire:FlxSprite;

	public var paused = false;

	override public function create():Void {
		super.create();

		bitdecaySoundBank = new BitdecaySoundBank();
		transitioner = new SceneTransitioner();

		FlxG.mouse.visible = false;

		var hitboxMgr = new HitboxManager(this);
		hitboxMgr.setPlayZone(27, 130, 1000, 750);
		hitboxMgr.addTrees();
		hitboxMgr.getPlayer().kill();

		fire = new FireArt(600, 400, null);
		add(fire);

		new TestAttacks(this, hitboxMgr, new FlxPoint(fire.x - 50, fire.y - 50));

		camera.zoom = 2;

		cameraFocalPoint = new PositionAverager();
		cameraFocalPoint.addObject(fire);
		add(cameraFocalPoint);
		camera.follow(cameraFocalPoint);
	}

	override public function update(elapsed:Float):Void {
		super.update(elapsed);
		bitdecaySoundBank.update();
		transitioner.update();
	}
}
