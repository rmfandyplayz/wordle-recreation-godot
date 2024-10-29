extends Button

#back length: 260
#confirm length: 365

var alreadyActive : bool = false
func _on_pressed() -> void:
	if alreadyActive == false:
		#plays animation
		alreadyActive = true
		disabled = true
		$"../../GameSfx/MogusTaskOpen".play()
		FadeOut($Text, 0.3)
		FadeOut($"Back Icon", 0.3)
		ChangeObjectSize(self, Vector2(365, size.y), 0.3)
		await get_tree().create_timer(.3).timeout

		$Text.text = "Confirm?"
		$"Back Icon".visible = false
		$"Confirm Icon".visible = true
		
		FadeIn($Text, 0.3)
		FadeIn($"Confirm Icon", 0.3)
		await get_tree().create_timer(2.7).timeout
		disabled = false
		
		#wait a few seconds, and then change it back
		await get_tree().create_timer(7.5).timeout
		alreadyActive = false
		disabled = true
		FadeOut($Text, 0.3)
		FadeOut($"Confirm Icon", 0.3)
		await get_tree().create_timer(.3).timeout
		
		$"../../GameSfx/MogusTaskClose".play()
		ChangeObjectSize(self, Vector2(260, size.y), 0.3)
		await get_tree().create_timer(.3).timeout
		
		$Text.text = "Back"
		$"Back Icon".visible = true
		$"Confirm Icon".visible = false
		
		FadeIn($Text, 0.3)
		FadeIn($"Back Icon", 0.3)
		disabled = false
	else:
		BackToMenu()

#disable music, play transition, etc.
func BackToMenu():
	var speedLines = $"../../Speed Lines".material
	create_tween().tween_property(speedLines, "shader_parameter/line_density", 0, 1)
	create_tween().tween_property($"../../Vignette", "modulate", Color.TRANSPARENT, 1)
	
	$"../../Scene Transition/Background Color".modulate = Color.TRANSPARENT
	$"../../Scene Transition/Background Color".visible = true
	$"../../WordSubmission".editable = false
	GlobalVariables.isSceneTransitioning = true
	$"../..".stopTimer = true
	
	#plays audio and fades out any sound/music that's playing
	$"../../GameSfx/MogusTaskOpen".play()
	create_tween().tween_property($"../../Scene Transition/Background Color", "modulate", Color.WHITE, 0.5)
	$"../../GameSfx".FadeOutAllSounds(1.5)
	$"../../GameSpecialMusic".FadeOutAllMusic(1.5)
	
	await get_tree().create_timer(RandomNumberGenerator.new().randf_range(1.6, 2.5)).timeout
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	
	

func FadeOut(object, duration : float):
	var tween = create_tween()
	tween.tween_property(object, "self_modulate", Color("#ffffff00"), duration)

func FadeIn(object, duration : float):
	var tween = create_tween()
	tween.tween_property(object, "self_modulate", Color("#ffffffff"), duration)

func ChangeObjectSize(object, finalSize : Vector2, duration):
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(object, "size", finalSize, duration)
