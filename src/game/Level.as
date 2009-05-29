package game {

import flash.events.*;
import flash.geom.*;
import flash.media.*;
import flash.net.*;
import flash.utils.*;
import mx.collections.ArrayCollection;
import mx.core.*;

public class Level {
	
	protected static var instance:Level = null;
	
	public static function get Instance():Level {
		if (instance == null) instance = new Level();
		return instance;
	}
	
	protected var totalTime:Number = 0;
	protected var background:GameObject = new GameObject();
	
	public function Level(caller:Function = null) {
		if (Level.instance != null) throw new Error("Only one Level can be created.");
	}
	
	public function startup(levelID:int):void {
		background.startupGameObject(ResourceManager.TownGraphics, new Point(), 0);
		new Player().startup();
		this.totalTime = 0;
	}
	
	public function shutdown():void { }
	
	public function enterFrame(dt:Number):void {
		totalTime += dt;
	}
	
}
	
}