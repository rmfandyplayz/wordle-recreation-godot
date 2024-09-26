extends Button

@export var tweenDuration : float
@export var tweenIntensity : float

var button = self

func _on_mouse_entered() -> void:
	button.pivot_offset = button.size / 2
	#button.
	var tween = create_tween().set_trans(Tween.TRANS_CIRC)

	tween.tween_property(self, "size", Vector2.ONE * tweenIntensity, tweenDuration)

func _on_mouse_exited() -> void:
	button.pivot_offset = button.size / 2
	var tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	
	tween.tween_property(self, "scale", Vector2.ONE, tweenDuration)
