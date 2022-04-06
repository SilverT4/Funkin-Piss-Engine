package;

import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import OptionsSubState.Background;
import flixel.FlxG;
import flixel.FlxState;

class DBox extends DialogueBoxOg {
    public var dialogues:Array<Alphabet>;

    public function new(Text:String) {
        super(null, false);

        var splittedDialogue = CoolUtil.splitDialogue("test");

        dialogues = new Array<Alphabet>();

        var index = 0;
        for (dialogue in splittedDialogue) {
            dialogues[index] = new Alphabet(box.x + 40, 420, Text, false, false, 0.7);
            dialogues[index].box = box;
            add(dialogues[0]);
            index++;
        }
    }
}

class DialogueBoxEditor extends FlxState {
    public var curText:String = "test";
    public var dBox:DBox;

    public function new() {
        super();

        var bg = new Background(FlxColor.WHITE);
        add(bg);

        var info:FlxText = new FlxText(0, 0, 0, "", 15);
		info.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
		info.text = "CTRL + ENTER - Reposition Text\n"
        ;
		// flx text is bugged with \n
		info.scrollFactor.set();
		info.y = 20;
		info.x = 10;
		add(info);

        dBox = new DBox(curText);
        dBox.scrollFactor.set();
        add(dBox);
    }

    override function update(elapsed) {
        super.update(elapsed);

        var letters = "abcdefghijklmnopqrstuvwxyz";

        if (FlxG.keys.justPressed.BACKSPACE) {
            curText = curText.substring(0, curText.length - 1);
            dBox.dialogues[0].remFromText();
        }

        if (FlxG.keys.justPressed.SPACE) {
            curText += " ";
            dBox.dialogues[0].addToText(" ");
        }

        if (FlxG.keys.justPressed.ANY) {
            if (letters.indexOf(FlxG.keys.getIsDown()[0].ID.toString().toLowerCase()) != -1) {
                if (FlxG.keys.pressed.SHIFT) {
                    curText += FlxG.keys.getIsDown()[0].ID.toString().toUpperCase();
                    dBox.dialogues[0].addToText(FlxG.keys.getIsDown()[0].ID.toString().toUpperCase());
                }
                else {
                    curText += FlxG.keys.getIsDown()[0].ID.toString().toLowerCase();
                    dBox.dialogues[0].addToText(FlxG.keys.getIsDown()[0].ID.toString().toLowerCase());
                }
            }
        }

        if (!FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.ENTER) {
            curText += "\n";
            dBox.dialogues[0].addToText("\n");
        }

        if (FlxG.keys.pressed.CONTROL && FlxG.keys.justPressed.ENTER) {
            dBox.dialogues[0].setText(curText);
        }

        if (Controls.check(BACK)) {
            FlxG.switchState(new MainMenuState());
        }
    }
}