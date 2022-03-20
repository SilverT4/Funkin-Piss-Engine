package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

class AnimationDebugCharacterSelector extends FlxState {
    public function new() {
		super();

        var info:FlxText = new FlxText();
        info.text = 'Select Your Asset here';
        info.size = 50;
        info.scrollFactor.set();
        info.screenCenter(XY);
        info.y -= 100;

        var info2:FlxText = new FlxText();
        info2.text = 'If you want to select a skin choose "[character]-custom"';
        info2.size = Std.int(info.size / 2);
        info2.screenCenter(X);
        info2.y = info.y + info.height;
        
        var characters:Array<String> = CoolUtil.getCharacters();
        characters.push("bf-custom");
        characters.push("dad-custom");
        characters.push("gf-custom");
        
        charDropDown = new UIDropDownMenu(0, 0, characters, function(character:String, i) {
			FlxG.switchState(new AnimationDebug(character));
		});
        charDropDown.scrollFactor.set();
        charDropDown.screenCenter(XY);
        charDropDown.y = info2.y + info2.height + 50;

        add(info);
        add(info2);
        add(charDropDown);

        FlxG.mouse.visible = true;
    }

	var charDropDown:UIDropDownMenu;
}