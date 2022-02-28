package;

import flixel.addons.ui.FlxUIInputText;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

class AnimationDebugCharacterSelector extends FlxState {
    public function new() {
		super();

        var info:FlxText = new FlxText();
        info.text = "Enter Character name here ex. dad";
        info.size = 50;
        info.scrollFactor.set();
        info.screenCenter(XY);
        info.y -= 100;

        input = new FlxUIInputText();
        input.size = 25;
        input.resize(25 * 20, 50);
        input.scrollFactor.set();
        input.screenCenter(XY);

        add(info);
        add(input);

        FlxG.mouse.visible = true;
    }

    override public function update(elapsed:Float) {
        input.resize(25 * 20, 50);
        super.update(elapsed);
        
        if (FlxG.keys.justPressed.ENTER) {
            FlxG.switchState(new AnimationDebug(input.text));
        }
    }

	var input:FlxUIInputText;
}