extends Button

## Make the default button function
##
## Send HTTP request to get a word
##
## Author(s): Jeremy


# https://random-word-api.herokuapp.com/word?length=5
func _on_pressed() -> void:
	#play sound
	get_node("../../../MainMenuSfx/StartGameSound").play()
	#scene transition + button animation + stop music
	await create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).tween_property(self, "scale", Vector2(1.2, 1.2), 0.1).finished
	create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK).tween_property(self, "scale", Vector2.ONE, 0.5)
	await get_tree().create_timer(.6).timeout
	
	$"../../..".StopMenuMusic(1.5)
	$"../../../Scene Transition/Background Color".visible = true
	create_tween().tween_property($"../../../Scene Transition/Background Color", "modulate", Color.WHITE, 0.5)
	
	
	$HTTPRequest.request_completed.connect(_on_request_completed)
	$HTTPRequest.request("https://random-word-api.herokuapp.com/word?length=5")

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse_string(body.get_string_from_utf8())
	_start_game(json[0])
	
func _start_game(word : String) -> void:
	GlobalVariables.wordChoice = word
	GlobalVariables.lives = 6
	GlobalVariables.timeLimit = 300
	
	
	
	
	#await get_tree().create_timer(RandomNumberGenerator.new().randf_range(1.6, 2.5)).timeout
	
	get_tree().change_scene_to_file("res://Scenes/GameCustomize.tscn")
