package hitbox;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import haxe.ds.Map;
import flixel.FlxSprite;

using extensions.FlxObjectExt;

class AttackHitboxes {

	var parentSprite:FlxSprite;
	var hitboxGroup:FlxGroup;

	var registrar:Map<String, HitboxRegistration> = [];
	var lastActive:HitboxSprite;

	var inspecting:HitboxRegistration;

	public function new(parent:FlxSprite, hitboxGroup:FlxGroup) {
		parentSprite = parent;
		this.hitboxGroup = hitboxGroup;
	}

	public function update(elapsed:Float) {
		if (lastActive == null) {
			return;
		}

		// flipX means we are facing left
		if (parentSprite.flipX) {
			lastActive.setMidpoint(
				parentSprite.getMidpoint().x - lastActive.loc.offset.x, 
				parentSprite.getMidpoint().y + lastActive.loc.offset.y);
		} else {
			lastActive.setMidpoint(
				parentSprite.getMidpoint().x + lastActive.loc.offset.x, 
				parentSprite.getMidpoint().y + lastActive.loc.offset.y);
		}
	}

	public function finishAnimation() {
		// TODO Logor why null when bench lift?
		if (lastActive == null) {
			return;
		}
		lastActive.kill();
		lastActive = null;
	}

	// register animations with the proper hitboxes and what frames they should appear on
	public function register(animName:String, startFrame:Int, hitboxLocations:Array<HitboxLocation>):Void {
		var hitboxes:Array<HitboxSprite> = [];
		for (hbl in hitboxLocations) {
			var box = new HitboxSprite(hbl);
			hitboxes.push(box);
			hitboxGroup.add(box);
		}
		registrar[animName] = new HitboxRegistration(startFrame, hitboxes);
	}

	// register this callback with the animation controller
	public function animCallback(name:String, frameNumber:Int, frameIndex:Int):Void {
		if (lastActive != null) {
			lastActive.kill();
		}
		if (registrar.exists(name)) {
			inspecting = registrar[name];
			if (frameNumber >= inspecting.offset && frameNumber < inspecting.offset + inspecting.hitboxFrames.length) {
				var hitboxFrame = inspecting.hitboxFrames[frameNumber - inspecting.offset];
				hitboxFrame.revive();
				lastActive = hitboxFrame;
				update(0);
			}
		}
	}
}