extends Button


func _on_pressed() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_property($"..", "scale", Vector2(0, 0), 0.25)
	
	await tween.finished
	$"../..".visible = false
