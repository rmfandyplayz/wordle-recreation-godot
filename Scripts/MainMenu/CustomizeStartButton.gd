extends Button

@onready var wordChoice : String
@onready var lives : int = 0 #0 for no limit
@onready var timeLimit : int = 0 #0 for no limit

@onready var gameCustomizeScene = preload("res://Scenes/GameCustomize.tscn").instantiate()

var validationRequirements : Array = [0, 0, 0]
#validatonRequirements[0] is for wordChoice, [1] is for lives, and [2] is for time limit



func _on_word_choice_input_text_changed(new_text: String) -> void:
	if new_text.length() >= 2:
		wordChoice = new_text
		validationRequirements[0] = 1
		StartButtonValidation()
	else:
		wordChoice = ""
		validationRequirements[0] = 0
		StartButtonValidation()


func _on_lives_input_text_changed(new_text: String) -> void:
	var numLives : int = new_text.to_int()
	
	if numLives == 0 or numLives >= 1:
		lives = numLives
		validationRequirements[1] = 1
		StartButtonValidation()
	else:
		lives = -1
		validationRequirements[1] = 0
		StartButtonValidation()


func _on_time_limit_input_text_changed(new_text: String) -> void:
	var timeParts # can be an array or int. this is the one time i kinda like static typing
	var totalSeconds : int = 0
	
	#player can type hh:mm:ss, mm:ss, or pure seconds. cases are handled here.
	#only will be handled if timeParts ends up being a list, aka player typed in hh:mm:ss or mm:ss
	if new_text.contains(":"):
		timeParts = new_text.split(":")
	
		match timeParts.size():
			2:  # mm:ss
				var minutes = int(timeParts[0])
				var seconds = int(timeParts[1])
				if (minutes < 0 or minutes >= 60 or seconds < 0 or seconds >= 60) == false:
					totalSeconds = minutes * 60 + seconds
			3:  # hh:mm:ss
				var hours = int(timeParts[0])
				var minutes = int(timeParts[1])
				var seconds = int(timeParts[2])
				if (minutes < 0 or minutes >= 60 or seconds < 0 or seconds >= 60) == false:
					totalSeconds = hours * 3600 + minutes * 60 + seconds
	#for the scenario where player types in some string without ":" where it will be converted into pure seconds.
	else:
		timeParts = int(new_text)
		totalSeconds = timeParts
	
	#button enable/disable logic
	if(totalSeconds > 0 or totalSeconds == -1):
		timeLimit = totalSeconds
		validationRequirements[2] = 1
		StartButtonValidation()
	else	:
		timeLimit = 0
		validationRequirements[2] = 0
		StartButtonValidation()


#handles logic for when the button is actually pressed.
#aka play animations, change the scenes and bring data over
func _on_pressed() -> void:
	GlobalVariables.wordChoice = wordChoice
	GlobalVariables.lives = lives
	GlobalVariables.timeLimit = timeLimit
	
	#disable all the buttons
	disabled = true
	$"Default Text".self_modulate = Color("707070")
	$"Default Icon".self_modulate = Color("707070")
	$"../Close Button".disabled = true
	$"../../../../Buttons/Play".disabled = true
	$"../../../../Buttons/Settings".disabled = true
	$"../../../../Buttons/Mr Kinney Jumpscare".disabled = true
	$"../../../../Buttons/Play/Default Preset".disabled = true
	$"../../../../Buttons/Play/Customize".disabled = true
	
	#play sound
	get_node("../../../../MainMenuSfx/StartGameSound").play()
	
	#scene transition + button animation + stop music
	await create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).tween_property(self, "scale", Vector2(1.2, 1.2), 0.1).finished
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).tween_property(self, "scale", Vector2.ONE, 0.5)
	await get_tree().create_timer(.6).timeout
	
	$"../Close Button".emit_signal("pressed")
	await get_tree().create_timer(0.4).timeout
	$"../../../..".StopMenuMusic(1.5)
	$"../../../../Scene Transition/Background Color".visible = true
	create_tween().tween_property($"../../../../Scene Transition/Background Color", "modulate", Color.WHITE, 0.5)
	
	await get_tree().create_timer(RandomNumberGenerator.new().randf_range(1.6, 2.5)).timeout
	
	get_tree().change_scene_to_file("res://Scenes/GameCustomize.tscn")


#checks whether or not all the input fields have valid properties
func StartButtonValidation():
	if validationRequirements.count(1) == 3:
		#enable the button to be clicked
		disabled = false
		$"Default Text".self_modulate = Color("ffffff")
		$"Default Icon".self_modulate = Color("ffffff")
	else: 
		disabled = true
		$"Default Text".self_modulate = Color("707070")
		$"Default Icon".self_modulate = Color("707070")
		
