package;

import yaml.util.ObjectMap.AnyObjectMap;

class YamlRender {

    // holy shit it works lol, good i didnt changed the data format to JSON
    // use this instead of Yaml.render because it breaks

    public var daFinalYAML = "";

	private var spaceString = " ";

    public function new(data:AnyObjectMap) {
		for (key in data.keys()) {
			var value = data.get(key);
			var valueSpace = 0;
			switch (Std.string(Type.typeof(value))) {
				case "TInt":
					//trace(key, "found integer");
					daFinalYAML += space(valueSpace) + '$key: $value\n';

				case "TBool":
					//trace(key, "found bool");
					daFinalYAML += space(valueSpace) + '$key: $value\n';

				case "TClass(String)":
					//trace(key, "found string");
					daFinalYAML += space(valueSpace) + '$key: $value\n';

				case "TClass(Array)":
					//trace(key, "found list/array");
					daFinalYAML += space(valueSpace) + '$key:\n';
					var values:Array<Dynamic> = value;
					for (val in values) {
						daFinalYAML += space(valueSpace) + '$spaceString- $val\n';
					}

				case "TClass(yaml.util.TObjectMap)":
					//trace(key, "found objectmap");
					daFinalYAML += space(valueSpace) + '$key:\n';
					iterateYAMLObjectMap(value, 1);
				
				default:
					trace("NOT RENDERING UNSUPPORTED TYPE: " + Std.string(Type.typeof(value)) + ' IN KEY: $key');
			}
		}
	}

	private function iterateYAMLObjectMap(data:AnyObjectMap, ?spaces:Int = 0) {
		for (key in data.keys()) {
			var value = data.get(key);
			var valueSpace = spaces;
			switch (Std.string(Type.typeof(value))) {
				case "TInt":
					//trace(key, "found integer");
					daFinalYAML += space(valueSpace) + '$key: $value\n';

				case "TBool":
					//trace(key, "found bool");
					daFinalYAML += space(valueSpace) + '$key: $value\n';

				case "TClass(String)":
					//trace(key, "found string");
					daFinalYAML += space(valueSpace) + '$key: $value\n';

				case "TClass(Array)":
					//trace(key, "found list/array");
					daFinalYAML += space(valueSpace) + '$key:\n';
					var values:Array<Dynamic> = value;
					for (val in values) {
						daFinalYAML += space(valueSpace) + '$spaceString- $val\n';
					}

				case "TClass(yaml.util.TObjectMap)":
					//trace(key, "found objectmap");
					daFinalYAML += space(valueSpace) + '$key:\n';
					iterateYAMLObjectMap(value, valueSpace + 1);

					/*
					for (val in values.keys()) {
						daFinalYAML += space(valueSpace) + '$val:\n';
						var mapValue = values.get(val);
					}
					*/
				
				default:
					trace("NOT RENDERING UNSUPPORTED TYPE: " + Std.string(Type.typeof(value)) + ' IN KEY: $key');
			}
		}
	}

	private function space(howMany:Int = 0) {
		var retur = "";
		for (space in 0...howMany) {
			retur += spaceString;
		}
		return retur;
	}
}