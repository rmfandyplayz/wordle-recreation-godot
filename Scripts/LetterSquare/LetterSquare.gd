extends Panel

func _ready() -> void:
	self_modulate = Color("#67671f") #make sure all squares are that color


#sets the text and changes the color
func SetText(text : String):
	$LetterText.text = text
	$LetterText.self_modulate = Color("#000000")
	self_modulate = Color("#b8c449")
	PlayZoomInEffect()
	
	


#removes the text and changes the color
func RemoveText():
	$LetterText.text = ""
	$LetterText.self_modulate = Color("#ffffff")
	self_modulate = Color("#67671f")
	PlayZoomOutEffect()
	
	
	

#for when the letter exists and is in the right place
func SetCorrect():
	pass
	
	
#for when the letter exists but is in the wrong place
func SetExistsWrongPlace():
	pass


#for when the letter doesn't even exist in the word at all
func SetDoesntExist():
	pass


func PlayZoomInEffect():
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1)
	tween.tween_interval(0.1)
	tween.parallel().tween_property(self, "scale", Vector2(1, 1), 0.1)

func PlayZoomOutEffect():
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(0.85, 0.85), 0.1)
	tween.tween_interval(0.1)
	tween.parallel().tween_property(self, "scale", Vector2(1, 1), 0.1)
