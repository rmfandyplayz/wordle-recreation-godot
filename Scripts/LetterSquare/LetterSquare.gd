extends Panel

#has getters and setters for each individual square



#sets the text and changes the color
func SetText(text : String):
	$LetterText.text = text
	$LetterText.self_modulate = Color("#000000")
	self_modulate = Color("#b8c449")
	get_node("../../../../../GameSfx/IPhoneKeyboardType").play()
	PlayZoomInEffect(0.1, Vector2(1.1, 1.1))
	
	
#removes the text and changes the color
func RemoveText():
	self_modulate = Color("#67671f")
	$LetterText.text = ""
	$LetterText.self_modulate = Color("#ffffff")
	get_node("../../../../../GameSfx/IPhoneKeyboardDelete").play()
	PlayZoomOutEffect(0.1)
	

#dont wanna have to do stupid get children crap
func GetText():
	return $LetterText.text


#for when the letter exists and is in the right place
func SetCorrect():
	$LetterText.self_modulate = Color("#ffffff")
	self_modulate = Color("#227ef0")
	get_node("../../../../../GameSfx/FullyCorrect").play()
	PlayZoomInEffect(0.175, Vector2(1.3, 1.3))
	PlayRotateShakeEffect(0.175/2, 7, 2)
	
	
#for when the letter exists but is in the wrong place
func SetExistsWrongPlace():
	$LetterText.self_modulate = Color("#000000")
	self_modulate = Color("#144d91")
	$LetterText.self_modulate = Color("#3680d9")
	get_node("../../../../../GameSfx/PartiallyCorrect").play()
	PlayZoomInEffect(0.175, Vector2(1.15, 1.15))


#for when the letter doesn't even exist in the word at all
func SetDoesntExist():
	$LetterText.self_modulate = Color("#000000")
	self_modulate = Color("#0e3361")
	get_node("../../../../../GameSfx/IncorrectUt").play()
	PlayZoomInEffect(0.175, Vector2(1.05, 1.05))




func PlayRotateShakeEffect(durationPerRotation : float, intensityAngle : float, rotateRepeatTimes : int):
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	for i in range(rotateRepeatTimes):
		tween.tween_property(self, "rotation", intensityAngle * (PI / 180), durationPerRotation)
		tween.tween_property(self, "rotation", -(intensityAngle * (PI / 180)), durationPerRotation)
	tween.tween_property(self, "rotation", 0, durationPerRotation)

func PlayZoomInEffect(duration : float, intensityVector : Vector2):
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", intensityVector, duration)
	tween.tween_property(self, "scale", Vector2.ONE, duration)

func PlayZoomOutEffect(duration : float):
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "scale", Vector2(0.85, 0.85), duration)
	tween.tween_property(self, "scale", Vector2(1, 1), duration)
