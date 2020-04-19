package entities;

import flixel.FlxSprite;
import flixel.group.FlxGroup;

class TreeGroup extends FlxTypedGroup<Tree> {
    public function new() {
        super(0);
    }

    public function spawn(numTrees: UInt):Array<Tree> {
        var trees:Array<Tree> = [];
        for (i in 1...numTrees + 1) {
            var tree = new Tree();
            tree.setPosition((i * 100) - 50, i * 100);
            add(tree);
            trees.push(tree);
        }
        return trees;
   }
}