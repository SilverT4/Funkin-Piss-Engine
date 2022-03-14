package multiplayer;

import multiplayer.Lobby;
import multiplayer.Lobby.LobbySelectorState;
import flixel.FlxG;
import haxe.io.Bytes;
import udprotean.client.UDProteanClient;

using StringTools;

class Client {
    
	public var client:ProteanClient;
    
    public function new(ip:String, port:Int) {
		client = new ProteanClient(ip, port);

		#if target.threaded
		sys.thread.Thread.create(() -> {
			client.connect();

			trace("Connected to a Server with IP: " + ip + " Port: " + port);

			sendString('P2::nick::' + Player2.nick);

			try {
				while (true) {
					client.update();
				}
	
				client.disconnect();
			} catch (exc) {
				trace(exc);
			}
		});
		#end
    }

	public function sendString(s:String) {
        client.send(Bytes.ofString(s));
    }
}

class ProteanClient extends UDProteanClient {
	// Called after the constructor.
	override function initialize() {

    }

	override function onMessage(msg:Bytes) {
		var strMsg = msg.toString();

		trace("Client got a message: " + strMsg);

		if (strMsg.contains("::")) {
			var msgSplitted = strMsg.split("::");

			var value = CoolUtil.stringToOgType(msgSplitted[2]);
			
			switch (msgSplitted[0]) {
				case "P1":
					Reflect.setField(Player1, msgSplitted[1], value);
				case "P2":
					Reflect.setField(Player2, msgSplitted[1], value);
			}
		}
    }

	// Called after the connection handshake.
	override function onConnect() {

    }

	override function onDisconnect() {
        trace("disconnected from server");
		CoolUtil.clearMPlayers();
        FlxG.switchState(new LobbySelectorState());
    }
}
