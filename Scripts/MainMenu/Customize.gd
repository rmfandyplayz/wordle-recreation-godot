extends Button

func _on_pressed() -> void:
	$"../../../Customize Game Options/Blur BG".visible = true
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property($"../../../Customize Game Options/Blur BG/Panel", "scale", Vector2(1, 1), 0.25)
