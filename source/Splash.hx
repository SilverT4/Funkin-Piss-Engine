package;

import haxe.macro.Expr.Function;
import flixel.FlxSprite;

using StringTools;

class Splash extends FlxSprite {
    public function new() {
        super();

        frames = Paths.getSparrowAtlas('noteSplashes');
		animation.addByPrefix('up', 'note impact 1 green', 24, false);
		animation.addByPrefix('right', 'note impact 1 red', 24, false);
		animation.addByPrefix('down', 'note impact 1 blue', 24, false);
		animation.addByPrefix('left', 'note impact 1 purple', 24, false);

        animation.finishCallback = function(name:String) {kill();};
    }
}