package;

import flixel.addons.ui.FlxUIInputText;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;

class DebugStageSelector extends FlxState {
    public function new() {
		super();

        var info:FlxText = new FlxText();
        info.text = 'Select Stage here';
        info.size = 50;
        info.scrollFactor.set();
        info.screenCenter(XY);
        info.y -= 100;
        
        var stages:Array<String> = CoolUtil.getStages();
        
        charDropDown = new UIDropDownMenu(0, 0, stages, function(stage:String, i) {
			FlxG.switchState(new StageDebug(stage));
		});
        charDropDown.scrollFactor.set();
        charDropDown.screenCenter(XY);
        charDropDown.y = info.y + info.height + 50;

        add(info);
        add(charDropDown);

        FlxG.mouse.visible = true;
    }

	var charDropDown:UIDropDownMenu;
}