package
{
	import flash.system.Security;
    import flash.text.TextField;
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;
    import flash.net.URLLoader;
    import flash.events.Event;
    import flash.display.Sprite;
    
    public class Main extends Sprite 
    {
        private const questDataURL:String = "quest.xml";
		private var model:GameModel;
		private var view:GameView;
		private var currentScene:GameScene;
        
        public function Main() 
        {
			Security.allowDomain("*");
			
            model = new GameModel();
            
            var loader:URLLoader = new URLLoader();
            loader.addEventListener(Event.COMPLETE, fillModel);
            loader.addEventListener(IOErrorEvent.IO_ERROR, showError);
            loader.load(new URLRequest(questDataURL));
        }
        
        private function showError(event:IOErrorEvent):void
        {
            var errorText:TextField = new TextField();
            errorText.text = "Could not find source XML file";
			errorText.autoSize = flash.text.TextFieldAutoSize.LEFT;
            addChild(errorText);
        }
        
        private function fillModel(event:Event):void
        {
            model.createFromXML(XML(event.target.data));
			
			view = new GameView();
			view.addEventListener(Event.SELECT, onAnswerSelect);
			addChild(view);
			
			currentScene = model.getFirstScene();
			if (currentScene != null) view.addScene(currentScene);
        }
		
		private function onAnswerSelect(event:Event):void 
		{
			var index:int = view.selected;
			if (index < 0) return;
			var selectedAnswer:Answer = currentScene.answers[index];
			if (currentScene.condition != "")
			{
				var condition:Condition = new Condition(model.vars, currentScene.condition);
				condition.analize(Number(selectedAnswer.value));
				model.vars = condition.varaibleData;
				if (condition.nextScene != "") currentScene = model.getSceneByName(condition.nextScene);
			}
			if (selectedAnswer.next != "") currentScene = model.getSceneByName(selectedAnswer.next);
			if (currentScene == null) currentScene = model.getNextScene(model.getSceneIndexByName(currentScene.name));
			if (currentScene != null) view.addScene(currentScene);
		}
    }
}
