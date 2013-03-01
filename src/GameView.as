package  
{
	import com.greensock.TweenMax;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Demy
	 */
	public class GameView extends Sprite
	{
		private var currentAnswer:int;
		private var oldScene:Sprite;
		private var newScene:Sprite;
		
		public function GameView()
		{
			currentAnswer = -1;
		}
		
		public function get selected():int
		{
			return currentAnswer;
		}
		
		public function addScene(sceneData:GameScene):void
		{
			var newSceneView:Sprite = new Sprite();
			
			if (sceneData.backgroundColor != 0 && stage != null) 
			{
				newSceneView.graphics.beginFill(sceneData.backgroundColor);
				newSceneView.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
				newSceneView.graphics.endFill();
			}
			if (sceneData.backgroundImage != "") newSceneView.addChild(new Image(sceneData.backgroundImage));
			if (sceneData.backgroundText != "") 
			{
				var text:flash.text.TextField = new TextField();
				text.defaultTextFormat = new TextFormat("Arial", 20, 0x808080, true);
				text.text = sceneData.text;
				text.autoSize = TextFieldAutoSize.CENTER;
				newSceneView.addChild(text);
				if (stage != null)
				{
					text.x = (stage.stageWidth - text.width) / 2;
					text.y = (stage.stageHeight - text.height) / 3;
				}
			}
			if (sceneData.text != "" || sceneData.answers.length > 0)
			{
				var textBlock:DisplayObject = createTextBlock(sceneData.text, sceneData.answers);
				newSceneView.addChild(textBlock);
				if (stage != null) textBlock.y = stage.stageHeight - textBlock.height;
			}
			newSceneView.alpha = 0;
			addChild(newSceneView);
			oldScene = newScene;
			newScene = newSceneView;
			if (oldScene != null) new TweenMax(oldScene, 0.3, { alpha: 0 } );
			new TweenMax(newSceneView, 0.3, { alpha: 1, onComplete: removeOldScene } );
		}
		
		private function removeOldScene():void 
		{
			if (oldScene != null) removeChild(oldScene);
		}
		
		private function createTextBlock(text:String, answers:Vector.<Answer>):Sprite
		{
			var textBlock:flash.display.Sprite = new flash.display.Sprite();
				
			var mainText:DisplayObject = createText(text, true);
			mainText.x = 10;
			mainText.y = 10;
			textBlock.addChild(mainText);
			textBlock.graphics.lineStyle(1, 0xC0C0C0, 0.7);
			if (stage != null)
			{
				textBlock.graphics.moveTo(0, mainText.y + mainText.height + 10);
				textBlock.graphics.lineTo(stage.stageWidth, mainText.y + mainText.height + 10);
			}
			
			var i:int = 0;
			while (i < answers.length)
			{
				var answerText:Sprite = createText(answers[i].text);
				answerText.x = 10;
				answerText.y = textBlock.height + 15;
				textBlock.addChild(answerText).name = "Answer" + i;
				answerText.buttonMode = true;
				answerText.addEventListener(MouseEvent.CLICK, dispatchAnswerSelect);
				answerText.addEventListener(MouseEvent.ROLL_OVER, highlightText);
				answerText.addEventListener(MouseEvent.ROLL_OUT, normalizeText);
				++i;
			}
			
			textBlock.graphics.beginFill(0xFFFFFF, 0.7);
			textBlock.graphics.drawRect(0, 0, textBlock.width + 20, textBlock.height + 20);
			
			return textBlock;
		}
		
		private function normalizeText(e:MouseEvent):void 
		{
			e.currentTarget.filters = [];
		}
		
		private function highlightText(e:MouseEvent):void 
		{
			e.currentTarget.filters = [new GlowFilter(0xFFFF00, 0.3)];
		}
		
		private function dispatchAnswerSelect(e:MouseEvent):void 
		{
			var index:int = int(e.currentTarget.name.substr(6));
			currentAnswer = index;
			dispatchEvent(new Event(Event.SELECT));
		}
		
		private function createText(text:String, isMainText:Boolean = false):Sprite
		{
			var result:flash.display.Sprite = new flash.display.Sprite();
			var textField:TextField = new TextField();
			textField.defaultTextFormat = new TextFormat("Arial", isMainText ? 16 : 14, 0x3F3F3F, isMainText);
			textField.text = text;
			if (stage != null) textField.width = stage.stageWidth - 20;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.mouseEnabled = false;
			result.addChild(textField)
			result.graphics.beginFill(0xFFFFFF, 0);
			result.graphics.drawRect(0, 0, textField.width, textField.height);
			result.graphics.endFill();
			return result;
		}
	}


}