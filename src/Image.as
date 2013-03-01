package  
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author Demy
	 */
	public class Image extends Sprite
	{
		public function Image(url:String)
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, addImage);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, addErrorMessage);
			loader.load(new URLRequest(url));
		}
		
		private function addErrorMessage(event:IOErrorEvent):void 
		{
			var errorText:TextField = new TextField();
			errorText.defaultTextFormat = new TextFormat("Arial", 20, 0xCCCCCC, true);
			errorText.text = "Image file \nnot found";
			errorText.autoSize = TextFieldAutoSize.CENTER;
			if (stage != null) 
			{
				errorText.x = (stage.stageWidth - errorText.width) / 2;
				errorText.y = (stage.stageHeight - errorText.height) / 3;
			}
			addChild(errorText);
		}
		
		private function addImage(event:Event):void 
		{
			addChild((event.target as LoaderInfo).content);
		}
	}

}