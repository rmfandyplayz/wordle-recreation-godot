extends CenterContainer

@onready var wordLength : int = GlobalVariables.wordChoice.length()

@onready var letterSquare = preload("res://Scenes/NodeCollections/LetterSquare.tscn")
@onready var letterSquareParent = $Grid

@onready var scrollRect : ScrollContainer = get_node("../../")

var currentSquarePosition : int = 0 #for use in changeSquaresText as an index number type thing
var currentSquareNumber : int = 0 #for use in cloning

var currentCorrectPitch : int = 1 #max 1.5 - determines the pitch of the sound for getting a letter fully correct
var correctLetterSFX : AudioStreamPlayer #the sfx for the correct sound. correlates to the above



func _ready() -> void:
	correctLetterSFX = get_node("../../../GameSfx/FullyCorrect")


#clones the number of squares per row according to the word length from the global variables
func CloneSquares(cloneAmount : int):
	#clone squares (but dont make them visible)
	for i in range(cloneAmount):
		var newSquare = letterSquare.instantiate()
		letterSquareParent.add_child(newSquare)
		newSquare.name = "LetterSquare%d" % currentSquareNumber
		currentSquareNumber += 1
	
	
	var scrolled : bool = false #did the scrollcontainer already scroll?
	
	#fade squares in
	var squares = letterSquareParent.get_children()
	for i in squares:
		var tween = create_tween()
		tween.tween_property(i, "self_modulate", Color("67671fff"), .8)
		if scrolled == false:
			scrollRect.ScrollDown()
			scrolled = true

		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(.8).timeout
	#await get_tree().create_timer(0.6 + 0.1*cloneAmount).timeout
	


#change the stuff in each letter square
func ChangeSquaresText(oldText : String, newText : String):
	var squaresList = letterSquareParent.get_children()
	var newTextList : Array = newText.split()
	var oldTextList : Array = oldText.split()
	
	for i in range(len(squaresList)):
		if i < len(newTextList): #prevent from going out of range
			if (i >= len(oldTextList)): #add letters
				squaresList[i].SetText(newTextList[i])
			elif(newTextList[i] != oldTextList[i]): # new text not the same as old text. replace letter
				squaresList[i].SetText(newTextList[i])
			if(i == 0 and newText == ""):
				squaresList[i].RemoveText()
		else: #remove letters
			if(squaresList[i].GetText() != ""):
				squaresList[i].RemoveText()



#plays the animation and returns true/false if the player has won
func CheckSquares(submittedText : String) -> bool:
	var correctWord : String = GlobalVariables.wordChoice.to_upper()
	var squaresList = letterSquareParent.get_children()
	
	
	for i in range(len(submittedText)):
		var inputLetter = submittedText[i]
		var correctLetter = correctWord[i]
		var currentSquare = squaresList[i]
	
		if inputLetter == correctLetter:
			currentSquare.SetCorrect()
			correctLetterSFX.pitch_scale += (0.5 / wordLength)
		elif inputLetter in correctWord:
			currentSquare.SetExistsWrongPlace()
		else:
			currentSquare.SetDoesntExist()
		
		await get_tree().create_timer(0.25).timeout
			
	if submittedText == correctWord: 
		return true
	else:
		return false
