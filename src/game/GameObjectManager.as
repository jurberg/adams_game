package game {

import flash.events.MouseEvent;
import flash.utils.Dictionary;
import mx.core.*;
import mx.collections.*;
import flash.display.*;
import mx.effects.easing.Bounce;
	
public class GameObjectManager {

	protected static var instance:GameObjectManager = null;
	
	public static function get Instance():GameObjectManager {
		if (instance == null) instance = new GameObjectManager();
		return instance;
	}
	
	public var backBuffer:BitmapData;
	public var clearColor:uint = 0xFF0043AB;
	
	protected var lastFrame:Date;
	protected var gameObjects:ArrayCollection = new ArrayCollection();
	protected var newGameObjects:ArrayCollection = new ArrayCollection();
	protected var removedGameObjects:ArrayCollection = new ArrayCollection();
	protected var collisionMap:Dictionary = new Dictionary();
	
	public function GameObjectManager() {
		if (instance != null) {
			throw new Error("There can only be one GameObjectManager");
		}
		backBuffer = new BitmapData(Application.application.width, Application.application.height, false);
	}
	
	public function startup():void {
		lastFrame = new Date();
	}
	
	public function shutdown():void {
		shutdownAll();
	}
	
	public function enterFrame():void {
		var thisFrame:Date = new Date();
		var seconds:Number = (thisFrame.getTime() - lastFrame.getTime()) / 1000.0;
		lastFrame = thisFrame;
		removeDeletedGameObjects();
		insertNewGameObjects();
		Level.Instance.enterFrame(seconds);
		checkCollisions();
		for each (var gameObject:GameObject in gameObjects) {
			if (gameObject.inuse) {
				gameObject.enterFrame(seconds);
			}
		}
		drawObjects();
	}
	
	public function click(event:MouseEvent):void {
		for each (var gameObject:GameObject in gameObjects) {
			if (gameObject.inuse) gameObject.click(event);
		}
	}

	public function mouseDown(event:MouseEvent):void {
		for each (var gameObject:GameObject in gameObjects) {
			if (gameObject.inuse) gameObject.mouseDown(event);
		}
	}

	public function mouseUp(event:MouseEvent):void {
		for each (var gameObject:GameObject in gameObjects) {
			if (gameObject.inuse) gameObject.mouseUp(event);
		}
	}

	public function mouseMove(event:MouseEvent):void {
		for each (var gameObject:GameObject in gameObjects) {
			if (gameObject.inuse) gameObject.mouseMove(event);
		}
	} 

	protected function drawObjects():void {
		backBuffer.fillRect(backBuffer.rect, clearColor);
		for each (var gameObject:GameObject in gameObjects) {
			if (gameObject.inuse) {
				gameObject.copyToBackBuffer(backBuffer);
			}
		}
	}
	
	public function addGameObject(gameObject:GameObject):void {
		newGameObjects.addItem(gameObject);
	}
	
	public function removeGameObject(gameObject:GameObject):void {
		removedGameObjects.addItem(gameObject);
	}
	
	protected function shutdownAll():void {
		for each (var gameObject:GameObject in gameObjects) {
			var found:Boolean = false;
			for each (var removedGameObject:GameObject in removedGameObjects) {
				if (removedGameObject == gameObject) {
					found = true;
					break;
				}
			}
			if (!found) {
				gameObject.shutdown();
			}
		}
	}
	
	protected function insertNewGameObjects():void {
		for each (var gameObject:GameObject in newGameObjects) {
			for (var i:int = 0; i < gameObjects.length; ++i) {
				if (gameObjects.getItemAt(i).zOrder > gameObject.zOrder 
					|| gameObjects.getItemAt(i).zOrder == -1) {
					break;
				}
			}
			gameObjects.addItemAt(gameObject, i);
		}
		newGameObjects.removeAll();
	}
	
	protected function removeDeletedGameObjects():void {
		for each (var removedObject:GameObject in removedGameObjects) {
			var i:int = 0;
			for (i = 0; i < gameObjects.length; ++i) {
				if (gameObjects.getItemAt(i) == removedObject) {
					gameObjects.removeItemAt(i);
					break;
				}
			}
		}
		removedGameObjects.removeAll();
	}
	
	public function addCollidingPair(collider1:String, collider2:String):void {
		if (collisionMap[collider1] == null) collisionMap[collider1] = new Array();
		if (collisionMap[collider2] == null) collisionMap[collider2] = new Array();
		collisionMap[collider1].push(collider2);
		collisionMap[collider2].push(collider1);
	}
	
	protected function checkCollisions():void {
		for (var i:int = 0; i < gameObjects.length; ++i) {
			var gameObjectI:GameObject = gameObjects.getItemAt(i) as GameObject;
			for (var j:int = 0; j < gameObjects.length; ++j) {
				var gameObjectJ:GameObject = gameObjects.getItemAt(j) as GameObject;
				var collisionNameNotNothing:Boolean = gameObjectI.collisionName != CollisionIdentifiers.NONE;
				var bothInUse:Boolean = gameObjectI.inuse && gameObjectJ.inuse;
				var collisionMapEntryExists:Boolean = collisionMap[gameObjectI.collisionName] != null;
				var testForCollision:Boolean = collisionMapEntryExists 
						&& collisionMap[gameObjectI.collisionName].indexOf(gameObjectJ.collisionName) != -1;
				if (collisionNameNotNothing && bothInUse && collisionMapEntryExists && testForCollision) {
					if (gameObjectI.CollisionArea.intersects(gameObjectJ.CollisionArea)) {
						gameObjectI.collision(gameObjectJ);
						gameObjectJ.collision(gameObjectI);
					}
				}
			}
		}
	}
	
}

}