extends Panel

#func _ready() -> void:
	#self_modulate = Color("#67671f") #make sure all squares are that color


#sets the text and changes the color
func SetText(text : String):
	$LetterText.text = text
	$LetterText.self_modulate = Color("#000000")
	self_modulate = Color("#b8c449")
	PlayZoomInEffect(0.1)
	
	
#removes the text and changes the color
func RemoveText():
	self_modulate = Color("#67671f")
	$LetterText.text = ""
	$LetterText.self_modulate = Color("#ffffff")
	PlayZoomOutEffect(0.1)
	

#dont wanna have to do stupid get children crap
func GetText():
	return $LetterText.text


#for when the letter exists and is in the right place
func SetCorrect():
	$LetterText.self_modulate = Color("#ffffff")
	self_modulate = Color("#227ef0")
	PlayZoomInEffect(0.175)
	
	
#for when the letter exists but is in the wrong place
func SetExistsWrongPlace():
	$LetterText.self_modulate = Color("#000000")
	self_modulate = Color("#144d91")
	PlayZoomInEffect(0.175)


#for when the letter doesn't even exist in the word at all
func SetDoesntExist():
	$LetterText.self_modulate = Color("#000000")
	self_modulate = Color("#0e3361")
	PlayZoomInEffect(0.175)


func PlayZoomInEffect(duration : float):
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), duration)
	tween.tween_property(self, "scale", Vector2(1, 1), duration)

func PlayZoomOutEffect(duration : float):
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(0.85, 0.85), duration)
	tween.tween_property(self, "scale", Vector2(1, 1), duration)
