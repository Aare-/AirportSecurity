package com.subfty.apsec;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;

/**
 * ...
 * @author Filip Loster
 */

class Game extends Sprite{

	public var gOverlord:GuyOverlord;
	
	public function new(parent:Sprite) {
		super();
		
		parent.addChild(this);
		gOverlord = new GuyOverlord(this);
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, step);
		
		gOverlord.spawnNew();
	}
	
	private function step(e) {
		
	}
	
	public function startGame() {
		gOverlord.kill();
		gOverlord.startGame();
	}
}