extends Control

#extra logic for main menu that doesn't really fit anywhere else


#this region of code applies a 
#region Hover Sound Logic
var hoverSound : AudioStreamPlayer

func _ready() -> void:
	hoverSound = get_node("MainMenuSfx/UndertaleButtonHover")
	
	for button in get_tree().get_nodes_in_group("buttonHover"):
		button.connect("mouse_entered", _on_button_hover)
		
func _on_button_hover() -> void:
	hoverSound.play()
#endregion
