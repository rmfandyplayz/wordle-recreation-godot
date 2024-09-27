extends Button

var isActive : bool = false
var soundList : Array[String] = []

func _on_pressed() -> void:
	if isActive == false:
		isActive = true
		var tween = create_tween()
		$"../../MrKinneyJumpscare".visible = true
		$"../../MrKinneyJumpscare".modulate = Color.WHITE
		
		$"../Play".disabled = true
		$"../Settings".disabled = true
		disabled = true
		
		tween.tween_property($"../../MrKinneyJumpscare", "modulate", Color.TRANSPARENT, 1)
		await tween.finished
		isActive = false
		
		$"../Play".disabled = false
		$"../Settings".disabled = false
		disabled = false
		
		
		
