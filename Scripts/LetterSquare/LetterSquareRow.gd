extends CenterContainer

@onready var wordLength : int = GlobalVariables.wordChoice.length()

@onready var letterSquare = preload("res://Scenes/NodeCollections/LetterSquare.tscn")
@onready var letterSquareParent = $Grid

var currentSquarePosition : int = 0 #for use in changeSquaresText as an index number type thing
var currentSquareNumber : int = 0 #for use in cloning



#clones the number of squares per row according to the word length from the global variables
func CloneSquares(cloneAmount : int):
	for i in range(cloneAmount):
		var newSquare =  letterSquare.instantiate()
		newSquare.name = "LetterSquare%d" % currentSquareNumber
		letterSquareParent.add_child(newSquare)
		
		currentSquareNumber += 1


#change the stuff in each letter square
func ChangeSquaresText(oldText : String, newText : String):
	if oldText != newText:
		var letterSquares = letterSquareParent.get_children()
		var letters : Array = newText.split()
		
		for i in range(len(letterSquares)):
			letterSquares[i].SetText(letters[i])
			
			
		
