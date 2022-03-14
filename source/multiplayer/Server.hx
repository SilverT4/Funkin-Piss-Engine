package multiplayer;

import multiplayer.Lobby;
import flixel.FlxG;
import haxe.io.Bytes;
import udprotean.server.UDProteanClientBehavior;
import udprotean.server.UDProteanServer;

using StringTools;

class Server extends UDProteanServer {

	public function new(host:String, port:Int) {
		super(host, port, ServerBehavior);

		#if target.threaded
		sys.thread.Thread.create(() -> {
			start();

			trace("Started Server with IP: " + host + " Port: " + port);

			onClientConnected(client -> {
				trace("Some Client Connected");

				Lobby.player2.alpha = 1;
				client.send(Bytes.ofString("P1::nick::" + Player1.nick));
				client.send(Bytes.ofString("P1::ready::" + Player1.ready));
			});
			onClientDisconnected(client -> {
				trace("Some Client Disconnected");

				Lobby.player2.alpha = 0.4;
				Player2.clear();
			});

			while (true) {
				update();
			}

			stop();
		});
		#end
	}

	public function sendStringToCurClient(s:String) {
		for (client in peers)
			client.send(Bytes.ofString(s));
    }

	public function hasClients() {
		if (peers.length > 0)
			return true;
		return false;
    }
}

class ServerBehavior extends UDProteanClientBehavior {
	// Called after the constructor.
	override function initialize() { }

	override function onMessage(msg:Bytes) {
		send(msg);

		var strMsg = msg.toString();
		trace("Server got a message: " + strMsg);

		if (strMsg.contains("::")) {
			var msgSplitted = strMsg.split("::");

			var value = CoolUtil.stringToOgType(msgSplitted[2]);
			
			switch (msgSplitted[0]) {
				case "P1":
					Reflect.setField(Player1, msgSplitted[1], value);
				case "P2":
					Reflect.setField(Player2, msgSplitted[1], value);
				case "NP":
					PlayState.currentPlaystate.goodNoteHit(new Note( CoolUtil.stringToOgType(msgSplitted[1]), CoolUtil.stringToOgType(msgSplitted[2]) ), true);
			}
		}
		trace(Player2.ready);
	}

	// Called after the connection handshake.
	override function onConnect() { }

	override function onDisconnect() { }
}

