extends Node

var inventory: Array[Item] = []

func show_inventory() -> void:
	if inventory:
		var items_list: String = ""
		for item in inventory:
			items_list += "- " + item.title + "\n"
		update_narrative("Your inventory contains the following items:\n" + items_list)
	else:
		update_narrative("Your inventory is empty.")

func take_item(target: String) -> void:
	if current_specting_stuff:
		for item in current_specting_stuff.items:
			if target.to_lower() == item.title.to_lower():
				update_narrative("[color=" + pink_color + "]Get[/color] " + target)
				update_narrative("You add a " + item.title + " to your inventory.")
				current_specting_stuff.items.erase(item)
				inventory.append(item)
				return
				
	update_narrative("[color=" + pink_color + "]Get[/color] " + target)
	update_narrative(INVALID_COMPLEMENT_MESSAGE + target)
