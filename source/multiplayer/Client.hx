package multiplayer;

import multiplayer.Lobby.LobbySelectorState;
import multiplayer.Server.Player2;
import multiplayer.Server.Player1;
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
		trace(s);
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
			
			switch (msgSplitted[0]) {
				case "P1":
					Reflect.setField(Player1, msgSplitted[1], msgSplitted[2]);
				case "P2":
					Reflect.setField(Player2, msgSplitted[1], msgSplitted[2]);
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
