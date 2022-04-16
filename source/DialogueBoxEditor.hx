package;

import sys.FileSystem;
import sys.io.File;
import clipboard.Clipboard;
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
    public var dBox:DBox;
    var letters = "abcdefghijklmnopqrstuvwxyz";

    private var texts:Array<String> = ["coolswag"];
    public var curIndex:Int = 0;
    public var textsProperties:Array<String> = ["dad,false"];

    var dialoguePath:String = CoolUtil.getSongPath(PlayState.SONG.song) + "dialogue.txt";

    public function new() {
        super();

        if (FileSystem.exists(dialoguePath)) {
            var fileContent = File.getContent(dialoguePath);
            var index = -1;
            for (line in fileContent.split("\n")) {
                index++;
                var splitName:Array<String> = line.split(":");

                textsProperties[index] = splitName[1];
                texts[index] = line.substr(splitName[1].length + 2).trim();
            }
        }

        var bg = new Background(FlxColor.WHITE);
        add(bg);

        var info:FlxText = new FlxText(0, 0, 0, "", 15);
		info.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
		info.text = 
        "CTRL + ENTER - Reposition Text\n" +
        "CTRL + S - Save the dialogue\n" +
        "CTRL + F - Flip the box\n" +
        "CTRL + ARROWS - Change the 'dialogues\n'"
        ;
		// flx text is bugged with \n
		info.scrollFactor.set();
		info.y = 20;
		info.x = 10;
		add(info);

        dBox = new DBox(texts[curIndex]);
        dBox.scrollFactor.set();
        add(dBox);
    }

    override function update(elapsed) {
        super.update(elapsed);

        dBox.box.flipX = CoolUtil.strToBool(textsProperties[curIndex].split(",")[1]);

        if (FlxG.keys.pressed.CONTROL) {
            if (FlxG.keys.justPressed.LEFT && curIndex >= 1) {
                curIndex--;
                dBox.dialogues[0].setText(texts[curIndex]);
            }
            if (FlxG.keys.justPressed.RIGHT) {
                curIndex++;
                if (texts.length <= curIndex) {
                    texts[curIndex] = "coolswag" + curIndex;
                    textsProperties[curIndex] = "dad,false";
                    trace("creating dialogue at " + curIndex);
                }
                dBox.dialogues[0].setText(texts[curIndex]);
            }
            if (FlxG.keys.justPressed.F) {
                var bool:Bool = !CoolUtil.strToBool(textsProperties[curIndex].split(",")[1]);
                var splitted:Array<String> = textsProperties[curIndex].split(",");
                var finalString = splitted[0] + "," + bool;
                textsProperties[curIndex] = finalString;
                trace(textsProperties[curIndex]);
            }
            if (FlxG.keys.justPressed.ENTER) {
                dBox.dialogues[0].setText(texts[curIndex]);
            }
            if (FlxG.keys.justPressed.S) {
                var finalDialogueFile = "";
                var index = -1;
                for (text in texts) {
                    index++;
                    var formattedText = text.replace("\n", "\\n");
                    finalDialogueFile += ':${textsProperties[index]}:${formattedText}\n';
                }
                CoolUtil.writeToFile(dialoguePath, finalDialogueFile);
            }
        }
        else {
            if (FlxG.keys.justPressed.ANY) {
                if (letters.indexOf(FlxG.keys.getIsDown()[0].ID.toString().toLowerCase()) != -1) {
                    if (FlxG.keys.pressed.SHIFT) {
                        texts[curIndex] += FlxG.keys.getIsDown()[0].ID.toString().toUpperCase();
                        dBox.dialogues[0].addToText(FlxG.keys.getIsDown()[0].ID.toString().toUpperCase());
                    }
                    else {
                        texts[curIndex] += FlxG.keys.getIsDown()[0].ID.toString().toLowerCase();
                        dBox.dialogues[0].addToText(FlxG.keys.getIsDown()[0].ID.toString().toLowerCase());
                    }
                }
            }

            if (FlxG.keys.justPressed.BACKSPACE) {
                texts[curIndex] = texts[curIndex].substring(0, texts[curIndex].length - 1);
                dBox.dialogues[0].remFromText();
            }
    
            if (FlxG.keys.justPressed.SPACE) {
                texts[curIndex] += " ";
                dBox.dialogues[0].addToText(" ");
            }
    
            if (FlxG.keys.justPressed.ENTER) {
                texts[curIndex] += "\n";
                dBox.dialogues[0].addToText("\n");
            }
    
            if (FlxG.keys.pressed.ESCAPE) {
                var playstate = new PlayState();
                playstate.forceDialogueBox = true;
                LoadingState.loadAndSwitchState(playstate);
            }
        }
    }
}