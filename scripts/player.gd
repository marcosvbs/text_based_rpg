extends Node

class_name Player

var inventory: Array[Item] = []

func show_inventory() -> String:
	if inventory:
		var inventory_items: String
		for item in inventory:
			inventory_items += "- " + item.title + "\n"
		return "Your inventory[/color] contains the following items:\n" + inventory_items
	else:
		return "Your inventory is empty."

#func take_item(target: String) -> void:
	#if current_specting_stuff:
		#for item in current_specting_stuff.items:
			#if target.to_lower() == item.title.to_lower():
				#update_narrative("[color=" + pink_color + "]Get[/color] " + target)
				#update_narrative("You add a " + item.title + " to your inventory.")
				#current_specting_stuff.items.erase(item)
				#inventory.append(item)
				#return
				#
	#update_narrative("[color=" + pink_color + "]Get[/color] " + target)
	#update_narrative(INVALID_COMPLEMENT_MESSAGE + target)
