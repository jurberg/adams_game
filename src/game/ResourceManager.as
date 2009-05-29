package game {
	
import flash.display.*;	
import mx.core.*;
	
public class ResourceManager {
	
	[Embed(source = "/media/stickman.gif")]
	public static var StickMan:Class;
	public static var StickManGraphics:GraphicsResource = new GraphicsResource(new StickMan(), 5, 10);

	[Embed(source = "/media/stickman_back.gif")]
	public static var StickManBack:Class;
	public static var StickManBackGraphics:GraphicsResource = new GraphicsResource(new StickManBack(), 5, 10);
	
	[Embed(source="/media/Town1.jpg")]
	public static var Town:Class;
	public static var TownGraphics:GraphicsResource = new GraphicsResource(new Town());

}
	
}