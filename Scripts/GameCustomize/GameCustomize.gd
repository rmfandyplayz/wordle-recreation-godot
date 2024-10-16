extends Control

#this script controls some aspects in this scene. it also receives the three variable values from mainmenu

var wordChoice : String = GlobalVariables.wordChoice
var lives : int = GlobalVariables.lives
var timeLimit : int = GlobalVariables.timeLimit

@onready var wordLength : int = wordChoice.length()

var currentRow : CenterContainer
var currentRowNumber : int = 0
@onready var rowScene = preload("res://Scenes/NodeCollections/Row.tscn")
@onready var rowParent = $Scrolling/VerticalContainer

@onready var currentText = "" #used for comparing the new and previous text


func _ready() -> void:
	CloneRow()
	
	print("Word Choice: %s" % wordChoice)
	print("Lives: %d" % lives)
	print("Time Limit: %d seconds" % timeLimit)
	
	
#clones a row of letter squares and sets them to the appropriate number
func CloneRow() -> void:
	var newRow = rowScene.instantiate()
	newRow.name = "Row%d" % currentRowNumber
	rowParent.add_child(newRow)
	newRow.CloneSquares(wordLength)
	currentRow = newRow
	currentRowNumber += 1
	
	print("Row Number: ", currentRowNumber)
	print("Current Row: ", currentRow.name)


#change the current row's text according to input from word submission
func ChangeText(newText : String):
	currentRow.ChangeSquaresText(currentText, newText)
