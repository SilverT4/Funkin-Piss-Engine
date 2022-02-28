package;

import haxe.io.Bytes;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class SysFile {
    public static function exists(path:String):Bool {
        #if sys
        return FileSystem.exists(path);
        #end

        return false;
    }

    public static function getBytes(path:String):Bytes {
        #if sys
        return File.getBytes(path);
        #end

        return null;
    }

    public static function getContent(path:String):String {
        #if sys
        return File.getContent(path);
        #end

        return null;
    }

    public static function readDirectory(path:String):Array<String> {
        #if sys
        return sys.FileSystem.readDirectory(path);
        #end

        return [];
    }

	public static function isDirectory(path:String):Bool {
        #if sys
        return sys.FileSystem.isDirectory(path);
        #end

        return false;
	}
}