package com.subfty.apsec;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;

/**
 * ...
 * @author Filip Loster
 */

class GuyOverlord extends Sprite{

	public var guys:Array<Guy> = null;
	private var spawnDelay:Float;
	private var terroSpawnDelay:Float;
	
	public function new(parent:Sprite) {
		super();
		parent.addChild(this);
		
		guys = new Array<Guy>();
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, step);
	}
	
	public function spawnNew(terro:Bool = false) {
		for (i in 0... guys.length) {
			if (!guys[i].visible) {
				guys[i].init(terro);
				return;
			}
		}
		
		guys.push(new Guy(this));
		spawnNew(terro);
	}
	
	public function kill() {
		for (i in 0... guys.length)
			guys[i].kill();
		
	}
	
	public function startGame() {
		spawnDelay = 1000;
		terroSpawnDelay = 1000;
	}
	
	private function step(e) {
		for (i in 0 ... guys.length)
			if (guys[i].visible) 
				guys[i].update();
				
		if (!Main.GAME_STARTED) return;
		
		spawnDelay -= Main.delta;
		if (spawnDelay < 0) {
			spawnDelay = 1000;
			spawnNew(false);
		}
		
		terroSpawnDelay -= Main.delta;
		if ( terroSpawnDelay < 0 ) {
			terroSpawnDelay = 1000;
			spawnNew(true);
		}
		
	  //UPDATE RENDER ORDER
		//TODO: how?!
	}
}