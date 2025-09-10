extends Node

var current_room: Room
@export var rooms: Array[Room]

const green_color: String = "#29D640"
const orange_color: String = "#FBB13C"
const blue_color: String = "#2892D7"
const pink_color: String = "#F46197"

const INTRO_MESSAGE: String = "[b][font_size=32]Welcome to Escape in 10 Turns![/font_size][/b]\nThis is a text-based RPG where every choice matters. Your mission is simple: escape the scenario in fewer than 10 turns. Each action you take will cost you 1 turn, so plan carefully.\n\nYou can choose from the following actions: [color=" + orange_color + "]Go[/color], [color=" + blue_color + "]Inspect[/color], and [color=" + pink_color + "]Use[/color].\n\nWhen you’re ready, type [color=" + green_color + "]Start[/color] to begin your adventure."
const INVALID_ACTION_MESSAGE: String = "Nothing happens..."
const INVALID_COMPLEMENT_MESSAGE: String = "For a moment you feel confused... there is no "

@onready var narrative = %Narrative
@onready var user_input = %UserInput

var is_game_started: bool = false
var turns: int = 10

var inventory: Array[String] = ["Apple", "Sword"]

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

func check_user_action(user_input: String) -> void:
	var input_parts: PackedStringArray = user_input.split(" ", false, 1)
	var input_action: String = input_parts[0].to_lower()
	
	if input_parts.size() >= 2:
		var input_complement: String = input_parts[1]
		
		if is_game_started:
			match input_action:
				"go":
					go_action(input_complement)
				"inspect":
					inspect_action(input_complement)
				"inventory":
					inventory_action()
				_:
					update_narrative(user_input)
					update_narrative(INVALID_ACTION_MESSAGE)
	else:
		if input_action == "start":
			start_action()
	
	reset_user_input()
	
func go_action(location: String) -> void:
	
	for exit in current_room.exits:
		if location.to_lower() == exit.title.to_lower():
			update_narrative("[color=" + orange_color + "]Go[/color] " + location)
			current_room = exit
			show_current_room_description()
			return

	update_narrative("[color=" + orange_color + "]Go[/color] " + location)
	update_narrative(INVALID_COMPLEMENT_MESSAGE + location)

func inspect_action(target: String) -> void:
	for stuff in current_room.stuffs:
		if target.to_lower() == stuff.title.to_lower():
			update_narrative("[color=" + blue_color + "]Inspect[/color] " + target)
			update_narrative(stuff.description)
			return
			
	update_narrative("[color=" + blue_color + "]Inspect[/color] " + target)
	update_narrative(INVALID_COMPLEMENT_MESSAGE + target)

func inventory_action() -> void:
	var inventory_items: String = "You open your inventory and see the following items:\n"
	
	for item in inventory:
		inventory_items += "- " + item + "\n"
		
	update_narrative(inventory_items)

func start_action() -> void:
	is_game_started = true
	reset_narrative()
	reset_user_input()
	show_current_room_description()
	
func _on_user_input_text_submitted(user_input: String):
	# Check if user input is not empty or just spaces
	if user_input.strip_edges():
		check_user_action(user_input)
	else:
		reset_user_input()

func _ready():
	narrative.text = INTRO_MESSAGE
	current_room = rooms[0]
	
