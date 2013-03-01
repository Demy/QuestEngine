package  
{
	/**
	 * ...
	 * @author Demy
	 */
	public class Condition 
	{
		private var source:String;
		private var next:String;
		private var differents:Object;
		private var variables:Object;
		private var value:Number;
		
		public function Condition(variables:Object, source:String = "") 
		{
			this.variables = variables;
			this.source = source;
		}
		
		public function get nextScene():String
		{
			return next;
		}
		
		public function get varaibleData():Object
		{
			return variables;
		}
		
		public function analize(value:Number, source:String = ""):void
		{
			this.value = value;
			if (source == "") source = this.source;
			source = removeWhilteSpaces(source);
			realize(source);
			this.value = 0;
		}
		
		private function realize(source:String):void
		{
			if (source == "") return;
			trace("source:", source);
			
			var lineIndex:int = source.indexOf(";") == -1 ? source.length : source.indexOf(";");
			while (lineIndex >= 0)
			{
				var curLine:String = source.substring(0, lineIndex);
				if (curLine.substring(0, 3) == "if(")
				{
					var ifCondition:String = getFirstCondition(curLine);
					var ifBody:String = getFirstCondition(curLine, "{", "}");
					trace("if: (" + ifCondition + ") => " + ifBody);
					trace(ifCondition + ":", isTrue(ifCondition));
					if (isTrue(ifCondition))
					{
						realize(ifBody);
					}
					curLine = curLine.substr(curLine.indexOf(ifBody) + ifBody.length);
				}
			
				var equasionIndex:int = curLine.indexOf("=");
				if (curLine.indexOf("goto") >= 0)
				{
					next = curLine.substring(curLine.indexOf("goto") + 6, curLine.lastIndexOf('"'));
					trace("next = " + next);
				}
				else if (equasionIndex > 0) 
				{
					var key:String = curLine.substring(0, equasionIndex);
					var val:String = curLine.substr(equasionIndex + 1);
					if (key == "value" && val != "value") value = Number(val);
					if (variables[key] != undefined) variables[key] = 0;
					variables[key] += ((val == "value") ? value : Number(val));
					trace(key + " => " + variables[key]);
				}
				
				source = source.substr(lineIndex + 1);
				lineIndex = source.indexOf(";");
			}
		}
		
		private function removeWhilteSpaces(source:String):String 
		{
			source = removeSymbol(source, " ");
			source = removeSymbol(source, "\n");
			source = removeSymbol(source, "\r");
			source = source.substring(source.indexOf("'") + 1, source.lastIndexOf("'"));
			return source;
		}
		
		private function removeSymbol(source:String, symbol:String):String
		{
			var index:int = source.indexOf(symbol);
			while (index >= 0)
			{
				source = source.substring(0, index) + source.substr(index + 1);
				index = source.indexOf(symbol);
			}
			return source;
		}
		
		private function isTrue(condition:String):Boolean
		{
			var conditionType:String = "==";
			var equasionIndex:int = condition.indexOf(conditionType);
			if (equasionIndex < 0) conditionType = "!=";
			equasionIndex = condition.indexOf(conditionType);
			if (equasionIndex < 0) conditionType = ">";
			equasionIndex = condition.indexOf(conditionType);
			if (equasionIndex < 0) conditionType = "<";
			equasionIndex = condition.indexOf(conditionType);
			if (equasionIndex < 0) conditionType = ">=";
			equasionIndex = condition.indexOf(conditionType);
			if (equasionIndex < 0) conditionType = "<=";
			equasionIndex = condition.indexOf(conditionType);
			if (equasionIndex < 0) return true;
			var key:String = condition.substring(0, equasionIndex);
			var val:String = condition.substr(equasionIndex + conditionType.length);
			if (key == "value") key = String(value);
			if (val == "value") val = String(value);
			if (variables[key] != undefined) key = String(variables[key]);
			if (variables[val] != undefined) val = String(variables[val]);
			if (conditionType == "==") return key == val;
			if (conditionType == "!=") return key != val;
			if (conditionType == ">") return Number(key) > Number(val);
			if (conditionType == "<") return Number(key) < Number(val);
			if (conditionType == ">=") return Number(key) >= Number(val);
			if (conditionType == "<=") return Number(key) <= Number(val);
			return true;
		}
		
		private function getFirstCondition(condition:String, openedBracket:String = "(", closedBracket:String = ")"):String 
		{
			if (condition.indexOf(openedBracket) < 0) return "";
			var brackets:int = 1;
			var subCondition:String = condition.substr(condition.indexOf(openedBracket) + 1);
			while (brackets > 0 )
			{
				var openedIndex:int = subCondition.indexOf(openedBracket);
				var closedIndex:int = subCondition.indexOf(closedBracket);
				if (openedIndex < 0 || closedIndex < openedIndex) 
				{
					if (closedIndex < 0) break;
					subCondition = subCondition.substr(closedIndex + 1);
					--brackets;
				}
				else
				{
					subCondition = subCondition.substr(openedIndex + 1);
					++brackets;
				}
			}
			if (subCondition == "") return condition;
			return condition.substring(condition.indexOf(openedBracket) + 1, condition.indexOf(subCondition) - 1);
		}
		
	}

}