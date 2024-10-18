extends Control

#handles a majority of the logic for this scene

var wordChoice : String = GlobalVariables.wordChoice.to_upper()
var lives : int = GlobalVariables.lives
var timeLimit : int = GlobalVariables.timeLimit

@onready var wordLength : int = wordChoice.length()

var currentRow : CenterContainer
var currentRowNumber : int = 0
@onready var rowScene = preload("res://Scenes/NodeCollections/Row.tscn")
@onready var rowParent = $Scrolling/VerticalContainer

@onready var currentText : String = "" #used for comparing the new and previous text


func _ready() -> void:
	#GlobalVariables.wordChoice = GlobalVariables.wordChoice.to_upper()
	
	$WordSubmission.max_length = wordLength
	$WordSubmission.editable = false
	await CloneRow()
	$WordSubmission.editable = true
	
	print("Word Choice: %s" % wordChoice)
	print("Lives: %d" % lives)
	print("Time Limit: %d seconds" % timeLimit)
	
	
#clones a row of letter squares and sets them to the appropriate number
func CloneRow() -> void:
	var newRow = rowScene.instantiate()
	newRow.name = "Row%d" % currentRowNumber
	rowParent.add_child(newRow)
	await newRow.CloneSquares(wordLength)
	currentRow = newRow
	currentRowNumber += 1




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
		$WordSubmission.editable = false
		var playerWon : bool = await currentRow.CheckSquares(new_text)
		
		if playerWon == true:
			pass #more logic here
		else:
			#more logic later
			await CloneRow()
			$Scrolling.scroll_vertical = $Scrolling.get_v_scroll_bar().max_value
			currentText = "" #to prevent THAT bug
			$WordSubmission.clear()
			$WordSubmission.editable = true
			preventSignal = false
			makeInactive = false
	
