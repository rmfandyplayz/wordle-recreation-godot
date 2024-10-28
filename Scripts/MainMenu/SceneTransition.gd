extends Node


func _ready() -> void:
	if GlobalVariables.isSceneTransitioning == true:
		$"Background Color".modulate = Color.WHITE
		$"Background Color".visible = true
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db($"../Settings".masterVolSlider.value))
		await create_tween().tween_property($"Background Color", "modulate", Color.TRANSPARENT, 0.4).finished
		
		$"Background Color".visible = false
		GlobalVariables.isSceneTransitioning = false
