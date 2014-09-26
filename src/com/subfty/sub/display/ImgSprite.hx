package com.subfty.sub.display;

import com.subfty.apsec.Main;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.Lib;
import nme.events.Event;

/**
 * ...
 * @author Filip Loster
 */

class ImgSprite extends Sprite{
	
	public var image : Bitmap;
	private var _x : Float;
	private var _y : Float;
	private var _width : Float;
	private var _height : Float;
	
	public function new(parent:Sprite) {
		super();
		
		parent.addChild(this);
				
		this.stage.addEventListener(Event.RESIZE, onResize);
	}
	
  //INIT FUNCTIONS
	public function loadBitmapData(data:BitmapData):Void {
		if (this.image == null){
			this.image = new Bitmap(data);
			this.addChild(image);
			
			return;
		}
			
		this.image.bitmapData = data;
		
	}
	public function loadBitmap(image:Bitmap):Void {
		this.image = image;
		if (image != null)
			this.addChild(image);
	}
	public function loadImage(image:String):Void {
		loadBitmap(new Bitmap(Assets.getBitmapData(image)));
	}
	
  //SETTERS AND GETTERS
	public function setRect(x:Float, y:Float, width:Float, height:Float) {
		this.setX(x);
		this.setY(y);
		this.setWidth(width);
		this.setHeight(height);
	}
  
	public function setWidth(width:Float):Void {
		_width = width;
		this.width = width * Main.aspect.scaleFactor;
	}
	public function getWidth() {
		return _width;
	}
	
	public function setHeight(height:Float):Void {
		_height = height;
		this.height = height * Main.aspect.scaleFactor;
	}
	public function getHeight():Float {
		return _height;
	}
	
	public function setX(x:Float):Void {
		_x = x;
		this.x = x * Main.aspect.scaleFactor;
	}
	public function getX():Float {
		return _x;
	}
	
	public function setY(y:Float):Void {
		_y = y;
		this.y = y * Main.aspect.scaleFactor;
	}
	public function getY():Float {
		return _y;
	}
	
	public function onResize(e:Event):Void {
		setWidth(_width);
		setHeight(_height);
		setX(_x);
		setY(_y);
	}
	
  //HELPERS
	public function setImgOnCenter():Void {
		image.x = -image.width / 2;
		image.y =  -image.height / 2;
	}
	
}