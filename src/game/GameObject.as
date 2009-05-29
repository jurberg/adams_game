package game {
	
import flash.display.*;
import flash.events.*;
import flash.geom.*;

public class GameObject {

	public var position:Point = new Point();
	public var zOrder:int = 0;
	public var graphics:GraphicsResource = null;
	public var inuse:Boolean = false;
	public var collisionArea:Rectangle;
	public var collisionName:String = CollisionIdentifiers.NONE;
	
	public function GameObject() {}
	
	public function startupGameObject(graphics:GraphicsResource, position:Point, z:int = 0):void {
		if (!inuse) {
			this.graphics = graphics;
			this.zOrder = z;
			this.position = position.clone();
			this.inuse = true;
			GameObjectManager.Instance.addGameObject(this);
			setupCollision();
		}
	}
	
	public function get CollisionArea():Rectangle {
		return new Rectangle(position.x, position.y, collisionArea.width, collisionArea.height);
	}
	
	public function shutdown():void {
		if (inuse) {
			graphics = null;
			inuse = false;
			GameObjectManager.Instance.removeGameObject(this);
		}
	}
	
	public function copyToBackBuffer(db:BitmapData):void {
		db.copyPixels(graphics.bitmap, graphics.bitmap.rect, position, graphics.bitmapAlpha, new Point(), true);
	}

	public function enterFrame(dt:Number):void {}
	
	public function click(event:MouseEvent):void {}

	public function mouseDown(event:MouseEvent):void {}

	public function mouseUp(event:MouseEvent):void {}

	public function mouseMove(event:MouseEvent):void { }
	
	protected function setupCollision():void {
		collisionArea = graphics.bitmap.rect;
	}
	
	public function collision(other:GameObject):void {}

}
	
}