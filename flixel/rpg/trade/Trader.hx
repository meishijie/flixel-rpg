package flixel.rpg.trade;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.data.TradeData;
import flixel.rpg.inventory.Inventory;
import flixel.rpg.inventory.InventoryItem;
import haxe.Unserializer;

using flixel.rpg.trade.TraderTools;

/**
 * A Trader can trade items.
 * @author Kevin
 */
class Trader
{
	private var tradeIds:Array<String>;
	private var inventory:Inventory;
	
	public static inline function getData(id:String):TradeData
	{
		return RpgEngine.current.data.getTrade(id);
	}
	
	
	/**
	 * Create a new trader. If an inventory is provided, the trader will use that as his inventory.
	 * Meaning that he will check this inventory to see if he is able to trade.
	 * If no inventory is provided, the trader has unlimited trades
	 * @param	?inventory optional inventory
	 */
	public function new(?inventory:Inventory)
	{
		// TODO hardcoded
		tradeIds = ["1"];
		
		this.inventory = inventory;		
	}
	
	/**
	 * Trade items
	 * @param	invetory
	 * @param	id trade id (defined by loadTradeData)
	 * @param	receiveCost true if this trader should receive the cost (ignored if this trader does not have an inventory)
	 * @return	return true if the trade is successful
	 */
	public function trade(buyerInventory:Inventory, id:String, receiveCost:Bool):Bool
	{
		var tradeData:TradeData = getData(id);
		
		// Test the buyer inventory
		if (!buyerInventory.canTrade(tradeData.cost, tradeData.reward))
			return false;
			
		// Test this trader's inventory (if any)
		if (inventory != null && !inventory.canTrade(tradeData.reward, tradeData.cost))
			return false;
		
		// Deduct the cost from buyer
		for (c in tradeData.cost)
			buyerInventory.removeItem(c.id, c.count);
		
		// Add the rewrads to buyer
		// Remove the rewards from trader
		for (r in tradeData.reward)
		{
			buyerInventory.addItem(InventoryItem.get(r.id, r.count));
			
			if(inventory != null)
				inventory.removeItem(r.id, r.count);
		}
		
		// Add the costs to trader
		if (receiveCost && inventory != null)		
			for (c in tradeData.cost)
				inventory.addItem(InventoryItem.get(c.id, c.count));
		
		return true;
	}
	
	/**
	 * Return a full list of trades of this trader
	 * @return
	 */
	public function getAllTrades():Array<TradeData>
	{
		var result = [];
		for (id in tradeIds)
			result.push(getData(id));
		return result;
	}
	
	/**
	 * Return a list of available trades, taking in account the buying power of 
	 * buyerInventory and the available stocks of this trader
	 * @param	buyerInventory
	 * @return
	 */
	public function getAvailableTrades(buyerInventory:Inventory):Array<TradeData>
	{
		var result = [];
		
		// For each trades
		for (id in tradeIds)
		{
			var tradeData = getData(id);
						
			// Check if the buyer has all the costs for this trade
			for (c in tradeData.cost)
				if (!buyerInventory.has(c.id, c.count))
					break;
			
			// Check if this trader has all the rewards
			if (inventory != null)
				for (r in tradeData.reward)
					if (!inventory.has(r.id, r.count))
						break;
			
			// Passed
			result.push(tradeData);
		}
		return result;
	}
	
}


