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
                PlayState.currentPlaystate.bfStrumLineNotes.forEach(function(spr:FlxSprite) {
                    if (Math.abs(whaNote.noteData) == spr.ID) {
                        y = spr.y;
                        x = spr.x;
                        return;
                    }
                });
            }
            else {
                PlayState.currentPlaystate.dadStrumLineNotes.forEach(function(spr:FlxSprite) {
                    if (Math.abs(whaNote.noteData) == spr.ID) {
                        y = spr.y;
                        x = spr.x;
                        return;
                    }
                });
            }
        }
    }

    override function update(elapsed) {
        super.update(elapsed);

        updatePos();
    }
}