package flixel.rpg.trade;
import flixel.rpg.core.Data;
import flixel.rpg.core.Factory;
import flixel.rpg.core.RpgEngine;
import flixel.rpg.inventory.Inventory;

using flixel.rpg.trade.TraderTools;
/**
 * A Trader can trade items.
 * @author Kevin
 */
class Trader
{
	private var tradeIds:Array<Int>;
	private var inventory:Inventory;
	
	/**
	 * Create a new trader. If an inventory is provided, the trader will use that as his inventory.
	 * Meaning that he will check this inventory to see if he is able to trade.
	 * @param	?inventory
	 */
	public function new(?inventory:Inventory)
	{
		// TODO hardcoded
		tradeIds = [1];
		
		this.inventory = inventory;		
	}
	
	/**
	 * Trade items
	 * @param	invetory
	 * @param	id trade id (defined by loadTradeData)
	 * @return	return true if the trade is successful
	 */
	public function trade(buyerInventory:Inventory, id:Int):Bool
	{
		var tradeData:TradeData = RpgEngine.data.getTradeData(id);
		
		// Test the buyer inventory
		if (!buyerInventory.canTrade(tradeData.cost, tradeData.reward))
			return false;
			
		// Test this trader's inventory (if any)
		if (inventory != null && !inventory.canTrade(tradeData.reward, tradeData.cost))
			return false;
		
		// Deduct the cost from buyer
		for (c in tradeData.cost)
			buyerInventory.removeItem(c.id, c.count);
		
		// Add the traded items to buyer
		// Remove the traded items from trader
		for (r in tradeData.reward)
		{
			buyerInventory.addItem(RpgEngine.factory.createInventoryItem(r.id, r.count));
			
			if(inventory != null)
				inventory.removeItem(r.id, r.count);
		}
		
		// Add the cost to trader
		if (inventory != null)		
			for (c in tradeData.cost)
				inventory.addItem(RpgEngine.factory.createInventoryItem(c.id, c.count));
		
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
			result.push(RpgEngine.data.getTradeData(id));
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
			var tradeData = RpgEngine.data.getTradeData(id);
						
			// Check if the buyer has all the costs for this trade
			for (c in tradeData.cost)
				if (!buyerInventory.has(c.id, c.count))
					break;
			
			if (inventory != null)
				for (r in tradeData.reward)
					if(inventory.has(r.id, r.
			
			// Passed
			result.push(tradeData);
		}
		return result;
	}
	
}
