package com.subfty.apsec;
import com.subfty.sub.display.ImgSprite;
import com.subfty.sub.helpers.Vector2D;
import nme.Assets;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.media.Sound;

/**
 * ...
 * @author Filip Loster
 */

class Guy extends Sprite {
	private static var bDataPatchs:Array< Array<String> > = [["img/person_1.png", "img/terro_1.png"],
															 ["img/person_2.png", "img/terro_2.png"],
															 ["img/person_3.png", "img/terro_3.png"],
															 ["img/person_4.png", "img/terro_4.png"],
															 ["img/person_5.png", "img/terro_5.png"],
															 ["img/person_6.png", "img/terro_6.png"]];
	
	private static var bDataArray:Array< Array<BitmapData> > = null;
	
	private var img:ImgSprite;
	private var reflection:ImgSprite;
	
	public var terro:Bool;
	public var direction:Vector2D;
	
	public var GX:Float;
	public var GY:Float;
	
	private static var terro_kill:Sound;
	private static var guy_kill:Sound;
	
	private var killed:Float;
	
	public function new(parent:Sprite) {
		super();
		parent.addChild(this);
		
		this.parent = parent; 
		
		if (bDataArray == null) {
			bDataArray = new Array< Array<BitmapData>>();
		  //LOAD BITMAP DATA
			for ( i in 0 ... bDataPatchs.length) {
				var tarr:Array<BitmapData> = new Array<BitmapData>();
				for ( j in 0 ... bDataPatchs[i].length)
					tarr.push(Assets.getBitmapData(bDataPatchs[i][j]));
				
				bDataArray.push(tarr);
			}
		}
		if(terro_kill == null)
			terro_kill = Assets.getSound("sounds/terro_hit.wav");
		if(guy_kill == null)
			guy_kill = Assets.getSound("sounds/guy_hit.wav");
			
		direction = new Vector2D(0, 0);
		
		img = new ImgSprite(this);
		img.addEventListener(TouchEvent.TOUCH_TAP, onTap);
		img.addEventListener(MouseEvent.CLICK, onTap);
		
		reflection = new ImgSprite(this);
		
		this.visible = false;
	}
	
	private var bd:BitmapData;
	public function init(terro:Bool = false) {
		this.visible = true;
		this.terro = terro;
		
		direction.x = 0.1 + 0.2*Math.random();
		direction.y = 0;
		
		var c = Math.floor(Math.random() * bDataArray.length);
		bd = bDataArray[c][terro ? 1 : 0];
		
		if (Math.random() > 0.5){
			direction.x *= -1;
			GX = Main.STAGE_W;
		}else {
			GX = 0-bd.width*10;// Main.STAGE_W;
		}
		
		
		GY = Main.STAGE_H/2+30 + 250 * Math.random();
		
		
		
		img.loadBitmapData(bd);
		img.alpha = 1;
		reflection.loadBitmapData(bd);
		
		
		
		img.setRect((img.scaleX < 0) ? GX - bd.width*10: GX, 
					GY+bd.height*10, 
					bd.width * 10, bd.height * 10);
		
					
		reflection.setRect((reflection.scaleX < 0) ? GX - bd.width*10: GX, 
						   GY + img.getHeight() * 1.8+bd.height*10, 
						   bd.width * 10, bd.height * 10);
						   
		
		reflection.scaleY = -10;
		reflection.alpha = 0.1;
		
		img.alpha = 1;
		img.scaleX = direction.x > 0 ? -10 : 10;
		reflection.scaleX = direction.x > 0 ? -10 : 10;
		
		update();
		
		killed = -1;
		
	  //SORTING ACTORS
		/*var arr:Array<Guy> = new Array<Guy>();
		for (i in 0 ... parent.numChildren)
				arr.push(cast(parent.getChildAt(i), Guy));
	
		for (i in 0 ... parent.numChildren)
			parent.removeChild(arr[i]);
		
		if(arr.length > 0){
			arr.sort(spriteSort);
		
			for ( i in 0 ... arr.length) 
				parent.addChild(arr[i]);
		}*/
		var id:Int = parent.getChildIndex(this);
		while (id > 0) {
			var g:Guy = cast(parent.getChildAt(id - 1), Guy);
				
			if (g != null && g.GY > GY){
				parent.swapChildren(this, g);
				id--;
			}else
				break;
		}
		
		while (id < parent.numChildren-1) {
			var g:Guy = cast(parent.getChildAt(id + 1), Guy);
				
			if (g != null && g.GY < GY){
				parent.swapChildren(this, g);
				id++;
			}else
				break;
		}
	}
	
	private function spriteSort(a:Guy, b:Guy):Int {
		return Math.floor((a.img.getY() - b.img.getY()) * 100);
	}
	
	public function kill() {
		this.visible = false;
	}
	private function leave() {
		if (terro && Main.GAME_STARTED) {
			Main.GAME_STARTED = false;
			Main.background.explodePlane();
		}
		kill();
	}

	public function update() {
		if (Main.GUY_KILLED) {
			img.alpha = Math.max(Main.GUY_KILLED_T / 1000,0);
			reflection.alpha = Math.max(0,0.1 * Main.GUY_KILLED_T / 1000);
			return;
		}else
			img.alpha = 1;
		
		if (killed > 0) {
			img.alpha = 0.5;
			
			killed -= Main.delta;
			if (killed <= 0)
				kill();
			return;
		}
		img.scaleX = direction.x > 0 ? -10 : 10;
		reflection.scaleX = direction.x > 0 ? -10 : 10;
		
		GX += direction.x * Main.delta * (!Main.GAME_STARTED ? 4 : 1); 
		GY += direction.y * Main.delta;
		
		img.setX((img.scaleX < 0) ? GX + bd.width*10: GX);
		img.setY(GY-bd.height*10);
		
		reflection.setX((reflection.scaleX < 0) ? GX + bd.width*10: GX);
		reflection.setY(GY + img.getHeight() * 1.8 - bd.height * 10);
		
		if (direction.x > 0 && GX > Main.STAGE_W + bd.width * 10) {
			leave();
		}
		if (direction.x < 0 && GX < - bd.width * 10) {
			leave();
		}
	}
	
	private function onTap(e) {
		if (!Main.GAME_STARTED || !this.visible) return;
		if (terro) {
			terro_kill.play();
			killed = 500;
			Main.background.setScore(Main.background.score + 100);
		}else {
			guy_kill.play();
			killed = 1000;
			Main.GAME_STARTED = false;
			Main.GUY_KILLED = true;
			Main.GUY_KILLED_T = 1000;
		}
		
	}
}