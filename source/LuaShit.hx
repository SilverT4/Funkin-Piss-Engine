package;

import flixel.tweens.FlxTween;
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

    // lua is currently not finished

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
            PlayState.currentPlaystate.changeCharacter(char, newChar);
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

        // Sets some variable from playstate
        Lua_helper.add_callback(lua, "setVariable", function(object:String, value:Dynamic) {
            Reflect.setField(PlayState, object, value);
        });

        // Returns some variable from playstate
        Lua_helper.add_callback(lua, "getVariable", function(object:String) {
            return Reflect.field(PlayState, object);
        });

        // Sets the player's health
        Lua_helper.add_callback(lua, "setHealth", function(value:Float) {
            Reflect.setField(PlayState.currentPlaystate, "health", value);
        });

        // Returns player's health
        Lua_helper.add_callback(lua, "getHealth", function() {
            return Reflect.field(PlayState.currentPlaystate, "health");
        });

        // Sets the camera position
        Lua_helper.add_callback(lua, "setCamPosition", function(cam:String, x:Float = 0, y:Float = 0) {
            if (cam == "hud") {
                PlayState.camHUD.setPosition(x, y);
            } else if (cam == "game") {
                PlayState.camFollow.setPosition(x, y);
            }
		});

        // Tweens the variable
        Lua_helper.add_callback(lua, "tweenVariable", function(object:String, value:Float = 0, duration:Float = 1) {
            FlxTween.num(Reflect.field(PlayState, object), value, duration, null, f -> Reflect.setField(PlayState, object, f));
        });

        // Tweens the cam angle
        Lua_helper.add_callback(lua, "tweenCamAngle", function(cam:String, value:Float = 0, duration:Float = 1) {
            if (cam == "hud") {
                FlxTween.num(PlayState.camHUD.angle, value, duration, null, f -> PlayState.camHUD.angle = f);
            } else if (cam == "game") {
                FlxTween.num(PlayState.camGame.angle, value, duration, null, f -> PlayState.camGame.angle = f);
            }
        });

        // Tweens the cam zoom
        Lua_helper.add_callback(lua, "tweenCamZoom", function(cam:String, value:Float = 0, duration:Float = 1) {
            if (cam == "hud") {
                FlxTween.num(PlayState.camHUD.zoom, value, duration, null, f -> PlayState.camHUD.zoom = f);
            } else if (cam == "game") {
                FlxTween.num(PlayState.camZoom, value, duration, null, f -> PlayState.camZoom = f);
            }
        });

        // Sets the camera angle
        Lua_helper.add_callback(lua, "setCamAngle", function(cam:String, angle:Float = 0) {
            if (cam == "hud") {
                PlayState.camHUD.angle = angle;
            } else if (cam == "game") {
                PlayState.camGame.angle = angle;
            }
        });

        // Returns the camera angle
        Lua_helper.add_callback(lua, "getCamAngle", function(cam:String) {
            if (cam == "hud") {
                return PlayState.camHUD.angle;
            } else if (cam == "game") {
                return PlayState.camGame.angle;
            }
            return 0;
        });

        // Sets the camera zoom
        Lua_helper.add_callback(lua, "setCamZoom", function(cam:String, zoom:Float = 0) {
            if (cam == "hud") {
                PlayState.tweenCamZoom(zoom, "hud");
            } else if (cam == "game") {
                PlayState.tweenCamZoom(zoom);
            }
		});

        // Return the camera zoom
        Lua_helper.add_callback(lua, "getCamZoom", function(cam:String) {
            if (cam == "hud") {
                return PlayState.camHUD.zoom;
            } else if (cam == "game") {
                return PlayState.camZoom;
            }
            return 0;
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