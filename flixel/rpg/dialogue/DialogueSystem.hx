package flixel.rpg.dialogue;
import flixel.rpg.requirement.IRequirement;
import flixel.rpg.requirement.ItemRequirement;
import haxe.Json;

/**
 * ...
 * @author Kevin
 */
class DialogueSystem
{
	private var dialogueActions:DialogueActions;
	private var dialogues:Array<Dialogue>;
	
	public var onChange:Void->Void;
	public var current(default, null):Dialogue;
	
	public function new(data:String, dialogueActionsClass:Class<DialogueActions>, ?onChange:Void->Void) 
	{
		this.onChange = onChange;
		
		dialogueActions = Type.createInstance(dialogueActionsClass, []);
		dialogueActions.system = this;
		
		load(data);
	}
	
	private function load(data:String):Void
	{
		dialogues = [];
		
		var data:Array<DialogueData> = Json.parse(data);
		for (dialogueData in data)
		{
			//create the dialogue object
			var dialogue = new Dialogue(dialogueData.id, dialogueData.name, dialogueData.text);			
			dialogues.push(dialogue);
			
			//create the responses objects
			for (responseData in dialogueData.responses)
			{
				//map the function object
				var action = Reflect.field(dialogueActions, responseData.action);
				
				//create array of requirements
				var requirements:Array<IRequirement> = [];
				for (requirementData in responseData.requirements)
				{
					//fetch the class reference
					var type = getRequirementClass(requirementData.type);
					
					//create and push the requirement object
					requirements.push(Type.createInstance(type, requirementData.params));
				}
				
				//create and push the response object
				dialogue.responses.push(new DialogueResponse(responseData.text, action, responseData.actionParams, requirements));
			}
		}
	}
	
	public function display(id:Int):Void
	{
		setCurrent(get(id));
			
	}
	
	public function end():Void
	{
		setCurrent(null);
	}
	
	private inline function setCurrent(dialogue:Dialogue):Void
	{		
		if (current != dialogue)
		{			
			current = dialogue;
			
			if (onChange != null)
				onChange();	
		}
	}
	
	private function get(id:Int):Dialogue
	{
		for (d in dialogues)
		{
			if (d.id == id)
				return d;
		}
		return null;
	}
	
	/**
	 * Get the class reference of the specified requirement type. Currently supported type: "item" -> ItemRequirement
	 * @param	type
	 * @return
	 */
	private function getRequirementClass(type:String):Class<IRequirement>
	{
		switch(type)
		{
			case "item": 	return ItemRequirement;
			default: 		throw "Requriement type not supported";				
		}
	}
}

typedef DialogueData = 
{
	id:Int,
	name:String,
	text:String,
	responses:Array<ResponseData>
	
}

typedef ResponseData =
{
	text:String, 
	action:String, 
	actionParams:Array<Dynamic>,
	requirements:Array<RequirementData>
}

typedef RequirementData = 
{
	type:String,
	params:Array<Dynamic>
}