extends Node

@onready var lowHealthMusic = $LowHealth.get_children()
@onready var lowTimeMusic = $LowTime.get_children()

func FadeOutAllMusic(duration : float):
	FadeOutLowHealthMusic(duration)
	FadeOutLowTimeMusic(duration)
	

func FadeOutLowHealthMusic(duration : float):
	#grab all the original db's so they can be re-applied later
	var dbList : Array = []
	
	for music : AudioStreamPlayer in lowHealthMusic:
		dbList.append(music.volume_db)
		create_tween().tween_property(music, "volume_db", -60, duration)
 	
	#reset the volumeDB after so the fade can be applied again
	await get_tree().create_timer(duration).timeout
	for i in len(lowHealthMusic):
		lowHealthMusic[i].stop()
		lowHealthMusic[i].volume_db = dbList[i]

func FadeOutLowTimeMusic(duration : float):
	#grab all the original db's so they can be re-applied later
	var dbList : Array = []
	
	for music : AudioStreamPlayer in lowTimeMusic:
		dbList.append(music.volume_db)
		create_tween().tween_property(music, "volume_db", -60, duration)
 	
	#reset the volumeDB after so the fade can be applied again
	await get_tree().create_timer(duration).timeout
	for i in len(lowTimeMusic):
		lowTimeMusic[i].stop()
		lowTimeMusic[i].volume_db = dbList[i]
