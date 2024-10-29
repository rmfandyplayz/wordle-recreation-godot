extends Node

@onready var soundList = get_children()


func FadeOutAllSounds(duration : float):
	#grab all the original db's so they can be re-applied later
	var dbList : Array = []
	
	for sound : AudioStreamPlayer in soundList:
		dbList.append(sound.volume_db)
		create_tween().tween_property(sound, "volume_db", -60, duration)
 	
	#reset the volumeDB after so the fade can be applied again
	await get_tree().create_timer(duration).timeout
	for i in len(soundList):
		soundList[i].stop()
		soundList[i].volume_db = dbList[i]
