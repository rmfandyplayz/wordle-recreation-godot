extends Node

#handles the logic for the volume sliders

@export var masterBusIndex : int
@export var musicBusIndex : int
@export var sfxBusIndex : int

@onready var masterVolSlider : Slider = $"Blur BG/Panel/Master Volume"
@onready var musicVolSlider : Slider = $"Blur BG/Panel/Music Volume"
@onready var sfxVolSlider : Slider = $"Blur BG/Panel/SFX Volume"

var test : AudioStreamPlayer

func _ready() -> void:
	masterBusIndex = AudioServer.get_bus_index("Master")
	musicBusIndex = AudioServer.get_bus_index("Music")
	sfxBusIndex = AudioServer.get_bus_index("SFX")
	
	#load the audio settings if a settings file exists
	var audioSettings = GlobalConfigFile.LoadAudioSettings()
	masterVolSlider.value = db_to_linear(audioSettings.masterVolume)
	AudioServer.set_bus_volume_db(masterBusIndex, audioSettings.masterVolume)
	musicVolSlider.value = db_to_linear(audioSettings.musicVolume)
	AudioServer.set_bus_volume_db(musicBusIndex, audioSettings.musicVolume)
	sfxVolSlider.value = db_to_linear(audioSettings.sfxVolume)
	AudioServer.set_bus_bypass_effects(sfxBusIndex, audioSettings.sfxVolume)
	


func _on_master_volume_drag_ended(value_changed: bool) -> void:
	var newVolume = linear_to_db(masterVolSlider.value)
	AudioServer.set_bus_volume_db(masterBusIndex, newVolume)
	GlobalConfigFile.SaveAudioSetting("masterVolume", newVolume)
	get_node("../MainMenuSfx/Aughhhhh").play()


func _on_music_volume_drag_ended(value_changed: bool) -> void:
	var newVolume = linear_to_db(musicVolSlider.value)
	AudioServer.set_bus_volume_db(musicBusIndex, newVolume)
	GlobalConfigFile.SaveAudioSetting("musicVolume", newVolume)
	get_node("../MainMenuSfx/MegalovaniaFirst4Notes").play()
	

func _on_sfx_volume_drag_ended(value_changed: bool) -> void:
	var newVolume = linear_to_db(sfxVolSlider.value)
	AudioServer.set_bus_volume_db(sfxBusIndex, newVolume)
	GlobalConfigFile.SaveAudioSetting("sfxVolume", newVolume)
	get_node("../MainMenuSfx/GetOut").play()
	
