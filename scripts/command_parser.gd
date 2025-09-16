extends Node

class_name CommandParser

func handle_text_input(text: String) -> Dictionary:
	var command: Dictionary[String, String] = {}
	
	if text.strip_edges():
		var command_parts: PackedStringArray = text.split(" ", false, 1)
		if command_parts.size() >= 2:
			var action: String = command_parts[0].to_lower()
			var complement: String = command_parts[1].to_lower()
			
			command["action"] = action
			command["complement"] = complement
		else:
			var action: String = command_parts[0].to_lower()
			
			command["action"] = action
			command["complement"] = ""
	else:
		command["action"] = ""
		command["complement"] = ""
	
	command["raw_text"] = text
	return command
	
