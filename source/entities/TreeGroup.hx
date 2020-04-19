package entities;

import constants.GameConstants;
import flixel.group.FlxGroup;

class TreeGroup extends FlxTypedGroup<Tree> {
    public function new() {
        super(0);
    }

    public function spawn():Array<Tree> {
        var trees:Array<Tree> = [];

        var radius = 200;

        for (i in 1...5 + 1) {
            var tree = new Tree();
            var treeX = GameConstants.GAME_START_X + (radius * Math.cos(i * Math.PI / 2.5));
            var treeY = GameConstants.GAME_START_Y + (radius * Math.sin(i * Math.PI / 2.5));
            tree.setPosition(treeX, treeY);
            add(tree);
            trees.push(tree);
        }
        return trees;
   }
}