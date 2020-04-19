package entities;

import flixel.FlxSprite;

class FireArt extends FlxSprite {
    public var currentAnimation = "raging";

    public function new(x:Float, y:Float) {
		super(x, y);
    
        super.loadGraphic(AssetPaths.Fire__png, true, 32, 48);
        animation.add("tiny", [0, 1, 2, 3], 15);
		animation.add("regular", [4, 5, 6, 7], 15);
		animation.add("raging", [8, 9, 10, 11], 15);
        animation.play(currentAnimation);
    }

    public function switchAnimation(newAnimation:String) {
        if (currentAnimation != newAnimation) {
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