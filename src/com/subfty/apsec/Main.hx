package com.subfty.apsec;

import com.subfty.sub.display.ImgSprite;
import com.subfty.sub.helpers.FixedAspectRatio;
import nme.Assets;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;
import nme.media.Sound;

/**
 * ...
 * @author Filip Loster
 */

class Main extends Sprite {
	
	public static var STAGE_W:Int = //1280;
									1024;
	public static var STAGE_H:Int = //768;
									600;
	public static var GAME_STARTED:Bool = false;
	public static var GUY_KILLED:Bool = false;
	public static var GUY_KILLED_T:Float = 1000;
									
	public static var aspect:FixedAspectRatio;
	
  //TIMER
	private static var prevFrame:Int = -1;
	public static var delta:Int = 0;
	
  //STAGEs
	public static var background:Background;
	public static var game:Game;
	
	var landingPlaneS:Sound;
  
	public function new() {
		super();
		#if iphone
		Lib.current.stage.addEventListener(Event.RESIZE, init);
		#else
		addEventListener(Event.ADDED_TO_STAGE, init);
		#end
		
		aspect = new FixedAspectRatio(this, STAGE_W, STAGE_H);
	}

	static public function main() {
		var stage = Lib.current.stage;
		stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
		stage.align = nme.display.StageAlign.TOP_LEFT;
		
		Lib.current.addChild(new Main());
	}
	
	private function init(e) {
		aspect.fix(null);
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, step);
		
		background = new Background(this);
		game = new Game(this);
		
		landingPlaneS = Assets.getSound("sounds/landin_plane.wav");
		startGame();
	}
	
	function step(e:Event){
		if (prevFrame < 0) prevFrame = Lib.getTimer();
		delta = Lib.getTimer() - prevFrame;
		prevFrame = Lib.getTimer();
		
		if (!GAME_STARTED && background.explosionLastDelay < 0 && !GUY_KILLED)
			startGame();
			
		if (GUY_KILLED) {
			GUY_KILLED_T -= delta;
			if (GUY_KILLED_T < -500)
				startGame();
		}
	}

  //GAME ACTIONS
	function startGame() {
		landingPlaneS.play();
		GAME_STARTED = false;
		GUY_KILLED = false;
		game.startGame();
		background.startGame(afterPlaneLanded);
	}
	function afterPlaneLanded():Void {
		GAME_STARTED = true;
	}
}