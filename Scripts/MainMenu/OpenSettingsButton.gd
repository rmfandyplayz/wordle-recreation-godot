extends Button

func _on_pressed() -> void:
	$"../../Settings/Blur BG".visible = true
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property($"../../Settings/Blur BG/Panel", "scale", Vector2(1, 1), 0.25)
	$"../../Settings/Blur BG/Panel/Close Button".disabled = false
	
#REMEMBER. SET THE SCALE TO 0, 0 AFTER!!!!
