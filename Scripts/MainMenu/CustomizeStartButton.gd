extends Button

var wordChoice : String
var lives : int
var timeLimit : int #max is 359,999 seconds

var validationRequirements : Array = [false, false, false]
#validatonRequirements[0] is for wordChoice, [1] is for lives, and [2] is for time limit



func _on_word_choice_input_text_changed(new_text: String) -> void:
	if new_text.length() > 0:
		wordChoice = new_text
		validationRequirements[0] = true
		StartButtonValidation()
	else:
		validationRequirements[0] = false



func _on_lives_input_text_changed(new_text: String) -> void:
	var numLives = new_text.to_int()
	print("num: ", numLives)
	if numLives == -1 or numLives >= 1:
		lives = numLives
		validationRequirements[1] = true
		StartButtonValidation()
	else:
		validationRequirements[1] = false
		


func _on_time_limit_input_text_changed(new_text: String) -> void:
	var time_parts = new_text.split(":")
	var total_seconds = 0
	
	# Handle different cases based on the number of parts in the input
	match time_parts.size():
		1:  # ss
			var seconds = int(time_parts[0])
			if (seconds < 0 or seconds >= 60) == false:
				total_seconds = seconds
		2:  # mm:ss
			var minutes = int(time_parts[0])
			var seconds = int(time_parts[1])
			if (minutes < 0 or minutes >= 60 or seconds < 0 or seconds >= 60) == false:
				total_seconds = minutes * 60 + seconds
		3:  # hh:mm:ss
			var hours = int(time_parts[0])
			var minutes = int(time_parts[1])
			var seconds = int(time_parts[2])
			if (minutes < 0 or minutes >= 60 or seconds < 0 or seconds >= 60) == false:
				total_seconds = hours * 3600 + minutes * 60 + seconds
	
	#logic
	
		



#checks whether or not all the input fields have valid properties
func StartButtonValidation():
	print("Start Button Validation:", validationRequirements)
	if validationRequirements.count(false) == 3:
		disabled = false
	else: 
		disabled = true
