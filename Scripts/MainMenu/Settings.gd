extends Node

#handles the logic for the volume sliders

@export var masterBusIndex : int
@export var musicBusIndex : int
@export var sfxBusIndex : int

@onready var dataManager = $"../DataSaveManager"

func _ready() -> void:
	masterBusIndex = AudioServer.get_bus_index("Master")
	musicBusIndex = AudioServer.get_bus_index("Music")
	sfxBusIndex = AudioServer.get_bus_index("SFX")


func _on_master_volume_drag_ended(value_changed: bool) -> void:
	AudioServer.set_bus_volume_db(masterBusIndex, linear_to_db($"Blur BG/Panel/Master Volume".value))



func _on_music_volume_drag_ended(value_changed: bool) -> void:
	AudioServer.set_bus_volume_db(musicBusIndex, linear_to_db($"Blur BG/Panel/Music Volume".value))



func _on_sfx_volume_drag_ended(value_changed: bool) -> void:
	AudioServer.set_bus_volume_db(sfxBusIndex, linear_to_db($"Blur BG/Panel/SFX Volume".value))


#loads the settings
func LoadSettings():
	var file = "user://DataSaves/Settings.res"
	if FileAccess.file_exists(file):
		dataManager = VolumeSettings.load_from_file(file)
		ApplySettings()
	else:
		dataManager = VolumeSettings.new()
		SaveSettings()

#applies loaded settings
func ApplySettings():
	pass
	
#saves user changes
func SaveSettings():
	pass
