package;

import flixel.math.FlxMath;
import flixel.util.FlxTimer;
import flixel.FlxCamera;
import llua.Convert;
import llua.Lua;
import llua.LuaL;
import llua.State;

class LuaShit {
    var lua:State;
    public function new(luaPath:String) {
        lua = LuaL.newstate();
        LuaL.openlibs(lua);
        #if debug
        trace("Lua version: " + Lua.version());
        trace("LuaJIT version: " + Lua.versionJIT());
        #end
        Lua.init_callbacks(lua);

        setVariable("swagSong", PlayState.SONG);

        Lua_helper.add_callback(lua, "setCamPosition", function(x:Float = 0, y:Float = 0) {
			PlayState.camFollow.setPosition(x, y);
		});

        Lua_helper.add_callback(lua, "setCamZoom", function(zoom:Float = 0) {
            PlayState.tweenCam(zoom);
            //PlayState.camZoom = FlxMath.lerp(PlayState.camZoom, zoom, PlayState.updateElapsed * 2.3);
		});

        Lua_helper.add_callback(lua, "shakeCamera", function(cam:String, intensity:Float = 0, duration:Float = 0) {
            if (cam == "hud") {
                PlayState.camHUD.shake(intensity, duration);
            }
            else if (cam == "game") {
                PlayState.camGame.shake(intensity, duration);
            }
		});

        Lua_helper.add_callback(lua, "trace", function(s:String = "") {
            trace(s);
		});

        LuaL.dofile(lua, luaPath);
    }

    public function setVariable(name:String, value:Dynamic) {
		Convert.toLua(lua, value);
		Lua.setglobal(lua, name);
	}

    public function call(functionName:String, ?args:Array<Dynamic>) {
        Lua.getglobal(lua, functionName);
        if (args != null) {
            for (s in args) {
                Convert.toLua(lua, s);
            }
            Lua.pcall(lua, args.length, 1, 1);
        } else {
            Lua.pcall(lua, 0, 1, 1);
        }
    }

    public function close() {
        Lua.close(lua);
    }
}