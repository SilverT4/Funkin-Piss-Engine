package;

import flixel.FlxObject;
import flixel.FlxSprite;
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

        // Sets the game camera default zoom
        Lua_helper.add_callback(lua, "setDefaultCamZoom", function(zoom:Float) {
            PlayState.camZoom = zoom;
        });

        // Caches character so it doesnt lag when changing the character
        Lua_helper.add_callback(lua, "cacheCharacter", function(char:String, daChar:String) {
            PlayState.cacheCharacter(char, daChar);
        });

        // Changes character
        Lua_helper.add_callback(lua, "changeCharacter", function(char:String, newChar:String) {
            PlayState.changeCharacter(char, newChar);
		});

        // Sets the size of some sprite
        Lua_helper.add_callback(lua, "setGraphicSize", function (sprite:String, width:Int, height:Int) {
            var daSprite:FlxSprite = Reflect.field(PlayState, sprite);
            daSprite.setGraphicSize(width, height);
        });

        // Returns the x position of some object
        Lua_helper.add_callback(lua, "getPositionX", function (object:String) {
            var daSprite:FlxObject = Reflect.field(PlayState, object);
            return daSprite.x;
        });

        // Returns the y position of some object
        Lua_helper.add_callback(lua, "getPositionY", function (object:String) {
            var daSprite:FlxObject = Reflect.field(PlayState, object);
            return daSprite.y;
        });

        // Sets the position of some object
        Lua_helper.add_callback(lua, "setPosition", function (object:String, x:Int, y:Int) {
            var daSprite:FlxObject = Reflect.field(PlayState, object);
            daSprite.setPosition(x, y);
        });

        // Sets some variable in playstate
        Lua_helper.add_callback(lua, "setVariable", function(object:String, value:Dynamic) {
            Reflect.setField(PlayState, object, value);
        });

        // Returns some variable in playstate
        Lua_helper.add_callback(lua, "getVariable", function(object:String) {
            return Reflect.field(PlayState, object);
        });

        // Sets the health
        Lua_helper.add_callback(lua, "setHealth", function(object:String, value:Dynamic) {
            Reflect.setField(PlayState, object, value);
        });

        // Sets the camera position
        Lua_helper.add_callback(lua, "setCamPosition", function(cam:String, x:Float = 0, y:Float = 0) {
            if (cam == "hud") {
                PlayState.camHUD.setPosition(x, y);
            } else if (cam == "game") {
                PlayState.camFollow.setPosition(x, y);
            }
		});

        // Sets the camera zoom
        Lua_helper.add_callback(lua, "setCamZoom", function(cam:String, zoom:Float = 0) {
            if (cam == "hud") {
                PlayState.tweenCamZoom(zoom, "hud");
            } else if (cam == "game") {
                PlayState.tweenCamZoom(zoom);
            }
		});

        // Makes camera do very epic effect (i killed 20 children in africa)
        Lua_helper.add_callback(lua, "shakeCamera", function(cam:String, intensity:Float = 0, duration:Float = 0) {
            if (cam == "hud") {
                PlayState.camHUD.shake(intensity, duration);
            } else if (cam == "game") {
                PlayState.camGame.shake(intensity, duration);
            }
		});

        LuaL.dofile(lua, luaPath);
    }

    public function setVariable(name:String, value:Dynamic) {
		Convert.toLua(lua, value);
		Lua.setglobal(lua, name);
	}

    public function call(functionName:String, ?args:Array<Dynamic>) {
        Lua.getglobal(lua, functionName);

        if (args != null)
            for (s in args) {
                Convert.toLua(lua, s);
            }
        else
            args = [];
        
        Lua.pcall(lua, args.length, 1, 1);
    }

    public function close() {
        Lua.close(lua);
    }
}

class Position {
    var x:Float;
    var y:Float;
}