package;

import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class Splash extends FlxSprite {
    public var whaNote:Note;

    public function new(?note:Note) {
        super();

        whaNote = note;

        frames = Paths.getSparrowAtlas('noteSplashes');
		animation.addByPrefix('up', 'note impact 1 green', 24, false);
		animation.addByPrefix('right', 'note impact 1 red', 24, false);
		animation.addByPrefix('down', 'note impact 1 blue', 24, false);
		animation.addByPrefix('left', 'note impact 1 purple', 24, false);

        animation.finishCallback = function(name:String) {kill();};
    }

    public function updatePos() {
        if (whaNote != null) {
            if (whaNote.mustPress) {
                y = PlayState.currentPlaystate.playerStrums.y;
                x = PlayState.currentPlaystate.playerStrums.x + (FlxG.width / 2);
            }
            else {
                y = PlayState.currentPlaystate.dadStrums.y;
            }
        }
    }

    override function update(elapsed) {
        super.update(elapsed);

        updatePos();
    }
}