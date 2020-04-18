package entities;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

class TreeGroup extends FlxTypedGroup<FlxSprite> {
    public function new() {
        super(100);
    }

    public function spawn(numTrees: UInt) {
       for (i in 1...numTrees + 1) {
            var tree = new Tree();
            tree.x = i * 100;
            tree.y = i * 100;
            add(tree);
       }
   }
}