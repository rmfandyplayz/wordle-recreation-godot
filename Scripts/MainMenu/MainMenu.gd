extends Control

#extra logic for main menu that doesn't really fit anywhere else

var hoverSound : AudioStreamPlayer

func _ready() -> void:
	#add hover sounds to buttons
	hoverSound = get_node("MainMenuSfx/UndertaleButtonHover")
	for button in get_tree().get_nodes_in_group("buttonHover"):
		button.connect("mouse_entered", _on_button_hover)
		
	#plays music after a short random period of time
	await get_tree().create_timer(RandomNumberGenerator.new().randi_range(3, 9)).timeout
	$"MainMenuMusic".play()
		
		
func _on_button_hover() -> void:
	hoverSound.play()
