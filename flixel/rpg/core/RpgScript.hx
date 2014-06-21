package flixel.rpg.core;
import flixel.math.FlxMath;
import flixel.rpg.entity.StateSwitch.GroupMode;
import flixel.rpg.entity.Toggle.ToggleState;
import hscript.Expr.Error;
import hscript.Interp;
import hscript.Parser;
import openfl.Assets;

/**
 * Scripting Engine
 * @author Kevin
 */
class RpgScript
{
	public static var parser = new Parser();
	
	public var variables(get, never):Map<String, Dynamic>;
	
	private var interp:Interp;

	public function new() 
	{
		interp = new NewInterp();	
		interp.variables.set("RpgEngine", RpgEngine);
		interp.variables.set("FlxMath", FlxMath);
		interp.variables.set("Assets", Assets);
		interp.variables.set("FlxG", FlxG);
		interp.variables.set("ToggleState", ToggleState); //TODO remove this?
		interp.variables.set("GroupMode", GroupMode); //TODO remove this?
		
	}
	
	public function execute(script:String):Dynamic
	{
		try
		{
			var ast = parser.parseString(script);
			return interp.execute(ast);		
		}
		catch (e:Error)
		{
			trace(e, " at line " + parser.line + " of: \n" + script);
			return null;
		}
	}
	
	private inline function get_variables():Map<String, Dynamic> 
	{
		return interp.variables;
	}
}

/**
 * Go thorugh getters/setters when accessing properties (not a default feature in the original Interp)
 */
private class NewInterp extends Interp
{
	override function get( o : Dynamic, f : String ) : Dynamic {
        if( o == null ) throw hscript.Expr.Error.EInvalidAccess(f);
        return Reflect.getProperty(o,f);
    }

    override function set( o : Dynamic, f : String, v : Dynamic ) : Dynamic {
        if( o == null ) throw hscript.Expr.Error.EInvalidAccess(f);
        Reflect.setProperty(o,f,v);
        return v;
    }
}