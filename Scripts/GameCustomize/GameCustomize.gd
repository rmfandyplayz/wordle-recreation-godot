extends Control

#this script controls some aspects in this scene. it also receives the three variable values from mainmenu

var wordChoice : String = GlobalVariables.wordChoice
var lives : int = GlobalVariables.lives
var timeLimit : int = GlobalVariables.timeLimit

var wordLength : int



func _ready() -> void:
	wordLength = wordChoice.length()
	
	print("Word Choice: %s" % wordChoice)
	print("Lives: %d" % lives)
	print("Time Limit: %d seconds" % timeLimit)
