extends CenterContainer

@onready var wordLength : int = GlobalVariables.wordChoice.length()

@onready var letterSquare = preload("res://Scenes/NodeCollections/LetterSquare.tscn")
@onready var letterSquareParent = $Grid

var currentSquarePosition : int = 0 #for use in changeSquaresText as an index number type thing
var currentSquareNumber : int = 0 #for use in cloning



#clones the number of squares per row according to the word length from the global variables
func CloneSquares(cloneAmount : int):
	#clone them
	for i in range(cloneAmount):
		var newSquare =  letterSquare.instantiate()
		letterSquareParent.add_child(newSquare)
		newSquare.name = "LetterSquare%d" % currentSquareNumber
		currentSquareNumber += 1
	
	#fade them in
	var squares = letterSquareParent.get_children()
	for i in squares:
		var tween = create_tween()
		tween.tween_property(i, "self_modulate", Color("67671fff"), .8)

		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(0.1 * len(squares)).timeout
	


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
	var correctWord : String = GlobalVariables.wordChoice
	var squaresList = letterSquareParent.get_children()
	
	
	for i in range(len(submittedText)):
		var inputLetter = submittedText[i]
		var correctLetter = correctWord[i]
		var currentSquare = squaresList[i]
	
		if inputLetter == correctLetter:
			currentSquare.SetCorrect()
		elif inputLetter in correctWord:
			currentSquare.SetExistsWrongPlace()
		else:
			currentSquare.SetDoesntExist()
		
		await get_tree().create_timer(0.25).timeout
			
	if submittedText == correctWord: 
		return true
	else:
		return false
