## About

An RPG framework based on [HaxeFlixel], including a set of essential components to build an RPG such as:
- Item/inventory/equipment system
- Trade system
- AI system
- Stats (attributes) system
- Dialog system

... and more (maybe multiplayer in the future)

## Install

flixel-rpg is still under development thus not available on haxelib yet. You may git this repo to use the library.

`haxelib git flixel-rpg https://github.com/kevinresol/flixel-rpg.git`

## Basic Usage

The core of the framework `RpgEngine`, and the most important class is `Entity` which includes most of the 
functionalities of the framework.

Very basic example:
	
```haxe

import flixel.rpg.state.GameState;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.entity.Entity;

class PlayState extends GameState
{	
	override public function create():Void
	{		
		super.create();
		
		RpgEngine.init(this);
		RpgEngine.levels.register("Level 1", new LevelOne()); //LevelOne extends Level		
		RpgEngine.levels.switchTo("Level 1");
		
		var e = new Entity();
		e.enableInventory();		
		e.enableEquipments();
		e.enableWeapon();		
		e.enableStat();
		e.enableDialogueInitializer();
		RpgEngine.levels.current.registerPlayer(e);
	}
	
	override public function update():Void
	{
		super.update();
		
		RpgEngine.collide();		
	}
}
```

[HaxeFlixel]: https://github.com/HaxeFlixel/flixel