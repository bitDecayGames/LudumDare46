package entities;

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
            var treeX = radius * Math.cos(i * Math.PI / 2.5);
            var treeY = radius * Math.sin(i * Math.PI / 2.5);
            tree.setPosition(treeX, treeY);
            add(tree);
            trees.push(tree);
        }
        return trees;
   }
}