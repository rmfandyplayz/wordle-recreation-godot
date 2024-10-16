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
	var squaresList = letterSquareParent.get_children()
	var newTextList = newText.split()
	var oldTextList = oldText.split()
	
	for i in range(len(squaresList)):
		if i < len(newTextList):
			if (i >= len(oldTextList)): #new text is longer
				squaresList[i].SetText(newTextList[i])
			elif(newTextList[i] != oldTextList[i]): # new text not the same as old text
				squaresList[i].SetText(newTextList[i])
		else:
			squaresList[i].RemoveText()
			
	
	#print(currentSquarePosition)
	#
	#if oldText != newText:
		#if newText.length() > oldText.length(): #added letter
			#squaresList[currentSquarePosition].SetText(newTextList[currentSquarePosition])
			#currentSquarePosition += 1
		#elif newText.length() < oldText.length(): #deleted letter
			#currentSquarePosition -= 1
			#squaresList[currentSquarePosition].RkemoveText()
			#
	#else: #word is changed but somehow is the same length (used insert key???)
		#pass
	#
	#print(currentSquarePosition)
			
		
