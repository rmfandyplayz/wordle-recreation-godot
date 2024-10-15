extends Button

var isActive : bool = false #is jumpscare currently happening?

func test() -> void:
	print('test')

func _on_pressed() -> void:
	
	if isActive == false:
		#initializations
		isActive = true
		var tween = create_tween().set_trans(Tween.TRANS_LINEAR)
		$"../../MrKinneyJumpscare".visible = true
		$"../../MrKinneyJumpscare".modulate = Color.WHITE
		
		#disable all buttons
		$"../Play".disabled = true
		$"../Play".mouse_filter = MouseFilter.MOUSE_FILTER_IGNORE
		$"../Settings".disabled = true
		disabled = true
		
		#play jumpscare audio (stop the previous one if running)
		var jumpscareAudio : AudioStreamPlayer = $"../../JumpscareAudio"
		jumpscareAudio.stop()
		jumpscareAudio.play()
		
		#mr kinney jumpscare
		tween.tween_property($"../../MrKinneyJumpscare", "modulate", Color.TRANSPARENT, 2)
		await tween.finished
		
		#re-enable all buttons
		$"../Play".mouse_filter = MouseFilter.MOUSE_FILTER_STOP
		$"../Play".disabled = false
		$"../Settings".disabled = false
		disabled = false
		
		#allow the button to be clicked again
		isActive = false
