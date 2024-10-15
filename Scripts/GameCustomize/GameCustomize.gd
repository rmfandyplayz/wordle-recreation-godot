extends Control

#this script controls some aspects in this scene. it also receives the three variable values from mainmenu

var wordChoice : String = ""
var lives : int = 0
var timeLimit : int = 0


func _ready() -> void:
	print("Word Choice: %s" % wordChoice)
	print("Lives: %d" % lives)
	print("Time Limit: %d seconds" % timeLimit)
