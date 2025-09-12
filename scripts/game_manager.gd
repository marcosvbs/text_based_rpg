extends Node

@export var rooms: Array[Room]
@onready var narrative = %Narrative
@onready var user_input = %UserInput

var current_room: Room
var current_specting_stuff: Stuff
var is_game_started: bool = false
var turns: int = 10
var inventory: Array[Item]
var is_inventory_open: bool = false

const green_color: String = "#29D640"
const orange_color: String = "#FBB13C"
const blue_color: String = "#2892D7"
const pink_color: String = "#F46197"
const yellow_color: String = "#FAE43C"
const INTRO_MESSAGE: String = "[b][font_size=32]Welcome to Escape in 10 Turns![/font_size][/b]\nThis is a text-based RPG where every choice matters. Your mission is simple: escape the scenario in fewer than 10 turns. Each action you take will cost you 1 turn, so plan carefully.\n\nYou can choose from the following actions: [color=" + orange_color + "]Go[/color], [color=" + blue_color + "]Inspect[/color], [color=" + pink_color + "]Get[/color], Inventory and Use.\n\nWhen you’re ready, type [color=" + green_color + "]Start[/color] to begin your adventure."
const INVALID_ACTION_MESSAGE: String = "Nothing happens..."
const INVALID_COMPLEMENT_MESSAGE: String = "For a moment you feel confused... there is no "

func reset_user_input() -> void:
	user_input.clear()
	user_input.grab_focus()

func reset_narrative() -> void:
	narrative.text = ""

func update_narrative(new_text: String) -> void:
	narrative.text += "[i]" + "\n\n" + new_text + "[/i]"
	reset_user_input()

func show_current_room_description() -> void:
	update_narrative(current_room.description) 

func check_user_action(input: String) -> void:
	var input_parts: PackedStringArray = input.split(" ", false, 1)
	var input_action: String = input_parts[0].to_lower()
	
	if input_parts.size() >= 2:
		var input_complement: String = input_parts[1]
		
		if is_game_started:
			match input_action:
				"go":
					go_action(input_complement)
				"inspect":
					inspect_action(input_complement)
				"get":
					get_action(input_complement)
				_:
					update_narrative(user_input)
					update_narrative(INVALID_ACTION_MESSAGE)
	else:
		if is_game_started:
			if input_action == "inventory":
				inventory_action()
			else: 
				update_narrative(user_input)
				update_narrative(INVALID_ACTION_MESSAGE)		
		else:
			if input_action == "start":
				start_action()
		
	reset_user_input()
	
func start_action() -> void:
	is_game_started = true
	reset_narrative()
	reset_user_input()
	show_current_room_description()
	
func go_action(location: String) -> void:
	for exit in current_room.exits:
		if location.to_lower() == exit.title.to_lower():
			update_narrative("[color=" + orange_color + "]Go[/color] " + location)
			current_room = exit
			show_current_room_description()
			is_inventory_open = false
			return

	update_narrative("[color=" + orange_color + "]Go[/color] " + location)
	update_narrative(INVALID_COMPLEMENT_MESSAGE + location)

func inspect_action(target: String) -> void:
	# Check current room's title as valid target
	if target.to_lower() == current_room.title.to_lower():
		update_narrative("[color=" + blue_color + "]Inspect[/color] " + target)
		update_narrative(current_room.description)
		is_inventory_open = false
		return
	if is_inventory_open:
		for item in inventory:
			if target.to_lower() == item.title.to_lower():
				update_narrative("[color=" + blue_color + "]Inspect[/color] " + target)
				update_narrative(item.description)
				return
	else:
		# Check among stuff in current room a title as valid target
		for stuff in current_room.stuffs:
			if target.to_lower() == stuff.title.to_lower():
				current_specting_stuff = stuff
				update_narrative("[color=" + blue_color + "]Inspect[/color] " + target)
				update_narrative(stuff.description)
				is_inventory_open = false
				return
			else: 
				# Check items in current inspecting stuff a title as valid target
				if current_specting_stuff:
					for item in current_specting_stuff.items:
						if target.to_lower() == item.title.to_lower():
							update_narrative("[color=" + blue_color + "]Inspect[/color] " + target)
							update_narrative(item.description)
							is_inventory_open = false
							return
			
	update_narrative("[color=" + blue_color + "]Inspect[/color] " + target)
	update_narrative(INVALID_COMPLEMENT_MESSAGE + target)

func get_action(target: String) -> void:
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

func inventory_action() -> void:
	is_inventory_open = true
	
	if inventory:
		var inventory_items: String = ""
		for item in inventory:
			inventory_items += "- " + item.title + "\n"
		update_narrative("Your [color=" + yellow_color + "]inventory[/color] contains the following items:\n" + inventory_items)
	else:
		update_narrative("Your [color=" + yellow_color + "]inventory[/color] is empty.")
		
func _on_user_input_text_submitted(input: String):
	# Check if user input is not empty or just spaces
	if input.strip_edges():
		check_user_action(input)
	else:
		reset_user_input()

func _ready():
	narrative.text = INTRO_MESSAGE
	current_room = rooms[0]
	
