package;

import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import OptionsSubState.Background;
import flixel.FlxG;
import flixel.FlxState;

class DBox extends FlxSpriteGroup {
    public var text:Alphabet;

    //STILL DOESNT WORK PROPERLY

    public function new(Text:String) {
        super();
        var box = new FlxSprite(0, 45);

        box.frames = Paths.getSparrowAtlas('dialogue/speech_bubble_talking');
        box.animation.addByPrefix('normalOpen', 'Speech Bubble Normal Open', 24, false);
        box.animation.addByIndices('normal', 'speech bubble normal', [0, 5, 10, 15], "", 6);
        box.setGraphicSize(Std.int(box.width * 0.9));

        box.animation.play('normalOpen');
        box.updateHitbox();
        box.y = FlxG.height - box.frameHeight;
        box.scrollFactor.set();
        add(box);

        box.screenCenter(X);
        box.x += 40;

        text = new Alphabet(box.x - 20, 420, Text, false, false, 0.7);
		text.scrollFactor.set();
        add(text);
    }
}

class DialogueBoxEditor extends FlxState {
    public var curText:String = "test";
    public var dBox:DBox;

    public function new() {
        super();

        var bg = new Background(FlxColor.WHITE);
        add(bg);

        dBox = new DBox(curText);
        dBox.scrollFactor.set();
        add(dBox);
    }

    override function update(elapsed) {
        super.update(elapsed);

        var letters = "abcdefghijklmnopqrstuvwxyz";

        if (FlxG.keys.justPressed.BACKSPACE) {
            curText = curText.substring(0, curText.length - 1);
            dBox.text.setText(curText);
        }

        if (FlxG.keys.justPressed.SPACE) {
            curText += " ";
            dBox.text.setText(curText);
        }

        if (FlxG.keys.justPressed.ENTER) {
            curText += "\n";
            dBox.text.setText(curText);
        }

        if (FlxG.keys.justPressed.ANY) {
            if (letters.indexOf(FlxG.keys.getIsDown()[0].ID.toString().toLowerCase()) != -1) {
                curText += FlxG.keys.getIsDown()[0].ID.toString();
                dBox.text.setText(curText);
            }
        }
    }
}