package com.subfty.apsec;
import com.subfty.sub.display.ImgSprite;
import nme.Assets;
import nme.display.Sprite;
import nme.events.Event;
import nme.Lib;
import nme.media.Sound;
import nme.text.Font;
import nme.text.TextField;
import nme.text.TextFormat;

/**
 * ...
 * @author Filip Loster
 */

class Background extends Sprite{

	var bgImage:ImgSprite;
	var airplane:ImgSprite;
	var explosion1:ImgSprite;
	var explosion2:ImgSprite;
	
	private var planeExplodingS:Sound;
	
  //GAME STATES
	private var animPlane:Bool = false;
	private var planeATime:Float;
	private var exploded:Bool = false;
	private var expSwitchDel:Float;
	public var explosionLastDelay:Float = 1000;
	
	public var score:Int;
  //TEXT STUFF
	public var scoreVal:TextField;
	var font:Font;
	var format:TextFormat;
	
	public function setScore(sc:Int) {
		score = sc;
		scoreVal.text = sc+"pts";
	}
	
	public function new(parent:Sprite) {
		super();
		
		parent.addChild(this);
		
		font = Assets.getFont("fonts/8bitlim.ttf");
		format = new TextFormat(font.fontName, 10, 0xffffff);
		
		bgImage = new ImgSprite(this);
		bgImage.loadImage("img/bg.png");
		bgImage.setRect(-100, -50, Main.STAGE_W+200, Main.STAGE_H+100);

		scoreVal = new TextField();
		scoreVal.defaultTextFormat = format;
		scoreVal.x = 20 * Main.aspect.scaleFactor;
		scoreVal.y = 0*Main.aspect.scaleFactor;
		scoreVal.width = 512*Main.aspect.scaleFactor;
		scoreVal.height = 200*Main.aspect.scaleFactor;
		scoreVal.text = "0pts";
		scoreVal.alpha = 0.7;
		scoreVal.selectable = false;
		scoreVal.embedFonts = true;
		scoreVal.scaleX = scoreVal.scaleY = 10 * Main.aspect.scaleFactor;
		this.addChild(scoreVal);
		
		
		airplane = new ImgSprite(this);
		airplane.loadImage("img/plane.png");
		airplane.setRect( -230 * 1.5, 150, 230, 110);
		airplane.visible = false;
		
		explosion1= new ImgSprite(this);
		explosion1.loadImage("img/explosion_1.png");
		explosion1.setRect( 150, 110, 280, 160);
		explosion1.visible = false;
		
		explosion2= new ImgSprite(this);
		explosion2.loadImage("img/explosion_2.png");
		explosion2.setRect( 150, 110, 280, 160);
		explosion2.visible = false;
		
		planeExplodingS = Assets.getSound("sounds/plane_exploded.wav");
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, step);
	}
	
	private var startGameCall:Void->Void;
	public function startGame(call:Void->Void) {
		airplane.setX(0);
		airplane.alpha = 1;
		animPlane = true;
		planeATime = 0;
		
		explosion1.visible = false;
		explosion2.visible = false;
		
		startGameCall = call;
		exploded = false;
		explosionLastDelay = 1000;
		
		setScore(0);
	}
	
	private function step(e):Void {
		if(Main.GUY_KILLED && !Main.GAME_STARTED){
			airplane.alpha = Math.max(Main.GUY_KILLED_T / 1000, 0);
			return;
		}
		
		if (animPlane) {
			planeATime += Main.delta/2000.0;
			if (planeATime > 1.0){
				planeATime = 1.0;
				animPlane = false;
			}
			airplane.visible = true;
			airplane.setX( -airplane.getWidth() * 1.5 + (Math.sin(Math.PI / 2 * planeATime)) * (170 + airplane.getWidth() * 1.5));
			
			if (startGameCall != null) {
				startGameCall();
			}
		}
		
		if (exploded) {
			expSwitchDel -= Main.delta;
			if (expSwitchDel < 0) {
				expSwitchDel = 200;
				
				if (explosion1.visible) {
					explosion1.visible = false;
					explosion2.visible = true;
				}else {
					explosion1.visible = true;
					explosion2.visible = false;
				}
			}
			
			var allGone:Bool = true;
			for (i in 0...Main.game.gOverlord.guys.length)
				if (Main.game.gOverlord.guys[i].visible){
					allGone = false;
					break;
				}
			if (allGone) {
				explosionLastDelay -= Main.delta;
				explosion1.alpha = explosionLastDelay / 1000.0;
				explosion2.alpha = explosionLastDelay / 1000.0;
			}
		}
	}
	
	public function explodePlane() {
		planeExplodingS.play();
		airplane.visible = false;
		
		exploded = true;
		expSwitchDel = 0;
		explosion1.visible = true;
		explosionLastDelay = 1000;
		
		explosion1.alpha = 1;
		explosion2.alpha = 1;
	}
}