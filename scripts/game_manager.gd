extends Node

@export var text_interface: TextInterface
@export var command_parser: CommandParser
@export var starting_room: Room

var current_room: Room
var is_game_started: bool = false
#var current_specting_stuff: Stuff
var turns: int = 10


const INTRO_MESSAGE: String = "[b][font_size=32]Welcome to Escape in 10 Turns![/font_size][/b]\nThis is a text-based RPG where every choice matters. Your mission is simple: escape the scenario in fewer than 10 turns. Each action you take will cost you 1 turn, so plan carefully.\n\nYou can choose from the following actions: Go, Inspect, Get, Inventory and Use.\n\nWhen you’re ready, type Start to begin your adventure."

func _on_text_input_entered(text: String) -> void:
	var command: Dictionary[String, String] = command_parser.handle_text_input(text)
	
	execute_action(command)
	
func execute_action(command: Dictionary[String, String]):
	match command["action"]:
		"start":
			start_game()
		"go":
			go(command["complement"])
		_:
			print("ação inválida")
	
func start_game():
	is_game_started = true
	text_interface.reset_narrative()
	text_interface.update_narrative(current_room.description)
	
func go(location: String) -> void:
	for exit in current_room.exits:
		if location.to_lower() == exit.title.to_lower():
			text_interface.update_narrative("Go " + location)
			current_room = exit
			current_room.inspect()
			return

func _ready() -> void:
	text_interface.input_text_entered.connect(_on_text_input_entered)
	text_interface.update_narrative(INTRO_MESSAGE)
	current_room = starting_room

#func show_current_room_description() -> void:
	#update_narrative(current_room.description) 


#func start_action() -> void:
	#is_game_started = true
	#reset_narrative()
	#reset_user_input()
	#show_current_room_description()
	

#
	#update_narrative("[color=" + orange_color + "]Go[/color] " + location)
	#update_narrative(INVALID_COMPLEMENT_MESSAGE + location)


	
