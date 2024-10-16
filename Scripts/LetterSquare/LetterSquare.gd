extends Panel

func _ready() -> void:
	self_modulate = Color("#67671f") #make sure all squares are that color


#sets the text and changes the color
func SetText(text : String):
	$LetterText.text = text
	$LetterText.label_settings.font_color = Color("#000000")
	self_modulate = Color("#b8c449")
	PlayZoomEffect(0.2, Vector2(1.15, 1.15), false)
	
	


#removes the text and changes the color
func RemoveText():
	$LetterText.text = ""
	$LetterText.label_settings.font_color = Color("#ffffff")
	self_modulate = Color("#67671f")
	PlayZoomEffect(0.2, Vector2(0.8, 0.8), false)
	
	
	

#for when the letter exists and is in the right place
func SetCorrect():
	pass
	
	
#for when the letter exists but is in the wrong place
func SetExistsWrongPlace():
	pass


#for when the letter doesn't even exist in the word at all
func SetDoesntExist():
	pass


func PlayZoomEffect(duration : float, size : Vector2, awaitFinished : bool):
	var tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", size, duration)
	if awaitFinished == true:
		await tween.finished
	
