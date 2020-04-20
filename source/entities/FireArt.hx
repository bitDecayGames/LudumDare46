package entities;

import flixel.math.FlxPoint;
import flixel.FlxSprite;
import entities.Throwable;

class FireArt extends FlxSprite {
    public var currentAnimation = "raging";

    var hurtboxSize:FlxPoint = new FlxPoint(28, 16);
    var parent:Fire;
    public var onConsume:Throwable->Void;

    public function new(x:Float, y:Float, parent:Fire) {
        super(x, y);
        this.parent = parent;
        immovable = true;

        super.loadGraphic(AssetPaths.Fire__png, true, 32, 48);

        // an extra -2 on the y to help account for empty space at the bottom of the sprites
		offset.set(width / 2 - hurtboxSize.x / 2, height - hurtboxSize.y - 2);
        setSize(hurtboxSize.x, hurtboxSize.y);
        
        animation.add("tiny", [0, 1, 2, 3], 15);
		animation.add("regular", [4, 5, 6, 7], 15);
		animation.add("raging", [8, 9, 10, 11], 15);
        animation.play(currentAnimation);
    }

    public function consume(thing:Throwable) {
        // TODO: maybe tweak things based on what hits the flame
        parent.addTime(5);

        trace("fire.consume");
        if (onConsume != null) {
            trace("calling onConsume");
            onConsume(thing);
        } else {
            trace("killing in the name of");
            thing.kill();
        }
    }

    public function switchAnimation(newAnimation:String) {
        if (currentAnimation != newAnimation) {
            trace("switch to: " + newAnimation);
            if (newAnimation == "none") {
                kill();
            } else {
                animation.play(newAnimation);
            }
            currentAnimation = newAnimation;    
        }
    }

    override public function update(delta:Float):Void {
		super.update(delta);
    }
}