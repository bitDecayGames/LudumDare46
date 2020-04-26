package hitbox;

import faxe.FaxeSoundHelper;
import managers.HitboxManager;
import audio.BitdecaySoundBank.BitdecaySounds;
import audio.SoundBankAccessor;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.FlxObject;
import haxe.ds.Map;
import flixel.FlxSprite;

using extensions.FlxObjectExt;

class AttackHitboxes {
	var parentSprite:FlxSprite;

	var registrar:Map<String, HitboxRegistration> = [];
	var lastActive:HitboxSprite;

	var inspecting:HitboxRegistration;

	public function new(parent:FlxSprite) {
		parentSprite = parent;
	}

	public function update(elapsed:Float) {
		if (lastActive == null) {
			return;
		}

		// flipX means we are facing left
		if (parentSprite.flipX) {
			lastActive.setMidpoint(parentSprite.getMidpoint().x - lastActive.loc.offset.x, parentSprite.getMidpoint().y + lastActive.loc.offset.y);
		} else {
			lastActive.setMidpoint(parentSprite.getMidpoint().x + lastActive.loc.offset.x, parentSprite.getMidpoint().y + lastActive.loc.offset.y);
		}
		// Don't let the hull calculation do it's thing
		lastActive.last.set(lastActive.x, lastActive.y);
	}

	public function finishAnimation() {
		if (lastActive == null) {
			return;
		}
		lastActive.kill();
		lastActive = null;
	}

	// register animations with the proper hitboxes and what frames they should appear on
	public function register(groupAdd:(HitboxSprite) -> Void, animName:String, startFrame:Int, hitboxLocations:Array<HitboxLocation>):Void {
		var hitboxes:Array<HitboxSprite> = [];
		for (hbl in hitboxLocations) {
			var box = new HitboxSprite(hbl, parentSprite);
			hitboxes.push(box);
			groupAdd(box);
		}
		registrar[animName] = new HitboxRegistration(startFrame, hitboxes);
	}

	// register this callback with the animation controller
	public function animCallback(name:String, frameNumber:Int, frameIndex:Int):Void {
		if (lastActive != null) {
			lastActive.kill();
		}
		if (registrar != null && name != null && registrar.exists(name)) {
			inspecting = registrar[name];
			if (frameNumber >= inspecting.offset && frameNumber < inspecting.offset + inspecting.hitboxFrames.length) {
				var hitboxFrame = inspecting.hitboxFrames[frameNumber - inspecting.offset];
				lastActive = hitboxFrame;
				update(0);
				hitboxFrame.clearHits();
				hitboxFrame.revive();
				
			}
		}
		if (frameNumber == 0 && name == "punch") {
			// SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.MachoManThrowPunch);
			FaxeSoundHelper.GetInstance().PlaySound("MachoManThrowPunch");
		}
		if (frameNumber == 0 && name == "pickup") {
			// SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.MachoManGrunt);
			FaxeSoundHelper.GetInstance().PlaySound("MachoManGrunt");
		}
		if (frameNumber == 0 && name == "throw") {
			// SoundBankAccessor.GetBitdecaySoundBank().PlaySound(BitdecaySounds.MachoManGruntThrow);
			FaxeSoundHelper.GetInstance().PlaySound("MachoManGruntThrow");
		}
	}
}
