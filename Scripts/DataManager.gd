extends Resource

@export var masterVolume : float
@export var musicVolume : float
@export var SFXVolume : float


func SaveToFile(path : String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_var(self)
	file.close()
	
func LoadFromFile(path : String) -> Resource:
	var file = FileAccess.open(path, FileAccess.READ)
	var data = file.get_var()
	file.close()
	return data
