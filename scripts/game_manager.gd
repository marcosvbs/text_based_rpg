extends Node

@export var text_interface: TextInterface
@export var command_parser: CommandParser
@export var starting_room: Room

var current_room: Room
var is_game_started: bool = false

const INTRO_MESSAGE: String = "[b][font_size=32]Welcome to Escape in 10 Turns![/font_size][/b]\nThis is a text-based RPG where every choice matters. Your mission is simple: escape the scenario in fewer than 10 turns. Each action you take will cost you 1 turn, so plan carefully.\n\nYou can choose from the following actions: Go, Inspect, Get, Inventory and Use.\n\nWhen you’re ready, type Start to begin your adventure."

func _on_text_input_entered(text: String) -> void:
	var command: Dictionary[String, String] = command_parser.handle_text_input(text)
	
	execute_action(command)
	
func execute_action(command: Dictionary[String, String]):
	if is_game_started:
		match command["action"]:
			"go":
				go(command["complement"])
			_:
				text_interface.update_narrative("Invalid action") 
	else:
		if command["action"] == "start":
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
	
