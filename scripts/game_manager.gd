extends Node

@export var text_interface: TextInterface
@export var command_parser: CommandParser
@export var starting_room: Room
@export var player: Player

var current_room: Room
var is_game_started: bool = false
var is_inventory_open: bool = false

const INTRO_MESSAGE: String = "[b][font_size=32]Welcome to Escape in 10 Turns![/font_size][/b]\nThis is a text-based RPG where every choice matters. Your mission is simple: escape the scenario in fewer than 10 turns. Each action you take will cost you 1 turn, so plan carefully.\n\nYou can choose from the following actions: Go, Inspect, Get, Inventory and Use.\n\nWhen you’re ready, type Start to begin your adventure."

func _on_text_input_entered(text: String) -> void:
	var command: Dictionary[String, String] = command_parser.handle_text_input(text)
	
	execute_action(command)
	
func execute_action(command: Dictionary[String, String]):
	text_interface.update_narrative(command["raw_text"])
	
	if is_game_started:
		if command["action"] == "inventory" && not command["complement"]:
			text_interface.update_narrative(player.show_inventory()) 
			is_inventory_open = true
			return
		match command["action"]:
			"go":
				go(command["complement"])
			"inspect":
				if is_inventory_open:
					for item in player.inventory:
							if item.title.to_lower() == command["complement"]:
								text_interface.update_narrative(item.inspect())
				else:
					if current_room.title.to_lower() == command["complement"]:
						text_interface.update_narrative(current_room.inspect()) 
					else:
						for item in current_room.items:
							if item.title.to_lower() == command["complement"]:
								text_interface.update_narrative(item.inspect()) 
			_:
				text_interface.update_narrative("Invalid action") 
		
		is_inventory_open = false
	else:
		if command["action"] == "start" && not command["complement"]:
			start_game()
		else:
			text_interface.update_narrative("Invalid action") 
	
func start_game():
	is_game_started = true
	text_interface.reset_narrative()
	text_interface.update_narrative(current_room.description)
	
func go(location: String) -> void:
	for exit in current_room.exits:
		if location == exit.title.to_lower():
			text_interface.update_narrative("Go " + exit.title)
			current_room = exit
			text_interface.update_narrative(current_room.inspect()) 
			return

func _ready() -> void:
	text_interface.input_text_entered.connect(_on_text_input_entered)
	text_interface.update_narrative(INTRO_MESSAGE)
	current_room = starting_room
	
