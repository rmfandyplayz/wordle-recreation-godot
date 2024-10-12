extends Panel
	

func _ready() -> void:
	SetText("T")

#sets the text and changes the color
func SetText(text : String):
	$LetterText.text = text

#removes the text and changes the color
func RemoveText():
	$LetterText.text = ""
	

#for when the letter exists and is in the right place
func SetCorrect():
	pass
	
	
#for when the letter exists but is in the wrong place
func SetExistsWrongPlace():
	pass


#for when the letter doesn't even exist in the word at all
func SetDoesntExist():
	pass
