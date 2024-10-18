extends Control

#handles a majority of the logic for this scene

var wordChoice : String = GlobalVariables.wordChoice.to_upper()
var lives : int = GlobalVariables.lives
var timeLimit : int = GlobalVariables.timeLimit

var infiniteLives : bool = false
var infiniteTime : bool = false
var stopTimer : bool = false
var gameOver : bool = false

@onready var wordLength : int = wordChoice.length()

var currentRow : CenterContainer
var currentRowNumber : int = 0
@onready var rowScene = preload("res://Scenes/NodeCollections/Row.tscn")
@onready var rowParent = $Scrolling/VerticalContainer

@onready var currentText : String = "" #used for comparing the new and previous text (used for some functions inside LetterSquareRow.gd)


func _ready() -> void:
	#initializations
	$WordSubmission.max_length = wordLength
	$WordSubmission.editable = false
	
	#lives text
	if(lives != 0):
		SetLivesText(lives)
	else:
		$"Topbar/Lives Panel/Text".text = "∞"
		infiniteLives = true
	
	#time text
	if timeLimit == -1:
		$"Topbar/Time Panel/Text".text = "∞"
		infiniteTime = true
	else:
		SetTimeText(timeLimit)
	
	#clone the first row
	await CloneRow()
	$WordSubmission.editable = true
	$WordSubmission.grab_focus()
	
	if(infiniteTime == false):
		StartTimer()
	

	
#clones a row of letter squares and sets them to the appropriate number
func CloneRow() -> void:
	var newRow = rowScene.instantiate()
	newRow.name = "Row%d" % currentRowNumber
	rowParent.add_child(newRow)
	await newRow.CloneSquares(wordLength)
	currentRow = newRow
	currentRowNumber += 1


#starts the timer and runs its logic
func StartTimer():
	var outOfTime = false
	
	while outOfTime == false and stopTimer == false:
		await get_tree().create_timer(1).timeout
		timeLimit -= 1
		SetTimeText(timeLimit)
		
		if timeLimit == 0:
			outOfTime = true
			GameOver()
			

#takes away a life and runs other logic tied with it
func TakeDamage():
	lives -= 1
	SetLivesText(lives)
	
	if lives == 0:
		gameOver = true
		GameOver()
	

#runs logic for when player lost
func GameOver():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	#this is temporary
	

#logic for when player wins 
func GameWon():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	#also temporary


func SetTimeText(input : int):
	$"Topbar/Time Panel/Text".text = FormatTime(input)
	
func SetLivesText(input):
	$"Topbar/Lives Panel/Text".text = str(input)

func FormatTime(seconds: int) -> String:
	var hours = int(seconds / 3600)
	var minutes = int((seconds % 3600) / 60)
	var secs = int(seconds % 60)

	if hours > 0:
		return "%02d:%02d:%02d" % [hours, minutes, secs]
	elif minutes > 0:
		return "%02d:%02d" % [minutes, secs]
	else:
		return "%02d" % secs



#refers to WordSubmission's signal
#updates the squares correctly and plays the correct animations
var preventSignal = false
func _on_text_changed(new_text: String) -> void:
	new_text = new_text.to_upper()
	
	if preventSignal == false:
		currentRow.ChangeSquaresText(currentText, new_text)
		currentText = new_text


#refers to WordSubmission's signal
#checks the correctness of the word and does stuff appropriately
var makeInactive = false
func _on_text_submitted(new_text: String) -> void:
	new_text = new_text.to_upper()
	
	#check if they even entered all the words
	if(len($WordSubmission.text) != wordLength and makeInactive == false):
		makeInactive = true
		$WordSubmission.editable = false
		$WordSubmission.self_modulate = Color("#ff6666")
		
		var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
		var original_position = $WordSubmission.position
		
		#shake effect
		for i in range(1, 7):
			tween.tween_property($WordSubmission, "position", original_position + Vector2(48 - 8*i, 0), 0.06)
			tween.tween_property($WordSubmission, "position", original_position - Vector2(48 - 8*i, 0), 0.06)
		
		
		await tween.finished
		makeInactive = false
		$WordSubmission.self_modulate = Color("#ffffff")
		$WordSubmission.editable = true
		return
	
	#otherwise, do the actual checking
	elif(len($WordSubmission.text) == wordLength and makeInactive == false):
		preventSignal = true
		makeInactive = true
		stopTimer = true
		$WordSubmission.editable = false
		var playerWon : bool = await currentRow.CheckSquares(new_text)
		
		if playerWon == true:
			GameWon()
		else:
			if infiniteLives == false:
				TakeDamage()
			
			if gameOver == false:
				await CloneRow()
				$Scrolling.scroll_vertical = $Scrolling.get_v_scroll_bar().max_value
				currentText = "" #to prevent THAT bug
				$WordSubmission.clear()
				$WordSubmission.editable = true
				preventSignal = false
				makeInactive = false
				stopTimer = false
				StartTimer()
