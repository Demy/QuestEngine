package  
{
	import flash.events.EventDispatcher;
	/**
	 * ...
	 * @author Demy
	 */
	public class GameModel extends EventDispatcher
	{
		private var scenes:Vector.<GameScene>;
		private var variables:Object;

		public function GameModel()
		{
			scenes = new Vector.<GameScene>();
			variables = new Object();
		}
		
		public function createFromXML(xml:XML):void
		{
			for each (var variableXML:XML in xml.vars.*)
			{
				variables[variableXML.@name] = variableXML.@value;
			}
			for each (var sceneXML:XML in xml.scenes.*)
			{
				var newScene:GameScene = new GameScene(sceneXML.@name);
				if (sceneXML.image.@color != "") newScene.backgroundColor = uint(sceneXML.image.@color);
				if (sceneXML.image.@src != "") newScene.backgroundImage = sceneXML.image.@src;
				if (sceneXML.image.@text != "") newScene.backgroundText = sceneXML.image.@text;
				newScene.text = sceneXML.text;
				for each (var answerXML:XML in sceneXML.answers.*)
				{
					var newAnswer:Answer = new Answer();
					if (answerXML.@id != "") newAnswer.id = answerXML.@id;
					if (answerXML.@value != "") newAnswer.value = answerXML.@value;
					if (answerXML.@next != "") newAnswer.next = answerXML.@next;
					newAnswer.text = answerXML;
					newScene.answers.push(newAnswer);
				}
				newScene.condition = sceneXML.condition;
				scenes.push(newScene);
			}
		}

		public function getSceneByName(name:String):GameScene
		{
			var curIndex:int = getSceneIndexByName(name);
			if (curIndex < 0) return null;
			return scenes[curIndex];
		}

		public function getSceneIndexByName(name:String):int
		{
			var i:int = scenes.length;
			while (i--)
			{
				var scene:GameScene = scenes[i];
				if (scene.name == name) return i;
			}
			return -1;
		}

		public function getNextScene(curIndex:int):GameScene
		{
			if (curIndex < 0 || curIndex > scenes.length - 2) return null;
			return scenes[curIndex + 1];
		}

		public function getNextSceneByName(currentName:String):GameScene
		{
			var curIndex:int = getSceneIndexByName(currentName);
			if (curIndex < 0 || curIndex > scenes.length - 2) return null;
			return scenes[curIndex + 1];
		}
		
		public function getFirstScene():GameScene
		{
			if (scenes.length == 0) return null;
			return scenes[0];
		}
		
		public function get vars():Object 
		{
			return variables;
		}
		
		public function set vars(value:Object):void 
		{
			variables = value;
		}
	}

}