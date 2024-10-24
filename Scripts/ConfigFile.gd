extends Node

#handles the logic of the config file

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("VolumeSettings", "masterVolume", 1.0)
		config.set_value("VolumeSettings", "musicVolume", 0.25)
		config.set_value("VolumeSettings", "sfxVolume", 0.2)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)

func SaveAudioSetting(key : String, value):
	config.set_value("VolumeSettings", key, value)
	config.save(SETTINGS_FILE_PATH)

func LoadAudioSettings():
	var audioSettings = {}
	for key in config.get_section_keys("VolumeSettings"):
		audioSettings[key] = config.get_value("VolumeSettings", key)
	return audioSettings
