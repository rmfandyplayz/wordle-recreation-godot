extends RichTextLabel

#handles some of the logic for the game title (pulsing to the music)

func _process(delta: float) -> void:
	rotation_degrees += 1 * delta
