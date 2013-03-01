package  
{
	/**
	 * ...
	 * @author Demy
	 */
	public class GameScene
	{
		public var name:String;
		public var backgroundImage:String;
		public var backgroundColor:uint;
		public var backgroundText:String;
		public var text:String;
		public var answers:Vector.<Answer>;
		public var condition:String;        

		public function GameScene(name:String)
		{
			this.name = name;
			answers = new Vector.<Answer>();
		}
	}

}