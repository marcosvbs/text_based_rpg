extends PanelContainer

class_name TextInterface

@onready var narrative = %Narrative
@onready var user_input = %UserInput

signal input_text_entered(text: String)

func update_narrative(new_text: String) -> void:
	narrative.text += "\n\n" + new_text

func reset_user_input() -> void:
	user_input.clear()
	user_input.grab_focus()

func reset_narrative() -> void:
	narrative.text = ""
	
func _on_user_input_text_submitted(new_text: String) -> void:
	emit_signal("input_text_entered", new_text)
	reset_user_input()
	
